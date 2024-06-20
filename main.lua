return {
    [4991214437] = function() -- town
        task.spawn(function()
            while task.wait() do
                game.Lighting.TimeOfDay = 16
            end
        end)
    end,
    [4581966615] = function() -- anomic
        while wait(5) do
            for i,v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
                if string.find(v.Name:lower(), "print") then
                    if v:FindFirstChild("HAHAHAHAAH") then v:Destroy() end
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
}
