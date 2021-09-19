local menuMotherID = {
    "Hannah","Audrey","Jasmine","Gisselle","Amelia",
    "Isabella","Zoe","Ava","Camila","Violet",
    "Sophia","Evelyn","Nicole","Ashley","Grace",
    "Brianna","Natalia","Olivia","Elizabeth","Charlotte",
    "Emma","Misty",
}
local menuFatherID = {
    "Benjamin","Daniel","Joshua","Noah","Andrew",
    "Juan","Alex","Isac","Evan","Ethan","Vincent",
    "Angel","Diego","Adrian","Gabriel","Michael",
    "Santiago","Kevin","Louis","Samuel","Anthony",
    "Claude","Niko","John",
}

menuMixID_2 = {
    '0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9'
}
menuMixID = {
    '0%','10%','20%','30%','40%','50%','60%','70%','80%','90%','100%'
}

menuParentIndex = {
    ['mother'] = {
        [1] = {name = "Hannah", id = 21},
        [2] = {name = "Audrey", id = 22},
        [3] = {name = "Jasmine", id = 23},
        [4] = {name = "Gisselle", id = 24},
        [5] = {name = "Amelia", id = 25},
        [6] = {name = "Isabella", id = 26},
        [7] = {name = "Zoe", id = 27},
        [8] = {name = "Ava", id = 28},
        [9] = {name = "Camila", id = 29},
        [10] = {name = "Violet", id = 30},
        [11] = {name = "Sophia", id = 31},
        [12] = {name = "Evelyn", id = 32},
        [13] = {name = "Nicole", id = 33},
        [14] = {name = "Ashley", id = 34},
        [15] = {name = "Grace", id = 35},
        [16] = {name = "Brianna", id = 36},
        [17] = {name = "Natalia", id = 37},
        [18] = {name = "Olivia", id = 38},
        [19] = {name = "Elizabeth", id = 39},
        [20] = {name = "Charlotte", id = 40},
        [21] = {name = "Emma", id = 41},
        [22] = {name = "Misty", id = 45},
    },
    ['father'] = {
        [1] = {name = "Benjamin", id = 0},
        [2] = {name = "Daniel", id = 1},
        [3] = {name = "Joshua", id = 2},
        [4] = {name = "Noah", id = 3},
        [5] = {name = "Andrew", id = 4},
        [6] = {name = "Juan", id = 5},
        [7] = {name = "Alex", id = 6},
        [8] = {name = "Isac", id = 7},
        [9] = {name = "Evan", id = 8},
        [10] = {name = "Ethan", id = 9},
        [11] = {name = "Vincent", id = 10},
        [12] = {name = "Angel", id = 11},
        [13] = {name = "Diego", id = 12},
        [14] = {name = "Adrian", id = 13},
        [15] = {name = "Gabriel", id = 14},
        [16] = {name = "Michael", id = 15},
        [17] = {name = "Santiago", id = 16},
        [18] = {name = "Kevin", id = 17},
        [19] = {name = "Louis", id = 18},
        [20] = {name = "Samuel", id = 19},
        [21] = {name = "Anthony", id = 20},
        [22] = {name = "Claude", id = 42},
        [23] = {name = "Niko", id = 43},
        [24] = {name = "John", id = 44},
    },
    ['mix'] = {
        [1] = 0.0,
        [2] = 0.1,
        [3] = 0.2,
        [4] = 0.3,
        [5] = 0.4,
        [6] = 0.5,
        [7] = 0.6,
        [8] = 0.7,
        [9] = 0.8,
        [10] = 0.9,
        [11] = 1.0,
    },
}

local motherIDindex = 1
local fatherIDindex = 1
local shapeIndex = 1
local skinIndex = 1
local menuModel = ""

local overlayIndexes = {
    --{"Name" = "Blemishes", index = 1, list = {}}
}

local overlayColorIndexes = {
    {name = "Makeup Primary Color", id = 4, type = 1, index = 1, list = {}},
    {name = "Makeup Secondary Color", id = 4, type = 2, index = 1, list = {}},
    {name = "Blush Primary Color", id = 5, type = 1, index = 1, list = {}},
    {name = "Blush Secondary Color", id = 5, type = 2, index = 1, list = {}},
    {name = "Lipstick Primary Color", id = 8, type = 1, index = 1, list = {}},
    {name = "Lipstick Secondary Color", id = 8, type = 2, index = 1, list = {}},
}

WarMenu.CreateMenu('core.CharacterCreation01', "Character Creation", "Select an option")
WarMenu.CreateSubMenu('core.CharacterCreation02', "core.CharacterCreation01", "Gender")
WarMenu.CreateSubMenu('core.CharacterCreation03', "core.CharacterCreation01", "Heritage")
WarMenu.CreateSubMenu('core.CharacterCreation04', "core.CharacterCreation01", "Face Features")
WarMenu.CreateSubMenu('core.CharacterCreation05', "core.CharacterCreation01", "Face Feature Color")


