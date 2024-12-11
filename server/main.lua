local spawnedPeds = {}

local function spawnPed(model, coords)
    local ped = CreatePed(1, model, coords.x, coords.y, coords.z, coords.w, true, false)
    while not DoesEntityExist(ped) do Wait(0) end

    local netId = NetworkGetNetworkIdFromEntity(ped)
    return netId
end

local function spawnPedsByZone(zoneId)
    print("Attempting to spawn peds for zone:", zoneId)

    local found = false
    spawnedPeds[zoneId] = spawnedPeds[zoneId] or {}

    for _, pedData in ipairs(Config.Peds) do
        if pedData.zoneId == zoneId then
            found = true
            print(string.format("Spawning ped with model '%s' at coords %s for zone '%s'", pedData.model, tostring(pedData.coords), zoneId))
            local netId = spawnPed(pedData.model, pedData.coords)
            table.insert(spawnedPeds[zoneId], netId)

            TriggerClientEvent('test-resource:client:setupPed', -1, netId)
        end
    end

    if not found then
        print("No peds found for the specified zone:", zoneId)
    end
end

local function deletePedsByZone(zoneId)
    if not spawnedPeds[zoneId] then
        print("No peds to delete for zone:", zoneId)
        return
    end

    print("Deleting peds for zone:", zoneId)
    for _, netId in ipairs(spawnedPeds[zoneId]) do
        local ped = NetworkGetEntityFromNetworkId(netId)
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end

    spawnedPeds[zoneId] = nil
end

RegisterNetEvent('test-resource:server:spawnPeds', function(zoneId)
    if type(zoneId) ~= "string" then return end
    spawnPedsByZone(zoneId)
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
