local spawnedPeds = {}

function CreatePed(model, coords)
    local ped = CreatePed(1, model, coords.x, coords.y, coords.z, coords.h, true, false)

    while not DoesEntityExist(ped) do Wait(0) end

    local netId = NetworkGetNetworkIdFromEntity(ped)

    table.insert(spawnedPeds, netId)
    print(json.encode(spawnedPeds))

    return netId

end

function SpawnPedsByZone(zoneId)
local found = false
for _, pedData in ipairs(Config.Peds) do
if PedData.zoneId == zoneId then
    found = true
local netId = CreatePed(pedData.model, pedData.coords)
table.insert(spawnedPeds[zoneId], netId)

TriggerClientEvent('test-resource:client:setupPed', -1, netId)

end

end
end

function deletePedsByZone(zoneId)
if not spawnedPeds[zoneId] then 
    print('no peds to delete in zone ' .. zoneId)
    return
end

for _, netId in ipairs(spawnedPeds[zoneId]) do
    local ped = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(ped) then
        DeleteEntity(ped)
    end
end

spawnedPeds[zoneId] = nil
    
end
    

RegisterNetEvent('test-resource:server:spawnedPeds', function(zoneId)
    if type(zoneId) ~= "string" then return end
    SpawnPedsByZone(zoneId)
end)

RegisterNetEvent('test-resource:server:deletePeds', function(zoneId)
    if type(zoneId) ~= "string" then return end
    deletePedsByZone(zoneId)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for zoneId in pairs(spawnedPeds) do
            deletePedsByZone(zoneId)
        end
    end
end)
