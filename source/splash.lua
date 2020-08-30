-- splash: Main menu choices screen.

--[[
    splash (object):
        options: Display text of all possible menu choices.
        spacer: Vertical distance between menu options in pixels.
        selected: ID of selected menu choice.
--]]

function newSplash()
    local splash = {}
    splash.options = {}
    splash.options[1] = "start"
    splash.options[2] = "credits"
    splash.options[3] = "quit"
    local nOptions = 3
    splash.spacer = 20
    splash.selected = 1
    
    function splash:handle(key)
        if _G.mode == 'credits' then
            if key == 'x' then
                _G.mode = "splash"
            end
        elseif _G.mode == 'splash' then
            if key == 'up' then
                if self.selected > 1 then
                    self.selected = self.selected-1
                end
            elseif key == 'down' then
                if self.selected < nOptions then
                    self.selected = self.selected+1
                end
            elseif key == 'space' or key == 'return' then
                if splash.selected == 1 then
                    _G.mode = "map"
                elseif splash.selected == 2 then
                    _G.mode = "credits"
                elseif splash.selected == 3 then
                    love.event.push('quit')
                end
            end
        end
    end

    function splash:draw()
        -- Title
        love.graphics.printf(
            "<TITLE PLACEHOLDER>", 
            _G.fontBig, 
            0, 
            love.graphics.getHeight()/4,
            love.graphics.getWidth(),
            "center"
        )
        -- Menu options
        for i, option in ipairs(splash.options) do
            love.graphics.printf(
                self.options[i], 
                _G.fontSmall, 
                0, 
                love.graphics.getHeight()/2 + i*self.spacer,
                love.graphics.getWidth(),
                "center"
            )
        end
        -- Selection indicator
        love.graphics.printf(
            "*          *", 
            _G.fontSmall, 
            0, 
            love.graphics.getHeight()/2 + self.selected*self.spacer,
            love.graphics.getWidth(),
            "center"
        )
    end

    function splash:drawCredits()
        --TODO: source stock resources
        love.graphics.printf(
            "Programming: Angela Chen\n\nLevel Design: Jerry Zhou\n\nArt: Trudi Tan\n\n", 
            _G.fontSmall, 
            0, 
            love.graphics.getHeight()/2,
            love.graphics.getWidth(),
            "center"
        )
        love.graphics.printf(
            "Press 'X' to return to main menu", 
            _G.fontSmall, 
            0, 
            love.graphics.getHeight()*3/4,
            love.graphics.getWidth(),
            "center"
        )
    end

    return splash
end