-- tiled: Load and draw tilemaps created with Tiled.

--[[
    map (object):
        tilesets: Tilesets objects as defined in generated file from Tiled.
            imageLoaded: Image object loaded from file.
            quads: Table of quads indexed by local tile ID.
            [...]
        [...]
--]]

function loadTiledMap(path)
    local map = require(path)

    for i, ts in ipairs(map.tilesets) do
        ts.imageLoaded = love.graphics.newImage(ts.image)
        ts.quads = {}

        for y=0, (ts.imageheight/ts.tileheight)-1 do
            for x=0, (ts.imagewidth/ts.tilewidth)-1 do
                local quad = love.graphics.newQuad(
                    x*ts.tilewidth,
                    y*ts.tileheight,
                    ts.tilewidth,
                    ts.tileheight,
                    ts.imagewidth,
                    ts.imageheight
                )
                table.insert(ts.quads, quad)
            end
        end
    end

    function map:getTilesetByTileID(tileID)
        -- Given absolute tileID, fetch the correct tileset and relative tileID for rendering.
        if tileID == 0 then
            return nil, 0
        end
        local tsID = 0
        for i, ts in ipairs(self.tilesets) do
            if tileID <= ts.tilecount then
                -- This is the tileset containing provided tileID.
                tsID = i
                break
            else
                tileID = tileID - ts.tilecount
            end
        end
        assert(tsID > 0)
        local ts = self.tilesets[tsID]
        return ts, tileID
    end

    function map:draw(layerName)
        -- Draws one layer onto the screen.
        for i, layer in ipairs(self.layers) do
            if layer.name == layerName then
                -- Iterate all tiles starting from upper left corner.
                for y=0, layer.height-1 do
                    for x=0, layer.width-1 do
                        local ind = (x+y*layer.width)+1
                        local absoluteTileID = layer.data[ind]
                        local ts, relativeTileID = self:getTilesetByTileID(absoluteTileID)
                        if relativeTileID > 0 then
                            love.graphics.draw(
                                ts.imageLoaded,
                                ts.quads[relativeTileID],
                                x*ts.tilewidth,
                                y*ts.tileheight
                            )
                        end
                    end
                end
            end
        end
        return
    end

    function map:canStand(x, y)
        -- Checks if player character and other entities can occupy this tile.
        for i, layer in ipairs(self.layers) do
            if layer.name == "collisions" then
                local ind = (x+y*layer.width)+1
                if layer.data[ind] > 1 then
                    return false
                end
                return true
            end
        end
        -- No collision layer
        return true
    end

    return map
end