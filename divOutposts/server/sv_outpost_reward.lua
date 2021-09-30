rewards = {
    --[outpostID] = {uid, outpostID, unlockType, mvpXP, mvpCash, mvpUnlockWeapon, mvpUnlockWeaponMod, mvpUnlockCosmetic, otherCash, otherXP, otherCash2, otherXP2},
}

AddEventHandler('outpost.RequestOutpostRewards', function()
    rewards = {}
    exports.oxmysql:fetch("SELECT * FROM `outpost_rewards` WHERE 1",{},function (result)
        local rows = 0
        for i,k in pairs(result) do
            rewards[k.outpostID] = k
            rows = rows + 1
        end
        print('Server loaded '..rows..' outpost rewards.')
    end)
end)


AddEventHandler('outpost.SendRewardsToPlayers', function(_mvp, _oID, _type)
    -- _mvp = The player source that destroyed the broadcaster, or liberated the outpost.
    -- _oID = outpost ID
    -- _type = 1 - destroyed outpost / 2 - liberated outpost
    local mvp = tonumber(_mvp)
    local oID = tonumber(_oID)
    local type = tonumber(_type)
    if rewards[oID] ~= nil then
        if type == 1 then
            --mvp rewards
            if PlayerInfo[mvp] ~= nil and GetPlayerPing(mvp) ~= 0 then
                --XP, Cash and sometimes a random unlock
                TriggerEvent('core.ChangePlayerInfo', 'stats', 'Outposts/sv_outpost_reward.lua', mvp, "xp", 0, PlayerInfo[mvp].stats['xp'] + rewards[oID].mvpXP, false)
                TriggerEvent('core.ChangePlayerInfo', 'stats', 'Outposts/sv_outpost_reward.lua', mvp, "cash", 0, PlayerInfo[mvp].stats['cash'] + rewards[oID].mvpCash, true)
            end
            for _,id in ipairs(GetPlayers()) do
                local coords = GetEntityCoords(GetPlayerPed(id))
                local dist = #(vector3(outposts[oID].blipX, outposts[oID].blipY, outposts[oID].blipZ) - coords)
                if dist <= 200.01 then
                    --xp and cash
                    if tonumber(id) ~= mvp then
                        TriggerEvent('core.ChangePlayerInfo', 'stats', 'Outposts/sv_outpost_reward.lua', id, "xp", 0, PlayerInfo[tonumber(id)].stats['xp'] + rewards[oID].otherXP, false)
                        TriggerEvent('core.ChangePlayerInfo', 'stats', 'Outposts/sv_outpost_reward.lua', id, "cash", 0, PlayerInfo[tonumber(id)].stats['cash'] + rewards[oID].otherCash, true)
                    end
                end
            end
        elseif type == 2 then
            if PlayerInfo[mvp] ~= nil and GetPlayerPing(mvp) ~= 0 then
                --XP, Cash and sometimes a random unlock
                local _change = math.random(1, 100)
                _change = math.random(1, 100)
                _change = math.random(1, 100)
                _change = math.random(1, 100)
                if _change <= 101 then --30
                    if rewards[oID].unlockType == 1 then --cosmetic
                        TriggerEvent('core.ChangePlayerInfo', 'clothes', 'Outposts/sv_outpost_reward.lua', mvp, rewards[oID].mvpUnlockCosmetic, 0, true, true)
                    elseif rewards[oID].unlockType == 2 then --weapon
                        TriggerEvent('core.ChangePlayerInfo', 'weapons', 'Outposts/sv_outpost_reward.lua', mvp, rewards[oID].mvpUnlockWeapon, 0, true, true)
                    elseif rewards[oID].unlockType == 3 then --weaponmod
                        TriggerEvent('core.ChangePlayerInfo', 'weaponmods', 'Outposts/sv_outpost_reward.lua', mvp, rewards[oID].mvpUnlockWeaponMod, rewards[oID].mvpUnlockWeapon, true, true)
                    end
                else
                    print('no reward for you')
                end
            end
            for _,id in ipairs(GetPlayers()) do
                local coords = GetEntityCoords(GetPlayerPed(id))
                local dist = #(vector3(outposts[oID].blipX, outposts[oID].blipY, outposts[oID].blipZ) - coords)
                if dist <= 200.01 then
                    --xp and cash
                    if tonumber(id) ~= mvp then
                        TriggerEvent('core.ChangePlayerInfo', 'stats', 'Outposts/sv_outpost_reward.lua', id, "xp", 0, PlayerInfo[tonumber(id)].stats['xp'] + rewards[oID].otherXP2, false)
                        TriggerEvent('core.ChangePlayerInfo', 'stats', 'Outposts/sv_outpost_reward.lua', id, "cash", 0, PlayerInfo[tonumber(id)].stats['cash'] + rewards[oID].otherCash2, true)
                    end
                end
            end
        end
    end
end)