module("luci.controller.clash", package.seeall)
local fs=require"nixio.fs"
local http=require"luci.http"
local uci=require"luci.model.uci".cursor()

function index()

	if not nixio.fs.access("/etc/config/clash") then
		return
	end

	entry({"admin", "services", "clash"},alias("admin", "services", "clash", "overview"), _("Clash"), 10).dependent = false
	entry({"admin", "services", "clash", "overview"},cbi("clash/overview"),_("Overview"), 10).leaf = true
	entry({"admin", "services", "clash", "client"},cbi("clash/client"),_("Client"), 20).leaf = true
	entry({"admin", "services", "clash", "import"},cbi("clash/import"),_("Import Config"), 30).leaf = true
	entry({"admin", "services", "clash", "create"},cbi("clash/create"),_("Create Config"), 40).leaf = true
    	entry({"admin", "services", "clash", "servers-config"},cbi("clash/servers-config"), nil).leaf = true
    	entry({"admin", "services", "clash", "groups"},cbi("clash/groups"), nil).leaf = true

	entry({"admin", "services", "clash", "settings"}, firstchild(),_("Settings"), 50)
	entry({"admin", "services", "clash", "settings", "port"},cbi("clash/port"),_("Proxy Ports"), 60).leaf = true
	entry({"admin", "services", "clash", "settings", "dns"},cbi("clash/dns"),_("DNS Settings"), 70).leaf = true
	entry({"admin", "services", "clash", "settings", "list"},cbi("clash/list"),_("Custom List"), 80).leaf = true
	entry({"admin", "services", "clash", "settings", "access"},cbi("clash/access"),_("Access Control"), 90).leaf = true
			
	entry({"admin", "services", "clash", "config"},firstchild(),_("Config"), 100)
	entry({"admin", "services", "clash", "config", "actconfig"},cbi("clash/actconfig"),_("Config In Use"), 110).leaf = true
	entry({"admin", "services", "clash", "config", "subconfig"},cbi("clash/subconfig"),_("Subscribe Config"), 120).leaf = true
	entry({"admin", "services", "clash", "config", "upconfig"},cbi("clash/upconfig"),_("Uploaded Config"), 130).leaf = true
	entry({"admin", "services", "clash", "config", "cusconfig"},cbi("clash/cusconfig"),_("Custom Config"), 140).leaf = true
	
	entry({"admin","services","clash","status"},call("action_status")).leaf=true
	entry({"admin", "services", "clash", "log"},cbi("clash/log"),_("Log"), 150).leaf = true

	entry({"admin", "services", "clash", "ping"}, call("act_ping")).leaf=true
	entry({"admin", "services", "clash", "readlog"},call("action_read")).leaf=true
	entry({"admin", "services", "clash", "getlog"}, call("get_log")).leaf=true
	entry({"admin", "services", "clash", "logstatus"},call("logstatus_check")).leaf=true
	
end

local function dash_port()
	return luci.sys.exec("uci get clash.config.dash_port 2>/dev/null")
end
local function dash_pass()
	return luci.sys.exec("uci get clash.config.dash_pass 2>/dev/null")
end

local function is_running()
	return luci.sys.call("pidof clash >/dev/null") == 0
end

local function is_web()
	return luci.sys.call("pidof clash >/dev/null") == 0
end

local function localip()
	return luci.sys.exec("uci get network.lan.ipaddr")
end


local function e_mode()
	return luci.sys.exec("egrep '^ {0,}enhanced-mode' /etc/clash/config.yaml |grep enhanced-mode: |awk -F ': ' '{print $2}'")
end

local function readlog()
	return luci.sys.exec("sed -n '$p' /usr/share/clash/clash_real.log 2>/dev/null")
end

function action_read()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
			readlog = readlog();
	})
end

function action_status()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		web = is_web(),
		clash = is_running(),
		localip = localip(),
		dash_port = dash_port(),
		dash_pass = dash_pass(),
		e_mode = e_mode()

	})
end

function act_ping()
	local e={}
	e.index=luci.http.formvalue("index")
	e.ping=luci.sys.exec("ping -c 1 -W 1 %q 2>&1 | grep -o 'time=[0-9]*.[0-9]' | awk -F '=' '{print$2}'"%luci.http.formvalue("domain"))
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end


function logstatus_check()
	luci.http.prepare_content("text/plain; charset=utf-8")
	local fdp=tonumber(fs.readfile("/usr/share/clash/logstatus_check")) or 0
	local f=io.open("/tmp/clash.log", "r+")
	f:seek("set",fdp)
	local a=f:read(2048000) or ""
	fdp=f:seek()
	fs.writefile("/usr/share/clash/logstatus_check",tostring(fdp))
	f:close()
if fs.access("/var/run/logstatus") then
	luci.http.write(a)
else
	luci.http.write(a.."\0")
end
end

