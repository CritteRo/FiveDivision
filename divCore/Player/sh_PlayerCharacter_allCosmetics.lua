-- We only save the texture directories for clothes. The are so many combinations only in the base game, that making individual items for every texture will be a nightmare.
-- The player will be able to change the texture, for a price. 


cosmeticClothes = {
    ['mp_m_freemode_01'] = {
        [1] = {
            {"comp1", 1},
        },
        [2] = {
            {"comp3", 1},
            {"comp8", 0},
            {"comp11", 88},
        },
    },
    ['mp_f_freemode_01'] = {
        [1] = {
            {"comp1", 1},
        },
        [2] = {
            {"comp3", 7},
            {"comp8", 51},
            {"comp11", 240},
        },
    }
}