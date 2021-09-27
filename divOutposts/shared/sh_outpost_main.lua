outposts = {
    [1] = {name = "Alta St Contruction Site", status = 0--[[0 = enemy, 1 = abandoned, 2 = liberated]], factionID = 0, blipX = 34.67, blipY = -410.101, blipZ = 45.601, x1 = 39.68, y1 = -371.78, z1 = 63.801, x2 = 26.08, y2 = -448.27, z2 = 74.98, x3 = -27.95, y3 = -445.02, z3 = 80.992, rx = 0.0, ry = 0.0, rz = -68.821, xp = "", cash = ""},
    [2] = {name = "Premium Deluxe Motorsport", status = 0--[[0 = enemy, 1 = abandoned, 2 = liberated]], factionID = 0, blipX = -51.86, blipY = -1112.39, blipZ = 26.44, x1 = -30.25, y1 = -1104.98, z1 = 25.42, x2 = -44.41, y2 = -1095.54, z2 = 35.16, x3 = -91.08, y3 = -1127.41, z3 = 37.101, rx = 0.0, ry = 0.0, rz = -62.34, xp = "", cash = ""},
    [3] = {name = "Little Seul Construction Site", status = 0--[[0 = enemy, 1 = abandoned, 2 = liberated]], factionID = 0, blipX = -474.01, blipY = -915.26, blipZ = 29.41, x1 = -448.403, y1 = -940.547, z1 = 37.503, x2 = -501.62, y2 = -989.148, z2 = 53.776, x3 = -501.166, y3 = -886.558, z3 = 51.06, rx = 0.0, ry = 0.0, rz = -163.945, xp = "", cash = ""},
    [4] = {name = "Pillbox Rooftop Rumble", status = 0--[[0 = enemy, 1 = abandoned, 2 = liberated]], factionID = 0, blipX = 127.383, blipY = -1087.175, blipZ = 46.347, x1 = 140.14, y1 = -1090.71, z1 = 48.14, x2 = 174.46, y2 = -1095.78, z2 = 52.705, x3 = 112.613, y3 = -1069.68, z3 = 47.36, rx = 0.0, ry = 0.0, rz = -123.282, xp = "", cash = ""},
    [5] = {name = "Los Santos Police Derangement", status = 0--[[0 = enemy, 1 = abandoned, 2 = liberated]], factionID = 0, blipX = 423.301, blipY = -981.305, blipZ = 35.16, x1 = 462.38, y1 = -989.51, z1 = 23.91, x2 = 450.09, y2 = -981.67, z2 = 44.69, x3 = 398.801, y3 = -953.052, z3 = 43.08, rx = 0.0, ry = 0.0, rz = -122.96, xp = "", cash = ""},
}

enemySpawns = {
    [1] = {
        {handle = 0, x = 17.04, y = -425.06, z = 55.28},
        {handle = 0, x = 21.601, y = -429.95, z = 55.28},
        {handle = 0, x = 25.401, y = -440.901, z = 55.28},
        {handle = 0, x = 48.62, y = -409.78, z = 45.56},
        {handle = 0, x = 56.04, y = -414.601, z = 39.92},
    },
    [2] = {
        {handle = 0, x = -26.51, y = -1088.001, z = 31.001},
        {handle = 0, x = -39.75, y = -1084.19, z = 31.001},
        {handle = 0, x = -27.04, y = -1107.64, z = 34.06},
        {handle = 0, x = -32.05, y = -1091.45, z = 26.42},
        {handle = 0, x = -33.83, y = -1103.401, z = 26.42},
        {handle = 0, x = -53.84, y = -1090.71, z = 26.42},
        {handle = 0, x = -62.85, y = -1102.47, z = 26.26},
        {handle = 0, x = -46.09, y = -1115.46, z = 26.44},
    },
    [4] = {
        {handle = 0, x = 125.77, y = -1088.19, z = 30.601, h = 34.193},
        {handle = 0, x = 121.53, y = -1088.31, z = 30.569, h = 332.89},
        {handle = 0, x = 120.13, y = -1106.27, z = 37.473, h = 251.51},
        {handle = 0, x = 125.71, y = -1106.55, z = 38.065, h = 85.066},
        {handle = 0, x = 127.81, y = -1087.62, z = 45.556, h = 43.653},
        {handle = 0, x = 133.14, y = -1111.04, z = 45.566, h = 270.87},
        {handle = 0, x = 144.11, y = -1095.58, z = 52.387, h = 96.524},
        {handle = 0, x = 162.25, y = -1105.26, z = 49.155, h = 11.840},
        {handle = 0, x = 176.82, y = -1095.51, z = 52.291, h = 274.86},
    },
    [5] = {
        {handle = 0, x = 428.46, y = -975.801, z = 30.71, h = 18.497},
    },
}

factionPeds = {
    [0] = {"mp_m_fibsec_01", "weapon_carbinerifle"}, --FIB
    [1] = {"u_m_m_streetart_01", "weapon_pistol"}, --Monkey face
    [2] = {"g_m_m_chicold_01", "weapon_sawnoffshotgun"}, --jackets
}

outpostStatusName = {
    [0] = "Enemy Outpost",
    [1] = "Neutral Outpost",
    [2] = "Liberated Outpost",
}

outpostStatusBlip = {
    [0] = "~r~Captured~s~",
    [1] = "~s~Abandoned~s~",
    [2] = "~b~Liberated~s~",
}

outpostFactionName = {
    [-1] = "",
    [0] = "The Division",
    [1] = "Monke",
    [2] = "Asian Jackets",
}

outpostStatusColor = {
    [0] = "~r~",
    [1] = "~s~",
    [2] = "~b~",
}