local themes = {
	selected = "Default",
	Default = {
		textForeground = Color3.fromRGB(235, 235, 235),
		notifTextForeground = Color3.fromRGB(180, 180, 180),
		imageForeground = Color3.fromRGB(235, 235, 235),
		mainBackground = Color3.fromRGB(27, 27, 27),
		topBackground = Color3.fromRGB(34, 34, 34),
		panelBackground = Color3.fromRGB(34, 34, 34),
		panelItemBackground = Color3.fromRGB(27, 27, 27),
		toggleEnabled = Color3.fromRGB(15, 180, 85),
		sliderHighlight = Color3.fromRGB(64, 64, 64),
		notifTimeoutHighlight = Color3.fromRGB(72, 72, 72),
		hoverEffect = Color3.fromRGB(48, 48, 48),
		clickEffect = Color3.fromRGB(64, 64, 64)
	},
	Discord = {
		textForeground = Color3.fromRGB(220, 221, 222),
		notifTextForeground = Color3.fromRGB(185, 187, 190),
		imageForeground = Color3.fromRGB(185, 187, 190),
		mainBackground = Color3.fromRGB(47, 49, 54),
		topBackground = Color3.fromRGB(41, 43, 47),
		panelBackground = Color3.fromRGB(54, 57, 63),
		panelItemBackground = Color3.fromRGB(47, 49, 54),
		toggleEnabled = Color3.fromRGB(88, 101, 242),
		sliderHighlight = Color3.fromRGB(88, 101, 242),
		notifTimeoutHighlight = Color3.fromRGB(88, 101, 242),
		hoverEffect = Color3.fromRGB(52, 55, 60),
		clickEffect = Color3.fromRGB(57, 60, 67)
	},
	OperaGX = {
		textForeground = Color3.fromRGB(255, 255, 255),
		notifTextForeground = Color3.fromRGB(176, 175, 178),
		imageForeground = Color3.fromRGB(250, 30, 78),
		mainBackground = Color3.fromRGB(18, 16, 25),
		topBackground = Color3.fromRGB(9, 8, 13),
		panelBackground = Color3.fromRGB(28, 23, 38),
		panelItemBackground = Color3.fromRGB(18, 16, 25),
		toggleEnabled = Color3.fromRGB(250, 30, 78),
		sliderHighlight = Color3.fromRGB(250, 30, 78),
		notifTimeoutHighlight = Color3.fromRGB(250, 30, 78),
		hoverEffect = Color3.fromRGB(76, 19, 38),
		clickEffect = Color3.fromRGB(46, 39, 63)
	}
}

local localPlayer = game:GetService("Players").LocalPlayer
local mouse = localPlayer:GetMouse()

local themeMeta = setmetatable({
	items = {}
}, {
	__index = function(t, k)
		if rawget(t, "currentItem") and not rawget(t, "items")[k][rawget(t, "currentItem")] then
			t.items[k][t.currentItem] = true
		end
		return themes[themes.selected][k]
	end
})
local function create(className, properties, children, round)
	local instance, properties = Instance.new(className), properties or {}
	for i, v in next, properties do
		if i ~= "Parent" then
			instance[i] = type(v) == "string" and v:find("theme.") and themeMeta[v:gsub("theme.", "")] or v
		end
	end
	if children then
		for i, v in next, children do
			v.Parent = instance
		end
	end
	if round then
		create("UICorner", { Name = "uicorner", CornerRadius = round, Parent = instance })
	end
	instance.Parent = properties.Parent
	return instance
end

local tweenService = game:GetService("TweenService")
local textService = game:GetService("TextService")

local function tween(instance, duration, properties, style)
	local t = tweenService:Create(instance, TweenInfo.new(duration, style or Enum.EasingStyle.Sine), properties)
	t:Play()
	return t
end

local function addMouseEffects(guiObject, normalColour, hoverColour, clickColour)
	local isMouseDown, isMouseOver = false, false
	if hoverColour then
		guiObject.MouseEnter:Connect(function()
			isMouseOver = true
			tween(guiObject, 0.2, { BackgroundColor3 = themeMeta[hoverColour] })
		end)
		guiObject.MouseLeave:Connect(function()
			isMouseOver = false
			if isMouseDown == false then
				tween(guiObject, 0.2, { BackgroundColor3 = themeMeta[normalColour] })
			end
		end)
	end
	if clickColour then
		if guiObject.ClassName == "Frame" then
			guiObject.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					isMouseDown = true
					tween(guiObject, 0.2, { BackgroundColor3 = themeMeta[clickColour] })
					local conn
					conn = input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							conn:Disconnect()
							isMouseDown = false
							tween(guiObject, 0.2, { BackgroundColor3 = isMouseOver and themeMeta[hoverColour] or themeMeta[normalColour] })
						end
					end)
				end
			end)
		elseif guiObject.ClassName == "TextButton" then
			guiObject.MouseButton1Down:Connect(function()
				isMouseDown = true
				tween(guiObject, 0.2, { BackgroundColor3 = themeMeta[clickColour] })
			end)
			guiObject.MouseButton1Up:Connect(function()
				isMouseDown = false
				tween(guiObject, 0.2, { BackgroundColor3 = isMouseOver and themeMeta[hoverColour] or themeMeta[normalColour] })
			end)
		end
	end
