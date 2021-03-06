include $(TOPDIR)/rules.mk 

PKG_NAME:=luci-app-clash
PKG_VERSION:=1.3.9
PKG_RELEASE:=1
PKG_MAINTAINER:=frainzy1477


include $(INCLUDE_DIR)/package.mk

define Package/luci-app-clash
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=2. Clash
	TITLE:=LuCI app for clash
	DEPENDS:=+luci +luci-base +wget +iptables +coreutils-base64 +coreutils +coreutils-nohup +bash +ipset
	PKGARCH:=all
	MAINTAINER:=frainzy1477
endef

define Package/luci-app-clash/description
	Luci Interface for clash.
endef


define Build/Prepare
	chmod 777 -R ${CURDIR}/tools/po2lmo
	${CURDIR}/tools/po2lmo/src/po2lmo ${CURDIR}/po/zh-cn/clash.po ${CURDIR}/po/zh-cn/clash.zh-cn.lmo

endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/preinst
#!/bin/sh

mkdir -p /usr/share/clashbackup 2>/dev/null

if [ -f "/tmp/dnsmasq.d/custom_list.conf" ]; then
	rm -rf /tmp/dnsmasq.d/custom_list.conf 2>/dev/null
fi

if [ -d "/tmp/dnsmasq.clash" ]; then
	rm -rf /tmp/dnsmasq.clash 2>/dev/null
fi

if [ -f "/etc/config/clash" ]; then
	mv /etc/config/clash /etc/config/clash.bak 2>/dev/null
fi

if [ -d "/usr/lib/lua/luci/model/cbi/clash" ]; then
	rm -rf /usr/lib/lua/luci/model/cbi/clash 2>/dev/null
fi	

if [ -d "/usr/lib/lua/luci/view/clash" ]; then
	rm -rf /usr/lib/lua/luci/view/clash 2>/dev/null
fi

if [  -d /usr/share/clash/web ]; then
	rm -rf /usr/share/clash/web 2>/dev/null
fi

if [  -f /usr/share/clash/config/sub/config.yaml ];then
	mv /usr/share/clash/config/sub/config.yaml /usr/share/clashbackup/config.bak1 2>/dev/null
fi

if [  -f /usr/share/clash/config/upload/config.yaml ];then
	mv /usr/share/clash/config/upload/config.yaml /usr/share/clashbackup/config.bak2 2>/dev/null
fi
 
if [  -f /usr/share/clash/config/custom/config.yaml ];then
	mv /usr/share/clash/config/custom/config.yaml /usr/share/clashbackup/config.bak3 2>/dev/null
fi



endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
rm -rf /tmp/luci*  

if [ -f "/etc/config/clash.bak" ]; then
	mv /etc/config/clash.bak /etc/config/clash 2>/dev/null
fi

if [  -f /usr/share/clashbackup/config.bak1 ];then
	mv /usr/share/clashbackup/config.bak1 /usr/share/clash/config/sub/config.yaml 2>/dev/null
fi

if [  -f /usr/share/clashbackup/config.bak2 ];then
	mv /usr/share/clashbackup/config.bak2 /usr/share/clash/config/upload/config.yaml 2>/dev/null
fi
 
if [  -f /usr/share/clashbackup/config.bak3 ];then
	mv /usr/share/clashbackup/config.bak3 /usr/share/clash/config/custom/config.yaml 2>/dev/null
fi

if [ -f "/etc/init.d/clash" ]; then
	/etc/init.d/clash disable 2>/dev/null
fi
	echo "Clash for OpenWRT" >/usr/share/clash/clash_real.log 2>/dev/null
	echo "0" > /usr/share/clash/logstatus_check 2>/dev/null
	echo "" > /tmp/clash.log 2>/dev/null

endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/clash
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/clash
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/clash
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(INSTALL_DIR) $(1)/usr/share/
	$(INSTALL_DIR) $(1)/usr/share/clash
	$(INSTALL_DIR) $(1)/usr/share/clash/yac
	$(INSTALL_DIR) $(1)/usr/share/clash/dashboard
	$(INSTALL_DIR) $(1)/usr/share/clash/dashboard/img
	$(INSTALL_DIR) $(1)/usr/share/clash/dashboard/js
	
	$(INSTALL_DIR) $(1)/usr/share/clash/config
	$(INSTALL_DIR) $(1)/usr/share/clash/config/sub
	$(INSTALL_DIR) $(1)/usr/share/clash/config/upload
	$(INSTALL_DIR) $(1)/usr/share/clash/config/custom
	$(INSTALL_DIR) $(1)/usr/share/clash/v2ssr
	

	$(INSTALL_BIN) ./root/usr/share/clash/config/upload/config.yaml $(1)/usr/share/clash/config/upload/
	$(INSTALL_BIN) ./root/usr/share/clash/config/custom/config.yaml $(1)/usr/share/clash/config/custom/
	$(INSTALL_BIN) ./root/usr/share/clash/config/sub/config.yaml $(1)/usr/share/clash/config/sub/

	$(INSTALL_BIN) 	./root/etc/init.d/clash $(1)/etc/init.d/clash
	$(INSTALL_CONF) ./root/etc/config/clash $(1)/etc/config/clash
	$(INSTALL_CONF) ./root/etc/clash/* $(1)/etc/clash/

	$(INSTALL_BIN) ./root/usr/share/clash/v2ssr/v2ssr_custom_rule.yaml $(1)/usr/share/clash/v2ssr/
	$(INSTALL_BIN) ./root/usr/share/clash/v2ssr/policygroup $(1)/usr/share/clash/v2ssr/

	$(INSTALL_BIN) ./root/usr/share/clash/clash-watchdog.sh $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/clash.sh $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/ipdb.sh $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/load.sh $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/logstatus_check $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/proxy.sh $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/dns.yaml $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/custom_rule.yaml $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/yum_change.sh $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/groups.sh $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/rule.sh $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/list.sh $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/v2ssr.sh $(1)/usr/share/clash/
	$(INSTALL_BIN) ./root/usr/share/clash/server.list $(1)/usr/share/clash/

	$(INSTALL_BIN) ./root/usr/share/clash/yac/* $(1)/usr/share/clash/yac/
	$(INSTALL_BIN) ./root/usr/share/clash/dashboard/index.html $(1)/usr/share/clash/dashboard/
	$(INSTALL_BIN) ./root/usr/share/clash/dashboard/main.aee3e3fc24cd46786598.css $(1)/usr/share/clash/dashboard/
	$(INSTALL_BIN) ./root/usr/share/clash/dashboard/img/33343e6117c37aaef8886179007ba6b5.png $(1)/usr/share/clash/dashboard/img/
	$(INSTALL_BIN) ./root/usr/share/clash/dashboard/js/1.bundle.aee3e3fc24cd46786598.min.js $(1)/usr/share/clash/dashboard/js/
	$(INSTALL_BIN) ./root/usr/share/clash/dashboard/js/bundle.aee3e3fc24cd46786598.min.js $(1)/usr/share/clash/dashboard/js/
        
	$(INSTALL_DATA) ./luasrc/clash.lua $(1)/usr/lib/lua/luci/
	$(INSTALL_DATA) ./luasrc/controller/*.lua $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DATA) ./luasrc/model/cbi/clash/*.lua $(1)/usr/lib/lua/luci/model/cbi/clash/
	$(INSTALL_DATA) ./luasrc/view/clash/* $(1)/usr/lib/lua/luci/view/clash/
	$(INSTALL_DATA) ./po/zh-cn/clash.zh-cn.lmo $(1)/usr/lib/lua/luci/i18n/
	
endef



$(eval $(call BuildPackage,$(PKG_NAME)))
