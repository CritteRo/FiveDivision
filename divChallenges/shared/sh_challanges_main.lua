sharedChallanges = {
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
        missionRewardCoins = 0,
        missionStartUnix = 0, --os.time(), unix 
        missionEndUnix = 0, --StartUnix + seconds, depending on "type"
    }
}