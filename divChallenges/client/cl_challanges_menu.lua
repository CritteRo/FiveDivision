TriggerEvent('lobbymenu:CreateMenu', 'ch_main_0', "Active Challenges", "", "MENU~s~", "INFO", "")
TriggerEvent('lobbymenu:SetHeaderDetails', 'ch_main_0', true, true, 123, 0, 0)
TriggerEvent('lobbymenu:SetDetailsTitle', 'ch_main_0', "Details Title", 'sproffroad', 'spr_offroad_3')

TriggerEvent('lobbymenu:SetTextBoxToColumn', 'ch_main_0', 3, "Challenges", "Throught San Andreas, the IAA set multiple tasks for the active agents.\n\nFrom liberating outposts, to completing missions, these challenges can change the way you play the game.", "")

TriggerEvent('lobbymenu:AddButton', 'ch_main_0', {text = "Showing button 1"}, "Button 1", "", false, 0, "lobby.AddPlayerToMenu")
TriggerEvent('lobbymenu:AddButton', 'ch_main_0', {text = "Showing button 2"}, "Button 2", "", false, 0, "lobby.AddDetailsToMenu")
TriggerEvent('lobbymenu:AddButton', 'ch_main_0', {text = "Showing button 3"}, "Button 3", "", false, 0, "lobby.AddWarningToMenu")
TriggerEvent('lobbymenu:AddButton', 'ch_main_0', {id = 0, text = "Button Used"}, "Close Menu", "", false, 0, "lobbymenu:CloseMenu")

--TriggerEvent('lobbymenu:AddPlayer', 'ch_main_0', "CritteR", '', "ADMIN", 65, 1, true, 12, 6)

TriggerEvent('lobbymenu:AddDetailsRow', 'ch_main_0', "Details Row 1", "~y~2 minutes~s~")

RegisterCommand('challenges', function(source, args)
    TriggerEvent('lobbymenu:OpenMenu', 'ch_main_0', true)
end)
