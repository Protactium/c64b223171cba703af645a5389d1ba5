-- services
local players = game:GetService("Players")
local userinputservice = game:GetService("UserInputService")
local tweenservice = game:GetService("TweenService")
local textservice = game:GetService("TextService")
local httpservice = game:GetService("HttpService")
local virtualuser = game:GetService("RunService")
local heartbeat = game:GetService("RunService").Heartbeat

-- variables
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()
local cam = workspace.CurrentCamera

local hugeVector2 = Vector2.new(math.huge,math.huge)

local placeholderBoxSize = textservice:GetTextSize("Enter Text...", 12, Enum.Font.Gotham, hugeVector2).X + 16
local placeholderBindSize = textservice:GetTextSize("[ None ]", 12, Enum.Font.Gotham, hugeVector2).X + 16
local ellipsisBindSize = textservice:GetTextSize("[ ... ]", 12, Enum.Font.Gotham, hugeVector2).X + 16

local blacklistedKeys = {
	[Enum.KeyCode.Unknown] = true
}

local whitelistedTypes = { 
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.MouseButton2] = true,
	[Enum.UserInputType.MouseButton3] = true
}

local library = {}
local tab = {}
local misc = {}
local cell = {}

tab.__index = tab
library.__index = library
misc.__index = misc
cell.__index = cell

library._settings = {
	dragging = false,
	binding = false,
	options = {}
}

-- functions
local function create(className, properties, children)
	local instance, properties = Instance.new(className), properties or {}
	
	for i,v in next, properties do
		instance[i] = v
	end
	
	if children then
		for i,v in next, children do
			v.Parent = instance
		end
	end
	
	return instance
end

local function tween(instance, duration, properties, style)
	local t = tweenservice:Create(instance, TweenInfo.new(duration, style or Enum.EasingStyle.Sine), properties)
	t:Play()
	return t
end

local function getFlagForm(name)
	return name:gsub(" ", ""):lower()
end

local function OffsetToScale(width)
	local viewPortSize = workspace.CurrentCamera.ViewportSize
	return {width[1] / viewPortSize.X, width[2] / viewPortSize.Y}
end

local function addMouseEffects(Object, normalColour, hoverColour, clickColour)
	local isMouseDown, isMouseOver = false, false
	if hoverColour then
		Object.MouseEnter:Connect(function()
			isMouseOver = true
			tween(Object, 0.2, { BackgroundColor3 = hoverColour })
		end)
		Object.MouseLeave:Connect(function()
			isMouseOver = false
			if isMouseDown == false then
				tween(Object, 0.2, { BackgroundColor3 = normalColour })
			end
		end)
	end
	if clickColour then
		if Object.ClassName == "Frame" then
			Object.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					isMouseDown = true
					tween(Object, 0.2, { BackgroundColor3 = clickColour })
					local conn
					conn = input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							conn:Disconnect()
							isMouseDown = false
							tween(Object, 0.2, { BackgroundColor3 = isMouseOver and hoverColour or normalColour })
						end
					end)
				end
			end)
		elseif Object.ClassName == "TextButton" then
			Object.MouseButton1Down:Connect(function()
				isMouseDown = true
				tween(Object, 0.2, { BackgroundColor3 = clickColour })
			end)
			Object.MouseButton1Up:Connect(function()
				isMouseDown = false
				tween(Object, 0.2, { BackgroundColor3 = isMouseOver and hoverColour or normalColour })
			end)
		end
	end
end

local function makeDraggable(frame)
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

local function autoResizeList(frame)
	local isScrollable,layout = frame.ClassName == "ScrollingFrame", frame:FindFirstChildOfClass("UIListLayout")
	
	local function resize()
		local size, offset = 0, layout.Padding.Offset
		for i, v in next, frame:GetChildren() do
			if v ~= layout then
				if not (v:IsA("UIPadding")) then
					size = size + v.AbsoluteSize.Y + offset
				end
			end
		end
		frame[isScrollable and "CanvasSize" or "Size"] = UDim2.new(0, isScrollable and 0 or frame.AbsoluteSize.X, 0, size - offset)
	end
	
	frame.ChildAdded:Connect(function(child)
		child:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize)
		resize()
	end)
