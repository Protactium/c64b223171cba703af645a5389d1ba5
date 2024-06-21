return {
    [4991214437] = function() -- town
        task.spawn(function()
            while task.wait() do
                game.Lighting.TimeOfDay = 16
            end
        end)
    end,
    [4581966615] = function() -- anomic
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/anomic%20printer%20esp.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/anomic%20v.lua"))()
    end,
    [4169490976] = function() -- mortem SHIT
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/mortem-1.lua"))()
    end,
    [3254838662] = function() -- blacklands
        loadstring(game:HttpGet("https://pastebin.com/raw/KpXPw4kU"))()
    end,
    [402122991] = function() -- redwood
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/redwood.lua"))()
    end,





    
    ["IY"] = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
    ["unnamedESP"] = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()
    end,
    ["uniHBE"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/uniHBE.lua"))()
    end,
    ["solaraFix"] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/solara.fixer/injection.lua"))()
    end,
}
