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

sharedChallangeTypeName = {
    ['daily'] = "Daily Challenge: ",
    ['weekly'] = "Weekly Challenge: ",
    ['monthly'] = 'Monthly Challenge: ',
    ['ex'] = "Custom Challenge: ",
}

sharedChallangeName = {
    ['outpost'] = {
        ['liberate'] = "The Liberator: %s",
    }
}

sharedChallengeShortDesc = {
    ['outpost'] = { --mType
        ['liberate'] = { --mCondition 1
            ['any'] = "Liberate %i outposts controlled by any faction.", --mCondition2
            ['monke'] = "Liberate %i outposts controlled by the Monke faction.",
            ['nythugs'] = "Liberate %i outposts controlled by the Nork Yankton Thugs.",
            ['docksmen'] = "Liberate %i outposts controlled by the Docksmen.",
            ['thelost'] = "Liberate %i outposts controlled by The Lost.",
        }
    }
}