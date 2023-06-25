
Dungeon = Class{}

function Dungeon:init(player)
    self.player = player

    -- container we could use to store rooms in a static dungeon, but unused here
    self.rooms = {}

    -- current room we're operating in
    self.currentRoom = Room(self.player)

    -- room we're moving camera to during a shift; becomes active room afterwards
    self.nextRoom = nil

    -- love.graphics.translate values, only when shifting screens and reset to 0 afterwards
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false

    -- trigger camera translation and adjustment of rooms whenever the player triggers a shift
    -- via a doorway collision, triggered in PlayerWalkState
    Event.on('shift-left', function()
        self:beginShifting(-VIRTUAL_WIDTH, 0)
    end)

    Event.on('shift-right', function()
        self:beginShifting(VIRTUAL_WIDTH, 0)
    end)

    Event.on('shift-up', function()
        self:beginShifting(0, -VIRTUAL_HEIGHT)
    end)

    Event.on('shift-down', function()
        self:beginShifting(0, VIRTUAL_HEIGHT)
    end)
end

--[[
    Prepares for the camera shifting process, kicking off a tween of the camera position.
]]
function Dungeon:beginShifting(shiftX, shiftY)

    -- commence shifting and create a new room to transition to
    self.shifting = true
    self.nextRoom = Room(self.player)

    -- start all doors in next room as open until we get in
    for k, doorway in pairs(self.nextRoom.doorways) do
        doorway.open = true
    end

    -- offset set depending on which direction we generate the room
    self.nextRoom.adjacentOffsetX = shiftX
    self.nextRoom.adjacentOffsetY = shiftY

    -- tween the player position so they move through the doorway
    local playerX, playerY = self.player.x, self.player.y

    -- figure out where player's X or Y should end up in the next room off screen
    if shiftX > 0 then
        playerX = VIRTUAL_WIDTH + (MAP_RENDER_OFFSET_X + TILE_SIZE)
    elseif shiftX < 0 then
        playerX = -VIRTUAL_WIDTH + (MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - TILE_SIZE - self.player.width)
    elseif shiftY > 0 then
        playerY = VIRTUAL_HEIGHT + (MAP_RENDER_OFFSET_Y + self.player.height / 2)
    else
        playerY = -VIRTUAL_HEIGHT + MAP_RENDER_OFFSET_Y + (MAP_HEIGHT * TILE_SIZE) - TILE_SIZE - self.player.height
    end

    -- tween the camera in whichever direction the new room is in, as well as the player to be
    -- at the opposite door in the next room, walking through the wall (which is stenciled)
    Timer.tween(1, {
        [self] = {cameraX = shiftX, cameraY = shiftY},
        [self.player] = {x = playerX, y = playerY}
    }):finish(function()

        -- set everything back to 0, with next room now the current room
        self:finishShifting()

        -- reset player to the correct location in this room, negating off-screen offsets
        if shiftX < 0 then
            self.player.x = MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - TILE_SIZE - self.player.width
            self.player.direction = 'left'
        elseif shiftX > 0 then
            self.player.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.player.direction = 'right'
        elseif shiftY < 0 then
            self.player.y = MAP_RENDER_OFFSET_Y + (MAP_HEIGHT * TILE_SIZE) - TILE_SIZE - self.player.height
            self.player.direction = 'up'
        else
            self.player.y = MAP_RENDER_OFFSET_Y + self.player.height / 2
            self.player.direction = 'down'
        end

        -- close all doors in the current room
        for k, doorway in pairs(self.currentRoom.doorways) do
            doorway.open = false
        end

        gSounds['door']:play()
    end)
end


--applying same properties of how the player avoids wall collision to entity avoiding trap collision

function Dungeon:init(entity)
    self.entity = entity

    -- container we could use to store rooms in a static dungeon, but unused here
    self.rooms = {}

    -- current room we're operating in
    self.currentRoom = Room(self.entity)

    -- room we're moving camera to during a shift; becomes active room afterwards
    self.nextRoom = nil

    -- love.graphics.translate values, only when shifting screens and reset to 0 afterwards
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false

    -- trigger camera translation and adjustment of rooms whenever the player triggers a shift
    -- via a doorway collision, triggered in PlayerWalkState
    Event.on('shift-left', function()
        self:beginShifting(-VIRTUAL_WIDTH, 0)
    end)

    Event.on('shift-right', function()
        self:beginShifting(VIRTUAL_WIDTH, 0)
    end)

    Event.on('shift-up', function()
        self:beginShifting(0, -VIRTUAL_HEIGHT)
    end)

    Event.on('shift-down', function()
        self:beginShifting(0, VIRTUAL_HEIGHT)
    end)
