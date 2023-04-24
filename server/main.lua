RegisterServerEvent('mndf_buscaresparragos:recoger_esparrago')
RegisterServerEvent('mndf_buscaresparragos:vender_esparragos')


AddEventHandler('mndf_buscaresparragos:recoger_esparrago', function()
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem('esparrago', 1) then
        xPlayer.addInventoryItem('esparrago', 1)
        
    else
        xPlayer.triggerEvent('mndf_buscaresparragos:noEnoughInventorySpace')
    end

	
end)

AddEventHandler('mndf_buscaresparragos:vender_esparragos', function()
	local xPlayer = ESX.GetPlayerFromId(source)
    local numeroEsparragos = xPlayer.getInventoryItem('esparrago').count;
    if numeroEsparragos>0 then
        xPlayer.removeInventoryItem("esparrago", numeroEsparragos)
        xPlayer.addMoney(numeroEsparragos*Config.PrecioXEsparrago, "Venta")
        xPlayer.triggerEvent('mndf_buscaresparragos:esparragosVendidos', numeroEsparragos)
    else
        xPlayer.triggerEvent('mndf_buscaresparragos:sinEsparragosEnInventario')
    end

	
end)


