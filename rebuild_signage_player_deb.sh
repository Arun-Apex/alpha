#!/usr/bin/env bash
set -euo pipefail
# This script rebuilds the signage-player .deb using dpkg-deb on your Pi if needed.
PKG=signage-player_0.2.0_all
mkdir -p "$PKG/DEBIAN"
cat > "$PKG/DEBIAN/control" <<'EOF'
Package: signage-player
Version: 0.2.0
Section: utils
Priority: optional
Architecture: all
Maintainer: Apex Innovation <info@apexinno.com>
Depends: xserver-xorg, openbox, chromium-browser | chromium, unclutter, x11-xserver-utils, coreutils, bash
Description: Raspberry Pi digital signage player (Chromium kiosk + offline web player)
 Installs /opt/signage/player, systemd services, and /etc/signage config.
EOF
install -D -m0755 postinst "$PKG/DEBIAN/postinst"
install -D -m0755 prerm "$PKG/DEBIAN/prerm"
install -D -m0755 postrm "$PKG/DEBIAN/postrm"
# data tree
mkdir -p "$PKG/opt/signage/player" "$PKG/etc/signage" "$PKG/lib/systemd/system" "$PKG/usr/local/bin" "$PKG/opt/signage"
cp -r opt/signage/player/* "$PKG/opt/signage/player/"
cp -r etc/signage/* "$PKG/etc/signage/"
cp -r lib/systemd/system/* "$PKG/lib/systemd/system/"
cp -r usr/local/bin/* "$PKG/usr/local/bin/"
cp -r opt/signage/signage-openbox-autostart "$PKG/opt/signage/signage-openbox-autostart"
cp -r opt/signage/xinitrc-template "$PKG/opt/signage/xinitrc-template"
dpkg-deb --build "$PKG"
echo "Built: ${PKG}.deb"
