ModdedVehicles = {}
VehicleStatus = {}
ClosestPlate = nil
isLoggedIn = false
PlayerJob = {}

local onDuty = false

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerJob.onduty then
            if PlayerJob.name == Config.jobname then
                TriggerServerEvent('QBCore:ToggleDuty')
            end
        end
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty) onDuty = duty end)

Citizen.CreateThread(function()
    local c = Config.Locations['exit']
    local Blip = AddBlipForCoord(c.x, c.y, c.z)

    SetBlipSprite(Blip, 446)
    SetBlipDisplay(Blip, 4)
    SetBlipScale(Blip, 0.7)
    SetBlipAsShortRange(Blip, true)
    SetBlipColour(Blip, 0)
    SetBlipAlpha(Blip, 0.7)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.jobname)
    EndTextCommandSetBlipName(Blip)
end)

Citizen.CreateThread(function()
    while true do
        local inRange = false
        if isLoggedIn then
            local currentjob = QBCore.Functions.GetPlayerData().job
            local jobname = currentjob.name
            if jobname == Config.jobname then
                local pos = GetEntityCoords(PlayerPedId())
                local StashDistance = #(pos -
                                          vector3(Config.Locations['stash'].x,
                                                  Config.Locations['stash'].y,
                                                  Config.Locations['stash'].z))
                local OnDutyDistance = #(pos -
                                           vector3(Config.Locations['duty'].x,
                                                   Config.Locations['duty'].y,
                                                   Config.Locations['duty'].z))
                local VehicleDistance = #(pos -
                                            vector3(
                                                Config.Locations['vehicle'].x,
                                                Config.Locations['vehicle'].y,
                                                Config.Locations['vehicle'].z))

                if onDuty then
                    if StashDistance < 20 then
                        inRange = true
                        DrawMarker(2, Config.Locations['stash'].x,
                                   Config.Locations['stash'].y,
                                   Config.Locations['stash'].z, 0.0, 0.0, 0.0,
                                   0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9,
                                   255, false, false, false, true, false, false,
                                   false)

                        if StashDistance < 1 then
                            DrawText3Ds(Config.Locations['stash'].x,
                                        Config.Locations['stash'].y,
                                        Config.Locations['stash'].z,
                                        '[E] Open Stash')
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent("inventory:client:SetCurrentStash", Config.stashname)
                                TriggerServerEvent("inventory:server:OpenInventory", "stash", Config.stashname, {
                                    maxweight = 4000000,
                                    slots = 500,
                                })
                            end
                        end
                    end
                end

                if onDuty then
                    if VehicleDistance < 20 then
                        inRange = true
                        DrawMarker(2, Config.Locations['vehicle'].x,
                                   Config.Locations['vehicle'].y,
                                   Config.Locations['vehicle'].z, 0.0, 0.0, 0.0,
                                   0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9,
                                   255, false, false, false, true, false, false,
                                   false)
                        if VehicleDistance < 1 then
                            local InVehicle = IsPedInAnyVehicle(PlayerPedId())

                            if InVehicle then
                                DrawText3Ds(Config.Locations['vehicle'].x,
                                            Config.Locations['vehicle'].y,
                                            Config.Locations['vehicle'].z,
                                            '[E] Hide Vehicle')
                                if IsControlJustPressed(0, 38) then
                                    DeleteVehicle(GetVehiclePedIsIn(
                                                      PlayerPedId()))
                                end
                            else
                                DrawText3Ds(Config.Locations['vehicle'].x,
                                            Config.Locations['vehicle'].y,
                                            Config.Locations['vehicle'].z,
                                            '[E] Get Vehicle')
                                if IsControlJustPressed(0, 38) then
                                    if IsControlJustPressed(0, 38) then
                                        VehicleList()
                                        Menu.hidden = not Menu.hidden
                                    end
                                end
                                Menu.renderGUI()
                            end
                        end
                    end
                end

                if OnDutyDistance < 20 then
                    inRange = true
                    DrawMarker(2, Config.Locations['duty'].x,
                               Config.Locations['duty'].y,
                               Config.Locations['duty'].z, 0.0, 0.0, 0.0, 0.0,
                               0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false,
                               false, false, true, false, false, false)

                    if OnDutyDistance < 1 then
                        if onDuty then
                            DrawText3Ds(Config.Locations['duty'].x,
                                        Config.Locations['duty'].y,
                                        Config.Locations['duty'].z,
                                        '[E] Off Duty')
                        else
                            DrawText3Ds(Config.Locations['duty'].x,
                                        Config.Locations['duty'].y,
                                        Config.Locations['duty'].z,
                                        '[E] On Duty')
                        end
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent('QBCore:ToggleDuty')
                        end
                    end
                end
            end
        end
        Citizen.Wait(3)
    end
end)

function VehicleList()
    ClearMenu()
    for k, v in pairs(Config.Vehicles) do
        Menu.addButton(v, 'SpawnListVehicle', k)
    end
    Menu.addButton('Close Menu', 'CloseMenu', nil)
end

function SpawnListVehicle(model)
    local coords = {
        x = Config.Locations['vehicle'].x,
        y = Config.Locations['vehicle'].y,
        z = Config.Locations['vehicle'].z,
        h = Config.Locations['vehicle'].w
    }
    local plate = 'AC' .. math.random(1111, 9999)
    QBCore.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh,
                                  'ACBV' .. tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, Config.Locations["vehicle"].w)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        Menu.hidden = true
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent('vehiclekeys:client:SetOwner',
                     GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

-- Menu Functions

CloseMenu = function()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

ClearMenu = function()
    -- Menu = {}
    Menu.GUI = {}
    Menu.buttonCount = 0
    Menu.selection = 0
end

function noSpace(str)
    local normalisedString = string.gsub(str, '%s+', '')
    return normalisedString
end
