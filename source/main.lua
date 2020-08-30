-- Load other lua files
require "splash"
require "tiled"
require "chars"

-- Startup
function love.load(arg)
    -- Initialize global variables
    _G.mode = "splash" -- [splash, credits, map]
    _G.splash = newSplash()
    _G.pixelUnit = 16
    -- Initialize timers
    _G.moveCooldownTimerMax = 8
    _G.moveCooldownTimer = _G.moveCooldownTimerMax
    -- Load font
    _G.fontBig = love.graphics.newFont("assets/fonts/PressStart2P.ttf", 18)
    _G.fontSmall = love.graphics.newFont("assets/fonts/PressStart2P.ttf", 10)
    -- Load tilemap
    _G.map = loadTiledMap("assets/sprites/serene")
    -- Create player
    _G.player = newPlayer("assets/sprites/animal_spritesheet.png", 0, 0)

end

-- Keyboard input
    -- 'escape' for exit
    -- 'space' or 'return' to begin game
function love.keypressed(key)
    -- Always the option to quit
    if key == "escape" then
        love.event.push('quit')
    end

    -- Keypresses handled differently depending on mode
    if _G.mode == "splash" or _G.mode == "credits" then
        _G.splash:handle(key)
    end
 end

-- Updating
function love.update(dt)
    -- Timers
    if _G.moveCooldownTimer > 0 then
        _G.moveCooldownTimer = _G.moveCooldownTimer - 1
    end
    -- Updates
    if _G.mode == "map" then
        _G.player:updatePosition()
    end
end

-- Drawing
function love.draw(dt)
    if _G.mode == "splash" then
        _G.splash:draw()
    elseif _G.mode == "credits" then
        _G.splash:drawCredits()
    elseif _G.mode == "map" then
        _G.map:draw("base")
        _G.map:draw("paths")
        _G.player:draw()
        _G.map:draw("objects")
    end
end