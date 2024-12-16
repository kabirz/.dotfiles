
ubuntu远程桌面已经支持通过Windows远程工具访问，直接输入ip地址和用户密码即可，仅支持22.04以上版本

## 使能开机启动服务

```shell
systemctl --user enable gnome-remote-desktop.service
```
开机重启后自动启动， 也可以手动启动

```shell
systemctl --user start gnome-remote-desktop.service
```

## 重启服务

```shell
systemctl --user restart gnome-remote-desktop.service
```

## 配置重启和使用远程使用

1. 使能和失能

```shell
grdctl rdp enable
```

```shell
grdctl rdp disable
```
2. 设置和清除密码

设置密码：

```shell
grdctl rdp set-credentials test 123
```
其中用户名是`test`， 密码是`123`， 用户名和密码可以任意设置，不要求一定和Ubuntu里面的用户一样


清除密码：

```shell
grdctl rdp clear-credentials
```

## 使能和失能view

使能之后远程只能查看不能操作
```shell
grdctl rdp enable-view-only
```

失能设置远程可操作
```shell
grdctl rdp disable-view-only
```

## 查看状态

```shell
grdctl  status
```
输出如下：

```log
Overall:
        Unit status: active
RDP:
        Status: enabled =====> 状态
        Port: 3389 ====> 端口号
        TLS certificate: /home/n3080/.local/share/gnome-remote-desktop/certificates/rdp-tls.crt
        TLS fingerprint: 8e:61:e8:6e:9b:a6:77:30:27:db:ad:a8:a5:d3:1d:cb:44:76:bb:3a:ee:59:5a:5e:d9:ae:16:1a:68:61:e3:ca
        TLS key: /home/n3080/.local/share/gnome-remote-desktop/certificates/rdp-tls.key
        View-only: no ====> 是否只能查看不能操作
        Negotiate port: yes
        Username: (hidden) ===> 用户名
        Password: (hidden) ===> 密码
```

默认用户和密码是隐藏的，如果需要显示用户和密码需要添加参数`--show-credentials`

```shell
grdctl  status --show-credentials
```