AddEventHandler('core.OpenCharCreationMenu', function()
    resetCharMenuButtons()
    generateOverlays()
    WarMenu.OpenMenu('core.CharacterCreation01')
    while true do
        if WarMenu.Begin('core.CharacterCreation01') then
            WarMenu.MenuButton('Change Model', 'core.CharacterCreation02')
            WarMenu.Button('Change Heritage')
            if WarMenu.IsItemSelected() then
                resetCharMenuButtons()
                TaskLookAtCoord(PlayerPedId(), camCoords[2].x, camCoords[2].y, camCoords[2].z, -1, 1, 1)
                WarMenu.OpenMenu('core.CharacterCreation03')
            end
            WarMenu.Button('Change Face Features')
            if WarMenu.IsItemSelected() then
                resetOverlays()
                TaskLookAtCoord(PlayerPedId(), camCoords[2].x, camCoords[2].y, camCoords[2].z, -1, 1, 1)
                WarMenu.OpenMenu('core.CharacterCreation04')
            end
            WarMenu.Button('Change Face Feature Colors')
            if WarMenu.IsItemSelected() then
                --resetOverlays()
                TaskLookAtCoord(PlayerPedId(), camCoords[2].x, camCoords[2].y, camCoords[2].z, -1, 1, 1)
                WarMenu.OpenMenu('core.CharacterCreation05')
            end
            WarMenu.Button('Save Character')
            if WarMenu.IsItemSelected() then
                PlayerInfo.ped = defaultCharacter[menuModel]
                PlayerInfo.ped['model'] = menuModel
                PlayerInfo.ped['blend'] = {menuParentIndex['mother'][motherIDindex].id, menuParentIndex['father'][fatherIDindex].id, menuParentIndex['mix'][shapeIndex], menuParentIndex['mix'][skinIndex]}
                PlayerInfo.ped['overlay'] = {overlayIndexes[0].idList[overlayIndexes[0].index], overlayIndexes[3].idList[overlayIndexes[3].index], overlayIndexes[4].idList[overlayIndexes[4].index], 0, overlayIndexes[5].idList[overlayIndexes[5].index], 0, overlayIndexes[6].idList[overlayIndexes[6].index], overlayIndexes[7].idList[overlayIndexes[7].index], overlayIndexes[8].idList[overlayIndexes[8].index], 0, overlayIndexes[9].idList[overlayIndexes[9].index]}
                PlayerInfo.ped['overlayColor'] = {overlayColorIndexes[1].list[overlayColorIndexes[1].index], overlayColorIndexes[2].list[overlayColorIndexes[2].index], overlayColorIndexes[3].list[overlayColorIndexes[3].index], overlayColorIndexes[4].list[overlayColorIndexes[4].index], overlayColorIndexes[5].list[overlayColorIndexes[5].index], overlayColorIndexes[6].list[overlayColorIndexes[6].index]}
                TriggerServerEvent('core.SavePlayerCharacter', PlayerInfo.ped)
                WarMenu.CloseMenu()
            end
            WarMenu.Button('Cancel Character Creation')
            if WarMenu.IsItemSelected() then
                isPlayerInCharacterCreation = false
                ClearFocus()
                RenderScriptCams(false, false, 0, true, false)
                DestroyCam(cam1, false)
                DestroyCam(cam1, false)
                WarMenu.CloseMenu()
                TriggerEvent('core.respawn', true)
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.CharacterCreation02') then
            WarMenu.Button('Male')
            if WarMenu.IsItemSelected() then
                setPlayerCharacter(defaultCharacter['mp_m_freemode_01'])
                menuModel = 'mp_m_freemode_01'
            end
            WarMenu.Button('Female')
            if WarMenu.IsItemSelected() then
                setPlayerCharacter(defaultCharacter['mp_f_freemode_01'])
                menuModel = 'mp_f_freemode_01'
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.CharacterCreation03') then
            local _, _motherIndex = WarMenu.ComboBox('Mother', menuMotherID, motherIDindex)
            if motherIDindex ~= _motherIndex then
                motherIDindex = _motherIndex
                SetPedHeadBlendData(PlayerPedId(), menuParentIndex['mother'][motherIDindex].id, menuParentIndex['father'][fatherIDindex].id, 0, menuParentIndex['mother'][motherIDindex].id, menuParentIndex['father'][fatherIDindex].id, 0, menuParentIndex['mix'][shapeIndex], menuParentIndex['mix'][skinIndex], 0.0, false)
            end

            local _, _fatherIndex = WarMenu.ComboBox('Father', menuFatherID, fatherIDindex)
            if fatherIDindex ~= _fatherIndex then
                fatherIDindex = _fatherIndex
                SetPedHeadBlendData(PlayerPedId(), menuParentIndex['mother'][motherIDindex].id, menuParentIndex['father'][fatherIDindex].id, 0, menuParentIndex['mother'][motherIDindex].id, menuParentIndex['father'][fatherIDindex].id, 0, menuParentIndex['mix'][shapeIndex], menuParentIndex['mix'][skinIndex], 0.0, false)
            end

            local _, _shapeIndex = WarMenu.ComboBox('Shape Ratio', menuMixID, shapeIndex)
            if shapeIndex ~= _shapeIndex then
                shapeIndex = _shapeIndex
                SetPedHeadBlendData(PlayerPedId(), menuParentIndex['mother'][motherIDindex].id, menuParentIndex['father'][fatherIDindex].id, 0, menuParentIndex['mother'][motherIDindex].id, menuParentIndex['father'][fatherIDindex].id, 0, menuParentIndex['mix'][shapeIndex], menuParentIndex['mix'][skinIndex], 0.0, false)
            end

            local _, _skinIndex = WarMenu.ComboBox('Skin Ratio', menuMixID, skinIndex)
            if skinIndex ~= _skinIndex then
                skinIndex = _skinIndex
                SetPedHeadBlendData(PlayerPedId(), menuParentIndex['mother'][motherIDindex].id, menuParentIndex['father'][fatherIDindex].id, 0, menuParentIndex['mother'][motherIDindex].id, menuParentIndex['father'][fatherIDindex].id, 0, menuParentIndex['mix'][shapeIndex], menuParentIndex['mix'][skinIndex], 0.0, false)
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.CharacterCreation04') then
            for i,k in pairs(overlayIndexes) do
                local _, _index = WarMenu.ComboBox(k.name, k.menuList, k.index)
                if k.index ~= _index then
                    k.index = _index
                    SetPedHeadOverlay(PlayerPedId(), i, k.idList[k.index], 1.0)
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('core.CharacterCreation05') then
            for i,k in pairs(overlayColorIndexes) do
                local _, _index = WarMenu.ComboBox(k.name, k.list, k.index)
                if k.index ~= _index then
                    k.index = _index
                    if k.type == 1 then
                        SetPedHeadOverlayColor(PlayerPedId(), k.id, 2, overlayColorIndexes[i].index - 1, overlayColorIndexes[i+1].index - 1)
                    elseif k.type == 2 then
                        SetPedHeadOverlayColor(PlayerPedId(), k.id, 2, overlayColorIndexes[i-1].index - 1, overlayColorIndexes[i].index - 1)
                    end
                end
            end
            WarMenu.End()
        else
            return
        end
        Citizen.Wait(0)
    end
end)

