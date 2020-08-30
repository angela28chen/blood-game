-- chars: Any player or NPC characters.

--[[
    player (object):
        x: tile position with 1 being leftmost column, 0 is offscreen
        y: tile position with 1 being topmost row, 0 is offscreen
        dir: facing direction [0:top 1:right 2:down 3:left]
        vis: boolean for visible or not
        imageLoaded: tileset where player sprite is stored
        quad: quad to go with imageLoaded
--]]

function newPlayer(spritesheet, initx, inity)
    local player = {}

    player.x = initx
    player.y = inity
    player.dir = 0
    player.vis = true
    player.imageLoaded = love.graphics.newImage(spritesheet)
    -- TEMP: getting dog as player
    player.quad = love.graphics.newQuad(
        1*_G.pixelUnit,
        2*_G.pixelUnit,
        _G.pixelUnit,
        _G.pixelUnit,
        player.imageLoaded:getWidth(),
        player.imageLoaded:getHeight()
    )

    function player:updatePosition()
        if _G.moveCooldownTimer == 0 then
            newX = player.x
            newY = player.y
            -- Update location and orientation, only one at a time
            if love.keyboard.isDown("up") then
                newY = newY - 1
                player.dir = 0
            elseif love.keyboard.isDown("right") then
                newX = newX + 1
                player.dir = 1
            elseif love.keyboard.isDown("down") then
                newY = newY + 1
                player.dir = 2
            elseif love.keyboard.isDown("left") then
                newX = newX - 1
                player.dir = 3
            end
            -- Prevent offscreen movement
            if newX < 0 or newX > _G.map.width-1 then
                newX = player.x
            end
            if newY < 0 or newY > _G.map.height-1 then
                newY = player.y
            end
            -- Check map collisions
            if not _G.map:canStand(newX, newY) then
                newX = player.x
                newY = player.y
            end
            -- Set new position if changed
            if (newX ~= player.x) or (newY ~= player.y) then
                player.x = newX
                player.y = newY
                -- Reset timer
                _G.moveCooldownTimer = _G.moveCooldownTimerMax
            end
        end
    end

    function player:draw()
        if player.vis then
            love.graphics.draw(
                self.imageLoaded,
                self.quad,
                self.x*_G.pixelUnit,
                self.y*_G.pixelUnit
            )
        end
    end

    return player
end