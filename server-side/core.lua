-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
local Tunnel = module("lib/Tunnel")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("sistema_judiciario",cRP)
vCLIENT = Tunnel.getInterface("sistema_judiciario")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("infoLicenses/get", "SELECT * FROM police_licenses WHERE user_id = @user_id")
vRP.prepare("infoPrison/get", "SELECT * FROM police_prison_register WHERE nuser_id = @nuser_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("jdt", function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Police") or vRP.hasGroup(user_id,"Judiciario") then
            vCLIENT.openNui(source)
        else
            TriggerClientEvent("Notify",source,"negado", "Sem permissão",4000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET INFOS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.queryId(id)
    local source = source
    local id = parseInt(id)
    local dataInfos = {}

    local identity = vRP.userIdentity(id)

    local tableLicenses = vRP.query("infoLicenses/get", {
        user_id = id,
    })

    local tablePrison = vRP.query("infoPrison/get", {
        nuser_id = id,
    })

    local port = false
    local aerea = false
    local reuPrimario = true

    for k,v in pairs(tableLicenses) do
        if v["license"] == "port" then
            port = true
        end

        if v["license"] == "aerea" then
            aerea = true
        end
    end

    if tablePrison[1] ~= nil then
        reuPrimario = false
    end

    if identity then
        dataInfos = {
            port = port,
            aerea = aerea,
            reuPrimario = reuPrimario,
            name = identity.name,
            name2 = identity.name2,
            passaport = id
        }
    end

    vCLIENT.getInfoServer(source,dataInfos)

end