end

local function autoResizeGrid(frame)
	local layout = frame:FindFirstChildOfClass("UIGridLayout")
	local function resize()
		local maxSize, offset = 0, layout.CellPadding.Y.Offset
		for i, v in next, frame:GetChildren() do
			if v ~= layout then
				if v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("ImageLabel") or v:IsA("ImageButton") or v:IsA("ScrollingFrame") then
				local size = v.AbsolutePosition.Y + frame.CanvasPosition.Y - frame.AbsolutePosition.Y + v.AbsoluteSize.Y + offset
					if size > maxSize then
						maxSize = size
					end
				end
			end
		end
		frame.CanvasSize = UDim2.new(0, 0, 0, maxSize)
	end
	frame.ChildAdded:Connect(function(child)
		child:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize)
		heartbeat:Wait()
		resize()
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

local function round(val, nearest)
	local value, remaining = math.modf(val / nearest)
	return nearest * (value + (remaining > 0.5 and 1 or 0))
end

local function doOptimalParenting(gui)
	if gethui then
		gui.Parent = gethui()
	else
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
		end
		gui.Parent = game:GetService("RunService"):IsStudio() and localPlayer.PlayerGui or game:GetService("CoreGui")
	end
end

-- misc functions

function misc:addInput(name, callback)
	name = name or "Textbox"
	
	local textBox = {
		_class = "Textbox",
		_callback = callback or function() end,
		_frame = create("Frame", {Name = name, Size = UDim2.fromOffset(264,20), BackgroundTransparency = 1, Parent = self._cell, LayoutOrder = #self._cell:GetChildren()}, {
			create("Frame", {Name = "Box", Size = UDim2.fromOffset(140,16), Position = UDim2.fromOffset(99,4), BackgroundTransparency = .5, BackgroundColor3 = Color3.fromRGB(47,47,47)}, {
				create("UICorner", {CornerRadius = UDim.new(0.2,0)}),
				create("UIStroke", {Color = Color3.fromRGB(49,49,49), Thickness = 2, Transparency = 0.3}),
				create("TextBox", {Name = "Input", Size = UDim2.fromOffset(140,9), Position = UDim2.fromOffset(0,3), PlaceholderText = "Input string", TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, TextColor3 = Color3.fromRGB(120,120,120), TextSize = 14, TextScaled = true, BackgroundTransparency = 1, Text = "", FontFace = Font.fromId(16658254058, Enum.FontWeight.SemiBold), ClearTextOnFocus = false}),
			}),
			create("TextLabel", {Name = "Context", Text = name, BackgroundTransparency = 1, Size = UDim2.fromOffset(89,10), Position = UDim2.fromOffset(24,7), TextColor3 = Color3.fromRGB(143,143,143), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, FontFace = Font.fromId(16658254058, Enum.FontWeight.Medium)})
		})
	}
	
	textBox._frame.Box.Input.FocusLost:Connect(function()
		callback(textBox._frame.Box.Input.Text)
	end)

	self._items[#self._items + 1] = textBox
	
	return textBox
end

function misc:addSlider(name, callback, options)
	local min = options and options.min or 0
	local max = options and options.max or 100
	local float = options and options.float or 1
	
	local slider = {
		_callback = callback or function() end,
		_class = "slider",
		_frame = create("Frame", {Name = name, Size = UDim2.fromOffset(264,40), Parent = self._cell, BackgroundTransparency = 1, LayoutOrder = #self._cell:GetChildren()}, {
			create("Frame", {Name = "Box", Size = UDim2.fromOffset(58,15), Position = UDim2.fromOffset(175,6), BackgroundTransparency = .5, BackgroundColor3 = Color3.fromRGB(47,47,47)}, {
				create("UICorner", {CornerRadius = UDim.new(0.2,0)}),
				create("UIStroke", {Color = Color3.fromRGB(49,49,49), Thickness = 2, Transparency = 0.3}),
				create("TextBox", {Name = "Input", Size = UDim2.fromOffset(58,9), Position = UDim2.fromOffset(0,3), PlaceholderText = `{tostring(min)}-{tostring(max)}`, TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, TextColor3 = Color3.fromRGB(120,120,120), TextSize = 14, TextScaled = true, BackgroundTransparency = 1, Text = min, FontFace = Font.fromId(16658254058, Enum.FontWeight.SemiBold), ClearTextOnFocus = false, TextEditable = false}),
			}),
			create("Frame", {Name = "Slider", Size = UDim2.fromOffset(128,3), Position = UDim2.fromOffset(23,27), BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(85,85,85)}, {
				create("UICorner", {CornerRadius = UDim.new(0,8)}),
				create("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Left}),
				create("Frame", {Name = "Cursor", Size = UDim2.fromScale(0,0), BorderSizePixel = 0, BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(255,255,255)}, {
					create("UICorner", {CornerRadius = UDim.new(1,0)}),
				})
			}),
			create("TextLabel", {Name = "Context", Text = name, BackgroundTransparency = 1, Size = UDim2.fromOffset(89,10), Position = UDim2.fromOffset(24,7), TextColor3 = Color3.fromRGB(143,143,143), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, FontFace = Font.fromId(16658254058, Enum.FontWeight.SemiBold)})
		}),
		_status = {
			value = min
		}
	}
	
	function slider:Set(value)
		value = math.clamp(round(value, float), min, max)
		if value ~= self._status.value then
			self._status.value = value
			tween(self._frame.Slider.Cursor, 0.2, { Size = UDim2.new((value - min) / (max - min), 0, 1, 0) })
			self._frame.Box.Input.Text = tostring(value)
			self._callback(value)
		end
	end
	
	slider._frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and library._settings.dragging == false then
			library._settings.dragging = true
			local mouseConn, inputConn
			mouseConn = mouse.Move:Connect(function()
				slider:Set(min + ((max - min) * math.clamp((mouse.X - slider._frame.Slider.AbsolutePosition.X) / slider._frame.Slider.AbsoluteSize.X, 0, 1)))
			end)
			inputConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					mouseConn:Disconnect()
					inputConn:Disconnect()
					library._settings.dragging = false
				end
			end)
		end
	end)
	
	if options and options.default then
		slider:Set(options.default)
	end

	self._items[#self._items + 1] = slider
	
	return slider
end

function misc:addBind(name, callback, options)
	local bind = {
		_callback = callback or function() end,
		_class = "keybind",
		_frame = create("Frame", {Name = name, Size = UDim2.fromOffset(264,20), BackgroundTransparency = 1, Parent = self._cell, LayoutOrder = #self._cell:GetChildren()}, {
			create("ImageButton", {Name = "Box", Size = UDim2.fromOffset(89,16), Position = UDim2.fromOffset(150,4), BackgroundTransparency = .5, BackgroundColor3 = Color3.fromRGB(47,47,47)}, {
				create("UICorner", {CornerRadius = UDim.new(0.2,0)}),
				create("UIStroke", {Color = Color3.fromRGB(49,49,49), Thickness = 2, Transparency = 0.3}),
				create("TextLabel", {Name = "Input", Size = UDim2.fromOffset(89,9), Position = UDim2.fromOffset(0,3), TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, TextColor3 = Color3.fromRGB(120,120,120), TextSize = 14, TextScaled = true, BackgroundTransparency = 1, Text = "[ None ]", FontFace = Font.fromId(16658254058, Enum.FontWeight.SemiBold)}),
			}),
			create("TextLabel", {Name = "Context", Text = name, BackgroundTransparency = 1, Size = UDim2.fromOffset(89,10), Position = UDim2.fromOffset(24,7), TextColor3 = Color3.fromRGB(143,143,143), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, FontFace = Font.fromId(16658254058, Enum.FontWeight.SemiBold)})
		}),
		_status = {
			value = ""
		}
	}
	
	function bind:Set(value)
		local escaped = (value == "Escape" or value == "")
		self._status.value = escaped and "" or value
		self._frame.Box.Input.Text = `[ {escaped and "None" or value} ]`
	end
	
	bind._frame.Box.MouseButton1Click:Connect(function()
		warn("CLICKED BUTTON OR FRAME OR SOMETHING")
		if not library._settings.binding  then
			library._settings.binding = true
			warn("DOING HAHAHA")
			bind._frame.Box.Input.Text = "[ ... ]"
			task.wait(0.1)
			while true do
				local input = userinputservice.InputBegan:Wait()
				if (input.UserInputType == Enum.UserInputType.Keyboard and not blacklistedKeys[input.KeyCode]) or whitelistedTypes[input.UserInputType] then
					bind:Set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name or input.UserInputType.Name)
					break
				end
			end
			task.wait(0.1)
			library._settings.binding = false
		end
	end)
	
	if options and options.default then
		bind:Set(options.default.Name)
	end
	
	self._items[#self._items + 1] = bind
	
	return bind
end

function misc:addToggle(name, callback, options)
	local toggle = {
		_callback = callback or function() end,
		_class = "toggle",
		_frame = create("Frame", {Name = name, Size = UDim2.fromOffset(264,20), BackgroundTransparency = 1, Parent = self._cell, LayoutOrder = #self._cell:GetChildren()}, {
			create("Frame", {Name = "ToggleHolder", Size = UDim2.fromOffset(46,18), Position = UDim2.fromOffset(187,0), BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(85,85,85)}, {
				create("UICorner", {CornerRadius = UDim.new(1,0)}), 
				create("Frame", {Name = "Circle", Size = UDim2.fromOffset(12,12), Position = UDim2.fromOffset(2,3)}, {
					create("UICorner", {CornerRadius = UDim.new(1,0)})
				})
			}),
			create("TextLabel", {Name = "Context", Text = name, BackgroundTransparency = 1, Size = UDim2.fromOffset(164,10), Position = UDim2.fromOffset(24,4), TextColor3 = Color3.fromRGB(143,143,143), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, FontFace = Font.fromId(16658254058, Enum.FontWeight.SemiBold)})
		}),
		_status = {
			enabled = false
		}
	}
	
	function toggle:set(value)
		tween(self._frame.ToggleHolder.Circle, .2, {Position = value and UDim2.fromOffset(32,3) or UDim2.fromOffset(2,3)})
		self._status.enabled = value
		self._callback(value)
	end
	
	toggle._frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			toggle:set(not toggle._status.enabled)
		end
	end)

	if options and options.default then
		toggle:set(true)
	end
	
	self._items[#self._items + 1] = toggle
	
	return toggle
end

function misc:addButton(name, callback)
	local button = {
		_callback = callback or function() end,
		_frame = create("ImageButton", {Name = name, Size = UDim2.fromOffset(227,29), BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(47,47,47), Parent = self._cell, AutoButtonColor = false, LayoutOrder = #self._cell:GetChildren()}, {
			create("UICorner", {CornerRadius = UDim.new(0.2,0)}),
			create("UIStroke", {Color = Color3.fromRGB(49,49,49), Thickness = 2, Transparency = 0.3}),
			create("ImageLabel", {Name = "Icon", Size = UDim2.fromOffset(20,20), Position = UDim2.fromOffset(201,4), BackgroundTransparency = 1, Image = "rbxassetid://6031090999", ImageColor3 = Color3.fromRGB(135,135,135)}),
			create("TextLabel", {Name = "Context", Text = name, BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), TextColor3 = Color3.fromRGB(143,143,143), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center, FontFace = Font.fromId(16658254058, Enum.FontWeight.Medium)})
		})
	}
	
	button._frame.MouseButton1Click:Connect(button._callback)
	
	self._items[#self._items + 1] = button
	
	return button
end

function cell:addCell()
	local newCell = setmetatable({
		_lib = self,
		_cell = create("Frame", {Name = "Cell", BackgroundColor3 = Color3.fromRGB(36,36,36), BackgroundTransparency = 0.5, Parent = self._frame, LayoutOrder = #self._frame:GetChildren()}, {
			create("UIPadding", {PaddingTop = UDim.new(0,25)}),
			create("UICorner", {CornerRadius = UDim.new(0.06,0)}),
			create("UIListLayout", {Padding = UDim.new(0,10), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top}),
			create("UIStroke", {Color = Color3.fromRGB(34,34,34), Thickness = 1.5, Transparency = 0.5}),
		}),
		_items = {},
	}, misc)
	
	self._items[#self._items + 1] = newCell
	
	return newCell
end

-- tab function

function tab:addCategory(name)
	local newCategory = setmetatable({
		_lib = self,
		_name = name,
		_frame = create("ScrollingFrame", {Name = name, Parent = self._page.Sections, Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarImageColor3 = Color3.fromRGB(54,54,54), ScrollBarThickness = 4, Visible = (#self._page.Sections:GetChildren() <= 0 and true or false)}, {
			create("UIGridLayout", {SortOrder = Enum.SortOrder.LayoutOrder, CellPadding = UDim2.fromOffset(15,15), CellSize = UDim2.fromOffset(264,245)}),
			create("UIPadding", {PaddingLeft = UDim.new(0,20), PaddingTop = UDim.new(0,20)})
		}),
		_button = create("Frame", {Name = name, Parent = self._page.SectionButtonContainer, Size = UDim2.fromOffset(148,39), BackgroundTransparency = 0.6, BackgroundColor3 = Color3.fromRGB(47,47,47), LayoutOrder = #self._page.SectionButtonContainer:GetChildren()}, {
			create("UICorner", {CornerRadius = UDim.new(0.2,0)}),
			create("UIStroke", {Color = Color3.fromRGB(49,49,49), Thickness = 2, Transparency = 0.3}),
			create("ImageLabel", {Name = "Icon", Size = UDim2.fromOffset(12,13), Position = UDim2.fromOffset(21,8), BackgroundTransparency = 1, Image = "rbxassetid://18263247588"}),
			create("TextLabel", {Name = "Title", Size = UDim2.fromOffset(106,25), Position = UDim2.fromOffset(42,5), BackgroundTransparency = 1, FontFace = Font.fromId(12187377099, Enum.FontWeight.SemiBold), Text = name, TextColor3 = (#self._page.SectionButtonContainer:GetChildren() - 2 <= 0 and Color3.fromRGB(255,255,255) or Color3.fromRGB(168,168,168)), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left})
		}),
		_items = {},
	}, cell)
	
	autoResizeGrid(newCategory._frame)
	
	newCategory._button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			for i,v in next, self._page.Sections:GetChildren() do
				v.Visible = false
			end
			newCategory._frame.Visible = true
		end
	end)
	
	self._items[#self._items + 1] = newCategory
	
	return newCategory
end

-- main functions

function library.new(name)
	local lib = setmetatable({
		_name = name,
		_gui = create("ScreenGui", { Name = httpservice:GenerateGUID(false), ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false }, {
			create("Frame", {Name = "Main", Size = UDim2.fromOffset(856,634), Position = UDim2.fromOffset(69,134), BackgroundTransparency = 0.08, BackgroundColor3 = Color3.fromRGB(18, 18, 18), Visible = false}, {
				-- ui stuff
				create("UIStroke", {Color = Color3.fromRGB(49,49,49), Thickness = 2, Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}),
				create("UICorner", {CornerRadius = UDim.new(0.025,0)}),
				
				-- lines
				create("Frame", {Name = "Line", BackgroundColor3 = Color3.fromRGB(43,43,43), Size = UDim2.fromOffset(4,632), Position = UDim2.fromOffset(274,0), BorderSizePixel = 0, BackgroundTransparency = 0.5}),
				create("Frame", {Name = "Line", BackgroundColor3 = Color3.fromRGB(43,43,43), Size = UDim2.fromOffset(557,2), Position = UDim2.fromOffset(279,60), BorderSizePixel = 0, BackgroundTransparency = 0.5}),
				create("Frame", {Name = "Line", BackgroundColor3 = Color3.fromRGB(43,43,43), Size = UDim2.fromOffset(275,1), Position = UDim2.fromOffset(0,112), BorderSizePixel = 0, BackgroundTransparency = 0.3}),

				-- main frames
				create("Frame", {Name = "Pages", BackgroundTransparency = 1, Size = UDim2.fromOffset(579,636), Position = UDim2.fromOffset(275,0)}),
				create("Frame", {Name = "Profile", BackgroundTransparency = 1, Size = UDim2.fromOffset(274,69), Position = UDim2.fromOffset(0,554)}, {
					create("ImageLabel", {Name = "Headshot", Size = UDim2.fromOffset(44,44), Position = UDim2.fromOffset(48,12), BackgroundTransparency = 1}, {
						create("UICorner", {CornerRadius = UDim.new(1,0)}),
						create("TextLabel", {Name = "Title1", BackgroundTransparency = 1, Size = UDim2.fromOffset(127,16), Position = UDim2.fromOffset(53,6), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, Text = "ROBLOX", TextColor3 = Color3.fromRGB(255,255,255), TextScaled = true, TextSize = 14}),
						create("TextLabel", {Name = "Title2", BackgroundTransparency = 1, Size = UDim2.fromOffset(147,14), Position = UDim2.fromOffset(53,23), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, Text = "32 days remaining", TextColor3 = Color3.fromRGB(143,143,143), TextScaled = true, TextSize = 14})
					})
				}),
				
				-- side panel
				create("ScrollingFrame", {Name = "SidePanel", Size = UDim2.fromOffset(267,401), Position = UDim2.fromOffset(0,142), BackgroundTransparency = 1, ScrollBarImageColor3 = Color3.fromRGB(54,54,54), ScrollBarThickness = 4, CanvasSize = UDim2.fromOffset(0,0), BorderSizePixel = 0}, {
					create("UIPadding", {PaddingLeft = UDim.new(0,30)}),
					create("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Left, VerticalAlignment = Enum.VerticalAlignment.Top, Padding = UDim.new(0,15), FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder}),
				}),
				
				-- search bar
				create("Frame", {Name = "SearchBar", Size = UDim2.fromOffset(200,35), Position = UDim2.fromOffset(18,59), BackgroundColor3 = Color3.fromRGB(47,47,47), BackgroundTransparency = 0.5}, {
					create("UIStroke", {Color = Color3.fromRGB(49,49,49), Thickness = 2, Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}),
					create("UICorner", {CornerRadius = UDim.new(0.2,0)}),
					create("TextBox", {Name = "Input", Size = UDim2.fromOffset(153,13), Position = UDim2.fromOffset(41,10), PlaceholderText = "Search...", TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextColor3 = Color3.fromRGB(136,136,138), TextSize = 14, TextScaled = true, BackgroundTransparency = 1, Text = ""}),
					create("ImageLabel", {Name = "Icon", Size = UDim2.fromOffset(14,14), Position = UDim2.fromOffset(16,9), BackgroundTransparency = 1, Image = "rbxassetid://6031154871", ImageColor3 = Color3.fromRGB(177,177,177)})
				}),
				
				-- title
				create("TextLabel", {Name = "title", Text = name, TextScaled = true, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, Size = UDim2.fromOffset(211,24), Position = UDim2.fromOffset(18,16), BackgroundTransparency = 1, FontFace = Font.fromId(16658254058, Enum.FontWeight.Bold, Enum.FontStyle.Normal)}),
			}),
			create("Frame", {Name = "Loader", Size = UDim2.fromScale(0.377, 0.31), Position = UDim2.fromScale(0.311,0.345), BackgroundTransparency = 1}, {
				-- ui stuff
				create("UIAspectRatioConstraint", { AspectRatio = 2.098, AspectType = Enum.AspectType.FitWithinMaxSize, DominantAxis = Enum.DominantAxis.Width }),
				create("UICorner", {CornerRadius = UDim.new(0.06,0)}),

				-- lines
				create("Frame", {Name = "Line", BackgroundColor3 = Color3.fromRGB(84,81,81), Size = UDim2.fromScale(0.005,0.643), Position = UDim2.fromScale(0.42,0.173), BorderSizePixel = 0, BackgroundTransparency = 0.5, ZIndex = 132}, {
					create("UICorner", {CornerRadius = UDim.new(1,0)})
				}),

				-- frames
				create("Frame", {Name = "Background", Size = UDim2.fromScale(0.472,1), BackgroundColor3 = Color3.fromRGB(0,0,0), BorderSizePixel = 0, ZIndex = 77}, {
					create("UIGradient", {Rotation = 45}),
					create("UICorner", {CornerRadius = UDim.new(0.06,0)})
				}),
				create("Frame", {Name = "TopShading", Size = UDim2.fromScale(1,1), BackgroundTransparency = 0.4, BackgroundColor3 = Color3.fromRGB(38,38,38), ZIndex = 4}, {
					create("UIGradient", {Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.47, 0.67), NumberSequenceKeypoint.new(1.00, 1.00)}, Rotation = 90}),
					create("UICorner", {CornerRadius = UDim.new(0.05,0)})
				}),
				create("Frame", {Name = "RightShading", Size = UDim2.fromScale(0.287,1), Position = UDim2.fromScale(0.713,0), BackgroundColor3 = Color3.fromRGB(38,38,38), BackgroundTransparency = 0.4}, {
					create("UICorner", {CornerRadius = UDim.new(0.05,0)}),
					create("UIGradient", {Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.39, 0.77), NumberSequenceKeypoint.new(1.00, 1.00)}, Rotation = 90}),
				}),
				create("Frame", {Name = "BottomShading", Size = UDim2.fromScale(1,1), BackgroundColor3 = Color3.fromRGB(38,38,38), BackgroundTransparency = 0.4}, {
					create("UICorner", {CornerRadius = UDim.new(0.05,0)}),
					create("UIGradient", {Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.356, 0.725), NumberSequenceKeypoint.new(1.00, 1.00)}, Rotation = -90}),
				}),
				create("Frame", {Name = "Middle", Size = UDim2.fromScale(0.131,1), Position = UDim2.fromScale(0.358,0), BackgroundColor3 = Color3.fromRGB(0,0,0), BorderSizePixel = 0, ZIndex = 5}),

				-- images
				create("ImageLabel", {Name = "OuterGlow", BackgroundTransparency = 1, Size = UDim2.fromScale(1.304,1.31), Position = UDim2.fromScale(-0.156,-0.141), Image = "rbxassetid://18171083070", ImageColor3 = Color3.fromRGB(0,0,0), ZIndex = -324131232}),
				create("ImageLabel", {Name = "GamePreview", BackgroundTransparency = 1, Size = UDim2.fromScale(0.528,1), Position = UDim2.fromScale(0.472,0), Image = "rbxassetid://18171355286", ZIndex = 2}, {
					create("UICorner", {CornerRadius = UDim.new(0.05,0)})
				}),

				-- loading bar
				create("Frame", {Name = "Loading", Size = UDim2.fromScale(0.369,0.173), Position = UDim2.fromScale(0.029, 0.471), BackgroundTransparency = 1, ZIndex = 78}, {
					create("Frame", {Name = "Bar", Size = UDim2.fromScale(0.835,0.196), Position = UDim2.fromScale(0.085,0.043), BackgroundColor3 = Color3.fromRGB(62,62,63), ZIndex = 78}, {
						create("UICorner", {CornerRadius = UDim.new(0.5,0)}),
						create("Frame", {Name = "Fill", Size = UDim2.fromScale(0,1), BackgroundColor3 = Color3.fromRGB(255,255,255), ZIndex = 78}, {
							create("UICorner", {CornerRadius = UDim.new(0.5,0)})
						})
					})
				}),

				-- titles
				create("TextLabel", {Text = `{name} | LOADER`, TextColor3 = Color3.fromRGB(255,255,255), TextScaled = true, BackgroundTransparency = 1, Size = UDim2.fromScale(0.358,0.094), Position = UDim2.fromScale(0.03,0.083), ZIndex = 132, FontFace = Font.fromId(16658254058, Enum.FontWeight.Bold, Enum.FontStyle.Normal)}),
				create("TextLabel", {Text = `Universal`, TextColor3 = Color3.fromRGB(255,255,255), TextScaled = true, BackgroundTransparency = 1, Size = UDim2.fromScale(0.358,0.053), Position = UDim2.fromScale(0.03,0.203), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 132, FontFace = Font.fromId(12187365364, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)}),
				create("TextLabel", {Text = `Loading Assets...`, TextColor3 = Color3.fromRGB(216, 216, 216), TextScaled = true, BackgroundTransparency = 1, Size = UDim2.fromScale(0.3,0.053), Position = UDim2.fromScale(0.059,0.546), ZIndex = 132,FontFace = Font.fromId(12187365364, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)}),
			})
		}),
		_items = {},
	}, library)
	
	autoResizeList(lib._gui.Main.SidePanel)
	
	makeDraggable(lib._gui.Main)
	makeDraggable(lib._gui.Loader)
	
	doOptimalParenting(lib._gui)
	
	lib:doLoad()
	
	userinputservice.InputBegan:Connect(function(input, GPE)
		if not library._settings.binding and not GPE then
			local inputName = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name or input.UserInputState.Name
			for _, page in next, lib._items do
				for _, category in next, page._items do
					for _, cell in next, category._items do
						for _, item in next, cell._items do
							if item._class == "keybind" and item._status.value == inputName then
								task.spawn(item._callback, item._status.value)
							end
						end
					end
				end
			end
		end
	end)
	
	lib._gui.Main.SearchBar.Input:GetPropertyChangedSignal("Text"):Connect(function()
		local text = lib._gui.Main.SearchBar.Input.Text
		
		for i,v in next, lib._gui.Main.SidePanel:GetChildren() do
			if v:IsA("TextButton") then
				if text ~= "" then
					if string.match(string.lower(v.Name), string.lower(text)) then
						v.Visible = true
					else
						v.Visible = false
					end
				else
					v.Visible = true
				end
			end
		end
	end)
	
	return lib
end

function library:doLoad()
	local loaded = self._gui.Loader
	
	local t = tween(loaded.Loading.Bar.Fill, 4, {Size = UDim2.fromScale(1,1)})
	t.Completed:Wait()
	self._gui.Main.Visible = true
	loaded:Destroy()
end

function library:createPage(name, icon)
	local sidePanel = self._gui.Main.SidePanel
	local pages = self._gui.Main.Pages
	
	local newPage = setmetatable({
		_lib  = self,
		_name = name,
		_page = create("Frame", {Parent = pages, Name = name, Size = UDim2.fromOffset(1,1), BackgroundTransparency = 1, Visible = (#pages:GetChildren() <= 0 and true or false)}, {
			create("UIPadding", {PaddingLeft = UDim.new(0.04,0)}),
			create("Frame", {Name = "SectionButtonContainer", Size = UDim2.fromOffset(580,60), BackgroundTransparency = 1}, {
				create("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Left, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0,15), FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder}),
				create("UIPadding", {PaddingLeft = UDim.new(0.04,0)}),
			}),
			create("Frame", {Name = "Sections", Size = UDim2.fromOffset(577,570), Position = UDim2.fromOffset(3,62), BackgroundTransparency = 1}, {}),
		}),
		_button = create("TextButton", {Parent = sidePanel, Name = name, Size = UDim2.fromOffset(216,41), BackgroundTransparency = 0.6, BackgroundColor3 = Color3.fromRGB(47,47,47), AutoButtonColor = false, LayoutOrder = #sidePanel:GetChildren()}, {
			create("UIStroke", {Color = Color3.fromRGB(49,49,49), Thickness = 2, Transparency = 0.7, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}),
			create("UICorner", {CornerRadius = UDim.new(0.2,0)}),
			create("ImageLabel", {Name = "Icon", Size = UDim2.fromOffset(18,18), Position = UDim2.fromOffset(21,10), BackgroundTransparency = 1, Image = icon}),
			create("TextLabel", {Name = "Title", Size = UDim2.fromOffset(159,23), Position = UDim2.fromOffset(50,8), BackgroundTransparency = 1, Text = name, TextColor3 = Color3.fromRGB(255,255,255), TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, FontFace = Font.fromId(12187377099, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)})
		}),
		_items = {},
	}, tab)
	

	newPage._button.MouseButton1Click:Connect(function(input)
		for i,v in next, pages:GetChildren() do
			if v:IsA("Frame") then
				v.Visible = false
			end
		end
		newPage._page.Visible = true
	end)

	self._items[#self._items + 1] = newPage
	
	return newPage
end

function library:addDivider()
	local ui = self._gui.Main.SidePanel
	create("Frame", {Parent = ui, Name = "Divider", Size = UDim2.fromOffset(210,2), ZIndex = #ui:GetChildren() - 2, BackgroundColor3 = Color3.fromRGB(43,43,43), BackgroundTransparency = 0.25, BorderSizePixel = 0, LayoutOrder = #ui:GetChildren()})
end

return library
