
function IsAuthorized(CitizenId)
    local retval = false
    for _, cid in pairs(Config.AuthorizedIds) do
        if cid == CitizenId then
            retval = true
            break
        end
    end
    return retval
end


--Set / Unset job commands--
QBCore.Commands.Add("setnewjob_"..Config.jobname, "Give Someone The "..Config.jobname.."job", {{name="id", help="ID Of The Player"}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = QBCore.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                TargetData.Functions.SetJob(Config.jobname)
                TriggerClientEvent('QBCore:Notify', TargetData.PlayerData.source, "You Were Hired As An "..Config.jobname.." Employee!")
                TriggerClientEvent('QBCore:Notify', source, "You have ("..TargetData.PlayerData.charinfo.firstname..") Hired As An "..Config.jobname.." Employee!")
            end
        else
            TriggerClientEvent('QBCore:Notify', source, "You Must Provide A Player ID!")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "You Cannot Do This!", "error") 
    end
end)

QBCore.Commands.Add("firejob_"..Config.jobname, "Fire a "..Config.jobname.."", {{name="id", help="ID Of The Player"}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = QBCore.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                if TargetData.PlayerData.job.name == Config.jobname then
                    TargetData.Functions.SetJob("unemployed")
                    TriggerClientEvent('QBCore:Notify', TargetData.PlayerData.source, "You Were Fired As An "..Config.jobname.." Employee!")
                    TriggerClientEvent('QBCore:Notify', source, "You have ("..TargetData.PlayerData.charinfo.firstname..") Fired As "..Config.jobname.." Employee!")
                else
                    TriggerClientEvent('QBCore:Notify', source, "Youre Not An Employee of "..Config.jobname.."!", "error")
                end
            end
        else
            TriggerClientEvent('QBCore:Notify', source, "You Must Provide A Player ID!", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, "You Cannot Do This!", "error")
    end
end)