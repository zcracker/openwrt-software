--[[
openwrt-dist-luci: ShadowSocks
]]--

local shadowsocks = "shadowsocks"
local ds = require "luci.dispatcher"
local ipkg = require("luci.model.ipkg")
local m, s, o

local encrypt_methods = {
	"rc4-md5",
	"aes-128-cfb",
	"aes-192-cfb",
	"aes-256-cfb",
	"aes-128-ctr",
	"aes-192-ctr",
	"aes-256-ctr",
	"aes-128-gcm",
	"aes-192-gcm",
	"aes-256-gcm",
	"camellia-128-cfb",
	"camellia-192-cfb",
	"camellia-256-cfb",
	"bf-cfb",
	"salsa20",
	"chacha20",
	"chacha20-ietf",
	"chacha20-ietf-poly1305",
	"xchacha20-ietf-poly1305"
}

arg[1] = arg[1] or ""

m = Map(shadowsocks, translate("ShadowSocks Server Config"))
m.redirect = ds.build_url("admin", "vpn", "shadowsocks")

s = m:section(NamedSection, arg[1], "servers", "")
s.addremove = false
s.dynamic = false

o = s:option(Value, "server", translate("Server Address"))
o.datatype = "host"
o.rmempty = false

o = s:option(Value, "server_port", translate("Server Port"))
o.datatype = "port"
o.rmempty = false

o = s:option(ListValue, "encrypt_method", translate("Encrypt Method"))
for _, v in ipairs(encrypt_methods) do o:value(v) end
o.rmempty = false

o = s:option(Value, "password", translate("Password"))
o.rmempty = false

o = s:option(Value, "local_port", translate("Local Port"))
o.datatype = "port"
o.default = 1080
o.rmempty = false

o = s:option(Value, "timeout", translate("Connection Timeout"))
o.datatype = "uinteger"
o.default = 60
o.rmempty = false

o = s:option(Value, "plugin", translate("Plugin Name"))
o.placeholder = "eg: obfs-local"

o = s:option(Value, "plugin_opts", translate("Plugin Arguments"))
o.placeholder = "eg: obfs=http;obfs-host=www.bing.com"

return m
