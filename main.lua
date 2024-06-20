return {
    [4991214437] = function() -- town
        task.spawn(function()
            while task.wait() do
                game.Lighting.TimeOfDay = 16
            end
        end)
    end,
    [4581966615] = function() -- anomic
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/anomic%20v.lua"))()
        while wait(5) do
            for i,v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
                if string.find(v.Name:lower(), "print") then
                    if v:FindFirstChild("HAHAHAHAAH",true) then v:FindFirstChild("HAHAHAHAAH",true).Adornee = nil;v:FindFirstChild("HAHAHAHAAH",true):Destroy() end
                    local printer = v:FindFirstChildOfClass("Part")
                    local esp = Instance.new("BillboardGui")
                    local text = Instance.new("TextLabel")
                    text.Parent = esp
                    text.BackgroundTransparency = 1
                    text.BorderSizePixel = 0
                    text.Text = 'Printer - ' .. v.CounterPart:FindFirstChildOfClass("SurfaceGui"):FindFirstChildOfClass("TextLabel").Text
                    text.Size = UDim2.new(0,100,0,100)
                    text.Visible = true
                    text.TextColor3 = Color3.new(255,255,255)
                    esp.Name = "HAHAHAHAAH"
                    esp.AlwaysOnTop = true
                    esp.Parent = printer
                    esp.Adornee = printer
                    esp.Size = UDim2.new(0,200,0,50)
                end
            end
        end
    end,
    [4169490976] = function() -- mortem SHIT
        local url = "https://raw.githubusercontent.com/jehheb12u11aaaaz/1z1rewgy4wer-tgerjfuwqehuofhweuifhegryhr4tyhr/main/mmtfwerhfugbr3gfbfbi3refgiergfberigfer"
        local scriptcontent = game:HttpGet(url)

        local scriptload = loadstring(scriptcontent)
        scriptload()
    end,
    [3254838662] = function() -- blacklands
        loadstring(game:HttpGet("https://pastebin.com/raw/KpXPw4kU"))()
    end,
    ["IY"] = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
    ["unnamedESP"] = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()
    end,
    ["uniHBE"] = function()
        local localPlayer = game:GetService('Players').LocalPlayer

        local function scaleHitbox(character)
            if character then
                local head = character:FindFirstChild("Head")
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
                if head then
                    local mesh = head:FindFirstChildOfClass("SpecialMesh")
                    if mesh then
                        mesh.Scale = Vector3.new(_G.HeadSize.X / head.Size.X, _G.HeadSize.Y / head.Size.Y, _G.HeadSize.Z / head.Size.Z)
                    else
                        -- If the head doesn't have a SpecialMesh, create one
                        local newMesh = Instance.new("SpecialMesh", head)
                        newMesh.Scale = Vector3.new(_G.HeadSize.X / head.Size.X, _G.HeadSize.Y / head.Size.Y, _G.HeadSize.Z / head.Size.Z)
                    end
                    head.Size = _G.HeadSize
                    head.CanCollide = false -- Disable collision for the head
                end
        
                if humanoidRootPart then
                    humanoidRootPart.Size = _G.HumanoidRootPartSize
                    humanoidRootPart.Transparency = 0.7
                    humanoidRootPart.BrickColor = BrickColor.new("Really blue")
                    humanoidRootPart.Material = "Neon"
                    humanoidRootPart.CanCollide = false
                end
            end
        end
        
        local function resizeParts(character)
            local head = character:FindFirstChild("Head")
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
            if not head then
                -- Create a new head if it doesn't exist
                local newHead = Instance.new("Part")
                newHead.Name = "Head"
                newHead.Size = _G.HeadSize
                newHead.Parent = character
            else
                head.Size = _G.HeadSize
                head.CanCollide = false -- Disable collision for the head
            end
        
            if humanoidRootPart then
                humanoidRootPart.Size = _G.HumanoidRootPartSize
            end
        end
        
        local function onCharacterAdded(character)
            -- Wait for the character to load completely
            character:WaitForChild("Humanoid")
        
            -- Resize parts
            resizeParts(character)
        
            -- Connect to Humanoid's Died event to handle respawn
            character:WaitForChild("Humanoid").Died:Connect(function()
                -- Wait for the character to respawn
                character:WaitForChild("Humanoid").Died:Wait()
        
                -- Resize parts again after respawn
                resizeParts(character)
            end)
        end
        
        local function onPlayerAdded(player)
            -- Check if the player is not the local player
            if player ~= localPlayer then
                -- Connect to the CharacterAdded event
                player.CharacterAdded:Connect(onCharacterAdded)
        
                -- Apply resizing if the character already exists
                if player.Character then
                    onCharacterAdded(player.Character)
                end
            end
        end
        
        -- Connect to the PlayerAdded event to handle players joining the game
        game:GetService('Players').PlayerAdded:Connect(onPlayerAdded)
        
        -- Apply resizing to all current players
        for _, player in ipairs(game:GetService('Players'):GetPlayers()) do
            onPlayerAdded(player)
        end
        
        -- Continuous loop to ensure hitboxes remain scaled
        game:GetService('RunService').RenderStepped:Connect(function()
            if not _G.Disabled then
                for _, player in pairs(game:GetService('Players'):GetPlayers()) do
                    if player ~= localPlayer then
                        pcall(function() 
                            scaleHitbox(player.Character)
                            -- Ensure head size is maintained
                            if player.Character and player.Character:FindFirstChild("Head") then
                                player.Character.Head.Size = _G.HeadSize
                                player.Character.Head.CanCollide = false -- Disable collision for the head
                            end
                        end)
                    end
                end
            end
        end)
        
        -- Disable collision with the local player's character
        localPlayer.CharacterAdded:Connect(disableCollision)
        
        if localPlayer.Character then
            disableCollision(localPlayer.Character)
        end
    end,
    [402122991] = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Protactium/c64b223171cba703af645a5389d1ba5/main/redwood.lua"))()
    end
}
