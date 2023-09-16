local QBCore = exports['qb-core']:GetCoreObject()


local function DriveByControl()
    local ped = PlayerPedId()
    local p_id = PlayerId()
    local veh = GetVehiclePedIsUsing(ped)
    local v_speed = GetEntitySpeed(veh)
    local driveByWeaponHash = GetHashKey(Config.WhitelistedWeapons)
    local isAiming = IsPlayerFreeAiming(p_id)

    if Config.DisableOnlyWhenSpeeding and v_speed >= (Config.VehicleSpeedToDisable / 2.4) then
        if Config.EnablePoliceDriveBySpeeding then
            local PlayerJob = QBCore.Functions.GetPlayerData().job
            if PlayerJob and PlayerJob.name == 'police' then
                if not Config.DriverCanShoot and GetPedInVehicleSeat(veh, -1) == ped then
                    SetPlayerCanDoDriveBy(p_id, false)
                    if isAiming and Config.EnableNotify then
                        QBCore.Functions.Notify('The Driver Cannot Shoot', 'error')
                    end
                else
                    SetPlayerCanDoDriveBy(p_id, true)
                end
            else
                SetPlayerCanDoDriveBy(p_id, false)
                if isAiming and Config.EnableNotify then
                    QBCore.Functions.Notify(
                        'You are Driving Fast, You Cannot Shoot', 'error')
                end
            end
        else
            SetPlayerCanDoDriveBy(p_id, false)
            if isAiming and Config.EnableNotify then

                QBCore.Functions.Notify(
                    'You are Driving Fast, You Cannot Shoot', 'error')
            end
        end
    else
        if not Config.DriverCanShoot and GetPedInVehicleSeat(veh, -1) == ped then
            SetPlayerCanDoDriveBy(p_id, false)
            if isAiming and Config.EnableNotify then
                QBCore.Functions.Notify('The Driver Cannot Shoot', 'error')
            end
        else
            SetPlayerCanDoDriveBy(p_id, true)
        end
    end
end

CreateThread(function()
    while true do
        Wait(1500)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then DriveByControl() end
    end
end)

