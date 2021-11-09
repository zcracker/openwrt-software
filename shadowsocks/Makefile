#
# Copyright (C) 2015 OpenWrt-dist
# Copyright (C) 2016 Chen RuiWei <crwbak@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocks
PKG_VERSION:=3.3.5
PKG_RELEASE=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/shadowsocks/shadowsocks-libev.git
PKG_SOURCE_VERSION:=d1171f44d0d8da34ec016974e7b3b95b0202d831

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Chen RuiWei <crwbak@gmail.com>

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

PKG_USE_MIPS16:=0
PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocks
	SECTION:=net
	CATEGORY:=Extra packages
	TITLE:=Lightweight Secured Socks5 Proxy
	URL:=https://github.com/shadowsocks/shadowsocks-libev
	DEPENDS:=+libev +libcares +libpcre +libpthread +libsodium +libmbedtls +ipset +ip +iptables-mod-tproxy +zlib
endef

define Package/shadowsocks/description
shadowsocks is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

define Package/shadowsocks/conffiles
/etc/config/shadowsocks
endef

CONFIGURE_ARGS += --disable-ssp --disable-documentation --disable-assert

define Package/shadowsocks/install
	$(INSTALL_DIR) $(1)/usr/share/shadowsocks $(1)/usr/bin $(1)/etc/init.d $(1)/etc/uci-defaults $(1)/etc/config
	$(CP) ./files/_common/* $(1)/etc/config/dnsmasq
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-{redir,tunnel,local} $(1)/usr/bin/
	$(INSTALL_BIN) ./files/shadowsocks.init $(1)/etc/init.d/shadowsocks
	$(INSTALL_DATA) ./files/shadowsocks.defaults $(1)/etc/uci-defaults/95-shadowsocks
	$(INSTALL_DATA) ./files/shadowsocks.firewall $(1)/usr/share/shadowsocks/firewall.include
	$(INSTALL_DATA) ./files/shadowsocks.config $(1)/etc/config/shadowsocks
endef

$(eval $(call BuildPackage,shadowsocks))
