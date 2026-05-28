# 透明代理 (redsocks)
# 支持: Linux (nftables) / macOS (pf)

# ---- 平台检测 ----
[[ "$(uname)" == "Darwin" ]] && _PROXY_OS="macos" || _PROXY_OS="linux"

# ---- 平台相关常量 ----
if [[ "$_PROXY_OS" == "macos" ]]; then
    _REDSOCKS_CONF="/usr/local/etc/redsocks.conf"
    _PF_ANCHOR="/etc/pf.anchors/redsocks"
else
    _NFT_TABLE="redsocks"
    _REDSOCKS_CONF="/etc/redsocks.conf"
fi

# ---- 通用输出 ----
_proxy_ok()   { echo "\e[32m[OK]\e[0m $*" }
_proxy_off()  { echo "\e[33m[OFF]\e[0m $*" }
_proxy_err()  { echo "\e[31m[ERROR]\e[0m $*" }

# ---- DNS 解析 ----
_proxy_resolve() {
    local host="$1"
    if [[ "$host" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "$host"
        return 0
    fi
    local ip
    if [[ "$_PROXY_OS" == "macos" ]]; then
        ip=$(dscacheutil -q host -a name "$host" 2>/dev/null | awk '/^ip_address:/{print $2}' | head -1)
    else
        ip=$(getent hosts "$host" 2>/dev/null | awk '{print $1}' | head -1)
    fi
    if [[ -z "$ip" ]]; then
        _proxy_err "无法解析 $host"
        return 1
    fi
    echo "$ip"
}

# ---- 服务管理 ----
_proxy_service() {
    local action="$1"  # start / stop / restart / status
    if [[ "$_PROXY_OS" == "macos" ]]; then
        case "$action" in
            start|stop|restart) brew services "$action" redsocks ;;
            status) brew services list 2>/dev/null | grep redsocks ;;
        esac
    else
        case "$action" in
            start|stop|restart) sudo systemctl "$action" redsocks ;;
            status) systemctl is-active --quiet redsocks 2>/dev/null ;;
        esac
    fi
}

# ---- 防火墙: 应用规则 ----
_proxy_fw_apply() {
    local proxy_ip="$1" local_port="$2"

    if [[ "$_PROXY_OS" == "macos" ]]; then
        # 写入 pf anchor 规则
        sudo tee "$_PF_ANCHOR" >/dev/null <<PFEOF
# redsocks transparent proxy
rdr pass on lo0 proto tcp from any to 127.0.0.0/8 -> 127.0.0.1 port $local_port
rdr pass on lo0 proto tcp from any to 10.0.0.0/8 -> 127.0.0.1 port $local_port
rdr pass on lo0 proto tcp from any to 172.16.0.0/12 -> 127.0.0.1 port $local_port
rdr pass on lo0 proto tcp from any to 192.168.0.0/16 -> 127.0.0.1 port $local_port
rdr pass on lo0 proto tcp from any to $proxy_ip -> 127.0.0.1 port $local_port
pass out route-to lo0 inet proto tcp to any -> 127.0.0.1 port $local_port
PFEOF
        sudo pfctl -ef /etc/pf.conf 2>/dev/null || true
        sudo pfctl -a "com.redsocks" -f "$_PF_ANCHOR" 2>/dev/null
    else
        sudo nft delete table ip "$_NFT_TABLE" 2>/dev/null || true
        sudo nft -f - <<EOF
table ip $_NFT_TABLE {
    chain output {
        type nat hook output priority dstnat; policy accept;
        ip protocol tcp jump redsocks
    }
    chain redsocks {
        ip daddr 127.0.0.0/8 return
        ip daddr 10.0.0.0/8 return
        ip daddr 172.16.0.0/12 return
        ip daddr 192.168.0.0/16 return
        ip daddr $proxy_ip return
        ip protocol tcp skuid "redsocks" return
        ip protocol tcp redirect to :$local_port
    }
}
EOF
    fi
}

# ---- 防火墙: 移除规则 ----
_proxy_fw_remove() {
    if [[ "$_PROXY_OS" == "macos" ]]; then
        sudo pfctl -a "com.redsocks" -F all 2>/dev/null || true
        sudo rm -f "$_PF_ANCHOR"
    else
        sudo nft delete table ip "$_NFT_TABLE" 2>/dev/null || true
    fi
}

# ---- 防火墙: 查看状态 ----
_proxy_fw_status() {
    if [[ "$_PROXY_OS" == "macos" ]]; then
        if sudo pfctl -a "com.redsocks" -s rules 2>/dev/null | grep -q redsocks; then
            _proxy_ok "pf 规则已生效:"
            sudo pfctl -a "com.redsocks" -s rules 2>/dev/null
        else
            _proxy_off "无透明代理规则"
        fi
    else
        if sudo nft list table ip "$_NFT_TABLE" &>/dev/null; then
            _proxy_ok "nftables 规则已生效:"
            sudo nft list table ip "$_NFT_TABLE"
        else
            _proxy_off "无透明代理规则"
        fi
    fi
}

# ============================================================
# 用户接口
# ============================================================

# proxy-on <host> <port> [local_port]  — 启动透明代理
function proxy-on() {
    if (( $# < 2 )); then
        echo "用法: proxy-on <代理主机> <代理端口> [本地监听端口]"
        echo "示例: proxy-on 127.0.0.1 7890"
        return 1
    fi

    local proxy_host="$1" proxy_port="$2" local_port="${3:-12345}"

    local proxy_ip
    proxy_ip=$(_proxy_resolve "$proxy_host") || return 1

    # redsocks redirector 类型
    local redirector="iptables"
    [[ "$_PROXY_OS" == "macos" ]] && redirector="pf"

    # 写入 redsocks 配置
    sudo tee "$_REDSOCKS_CONF" >/dev/null <<EOF
base {
    log_debug = off;
    log_info = on;
    daemon = on;
    redirector = $redirector;
}
redsocks {
    local_ip = 127.0.0.1;
    local_port = $local_port;
    ip = $proxy_ip;
    port = $proxy_port;
    type = http-connect;
}
EOF

    _proxy_service restart || { _proxy_err "redsocks 启动失败"; return 1; }
    _proxy_fw_apply "$proxy_ip" "$local_port"

    _proxy_ok "透明代理已启动 → $proxy_host ($proxy_ip):$proxy_port"
}

# proxy-off — 关闭透明代理
function proxy-off() {
    _proxy_fw_remove
    _proxy_service stop 2>/dev/null || true
    _proxy_ok "透明代理已关闭"
}

# proxy-status — 查看透明代理状态
function proxy-status() {
    _proxy_fw_status
    echo ""
    if [[ "$_PROXY_OS" == "macos" ]]; then
        if brew services list 2>/dev/null | grep -q "redsocks.*started"; then
            _proxy_ok "redsocks 运行中"
        else
            _proxy_off "redsocks 未运行"
        fi
    else
        if systemctl is-active --quiet redsocks 2>/dev/null; then
            _proxy_ok "redsocks 运行中"
        else
            _proxy_off "redsocks 未运行"
        fi
    fi
}