end

--[[
    Prepares for the camera shifting process, kicking off a tween of the camera position.
]]
function Dungeon:beginShifting(shiftX, shiftY)

    -- commence shifting and create a new room to transition to
    self.shifting = true
    self.nextRoom = Room(self.entity)

    -- start all doors in next room as open until we get in
    for k, doorway in pairs(self.nextRoom.doorways) do
        doorway.open = true
    end

    -- offset set depending on which direction we generate the room
    self.nextRoom.adjacentOffsetX = shiftX
    self.nextRoom.adjacentOffsetY = shiftY

    -- tween the player position so they move through the doorway
    local entityX, entity = self.entity.x, self.entity.y

    -- figure out where player's X or Y should end up in the next room off screen
    if shiftX > 0 then
        entityX = VIRTUAL_WIDTH + (MAP_RENDER_OFFSET_X + TILE_SIZE)
    elseif shiftX < 0 then
        entityX = -VIRTUAL_WIDTH + (MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - TILE_SIZE - self.entity.width)
    elseif shiftY > 0 then
       entityY = VIRTUAL_HEIGHT + (MAP_RENDER_OFFSET_Y + self.player.height / 2)
    else
        entityY = -VIRTUAL_HEIGHT + MAP_RENDER_OFFSET_Y + (MAP_HEIGHT * TILE_SIZE) - TILE_SIZE - self.entity.height
    end

    -- tween the camera in whichever direction the new room is in, as well as the player to be
    -- at the opposite door in the next room, walking through the wall (which is stenciled)
    Timer.tween(1, {
        [self] = {cameraX = shiftX, cameraY = shiftY},
        [self.entity] = {x = playerX, y = playerY}
    }):finish(function()

        -- set everything back to 0, with next room now the current room
        self:finishShifting()

        -- reset player to the correct location in this room, negating off-screen offsets
        if shiftX < 0 then
            self.entity.x = MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - TILE_SIZE - self.entity.width
            self.entity.direction = 'left'
        elseif shiftX > 0 then
            self.entity.x = MAP_RENDER_OFFSET_X + TILE_SIZE
            self.entity.direction = 'right'
        elseif shiftY < 0 then
            self.entity.y = MAP_RENDER_OFFSET_Y + (MAP_HEIGHT * TILE_SIZE) - TILE_SIZE - self.entity.height
            self.entity.direction = 'up'
        else
            self.entity.y = MAP_RENDER_OFFSET_Y + self.entity.height / 2
            self.entity.direction = 'down'
        end

        -- close all doors in the current room
        for k, doorway in pairs(self.currentRoom.doorways) do
            doorway.open = false
        end

        gSounds['door']:play()
    end)
end
--[[
    Resets a few variables needed to perform a camera shift and swaps the next and
    current room.
]]
function Dungeon:finishShifting()

    -- reset camera and deactivate shifting to avoid translation
    self.cameraX = 0
    self.cameraY = 0
    self.shifting = false

    -- point to transitioned room as the new active room, pointing to an empty room next
    self.currentRoom = self.nextRoom
    self.nextRoom = nil

    -- this room (previously the off-screen room) should now be in the center, not offset
    self.currentRoom.adjacentOffsetX = 0
    self.currentRoom.adjacentOffsetY = 0 
end

function Dungeon:update(dt)
    
    -- pause updating if we're in the middle of shifting
    if not self.shifting then    
        self.currentRoom:update(dt)
    else
        
        -- still update the player animation if we're shifting rooms
        self.player.currentAnimation:update(dt)
    end
end

function Dungeon:render()
    
    -- translate the camera if we're actively shifting
    if self.shifting then
        love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    end

    self.currentRoom:render()
    
    if self.nextRoom then
        self.nextRoom:render()
    end
end