end

local function makeDraggable(library, frame)
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and library._settings.dragging == false then
			library._settings.dragging = true
			local offset = Vector2.new(frame.AbsoluteSize.X * frame.AnchorPoint.X, frame.AbsoluteSize.Y * frame.AnchorPoint.Y)
			local pos = Vector2.new(mouse.X - (frame.AbsolutePosition.X + offset.X), mouse.Y - (frame.AbsolutePosition.Y + offset.Y))
			local dragConn, conn
			dragConn = mouse.Move:Connect(function()
				tween(frame, 0.125, { Position = UDim2.new(0, mouse.X - pos.X, 0, mouse.Y - pos.Y) })
			end)
			conn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					library._settings.dragging = false
					dragConn:Disconnect()
					conn:Disconnect()
				end
			end)
		end
	end)
end

local function organiseNotifs(notifDir)
	local yOffset, notifs = -30, notifDir:GetChildren()
	for i = #notifs, 1, -1 do
		local v = notifs[i]
		tween(v, 0.35, { Position = UDim2.new(1, -10, 1, yOffset) })
		yOffset = yOffset - (v.AbsoluteSize.Y + 10)
	end
end

local function getNotificationGui()
	return game:GetService("CoreGui"):WaitForChild("Notifications",3)
end

local library = {}

function library:Notify(plr, title, text, theme, options, callback)
	local mainholder
	if not getNotificationGui() then
		mainholder = create("ScreenGui", { Name = "Notifications", Parent = game:GetService("CoreGui"), DisplayOrder = 1000000000, ResetOnSpawn = false }, {
			create("Folder", {Name = "Notifications"})
		})
	else
		mainholder = getNotificationGui().Notifications
	end
	themes.selected = theme or "Default"
	local sizeY, called = textService:GetTextSize(text, 13, Enum.Font.Gotham, Vector2.new(260, math.huge)).Y + 10, false
	local frame = create("Frame", { Name = "notification", AnchorPoint = Vector2.new(1, 1), BackgroundColor3 = "theme.panelItemBackground", ClipsDescendants = true, Parent = mainholder, Position = UDim2.new(1, 300, 1, -30), Size = UDim2.new(0, 280, 0, sizeY + 34) }, {
		create("TextLabel", { Name = "title", BackgroundTransparency = 1, Font = Enum.Font.GothamSemibold, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -66, 0, 30), Text = "Neutral Notification", TextColor3 = "theme.textForeground", TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left }),
		create("TextLabel", { Name = "content", AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamSemibold, Position = UDim2.new(0.5, 0, 0, 26), Size = UDim2.new(1, -20, 0, sizeY), Text = text, TextColor3 = "theme.notifTextForeground", TextSize = 13, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left }),
		create("Frame", { Name = "yes", AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = "theme.panelItemBackground", Position = UDim2.new(1, -30, 0, 4), Size = UDim2.new(0, 22, 0, 22) }, {
			create("ImageLabel", { Name = "icon", AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://7234543866", Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 0, 1, 0) })
		}, UDim.new(0, 4)),
		create("Frame", { Name = "no", AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = "theme.panelItemBackground", Position = UDim2.new(1, -4, 0, 4), Size = UDim2.new(0, 22, 0, 22) }, {
			create("ImageLabel", { Name = "icon", AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://7234543609", Position = UDim2.new(0.5, 0, 0.5, 0), Rotation = 45, Size = UDim2.new(1, 0, 1, 0) })
		}, UDim.new(0, 4)),
		create("Frame", { Name = "underline", AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = "theme.notifTimeoutHighlight", Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(0, 0, 0, 6) }, {
			create("Frame", { Name = "overline", BackgroundColor3 = "theme.notifTimeoutHighlight", BorderSizePixel = 0, Size = UDim2.new(1, 0, 0.5, 0) })
		}, UDim.new(1, 0))
	}, UDim.new(0, 4))

	local function closeNotif(option)
		called = true
		tween(frame, 0.35, { Position = UDim2.new(1, 300, frame.Position.Y.Scale, frame.Position.Y.Offset) }).Completed:Connect(function()
			frame:Destroy()
			organiseNotifs(mainholder)
		end)
		if callback then
			callback(option)
		end
	end

	addMouseEffects(frame.yes, "panelItemBackground", nil, "clickEffect")
	addMouseEffects(frame.no, "panelItemBackground", nil, "clickEffect")

	frame.yes.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			closeNotif(true)
		end
	end)

	frame.no.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			closeNotif(false)
		end
	end)
	
	organiseNotifs(mainholder)

	tween(frame.underline, options and options.timeout or 10, { Size = UDim2.new(1, 0, 0, 6) }, Enum.EasingStyle.Linear).Completed:Connect(function()
		if not called then
			closeNotif(false)
		end
	end)
end

return library
