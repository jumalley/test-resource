local spawnedPeds = {}

CreatePed(model, coords)

function CreatePed(model, coords)
    local ped = CreatePed(1, model, coords.x, coords.y, coords.z, coords.h, true, false)

    while not DoesEntityExist(ped) do Wait(0) end

    local netId = NetworkGetNetworkIdFromEntity(ped)

    table.insert(spawnedPeds, netId)
    print(json.encode(spawnedPeds))

    return netId

end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteSpawnedPeds()
    end
end)

function DeleteSpawnedPeds()
    for _, netId in ipairs(spawnedPeds) do
        if netId and DoesEntityExist(netId) then
            local ped = NetworkGetEntityFromNetworkId(netId)
            DeleteEntity(ped)
        end
    end
    spawnedPeds = {}
end