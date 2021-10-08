local queries = {
    {query = [[
        CREATE TABLE IF NOT EXISTS `challenges` (
            uid SERIAL,
            type varchar(20) NOT NULL DEFAULT 'daily',
            status varchar(20) NOT NULL DEFAULT 'inactive',
            missionType varchar(20) NOT NULL DEFAULT 'outposts',
            missionCondition1 varchar(20) NOT NULL DEFAULT 'liberate',
            missionCondition2 varchar(20) NOT NULL DEFAULT 'any',
            missionCondition3 int NOT NULL DEFAULT 20,
            missionRewardXP int NOT NULL DEFAULT 0,
            missionRewardCash int NOT NULL DEFAULT 0,
            missionRewardBank int NOT NULL DEFAULT 0,
            missionRewardCoins int NOT NULL DEFAULT 0,
            missionStartUnix int NOT NULL DEFAULT 0,
            missionEndUnix int NOT NULL DEFAULT 0
        );
    ]], values = {}},
    {query = [[
        CREATE TABLE IF NOT EXISTS `challenge_users` (
            uid SERIAL,
            pID int NOT NULL,
            name varchar(50) NOT NULL,
            challengeID int NOT NULL,
            dataPoint1 varchar(50) NOT NULL,
            dataPoint2 varchar(50) NOT NULL,
            dataPoint3 varchar(50) NOT NULL
        );
    ]], values = {}},
}


AddEventHandler('onResourceStart', function(name)
    if name == GetCurrentResourceName() then
        exports.oxmysql:transaction(queries, function(result) 
        end)
    end
end)