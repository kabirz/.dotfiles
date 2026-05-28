# nftables 详细用法指南

## 基本概念层级

```
nftables
  └── table (表)        — 协议族级别
       └── chain (链)   — 钩子类型
            └── rule (规则) — 匹配+动作
```

---

## 1. 表 (table) 操作

```bash
# 列出所有表
sudo nft list tables

# 列出指定表内容
sudo nft list table ip nat
sudo nft list table ip filter

# 列出完整规则集
sudo nft list ruleset

# 创建表（ip = IPv4, ip6 = IPv6, inet = IPv4+IPv6, bridge, arp）
sudo nft add table ip mytable

# 删除表
sudo nft delete table ip mytable

# 清空表中所有链的规则（保留链结构）
sudo nft flush table ip mytable
```

## 2. 链 (chain) 操作

```bash
# 添加常规链（无钩子，需手动跳转）
sudo nft add chain ip mytable mychain

# 添加基础链（挂载到内核钩子）
sudo nft add chain ip mytable input \
  '{ type filter hook input priority 0; policy accept; }'
```

### 钩子类型

| 钩子 | 说明 |
|------|------|
| `prerouting` | 路由前（刚进入网卡） |
| `input` | 发往本机的包 |
| `forward` | 转发的包 |
| `output` | 本机发出的包 |
| `postrouting` | 路由后（即将离开网卡） |

### 链类型

| 类型 | 用途 |
|------|------|
| `filter` | 过滤（input/output/forward） |
| `nat` | 地址转换（prerouting/postrouting/output） |
| `route` | 路由策略（output） |

### 优先级

数字越小越先执行：

| 优先级值 | 名称 | 说明 |
|----------|------|------|
| -300 | raw | 原始包处理 |
| -150 | mangle | 包修改 |
| -100 | dstnat | 目标地址转换 |
| 0 | filter | 过滤（默认） |
| 50 | security | 安全标记 |
| 100 | srcnat | 源地址转换 |

### 管理链

```bash
# 删除链（必须先清空规则）
sudo nft flush chain ip mytable mychain
sudo nft delete chain ip mytable mychain

# 列出链规则
sudo nft list chain ip mytable mychain
```

## 3. 规则 (rule) 操作

```bash
# 添加规则（追加到末尾）
sudo nft add rule ip mytable input tcp dport 22 accept

# 插入规则（到开头）
sudo nft insert rule ip mytable input tcp dport 22 accept

# 插入到指定位置（通过 handle 号）
sudo nft insert rule ip mytable input position 3 tcp dport 80 accept

# 在指定 handle 后添加
sudo nft add rule ip mytable input position 3 tcp dport 443 accept

# 删除规则（通过 handle）
sudo nft list chain ip mytable input -a   # -a 显示 handle
sudo nft delete rule ip mytable input handle 5

# 替换规则
sudo nft replace rule ip mytable input handle 5 tcp dport 8080 accept
```

## 4. 匹配条件

### 协议匹配

```bash
ip protocol tcp
ip protocol udp
ip protocol icmp
ip6 nexthdr tcp                         # IPv6
meta l4proto tcp                        # 通用（不区分 v4/v6）
```

### IP 地址

```bash
ip saddr 192.168.1.0/24                 # 源地址
ip daddr 10.0.0.1                       # 目标地址
ip saddr . ip daddr { 1.1.1.1 . 2.2.2.2 }  # 连接匹配（concatenation）
```

### 端口

```bash
tcp dport 22                            # 目标端口
tcp sport 1024-65535                    # 源端口范围
tcp dport { 80, 443, 8080 }            # 集合匹配
udp dport 53
tcp dport != 22                         # 取反
```

### 接口

```bash
iif eth0                                # 入接口（索引匹配，快）
oif eth1                                # 出接口
iifname "eth0"                          # 接口名匹配（字符串匹配，灵活）
oifname "eth1"
iiftype ether                           # 接口类型
```

### 连接跟踪 (conntrack)

```bash
ct state established,related accept     # 已建立/相关的连接
ct state new tcp dport 22 accept       # 新连接
ct state invalid drop                   # 无效连接
ct status dnat                          # DNAT 过的连接
```

### 用户/组

```bash
skuid 1000                              # 匹配 UID
skgid 1000                              # 匹配 GID
skuid != 0                              # 非 root
```

### 逻辑运算

```bash
# AND（默认，空格分隔）
ip saddr 10.0.0.0/8 ip daddr != 192.168.1.1

# OR
ip protocol tcp or ip protocol udp

# verdict map（条件跳转）
ip saddr vmap {
  10.0.0.0/8 => accept,
  192.168.0.0/16 => drop
}
```

### ICMP

```bash
icmp type echo-request                  # ping 请求
icmp type echo-reply                    # ping 回复
icmp type destination-unreachable       # 目标不可达
```

## 5. 动作 (statement)

### 基本动作

| 动作 | 说明 |
|------|------|
| `accept` | 接受包 |
| `drop` | 静默丢弃 |
| `reject` | 拒绝并返回错误 |
| `return` | 返回上一级链 |
| `queue` | 送用户空间处理 |
| `jump <chain>` | 跳转到自定义链（可返回） |
| `goto <chain>` | 跳转到自定义链（不可返回） |

### NAT

```bash
snat to 1.2.3.4                         # 源地址转换
snat to 1.2.3.4:8080                    # 源地址+端口转换
dnat to 10.0.0.1:8080                   # 目标地址转换
masquerade                               # 动态 SNAT（拨号/动态IP适用）
redirect to :12345                       # 重定向到本机端口
```

### 日志与计数

```bash
# 带前缀的日志
log prefix "DROP: " level warn drop

# 计数器
counter accept
counter packets 0 bytes 0

# 同时记录和丢弃
log prefix "BLOCKED: " counter drop
```

