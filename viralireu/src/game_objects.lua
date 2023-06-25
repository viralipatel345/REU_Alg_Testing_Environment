--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'dawnblocker_ortho_extension',
        frame = 2,
        width = 4,
        height = 3,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        type = 'pot',
        texture = 'tilesheet',
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'idle',
        states = {
            ['idle'] = {
                frame = 14
            },
            ['thrown'] = {
                frame = 14
            }
        },
        onCollide = function()
        end
    }

}

