# add new file in autoexecute and add:
```
getgenv()["lib"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/main.lua"))()
```
# if you don't want to create an autoexecute file do this above your script:
```
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/main.lua"))()
```


# Params:
```
lib.IY() -- infinite yield
lib.unnamedESP() - unnamed esp
lib.uniHBE() - universal hitbox expander
lib.solaraFix() - add custom functions to solara, fixes some scripts
lib.airhub() - universal aimlock
```

# Information:
This has some scripts that i've used and work with solara, if you want to use game specific scripts that are in the lib, do:
```
if lib[game.PlaceId] then
    lib[game.PlaceId]()
end
```
