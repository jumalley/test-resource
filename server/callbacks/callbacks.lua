local spawnedPeds = {}

lib.callback.register('test-resource:server:CreatePed', function(source, pedType, modelHash, coords, isNetwork, bScriptHostPed)
    local ped = CreatePed(pedType, modelHash, coords.x, coords.y, coords.z, coords.h, isNetwork, bScriptHostPed)
    local netId = NetworkGetNetworkIdFromEntity(ped)
    local pedData = {
        model = modelHash,
        coords = coords,
        isNetwork = isNetwork,
        ped = ped,
        netId = netId
    }

    table.insert(spawnedPeds, pedData)
    print(json.encode(spawnedPeds))

    return ped
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteSpawnedPeds()
    end
end)

function DeleteSpawnedPeds()
    for _, pedData in ipairs(spawnedPeds) do
        if pedData.ped and DoesEntityExist(pedData.ped) then
            DeleteEntity(pedData.ped)
        end
    end
    spawnedPeds = {}
end