### 限速

```bash
# 每秒最多 10 个包
limit rate 10/second accept

# 每分钟最多 100 个包，突发 20
limit rate 100/minute burst 20 packets accept

# 按 IP 限速（需要集合配合）
```

## 6. 集合 (set)

### 匿名集合

```bash
# 花括号定义，不可修改
tcp dport { 22, 80, 443 } accept
ip saddr { 10.0.0.1, 10.0.0.2 } drop
```

### 命名集合

```bash
# 创建
sudo nft add set ip mytable myset '{ type ipv4_addr; }'

# 支持的类型：ipv4_addr, ipv6_addr, ether_addr, inet_proto, inet_service, mark 等

# 添加元素
sudo nft add element ip mytable myset { 10.0.0.1, 10.0.0.2 }

# 删除元素
sudo nft delete element ip mytable myset { 10.0.0.1 }

# 查看集合内容
sudo nft list set ip mytable myset

# 在规则中使用
ip saddr @myset drop
```

### 带间隔的集合

```bash
# 创建（需要 flags interval）
sudo nft add set ip mytable blocklist \
  '{ type ipv4_addr; flags interval; }'

# 添加网段
sudo nft add element ip mytable blocklist { 10.0.0.0/8, 172.16.0.0/12 }

# 自动合并相邻网段
sudo nft add element ip mytable blocklist { 192.168.1.0/24, 192.168.2.0/24 }
# 会自动合并为 192.168.0.0/23
```

### 带超时的集合

```bash
# 元素自动过期（适合临时封禁）
sudo nft add set ip mytable blacklist \
  '{ type ipv4_addr; flags timeout; timeout 1h; }'

# 添加元素，10分钟后过期
sudo nft add element ip mytable blacklist { 1.2.3.4 timeout 10m }
```

## 7. 字典 (map/verdict map)

```bash
# verdict map — 根据匹配结果执行不同动作
sudo nft add map ip mytable portmap \
  '{ type inet_service: verdict; }'

sudo nft add element ip mytable portmap { 22: accept, 80: accept, 3306: drop }

# 在规则中使用
tcp dport vmap @portmap
```

## 8. 完整示例

### 基础防火墙

```bash
# 创建表
sudo nft add table ip firewall

# 创建 input 链
sudo nft add chain ip firewall input \
  '{ type filter hook input priority 0; policy drop; }'

# 创建 output 链
sudo nft add chain ip firewall output \
  '{ type filter hook output priority 0; policy accept; }'

# input 规则
sudo nft add rule ip firewall input ct state established,related accept
sudo nft add rule ip firewall input iif lo accept
sudo nft add rule ip firewall input icmp type echo-request accept
sudo nft add rule ip firewall input tcp dport 22 accept
sudo nft add rule ip firewall input tcp dport { 80, 443 } accept
sudo nft add rule ip firewall input log prefix "DROP_INPUT: " counter drop
```

### 透明代理（类似你的 REDSOCKS 配置）

```bash
# 创建表
sudo nft add table ip nat

# OUTPUT 链
sudo nft add chain ip nat output \
  '{ type nat hook output priority -100; policy accept; }'

# REDSOCKS 自定义链
sudo nft add chain ip nat redsocks

# OUTPUT 跳转
sudo nft add rule ip nat output ip protocol tcp jump redsocks

# REDSOCKS 规则
sudo nft add rule ip nat redsocks ip daddr 127.0.0.0/8 return
sudo nft add rule ip nat redsocks ip daddr 10.0.0.0/8 return
sudo nft add rule ip nat redsocks ip daddr 172.16.0.0/12 return
sudo nft add rule ip nat redsocks ip daddr 192.168.0.0/16 return
sudo nft add rule ip nat redsocks ip daddr 10.240.252.23 return
sudo nft add rule ip nat redsocks ip protocol tcp skuid 122 return
sudo nft add rule ip nat redsocks ip protocol tcp redirect to :12345
```

## 9. 实时监控与调试

```bash
# 监控所有变化
sudo nft monitor

# 只监控新规则
sudo nft monitor new

# 监控规则删除
sudo nft monitor destroy

# 带 handle 查看（用于删除/定位规则）
sudo nft list ruleset -a

# 查看计数器
sudo nft list ruleset -s
```

## 10. 持久化

```bash
# 导出规则
sudo nft list ruleset > /etc/nftables.conf

# 从文件恢复
sudo nft -f /etc/nftables.conf

# systemd 自动加载（如果启用了 nftables 服务）
sudo systemctl enable nftables
sudo systemctl start nftables
```

## 11. 与 iptables 对比

| 特性 | iptables | nftables |
|------|----------|----------|
| 语法 | 多命令分散 | 统一语法 |
| 性能 | 线性匹配 | 集合用哈希/字典查找 |
| 原子更新 | 逐条生效 | 整个规则集原子替换 |
| 协议支持 | iptables/ip6tables/arptables 分离 | 统一 `inet` 族处理 v4/v6 |
| 集合 | ipset（外部工具） | 内置 set/map |
| 调试 | `iptables -L -v -n` | `nft list ruleset` / `nft monitor` |
| 配置持久化 | iptables-save/restore | nft -f / nftables.conf |

## 12. 注意事项

- **不要混用 iptables 和 nft 命令**修改同一张表，容易导致状态不一致
- Ubuntu 22.04+ 默认使用 iptables-nft 兼容层，底层是 nftables
- 兼容层管理的表会显示警告：`Warning: table ip xxx is managed by iptables-nft, do not touch!`
- 使用 `inet` 族可以同时处理 IPv4 和 IPv6，减少重复规则
- 删除链前必须先清空其中的规则
- 规则顺序很重要，先匹配先生效（类似 iptables）