function resetCharMenuButtons()
    local initialBlend = exports.hbw:GetHeadBlendData(PlayerPedId())
    for i,k in pairs(menuParentIndex['mother']) do
        if k.id == initialBlend['FirstFaceShape'] then
            motherIDindex = i
            break
        end
    end
    for i,k in pairs(menuParentIndex['father']) do
        if k.id == initialBlend['SecondFaceShape'] then
            fatherIDindex = i
            break
        end
    end
    for i,k in pairs(menuParentIndex['mix']) do
        if tostring(k) == string.format("%.1f", initialBlend['ParentFaceShapePercent']) then
            shapeIndex = i
        end
        if tostring(k) == string.format("%.1f", initialBlend['ParentSkinTonePercent']) then
            skinIndex = i
        end
    end
end

function generateOverlays()
    for i=0, 9, 1 do
        if i == 1 or i == 2 then
            --no facial hair or eyebrows here. Will be added on Items.
        else
            local total = GetPedHeadOverlayNum(i)
            local row = i
            overlayIndexes[row] = {name = overlayNames[i], index = 1, menuList = {}, idList = {}}
            overlayIndexes[row].menuList[1] = "N.A. / Don't add"
            overlayIndexes[row].idList[1] = 255
            for i=0, total-1, 1 do
                local row2 = #overlayIndexes[row].menuList +1
                overlayIndexes[row].menuList[row2] = i
                overlayIndexes[row].idList[row2] = i
            end
        end
    end
    for i=0, 63, 1 do
        for v,k in pairs(overlayColorIndexes) do
            overlayColorIndexes[v].list[i] = i
        end
    end
end

function resetOverlays()
    local ped = PlayerPedId()
    for i,k in pairs(overlayIndexes) do
        local id = GetPedHeadOverlayValue(ped, i)
        for b,v in pairs(k.idList) do
            if v == id then
                overlayIndexes[i].index = b
                break
            end
        end
    end
end

overlayNames = {
    [0] = "Blemishes",
    [1] = "Facial Hair",
    [2] = "Eyebrows",
    [3] = "Ageing",
    [4] = "Makeup",
    [5] = "Blush",
    [6] = "Complexion",
    [7] = "Sun Damage",
    [8] = "Lipstick",
    [9] = "Moles/Freckles",
}