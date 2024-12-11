local pedType = 'pedType'
local isNetwork = true
local bScriptHostPed = true

local listOfPeds = {
   { modelHash = 'a_m_y_business_02', coords = vector4(-2226.7527, 205.3102, 194.6066, 209.4481)},
   { modelHash = 'a_m_y_business_03', coords = vector4(-2221.1589, 194.8655, 194.6065, 305.7330)},
   { modelHash = 'a_m_y_business_01', coords = vector4(-2231.5112, 217.4586, 194.6066, 203.6290)},
}

for _, ped in pairs (listOfPeds) do
    local spawnedPed = lib.callback.await('test-resource:server:CreatePed', false, pedType, ped.modelHash, ped.coords, isNetwork, bScriptHostPed)
end

local test = 'test'