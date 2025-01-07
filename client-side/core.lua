-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("sistema_judiciario",cRP)
vSERVER = Tunnel.getInterface("sistema_judiciario")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local open = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOW
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openNui()
    if not open then
        open = true
        ExecuteCommand("e tablet")
        SetTimeout(500, function()
            SetNuiFocus(true,true)
            SendNuiMessage(json.encode({
                action = "open"
            }))
        end)
    end
end

RegisterNUICallback("close",function()
    TriggerEvent('snt/animations/setBlocked', false)
    TriggerEvent('snt/animations/stop')
    open = false
    SendNuiMessage(json.encode({action = "close"}))
    SetNuiFocus(false, false)
end)

RegisterNUICallback("toReceive",function(id,cb)
    vSERVER.queryId(id)
    cb('')
end)


function cRP.getInfoServer(data)
    if data.name == nil then
        SendNuiMessage(json.encode({
            action = "nil",
        }))
        return
    end
    SendNuiMessage(json.encode({
        action = "query",
        data = data
    }))
end