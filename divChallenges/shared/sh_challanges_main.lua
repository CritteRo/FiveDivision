sharedCurrentServerTime = 0

sharedChallenges = {
    [0] = {
        uid = 0,
        type = "daily", --daily, weekly, monthly..
        status = "inactive", --inactive or active
        missionType = 'outpost', --outpost, mission, kill, etc...
        missionCondition1 = 'liberate', --for outpost: liberate or destroy.
        missionCondition2 = 'any', --for outpost: 'any' or a factionID.
        missionCondition3 = 20, --for outpost: number of outposts that you need to achive.
        missionRewardXP = 4000,
        missionRewardCash = 4000,
        missionRewardBank = 10,
        missionRewardCoins = 0,
        missionStartUnix = 0, --os.time(), unix 
        missionEndUnix = 0, --StartUnix + seconds, depending on "type"
    }
}

sharedChallengeUsers = {
    [0]--[[challengeID]] = {
        --[pID] = {uid = 1[local id], pID = 32[players UID], name = "Console"[playername], challengeID = 0[challenge UID], dataPoint1 = 0, dataPoint2 = 0, dataPoint3 = 0},
    },
}

factionIdToName = {
    [-1] = "any",
    [0] = "any",
    [1] = "Monke",
    [2] = "North Yankton Thugs",
    [3] = "Thugs",
    [4] = "The Lost",
    [5] = "Docksmen",
}

sharedChallangeTypeName = {
    ['daily'] = "Daily Challenge: ",
    ['weekly'] = "Weekly Challenge: ",
    ['monthly'] = 'Monthly Challenge: ',
    ['ex'] = "Custom Challenge: ",
}

sharedChallangeName = {
    ['outpost'] = {
        ['liberate'] = "The Liberator: %s",
        ['destroy'] = "The Destroyer: %s",
        ['part'] = "The Backup: %s",
    }
}

sharedChallengeShortDesc = {
    ['outpost'] = { --mType
        ['liberate'] = { --mCondition 1
            ['any'] = "Liberate %i outposts controlled by any faction.", --mCondition2
            ['Monke'] = "Liberate %i outposts controlled by the Monke faction.",
            ['North Yankton Thugs'] = "Liberate %i outposts controlled by the Nork Yankton Thugs.",
            ['Thugs'] = "Liberate %i outposts controlled by the Thugs.",
            ['Docksmen'] = "Liberate %i outposts controlled by the Docksmen.",
            ['The Lost'] = "Liberate %i outposts controlled by The Lost.",
        },
        ['destroy'] = { --mCondition 1
            ['any'] = "Destroy %i enemy outpost broadcasters controlled by any faction.", --mCondition2
            ['Monke'] = "Destroy %i enemy outpost broadcasters controlled by the Monke faction.",
            ['North Yankton Thugs'] = "Destroy %i enemy outpost broadcasters controlled by the Nork Yankton Thugs.",
            ['Thugs'] = "Destroy %i enemy outpost broadcasters controlled by the Thugs.",
            ['Docksmen'] = "Destroy %i enemy outpost broadcasters controlled by the Docksmen.",
            ['The Lost'] = "Destroy %i enemy outpost broadcasters controlled by The Lost.",
        },
        ['part'] = { --mCondition 1
            ['any'] = "Take part in liberating %i outposts controlled by any faction.", --mCondition2
            ['Monke'] = "Take part in liberating %i outposts controlled by the Monke faction.",
            ['North Yankton Thugs'] = "Take part in liberating %i outposts controlled by the Nork Yankton Thugs.",
            ['Thugs'] = "Take part in liberating %i outposts controlled by the Thugs.",
            ['Docksmen'] = "Take part in liberating %i outposts controlled by the Docksmen.",
            ['The Lost'] = "Take part in liberating %i outposts controlled by The Lost.",
        },
    }
}