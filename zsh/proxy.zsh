# 透明代理 (redsocks + nftables)
_NFT_TABLE="redsocks"
_REDSOCKS_CONF="/etc/redsocks.conf"

_proxy_ok()   { echo "\e[32m[OK]\e[0m $*" }
_proxy_off()  { echo "\e[33m[OFF]\e[0m $*" }
_proxy_err()  { echo "\e[31m[ERROR]\e[0m $*" }

# proxy-on <host> <port> [local_port]  — 启动透明代理
function proxy-on() {
    if (( $# < 2 )); then
        echo "用法: proxy-on <代理主机> <代理端口> [本地监听端口]"
        echo "示例: proxy-on 127.0.0.1 7890"
        return 1
    fi

    local proxy_host="$1" proxy_port="$2" local_port="${3:-12345}"

    # 解析代理 IP
    local proxy_ip
    if [[ "$proxy_host" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        proxy_ip="$proxy_host"
    else
        proxy_ip=$(getent hosts "$proxy_host" 2>/dev/null | awk '{print $1}' | head -1)
        if [[ -z "$proxy_ip" ]]; then
            _proxy_err "无法解析 $proxy_host"; return 1
        fi
    fi

    # 写入 redsocks 配置
    sudo tee "$_REDSOCKS_CONF" >/dev/null <<EOF
base {
    log_debug = off;
    log_info = on;
    daemon = on;
    redirector = iptables;
}
redsocks {
    local_ip = 127.0.0.1;
    local_port = $local_port;
    ip = $proxy_ip;
    port = $proxy_port;
    type = http-connect;
}
EOF

    # 重启 redsocks
    sudo systemctl restart redsocks || { _proxy_err "redsocks 启动失败"; return 1; }

    # 配置 nftables（原子替换）
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

    _proxy_ok "透明代理已启动 → $proxy_host ($proxy_ip):$proxy_port"
}

# proxy-off — 关闭透明代理
function proxy-off() {
    sudo nft delete table ip "$_NFT_TABLE" 2>/dev/null || true
    sudo systemctl stop redsocks 2>/dev/null || true
    _proxy_ok "透明代理已关闭"
}

# proxy-status — 查看透明代理状态
function proxy-status() {
    if sudo nft list table ip "$_NFT_TABLE" &>/dev/null; then
        _proxy_ok "nftables 规则已生效:"
        sudo nft list table ip "$_NFT_TABLE"
    else
        _proxy_off "无透明代理规则"
    fi
    echo ""
    if systemctl is-active --quiet redsocks 2>/dev/null; then
        _proxy_ok "redsocks 运行中"
    else
        _proxy_off "redsocks 未运行"
    fi
}
