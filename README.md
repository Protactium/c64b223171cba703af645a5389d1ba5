# add new file in autoexecute and add:
```lua
getgenv()["lib"] = loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/main.lua"))()
```
# if you don't want to create an autoexecute file do this above your script:
```lua
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/main.lua"))()
```


# Params:
```lua
lib("others","IY") -- infinite yield
lib("others","unnamedESP") -- unnamed ESP
lib("others","uniHBE") -- universal hitbox expander
lib("others","solaraFix") -- adds custom functions to solara, fixes some scripts (maybe?)
lib("others","airhub") -- universal aimlock
```

# Information:
This has some scripts that i've used and work with solara, if you want to use game specific scripts that are in the lib, do:
```lua
lib("gameSpecific",game.PlaceId)
```
