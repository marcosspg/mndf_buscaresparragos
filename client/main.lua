



local esparragosSpawneados = {}

local blipsEsparragos = {}

local recolectando = false;

local buscandoEsparragos = false;

local NPC = {x=Config.PosicionCompradorNPC.x, y=Config.PosicionCompradorNPC.y, z=Config.PosicionCompradorNPC.z, rotation=Config.PosicionCompradorNPC.rotacion, NetworkSync = true}

local NPCPed = nil;


--Creamos el npc para vender los espárragos
Citizen.CreateThread(function()
    local modelHash = GetHashKey(Config.ModeloNPC)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    NPCPed = CreatePed(0, modelHash , NPC.x,NPC.y,NPC.z - 1, NPC.rotation, NPC.NetworkSync)
    FreezeEntityPosition(NPCPed, true)
    SetEntityInvincible(NPCPed, true)
    SetBlockingOfNonTemporaryEvents(NPCPed, true)
    TaskStartScenarioInPlace(NPCPed, "WORLD_HUMAN_GUARD_STAND_CASINO", 0, true)

    
    local mapBlip = AddBlipForCoord(Config.PosicionCompradorNPC.x, Config.PosicionCompradorNPC.y, Config.PosicionCompradorNPC.z);
    SetBlipSprite(mapBlip, 761)
    SetBlipScale(mapBlip, 1.2)
    SetBlipColour(mapBlip, 18)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Buscar Espárragos')
    EndTextCommandSetBlipName(mapBlip)

end)


Citizen.CreateThread(function()
    
    Citizen.Wait(0)
    RequestModel('Esparrago')
    while not HasModelLoaded('Esparrago') do
        Citizen.Wait(10)
    end
    --TODO Poner en el bucle 
    for _, esparrago in pairs(esparragosSpawneados) do
        DeleteObject(esparrago);
    end
    esparragosSpawneados = {}


   

    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distanceToNPC = #(playerCoords - GetEntityCoords(NPCPed))
        if distanceToNPC <=1.5 then
            if buscandoEsparragos and not IsPedInAnyVehicle(PlayerPedId())then
                ESX.ShowHelpNotification(TranslateCap('vender_esparragos'))
                if IsControlJustReleased(0, 38) then
                    
                    TriggerServerEvent('mndf_buscaresparragos:vender_esparragos')
                    for _, blip in pairs(blipsEsparragos) do
                        RemoveBlip(blip)
                        
                    end
                    for index, esparrago in pairs(esparragosSpawneados) do
                        DeleteObject(esparrago);
                    end
                    esparragosSpawneados = {}
                    blipsEsparragos = {}
                    buscandoEsparragos = false;
                    Citizen.Wait(300);
                end
                
                
            elseif not IsPedInAnyVehicle(PlayerPedId()) then
                ESX.ShowHelpNotification(TranslateCap('comenzar_busqueda'))
                if IsControlJustReleased(0, 38) then
                    --Citizen.Wait(500);
                    buscandoEsparragos = true;
                    for _,posicion in pairs(Config.PosicionesSpawnEsparragos) do

                        if math.random(-1, 3) >= 0 then --Puede spawnear un espárrago en esa posición o no
                            for i=0, math.random(1,3), 1 do
                                local handle = CreateObject(GetHashKey('Esparrago'), posicion.x+math.random(1.0,2.0), posicion.y+math.random(1.0,2.0), posicion.z-(math.random(120, 150))/100, true, false, false)
                                local blip = AddBlipForEntity(handle);
                                SetBlipAsFriendly(blip, true);
                                BeginTextCommandSetBlipName('STRING')
                                AddTextComponentSubstringPlayerName('Espárrago')
                                EndTextCommandSetBlipName(blip)
                                table.insert(esparragosSpawneados, handle)
                                table.insert(blipsEsparragos, blip)
                            end
                            
                        end
                    end
                    Citizen.Wait(300);
                end
            end
            
        end




        if buscandoEsparragos then
            for index, esparrago in pairs(esparragosSpawneados) do
                if esparrago ~= nil then
                    local distance = #(playerCoords - GetEntityCoords(esparrago))
    
                    if distance <2 and not IsPedInAnyVehicle(PlayerPedId()) then
                        ESX.ShowHelpNotification(TranslateCap('recoger_esparrago'))
                        if IsControlJustReleased(0, 38) and not recolectando then
                            recolectando = true;
                            TaskStartScenarioInPlace(PlayerPedId(), 'world_human_gardener_plant', 0, false)
                            Wait(2000)
                            ClearPedTasks(PlayerPedId())
                            Wait(5000)
                            TriggerServerEvent('mndf_buscaresparragos:recoger_esparrago')
                            DeleteObject(esparrago);
                            eliminarEsparrago(esparrago);
                            recolectando = false;
                        end
                    end
                end
            end
        end
        
    end


end)





RegisterNetEvent('mndf_buscaresparragos:noEnoughInventorySpace')
AddEventHandler('mndf_buscaresparragos:noEnoughInventorySpace', function()
    ESX.ShowNotification(TranslateCap('inventariolleno'))
end)

RegisterNetEvent('mndf_buscaresparragos:sinEsparragosEnInventario')
AddEventHandler('mndf_buscaresparragos:sinEsparragosEnInventario', function()
    ESX.ShowNotification(TranslateCap('sin_esparragos'))
end)

RegisterNetEvent('mndf_buscaresparragos:esparragosVendidos')
AddEventHandler('mndf_buscaresparragos:esparragosVendidos', function(esparragosVendidos)
    ESX.ShowNotification(TranslateCap('esparragos_vendidos', esparragosVendidos, Config.PrecioXEsparrago*esparragosVendidos))
end)




function eliminarEsparrago(esparrago)
    local oldEsparragosSpawneados = esparragosSpawneados;
    esparragosSpawneados = {};
    for _, old_esparrago in pairs(oldEsparragosSpawneados) do
        if old_esparrago ~= esparrago then
            table.insert(esparragosSpawneados, old_esparrago)
        end
    end
end