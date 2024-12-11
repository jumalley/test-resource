function onEnter(self)
    print('Entered zone', self.name)
    TriggerServerEvent('test-resource:server:spawnPeds', self.name)
end

function onExit(self)
    print('Exited zone', self.name)
    TriggerServerEvent('test-resource:server:deletePeds', self.name)
end

lib.zones.poly({
    name = "cop",
    points = {
        vec3(-1091.0, -873.0, 5.0),
        vec3(-1080.0, -889.0, 5.0),
        vec3(-1054.0, -873.0, 5.0),
        vec3(-1032.0, -854.0, 5.0),
        vec3(-1052.0, -837.0, 5.0),
        vec3(-1088.0, -864.0, 5.0),
    },
    thickness = 4.0,
    onEnter = onEnter,
    onExit = onExit,
    debug = Config.Debug
})


lib.zones.sphere({
	name = "ambulance",
	coords = vec3(340.0, -557.0, 29.0),
	radius = 10.0,
    onEnter = onEnter,
    onExit = onExit,
    debug = Config.Debug
})


-- lib.zones.poly({
-- 	name = "ambulance",
-- 	points = {
-- 		vec3(344.0, -566.0, 29.0),
-- 		vec3(344.0, -566.0, 29.0),
-- 		vec3(351.0, -550.0, 29.0),
-- 		vec3(351.0, -536.0, 29.0),
-- 		vec3(313.0, -536.0, 29.0),
-- 		vec3(313.0, -551.0, 29.0),
-- 		vec3(311.0, -551.0, 29.0),
-- 		vec3(311.0, -559.0, 29.0),
-- 		vec3(317.0, -561.0, 29.0),
-- 		vec3(323.0, -558.0, 29.0),
-- 	},
-- 	thickness = 4.0,
--     onEnter = onEnter,
--     onExit = onExit,
--     debug = Config.Debug
-- })

RegisterNetEvent('test-resource:client:setupPed', function(netId)
    while NetworkGetEntityFromNetworkId(netId) == 0 do
        Wait(1)
    end

    local ped = NetworkGetEntityFromNetworkId(netId)

    if not DoesEntityExist(ped) then
        print("Ped does not exist for netId:", netId)
        return
    end

    local options = {
        label = 'Talk with the guy',
        name = netId,
        icon = 'fa-solid fa-warehouse',
        iconColor = '#03b1fc',
        distance = 5,
        canInteract = function(entity, distance, coords, name, bone)
            return true
        end,
        onSelect = function(data)
            print('im talking with the guy')
        end
    }

    exports.ox_target:addEntity(netId, options)

    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)

    local animDict = 'friends@frj@ig_1'
    local animName = 'wave_a'

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(1)
    end

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 0, 0, true, true, true)

    Wait(5000)

    GiveWeaponToPed(ped, joaat('weapon_petrolcan'), -1, false, true)
    SetPedCurrentWeaponVisible(ped, true, true, true, true)

    print("Animation started on ped with netId:", netId)
end)


-- function test()
-- CreatePed(1, "s_m_y_cop_01", -1068.1650, -853.5421, 4.8672, 221.4160, false, true)
-- end

-- test()