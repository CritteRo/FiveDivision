AddEventHandler('onResourceStart', function(name)
    if name == GetCurrentResourceName() then
        exports.oxmysql:execute([[
            CREATE TABLE IF NOT EXISTS `users` (
                uid SERIAL,
                name text NOT NULL,
                bantime int NOT NULL DEFAULT 0,
                mutetime int NOT NULL DEFAULT 0,
                stats longtext NOT NULL,
                weapons longtext NOT NULL,
                clothes longtext NOT NULL,
                ped longtext NOT NULL,
                lang varchar(4) NOT NULL DEFAULT 'en',
                admin int NOT NULL DEFAULT 0,
                license varchar(60) NOT NULL);
        ]],{}, function(affectedRows)
        end)
    end
end)