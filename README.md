# add new file in autoexecute and add:
> getgenv()["amazing"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/main.lua"))()

# or open your script and add this on the first line:
> local amazing = loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/main.lua"))()



# Params:
### .IY() -- infinite yield
### .unnamedESP() - unnamed esp
### .uniHBE() - universal hitbox expander
### .solaraFix() - add custom functions to solara, fixes some scripts
### .airhub() - universal aimlock

# Information:
> This has some scripts that i've used and work with solara, if you want to use game specific scripts that are in the lib, do:
> amazing[game.PlaceId]()
