#!/bin/sh
MARK="/var/jb/var/.auto_deb_done"
# 判断已经执行过就直接退出，防止反复安装
if [ -f "$MARK" ]; then
    exit 0
fi

DEB_SRC="$1"
DEB_TMP="/var/jb/tmp/auto_debs"

mkdir -p "$DEB_TMP"
# 复制所有deb到越狱内临时目录
cp "$DEB_SRC"/*.deb "$DEB_TMP/"

cd "$DEB_TMP"
# 逐个安装deb
for f in *.deb; do
    [ -f "$f" ] && /var/jb/usr/bin/dpkg -i "$f"
done
# 自动补依赖
/var/jb/usr/bin/apt -f install -y
# 重载SpringBoard生效插件
/var/jb/usr/bin/sbreload

# 打标记，下次越狱不再跑
touch "$MARK"