# add new file in autoexecute and add:
```
getgenv()["amazing"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/main.lua"))()
```
# if you don't want to create an autoexecute file do this above your script:
```
local amazing = loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/main.lua"))()
```


# Params:
```
amazing.IY() -- infinite yield
amazing.unnamedESP() - unnamed esp
amazing.uniHBE() - universal hitbox expander
amazing.solaraFix() - add custom functions to solara, fixes some scripts
amazing.airhub() - universal aimlock
```

# Information:
This has some scripts that i've used and work with solara, if you want to use game specific scripts that are in the lib, do:
```
amazing[game.PlaceId]()
```
