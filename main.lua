local scripts = {
    gameSpecific = {
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
        [402122991] = function() -- redwood (shittier version of that OP ass redwood prison script)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/redwood.lua"))()
        end,
    },
    others = {
        ["iy"] = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/iy.lua'))()
        end,
        ["unnamedesp"] = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/unnamed.lua'))()
        end,
        ["unihbe"] = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/uniHBE.lua"))()
        end,
        ["solarafix"] = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/solara.fixer/injection.lua"))()
        end,
        ["airhub"] = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/airhub/airhub.lua"))()
        end,
        ["r15gui"] = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/scripts/R15Gui.lua"))()
        end
    }
}

return function(Type,str)
    Type = Type:lower() str = str:lower()
    if Type == "others" then
        if not scripts.others[str] then
            error("Failed to find string in table, "..str, 5) return
        end
        scripts.others[str]()
    else
        if not scripts.gameSpecific[str] then
            error("Failed to find string in table, "..str, 5) return
        end
        scripts.gameSpecific[str]()
    end
end
