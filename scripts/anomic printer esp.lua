task.spawn(function()
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
        end)
