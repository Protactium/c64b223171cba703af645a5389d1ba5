return {
    [4991214437] = function() -- town
        task.spawn(function()
            while task.wait() do
                game.Lighting.TimeOfDay = 16
            end
        end)
    end,
    [4581966615] = function() -- anomic
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/anomic%20printer%20esp.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/anomic%20v.lua"))()
    end,
    [4169490976] = function() -- mortem SHIT
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/mortem-1.lua"))()
    end,
    [3254838662] = function() -- blacklands
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/blackland.lua"))()
    end,
    [402122991] = function() -- redwood
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/redwood.lua"))()
    end,





    
    ["IY"] = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/iy.lua'))()
    end,
    ["unnamedESP"] = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/unnamed.lua'))()
    end,
    ["uniHBE"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/uniHBE.lua"))()
    end,
    ["solaraFix"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/solara.fixer/injection.lua"))()
    end,
}
