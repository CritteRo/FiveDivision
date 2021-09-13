-- We only save the texture directories for clothes. The are so many combinations only in the base game, that making individual items for every texture will be a nightmare.
-- The player will be able to change the texture, for a price. 


cosmeticClothes = {
    ['mp_m_freemode_01'] = { ---MALE CLOTHES-----------------------------------------------------------------------
        [1] = {
            {"comp3", 1, "Default Jacket"},
            {"comp8", 32},
            {"comp11", 167},
        },
        [2] = {
            {"comp4", 9, "Default Pants"},
        },
        [3] = {
            {"comp6", 25, "Default Shoes"},
        },
        [4] = {
            {"comp2", 1, "Default Hairstyle"},
        },
        [5] = {
            {"comp3", 1, "Sports Jacket"},
            {"comp8", 0},
            {"comp11", 88},
        },
        [6] = {
            {"comp4", 4, "Fit Jeans"},
        },
        [7] = {
            {"comp4", 1, "Regular Jeans"},
        },
        [8] = {
            {'comp2', 0, "Bald / No hairstyle"},
        }
    },
    ['mp_f_freemode_01'] = { ---FEMALE CLOTHES-----------------------------------------------------------------------
        [1] = {
            {"comp3", 1, "Default Shirt"},
            {"comp8", 0},
            {"comp11", 88},
        },
        [2] = {
            {"comp4", 9, "Default Pants"},
        },
        [3] = {
            {"comp6", 25, "Default Shoes"},
        },
        [4] = {
            {"comp2", 1, "Default Hairstyle"},
        },
        [5] = {
            {"comp3", 7, 'Jacket'},
            {"comp8", 51},
            {"comp11", 240},
        },
    }
}