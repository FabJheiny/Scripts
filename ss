local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserGameSettings   = UserSettings():GetService("UserGameSettings")
local CoreGui            = game:GetService("CoreGui")
local UIS                = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local StarterGui         = game:GetService("StarterGui")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer
local Cam         = workspace.CurrentCamera

local function getHui()
	local fn = rawget(getfenv(), "gethui")
	if type(fn) == "function" then
		local ok, res = pcall(fn)
		if ok and res then return res end
	end
end

local function getGlobalEnv()
	if typeof(getgenv) == "function" then
		local ok, env = pcall(getgenv)
		if ok and env then return env end
	end
	return _G
end

local parentTarget = getHui() or CoreGui
local genv = getGlobalEnv()

if genv.SpectatePillGui_Cleanup then
	pcall(genv.SpectatePillGui_Cleanup)
	genv.SpectatePillGui_Cleanup = nil
end

for _, obj in ipairs(parentTarget:GetChildren()) do
	if obj.Name == "SpectatePillGui" then
		pcall(function() obj:Destroy() end)
	end
end

if not genv.SpectatePillGui_DefaultSpeed then
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		genv.SpectatePillGui_DefaultSpeed = hum.WalkSpeed
	end
end

local _shutdown = false
local connections = {}

local function track(conn)
	table.insert(connections, conn)
	return conn
end

local IsItOn = false

local pillGui = Instance.new("ScreenGui")
pillGui.Name = "SpectatePillGui"
pillGui.ResetOnSpawn = false
pillGui.IgnoreGuiInset = true
pillGui.DisplayOrder = 0
pillGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if not pcall(function() pillGui.Parent = parentTarget end) then
	pillGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local PILL_BG    = Color3.fromRGB(18, 18, 21)
local MID        = Color3.fromRGB(220, 225, 230)
local W          = Color3.fromRGB(255, 255, 255)
local BLUE       = Color3.fromRGB(90, 200, 255)
local GREEN      = Color3.fromRGB(120, 230, 150)
local RED        = Color3.fromRGB(240, 100, 100)
local FONT       = Enum.Font.GothamMedium
local BAR_TRANS  = 0.08

local HOVER_COLOR = Color3.fromRGB(42, 42, 48)
local PRESS_COLOR = Color3.fromRGB(65, 65, 72)

local function new(cls, props, parent)
	local inst = Instance.new(cls)
	for k, v in pairs(props) do inst[k] = v end
	if parent then inst.Parent = parent end
	return inst
end

local function attachButtonFeedback(btn, bgFrame, baseTrans)
	baseTrans = baseTrans or BAR_TRANS

	local hovering  = false
	local pressing  = false
	local lockColor = nil
	local lockTrans = nil

	local function apply()
		if lockColor then
			bgFrame.BackgroundColor3 = lockColor
			bgFrame.BackgroundTransparency = lockTrans or baseTrans
			return
		end
		local targetColor
		if pressing then
			targetColor = PRESS_COLOR
		elseif hovering then
			targetColor = HOVER_COLOR
		else
			targetColor = PILL_BG
		end
		bgFrame.BackgroundColor3 = targetColor
		bgFrame.BackgroundTransparency = baseTrans
	end

	btn.MouseEnter:Connect(function() hovering = true;  apply() end)
	btn.MouseLeave:Connect(function() hovering = false; pressing = false; apply() end)
	btn.MouseButton1Down:Connect(function() pressing = true;  apply() end)
	btn.MouseButton1Up:Connect(function()   pressing = false; apply() end)

	return {
		setLock = function(color, trans)
			lockColor = color
			lockTrans = trans
			apply()
		end,
		clearLock = function()
			lockColor = nil
			lockTrans = nil
			apply()
		end,
	}
end

local MASTER_Y  = 70
local PILL_SIZE = 44
local GAP       = 10

local BUTTON_DEFS = {
	{ name = "MouseLock",    image = "rbxassetid://80450981243325"  },
	{ name = "PillSpectate", image = "rbxassetid://95367294955296"  },
	{ name = "PillExtra",    image = "rbxassetid://128627976860226" },
	{ name = "PillNew",      image = "rbxassetid://92692342810434"  },
	{ name = "PillWaypoint", image = "rbxassetid://127634562492512" },
	{ name = "PillZoom",     image = "rbxassetid://121059419392731" },
	{ name = "PillInstant",  image = "rbxassetid://137848670348849" },
	{ name = "PillJump",     image = "rbxassetid://76225205426537"  },
}

local BUTTON_COUNT = #BUTTON_DEFS
local stackHeight  = PILL_SIZE * BUTTON_COUNT + GAP * (BUTTON_COUNT - 1)
local baseY        = PILL_SIZE + GAP
local clipOffset   = PILL_SIZE / 2
local baseYInner   = baseY - clipOffset
local CLIP_HEIGHT  = baseYInner + stackHeight

local rig = new("Frame", {
	Name = "Rig",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0, 15 + PILL_SIZE/2, 0, MASTER_Y + PILL_SIZE/2),
	Size = UDim2.new(0, PILL_SIZE, 0, PILL_SIZE),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 1,
}, pillGui)

local stackClip = new("Frame", {
	Name = "StackClip",
	Position = UDim2.new(0, 0, 0, clipOffset),
	Size = UDim2.new(0, PILL_SIZE, 0, CLIP_HEIGHT),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ZIndex = 1,
}, rig)

local stackInner = new("Frame", {
	Name = "StackInner",
	Position = UDim2.new(0, 0, 0, baseYInner),
	Size = UDim2.new(0, PILL_SIZE, 0, stackHeight),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
}, stackClip)

local function makePill(parent, index, imageId, pillName)
	local y = (PILL_SIZE + GAP) * index

	local frame = new("Frame", {
		Name = pillName,
		Position = UDim2.new(0, 0, 0, y),
		Size = UDim2.new(0, PILL_SIZE, 0, PILL_SIZE),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, parent)

	local container = new("Frame", {
		Name = "Container",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, frame)

	local bg = new("Frame", {
		Name = "Background",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = PILL_BG,
		BackgroundTransparency = BAR_TRANS,
		BorderSizePixel = 0,
	}, container)
	new("UICorner", { CornerRadius = UDim.new(1, 0) }, bg)

	local icon = new("Frame", {
		Name = "Icon",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 5,
	}, container)

	local img = new("ImageLabel", {
		Name = "Image",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0.7, 0, 0.7, 0),
		BackgroundTransparency = 1,
		Image = imageId,
	}, icon)
	new("UIAspectRatioConstraint", {}, img)

	local btn = new("TextButton", {
		Name = "Button",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 6,
	}, container)

	return btn, bg
end

local pillButtons = {}
for i, def in ipairs(BUTTON_DEFS) do
	local btn, bg = makePill(stackInner, i - 1, def.image, def.name)
	attachButtonFeedback(btn, bg)
	pillButtons[def.name] = btn
end

local mlBtn    = pillButtons.MouseLock
local pillBtn  = pillButtons.PillSpectate
local pillBtn3 = pillButtons.PillExtra
local pillBtn4 = pillButtons.PillNew
local pillBtn5 = pillButtons.PillWaypoint
local pillBtn6 = pillButtons.PillZoom
local pillBtn7 = pillButtons.PillInstant
local pillBtn8 = pillButtons.PillJump

local master = new("Frame", {
	Name = "PillMaster",
	Position = UDim2.new(0, 15, 0, MASTER_Y),
	Size = UDim2.new(0, PILL_SIZE, 0, PILL_SIZE),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 10,
}, pillGui)

local masterContainer = new("Frame", {
	Name = "Container",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 10,
}, master)

local masterBg = new("Frame", {
	Name = "Background",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = BAR_TRANS,
	BorderSizePixel = 0,
	ZIndex = 10,
}, masterContainer)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, masterBg)

local masterIcon = new("Frame", {
	Name = "Icon",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 11,
}, masterContainer)

local masterArrow = new("ImageLabel", {
	Name = "Arrow",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0.7, 0, 0.7, 0),
	BackgroundTransparency = 1,
	Image = "rbxassetid://89079638857106",
	ImageColor3 = W,
	ImageTransparency = 0,
	Rotation = 0,
	ZIndex = 11,
}, masterIcon)
new("UIAspectRatioConstraint", {}, masterArrow)

local masterBtn = new("TextButton", {
	Name = "Button",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Text = "",
	ZIndex = 12,
}, masterContainer)

local masterFeedback = attachButtonFeedback(masterBtn, masterBg)

local stackOpen  = false
local TWEEN_INFO = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function setStack(open)
	stackOpen = open

	local openY     = baseYInner
	local closedY   = -stackHeight
	local targetY   = open and openY or closedY
	local targetRot = open and 180 or 0

	TweenService:Create(
		stackInner, TWEEN_INFO, { Position = UDim2.new(0, 0, 0, targetY) }
	):Play()

	TweenService:Create(
		masterArrow, TWEEN_INFO, { Rotation = targetRot }
	):Play()
end

local function clampMaster(x, y)
	local vp = Cam.ViewportSize
	local maxX = math.max(0, vp.X - PILL_SIZE)
	local maxY = math.max(0, vp.Y - PILL_SIZE)
	return math.clamp(x, 0, maxX), math.clamp(y, 0, maxY)
end

local HOLD_TIME       = 1.5
local DRAG_THRESHOLD  = 5

local holding         = false
local dragMode        = false
local dragMoved       = false
local holdToken       = 0
local holdInput       = nil
local lastInputPos    = nil
local dragStartPos    = nil
local dragStartMaster = nil

local function isSameHold(input)
	if not holdInput then return false end
	if input == holdInput then return true end
	if holdInput.UserInputType == Enum.UserInputType.MouseButton1
	   and input.UserInputType == Enum.UserInputType.MouseMovement then
		return true
	end
	return false
end

local function beginHold(input)
	if holding then return end
	holding         = true
	dragMode        = false
	dragMoved       = false
	holdInput       = input
	lastInputPos    = Vector2.new(input.Position.X, input.Position.Y)
	dragStartPos    = lastInputPos
	dragStartMaster = master.Position
	holdToken      += 1
	local myToken   = holdToken

	task.delay(HOLD_TIME, function()
		if _shutdown then return end
		if holdToken == myToken and holding then
			dragMode = true
			if lastInputPos then
				dragStartPos    = lastInputPos
				dragStartMaster = master.Position
			end
			masterFeedback.setLock(W, 0.15)
		end
	end)
end

local function updateHold(input)
	if not holding then return end
	if not isSameHold(input) then return end

	local current = Vector2.new(input.Position.X, input.Position.Y)
	lastInputPos = current

	local delta = current - dragStartPos
	if delta.Magnitude > DRAG_THRESHOLD then
		dragMoved = true
	end

	if dragMode then
		local rawX = dragStartMaster.X.Offset + delta.X
		local rawY = dragStartMaster.Y.Offset + delta.Y
		local newX, newY = clampMaster(rawX, rawY)

		master.Position = UDim2.new(0, newX, 0, newY)
		rig.Position    = UDim2.new(0, newX + PILL_SIZE/2, 0, newY + PILL_SIZE/2)
	end
end

local function endHold(input)
	if not holding then return end
	if holdInput and input ~= holdInput then return end

	holding   = false
	holdInput = nil
	holdToken += 1

	local wasDragMode = dragMode
	dragMode = false

	masterFeedback.clearLock()

	if not wasDragMode and not dragMoved then
		setStack(not stackOpen)
	end
end

track(masterBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		beginHold(input)
	end
end))

track(UIS.InputChanged:Connect(function(input)
	if not holding then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		updateHold(input)
	end
end))

track(UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		endHold(input)
	end
end))

setStack(true)

RunService:BindToRenderStep("SmoothTrans", Enum.RenderPriority.Camera.Value + 1, function()
	if IsItOn ~= true then return end
	if not workspace.CurrentCamera then return end
	if ((workspace.CurrentCamera.CFrame.Position - workspace.CurrentCamera.Focus.Position).Magnitude) < 0.6 then
		return
	else
		workspace.CurrentCamera.Focus = (workspace.CurrentCamera.CFrame * CFrame.new(1.7, 0, 0)) * CFrame.new(0, 0, -((workspace.CurrentCamera.Focus.Position - workspace.CurrentCamera.CFrame.Position).Magnitude))
		workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(1.7, 0, 0)
	end
end)

mlBtn.MouseButton1Click:Connect(function()
	IsItOn = not IsItOn
	if IsItOn == true then
		UserGameSettings.RotationType = Enum.RotationType.CameraRelative
	else
		UserGameSettings.RotationType = Enum.RotationType.MovementRelative
	end
end)

local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 3,
		})
	end)
end

local infiniteZoomEnabled = false
local zoomConn = nil

local function setInfiniteZoom(enable)
	infiniteZoomEnabled = enable

	if zoomConn then
		zoomConn:Disconnect()
		zoomConn = nil
	end

	if not enable then
		pcall(function()
			LocalPlayer.CameraMode = Enum.CameraMode.Classic
			LocalPlayer.CameraMaxZoomDistance = 128
			LocalPlayer.CameraMinZoomDistance = 0.5
		end)
		notify("Infinite Zoom", "Infinite Zoom Disabled")
		return
	end

	notify("Infinite Zoom", "Infinite Zoom Active")

	zoomConn = track(RunService.RenderStepped:Connect(function()
		pcall(function()
			LocalPlayer.CameraMaxZoomDistance = math.huge
			LocalPlayer.CameraMinZoomDistance = 0.1
			if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
				LocalPlayer.CameraMode = Enum.CameraMode.Classic
			end
			if Cam.CameraType == Enum.CameraType.Fixed
			or Cam.CameraType == Enum.CameraType.Scriptable then
				Cam.CameraType = Enum.CameraType.Custom
			end
			if Cam.CameraType == Enum.CameraType.Custom then
				local char = LocalPlayer.Character
				if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart")
				if not root then return end
				local dist = (Cam.CFrame.Position - root.Position).Magnitude
				if dist < 0.5 then
					Cam.CFrame = Cam.CFrame * CFrame.new(0, 0, 1)
				end
			end
		end)
	end))
end

local _firePrompt = rawget(getfenv(), "fireproximityprompt")
if type(_firePrompt) ~= "function" then
	_firePrompt = (type(fireproximityprompt) == "function") and fireproximityprompt or nil
end

local function firePrompt(prompt)
	if _firePrompt then
		pcall(_firePrompt, prompt)
	end
end

local instantInteractEnabled = false
local instantConn = nil

local function setInstantInteraction(enable)
	instantInteractEnabled = enable

	if instantConn then
		instantConn:Disconnect()
		instantConn = nil
	end

	if not enable then
		notify("Instant Interaction", "Instant Interaction Disabled")
		return
	end

	notify("Instant Interaction", "Instant Interaction Active")

	instantConn = track(ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, player)
		if instantInteractEnabled then
			firePrompt(prompt)
		end
	end))
end

local infiniteJumpEnabled = false
local jumpConn = nil

local function setInfiniteJump(enable)
	infiniteJumpEnabled = enable

	if jumpConn then
		jumpConn:Disconnect()
		jumpConn = nil
	end

	if not enable then
		notify("Infinite Jump", "Infinite Jump Disabled")
		return
	end

	notify("Infinite Jump", "Infinite Jump Active")

	jumpConn = track(UIS.JumpRequest:Connect(function()
		if not infiniteJumpEnabled then return end
		local char = LocalPlayer.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end))
end

local players       = {}
local currentIndex  = 1
local menuOpen      = false
local extraMenuOpen = false

local bar = new("Frame", {
	Name = "Bar",
	Position = UDim2.new(-1, -100, 0.88, -25),
	Size = UDim2.new(0, 220, 0, 50),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = BAR_TRANS,
	BorderSizePixel = 0,
}, pillGui)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, bar)

local prev = new("TextButton", {
	Name = "Previous",
	Position = UDim2.new(0.02, 0, 0.075, 0),
	Size = UDim2.new(0.2, 0, 0.85, 0),
	Text = "<",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Font = FONT,
	TextColor3 = MID,
	TextSize = 22,
	AutoButtonColor = false,
}, bar)
prev.MouseEnter:Connect(function() prev.TextColor3 = BLUE end)
prev.MouseLeave:Connect(function() prev.TextColor3 = MID end)

local nex = new("TextButton", {
	Name = "Next",
	Position = UDim2.new(0.78, 0, 0.075, 0),
	Size = UDim2.new(0.2, 0, 0.85, 0),
	Text = ">",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Font = FONT,
	TextColor3 = MID,
	TextSize = 22,
	AutoButtonColor = false,
}, bar)
nex.MouseEnter:Connect(function() nex.TextColor3 = BLUE end)
nex.MouseLeave:Connect(function() nex.TextColor3 = MID end)

local title = new("TextButton", {
	Name = "Title",
	Position = UDim2.new(0.22, 0, 0.1, 0),
	Size = UDim2.new(0.56, 0, 0.8, 0),
	Text = "",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Font = FONT,
	TextColor3 = W,
	TextSize = 14,
	TextScaled = false,
	TextTruncate = Enum.TextTruncate.AtEnd,
	TextXAlignment = Enum.TextXAlignment.Center,
	AutoButtonColor = false,
}, bar)
title.MouseEnter:Connect(function() title.TextColor3 = BLUE end)
title.MouseLeave:Connect(function() title.TextColor3 = W end)

local bar3 = new("Frame", {
	Name = "BarExtra",
	Position = UDim2.new(-1, -100, 0.88, -25),
	Size = UDim2.new(0, 220, 0, 50),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = BAR_TRANS,
	BorderSizePixel = 0,
}, pillGui)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, bar3)

local iconBtn3 = new("TextButton", {
	Name = "IconButton",
	Position = UDim2.new(0, 5, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5),
	Size = UDim2.new(0, 40, 0, 40),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = 0.3,
	BorderSizePixel = 0,
	Text = "",
	AutoButtonColor = false,
}, bar3)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, iconBtn3)

local iconImg3 = new("ImageLabel", {
	Name = "Image",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0.65, 0, 0.65, 0),
	BackgroundTransparency = 1,
	Image = "rbxassetid://91674989394340",
	ImageColor3 = W,
}, iconBtn3)
new("UIAspectRatioConstraint", {}, iconImg3)

local numberBox3 = new("TextBox", {
	Name = "NumberBox",
	Position = UDim2.new(0, 52, 0, 5),
	Size = UDim2.new(1, -60, 1, -10),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Font = FONT,
	TextColor3 = W,
	TextSize = 20,
	Text = "0",
	PlaceholderText = "0",
	PlaceholderColor3 = MID,
	TextXAlignment = Enum.TextXAlignment.Left,
	ClearTextOnFocus = false,
}, bar3)

local bar4 = new("Frame", {
	Name = "BarNew",
	Position = UDim2.new(-1, -100, 0.88, -25),
	Size = UDim2.new(0, 220, 0, 50),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = BAR_TRANS,
	BorderSizePixel = 0,
}, pillGui)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, bar4)

local iconBtn4 = new("TextButton", {
	Name = "IconButton",
	Position = UDim2.new(0, 5, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5),
	Size = UDim2.new(0, 40, 0, 40),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = 0.3,
	BorderSizePixel = 0,
	Text = "",
	AutoButtonColor = false,
}, bar4)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, iconBtn4)

local iconImg4 = new("ImageLabel", {
	Name = "Image",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0.65, 0, 0.65, 0),
	BackgroundTransparency = 1,
	Image = "rbxassetid://91674989394340",
	ImageColor3 = W,
}, iconBtn4)
new("UIAspectRatioConstraint", {}, iconImg4)

local numberBox4 = new("TextBox", {
	Name = "NumberBox",
	Position = UDim2.new(0, 52, 0, 5),
	Size = UDim2.new(1, -60, 1, -10),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Font = FONT,
	TextColor3 = W,
	TextSize = 20,
	Text = "16",
	PlaceholderText = "1",
	PlaceholderColor3 = MID,
	TextXAlignment = Enum.TextXAlignment.Left,
	ClearTextOnFocus = false,
}, bar4)

local bar5 = new("Frame", {
	Name = "BarWaypoint",
	Position = UDim2.new(-1, -100, 0.88, -25),
	Size = UDim2.new(0, 220, 0, 50),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = BAR_TRANS,
	BorderSizePixel = 0,
}, pillGui)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, bar5)

local saveBtn5 = new("TextButton", {
	Name = "Save",
	Position = UDim2.new(0, 5, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5),
	Size = UDim2.new(0, 100, 0, 40),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = 0.3,
	BorderSizePixel = 0,
	Text = "",
	AutoButtonColor = false,
}, bar5)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, saveBtn5)

local saveImg5 = new("ImageLabel", {
	Name = "Image",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0.55, 0, 0.55, 0),
	BackgroundTransparency = 1,
	Image = "rbxassetid://98119420080865",
	ImageColor3 = W,
}, saveBtn5)
new("UIAspectRatioConstraint", {}, saveImg5)

saveBtn5.MouseEnter:Connect(function() saveImg5.ImageColor3 = GREEN end)
saveBtn5.MouseLeave:Connect(function() saveImg5.ImageColor3 = W end)

local tpBtn5 = new("TextButton", {
	Name = "Teleport",
	Position = UDim2.new(0, 115, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5),
	Size = UDim2.new(0, 100, 0, 40),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = 0.3,
	BorderSizePixel = 0,
	Text = "",
	AutoButtonColor = false,
}, bar5)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, tpBtn5)

local tpImg5 = new("ImageLabel", {
	Name = "Image",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0.55, 0, 0.55, 0),
	BackgroundTransparency = 1,
	Image = "rbxassetid://134973087992424",
	ImageColor3 = W,
}, tpBtn5)
new("UIAspectRatioConstraint", {}, tpImg5)

tpBtn5.MouseEnter:Connect(function() tpImg5.ImageColor3 = BLUE end)
tpBtn5.MouseLeave:Connect(function() tpImg5.ImageColor3 = W end)

local wpPopup = new("Frame", {
	Name = "WaypointPopup",
	Position = UDim2.new(-1, -100, 0.88, -25),
	Size = UDim2.new(0, 220, 0, 5 * 34 + 10),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = BAR_TRANS,
	BorderSizePixel = 0,
	ZIndex = 5,
	ClipsDescendants = true,
}, pillGui)
new("UICorner", { CornerRadius = UDim.new(0, 14) }, wpPopup)

local wpButtons = {}
for i = 1, 5 do
	local b = new("TextButton", {
		Name = "WP" .. i,
		Position = UDim2.new(0, 5, 0, 5 + (i - 1) * 34),
		Size = UDim2.new(1, -10, 0, 30),
		BackgroundColor3 = Color3.fromRGB(30, 30, 35),
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Visible = false,
		ZIndex = 6,
	}, wpPopup)
	new("UICorner", { CornerRadius = UDim.new(0, 10) }, b)

	local wpImg = new("ImageLabel", {
		Name = "Image",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 6, 0.5, 0),
		Size = UDim2.new(0, 20, 0, 20),
		BackgroundTransparency = 1,
		Image = "rbxassetid://98119420080865",
		ImageColor3 = W,
		ZIndex = 7,
	}, b)
	new("UIAspectRatioConstraint", {}, wpImg)

	local wpLabel = new("TextLabel", {
		Name = "Label",
		Position = UDim2.new(0, 32, 0, 0),
		Size = UDim2.new(1, -36, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Font = FONT,
		TextColor3 = W,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 7,
	}, b)

	b.MouseEnter:Connect(function()
		if not b:GetAttribute("Holding") then
			wpLabel.TextColor3 = BLUE
		end
	end)
	b.MouseLeave:Connect(function()
		if not b:GetAttribute("Holding") then
			wpLabel.TextColor3 = W
		end
	end)

	wpButtons[i] = { button = b, img = wpImg, label = wpLabel }
end

local waypoints     = {}
local wpPopupOpen   = false

local function formatCoords(cf)
	local p = cf.Position
	return string.format("%d, %d, %d", math.round(p.X), math.round(p.Y), math.round(p.Z))
end

local function refreshWaypointPopup()
	for i = 1, 5 do
		local wp = waypoints[i]
		local entry = wpButtons[i]
		if wp then
			entry.button.Visible = true
			entry.label.Text = formatCoords(wp)
		else
			entry.button.Visible = false
		end
	end
end

local function closeWaypointPopup()
	wpPopupOpen = false
	wpPopup.Position = UDim2.new(-1, -100, 0.88, -25)
end

saveBtn5.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	table.insert(waypoints, root.CFrame)
	if #waypoints > 5 then
		table.remove(waypoints, 1)
	end
	refreshWaypointPopup()
end)

tpBtn5.MouseButton1Click:Connect(function()
	if wpPopupOpen then
		closeWaypointPopup()
		return
	end
	if #waypoints == 0 then return end
	refreshWaypointPopup()
	wpPopup.Position = UDim2.new(0.5, -110, 0.88, -220)
	wpPopupOpen = true
end)

local LONG_PRESS_TIME = 1

for i, entry in ipairs(wpButtons) do
	local b = entry.button
	local holdToken = 0

	local function startHold()
		if not waypoints[i] then return end
		holdToken += 1
		local myToken = holdToken
		b:SetAttribute("Holding", true)
		entry.label.TextColor3 = RED
		task.delay(LONG_PRESS_TIME, function()
			if _shutdown then return end
			if holdToken == myToken and b:GetAttribute("Holding") then
				holdToken += 1
				b:SetAttribute("Holding", false)
				entry.label.TextColor3 = W

				table.remove(waypoints, i)
				refreshWaypointPopup()

				if #waypoints == 0 then
					closeWaypointPopup()
				end
			end
		end)
	end

	local function endHold()
		if not b:GetAttribute("Holding") then return end
		holdToken += 1
		b:SetAttribute("Holding", false)
		entry.label.TextColor3 = W

		local wp = waypoints[i]
		if not wp then return end
		local char = LocalPlayer.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		root.CFrame = wp
		closeWaypointPopup()
	end

	b.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			startHold()
		end
	end)

	b.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			endHold()
		end
	end)
end

local speedEnabled = false
local targetSpeed  = 16
local defaultSpeed = nil

local function getHumanoid()
	local char = LocalPlayer.Character
	if not char then return nil end
	return char:FindFirstChildOfClass("Humanoid")
end

local function captureDefaultSpeed()
	if genv.SpectatePillGui_DefaultSpeed then
		defaultSpeed = genv.SpectatePillGui_DefaultSpeed
		return
	end
	local hum = getHumanoid()
	if hum then
		defaultSpeed = hum.WalkSpeed
		genv.SpectatePillGui_DefaultSpeed = defaultSpeed
	end
end

local function applySpeed()
	local hum = getHumanoid()
	if hum then
		hum.WalkSpeed = targetSpeed
	end
end

local function setSpeed(n, enable)
	targetSpeed = math.clamp(math.floor(n), 1, 1000)
	numberBox4.Text = tostring(targetSpeed)
	if enable ~= nil then
		speedEnabled = enable
	end
	if speedEnabled then
		applySpeed()
	end
end

captureDefaultSpeed()

track(LocalPlayer.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid", 5)
	if hum then
		if defaultSpeed == nil then
			captureDefaultSpeed()
		end
		if speedEnabled then
			hum.WalkSpeed = targetSpeed
		end
	end
end))

track(RunService.Heartbeat:Connect(function()
	if not speedEnabled then return end
	local hum = getHumanoid()
	if hum and hum.WalkSpeed ~= targetSpeed then
		hum.WalkSpeed = targetSpeed
	end
end))

numberBox4:GetPropertyChangedSignal("Text"):Connect(function()
	local filtered = numberBox4.Text:gsub("%D", "")
	if filtered ~= numberBox4.Text then
		numberBox4.Text = filtered
	end
end)

numberBox4.FocusLost:Connect(function()
	local n = tonumber(numberBox4.Text)
	if not n then n = targetSpeed end
	setSpeed(n, true)
end)

iconBtn4.MouseButton1Click:Connect(function()
	speedEnabled = false
	targetSpeed = 16
	numberBox4.Text = "16"
	if defaultSpeed == nil then captureDefaultSpeed() end
	local hum = getHumanoid()
	if hum and defaultSpeed then
		hum.WalkSpeed = defaultSpeed
	end
end)

local flySpeed   = 0
local FLY_MULT   = 10
local flying     = false
local vVect      = 0
local lastStablePos = nil
local flyConn, noclipConn = nil, nil
local applyFlyState = nil

local function setFlySpeed(n)
	flySpeed = math.clamp(math.floor(n), 0, 100)
	numberBox3.Text = tostring(flySpeed)
	if applyFlyState then applyFlyState() end
end

numberBox3:GetPropertyChangedSignal("Text"):Connect(function()
	local filtered = numberBox3.Text:gsub("%D", "")
	if filtered ~= numberBox3.Text then
		numberBox3.Text = filtered
	end
end)

numberBox3.FocusLost:Connect(function()
	local n = tonumber(numberBox3.Text) or 0
	setFlySpeed(n)
end)

iconBtn3.MouseButton1Click:Connect(function()
	setFlySpeed(0)
end)

local function sortPlayers()
	local list = Players:GetPlayers()
	table.sort(list, function(a, b)
		return string.lower(a.Name) < string.lower(b.Name)
	end)
	players = list
end

local function refreshPlayers()
	local previous = players[currentIndex]
	sortPlayers()
	if #players == 0 then currentIndex = 1; return end
	if previous then
		for i, p in ipairs(players) do
			if p == previous then currentIndex = i; return end
		end
	end
	currentIndex = math.clamp(currentIndex, 1, #players)
end

local function findNextValid(startIdx, dir)
	if #players == 0 then return 1 end
	local i = startIdx
	for _ = 1, #players do
		if i < 1 or i > #players then return startIdx end
		local p = players[i]
		if p and p ~= LocalPlayer then return i end
		i += dir
	end
	return startIdx
end

local function getCurrentTarget()
	local p = players[currentIndex]
	if p and p ~= LocalPlayer then return p end
end

local function updateCameraAndTitle(index)
	local p = players[index]
	if not p or p == LocalPlayer then
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			Cam.CameraSubject = LocalPlayer.Character.Humanoid
		end
		title.Text = string.format("%s (@%s)", LocalPlayer.DisplayName, LocalPlayer.Name)
		return
	end
	if p.Character and p.Character:FindFirstChild("Humanoid") then
		Cam.CameraSubject = p.Character.Humanoid
		title.Text = string.format("%s (@%s)", p.DisplayName, p.Name)
	end
end

sortPlayers()

track(Players.PlayerAdded:Connect(function()
	task.wait(0.1)
	if _shutdown then return end
	refreshPlayers()
	if menuOpen then updateCameraAndTitle(currentIndex) end
end))

track(Players.PlayerRemoving:Connect(function()
	task.wait(0.1)
	if _shutdown then return end
	refreshPlayers()
	if menuOpen then updateCameraAndTitle(currentIndex) end
end))

task.spawn(function()
	while not _shutdown do
		task.wait(30)
		if _shutdown then break end
		refreshPlayers()
		if menuOpen then updateCameraAndTitle(currentIndex) end
	end
end)

local function hideAllBars()
	bar.Position  = UDim2.new(-1, -100, 0.88, -25)
	bar3.Position = UDim2.new(-1, -100, 0.88, -25)
	bar4.Position = UDim2.new(-1, -100, 0.88, -25)
	bar5.Position = UDim2.new(-1, -100, 0.88, -25)
	closeWaypointPopup()
end

local function showBar(target)
	hideAllBars()
	target.Position = UDim2.new(0.5, -110, 0.88, -25)
end

local function getTarget()
	local char = LocalPlayer.Character
	if not char then return nil, nil, nil end
	local hum  = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if hum and hum.SeatPart then
		local v = hum.SeatPart.Parent
		while v and not v:IsA("Model") do v = v.Parent end
		return hum.SeatPart, v, hum
	end
	return root, nil, hum
end

local function toggleFly()
	flying = not flying
	local root, _, hum = getTarget()
	if flying then
		if root then lastStablePos = root.Position
		else lastStablePos = Vector3.new(0, 50, 0) end
		noclipConn = track(RunService.Stepped:Connect(function()
			local _, vehicle = getTarget()
			local char = LocalPlayer.Character
			if char then
				for _, v in pairs(char:GetDescendants()) do
					if v:IsA("BasePart") then v.CanCollide = false end
				end
			end
			if vehicle then
				for _, v in pairs(vehicle:GetDescendants()) do
					if v:IsA("BasePart") then v.CanCollide = false end
				end
			end
		end))
		flyConn = track(RunService.Heartbeat:Connect(function(dt)
			local target, _, hum = getTarget()
			if not target or not hum then return end
			if hum.Health <= 0 then return end
			if not lastStablePos then lastStablePos = target.Position end
			target.Velocity    = Vector3.zero
			target.RotVelocity = Vector3.zero
			local velocity = flySpeed * FLY_MULT
			local camCF = Cam.CFrame
			local moveDir = hum.MoveDirection
			local finalVelocity = Vector3.zero
			if moveDir.Magnitude > 0 then
				local localMove = camCF:VectorToObjectSpace(moveDir)
				local rawDir = Vector3.new(localMove.X, 0, localMove.Z).Unit
				finalVelocity = camCF:VectorToWorldSpace(rawDir) * velocity
			end
			finalVelocity = finalVelocity + Vector3.new(0, vVect * velocity, 0)
			if finalVelocity.Magnitude > 0 then
				lastStablePos = lastStablePos + (finalVelocity * dt)
			end
			target.CFrame = CFrame.new(lastStablePos, lastStablePos + camCF.LookVector)
			if not hum.SeatPart then hum.PlatformStand = true end
		end))
	else
		if flyConn   then flyConn:Disconnect();   flyConn = nil end
		if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
		if hum then
			hum.PlatformStand = false
			pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
		end
	end
end

applyFlyState = function()
	local shouldFly = flySpeed > 0 and extraMenuOpen
	if shouldFly and not flying then
		toggleFly()
	elseif not shouldFly and flying then
		toggleFly()
	end
end

pillBtn.MouseButton1Click:Connect(function()
	if not menuOpen then
		menuOpen = true
		refreshPlayers(); currentIndex = 1
		showBar(bar)
		updateCameraAndTitle(currentIndex)
	else
		menuOpen = false
		bar.Position = UDim2.new(-1, -100, 0.88, -25)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			Cam.CameraSubject = LocalPlayer.Character.Humanoid
		end
		currentIndex = 1
	end
end)

prev.MouseButton1Click:Connect(function()
	if currentIndex <= 1 then return end
	local idx = findNextValid(currentIndex - 1, -1)
	if idx ~= currentIndex then currentIndex = idx; updateCameraAndTitle(currentIndex) end
end)
nex.MouseButton1Click:Connect(function()
	if currentIndex >= #players then return end
	local idx = findNextValid(currentIndex + 1, 1)
	if idx ~= currentIndex then currentIndex = idx; updateCameraAndTitle(currentIndex) end
end)

title.MouseButton1Click:Connect(function()
	local target = getCurrentTarget(); if not target then return end
	local myChar     = LocalPlayer.Character
	local targetChar = target.Character
	if not myChar or not targetChar then return end
	local myRoot     = myChar:FindFirstChild("HumanoidRootPart")
	local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
	if not myRoot or not targetRoot then return end
	myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -3)
end)

pillBtn3.MouseButton1Click:Connect(function()
	if not extraMenuOpen then
		extraMenuOpen = true
		showBar(bar3)
		menuOpen = false
		applyFlyState()
	else
		extraMenuOpen = false
		bar3.Position = UDim2.new(-1, -100, 0.88, -25)
		vVect = 0
		applyFlyState()
	end
end)

local newMenuOpen = false

pillBtn4.MouseButton1Click:Connect(function()
	if not newMenuOpen then
		newMenuOpen = true
		showBar(bar4)
		menuOpen = false
		extraMenuOpen = false
		vVect = 0
		applyFlyState()
	else
		newMenuOpen = false
		bar4.Position = UDim2.new(-1, -100, 0.88, -25)
	end
end)

local waypointMenuOpen = false

pillBtn5.MouseButton1Click:Connect(function()
	if not waypointMenuOpen then
		waypointMenuOpen = true
		showBar(bar5)
		menuOpen = false
		extraMenuOpen = false
		newMenuOpen = false
		vVect = 0
		applyFlyState()
	else
		waypointMenuOpen = false
		bar5.Position = UDim2.new(-1, -100, 0.88, -25)
		closeWaypointPopup()
	end
end)

pillBtn6.MouseButton1Click:Connect(function()
	setInfiniteZoom(not infiniteZoomEnabled)
end)

pillBtn7.MouseButton1Click:Connect(function()
	setInstantInteraction(not instantInteractEnabled)
end)

pillBtn8.MouseButton1Click:Connect(function()
	setInfiniteJump(not infiniteJumpEnabled)
end)

track(UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if not extraMenuOpen then return end
	if input.KeyCode == Enum.KeyCode.Space then vVect = 1 end
end))
track(UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Space then vVect = 0 end
end))
track(UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if not extraMenuOpen then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then vVect = -1 end
end))
track(UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then vVect = 0 end
end))

local function cleanup()
	_shutdown = true

	for _, conn in ipairs(connections) do
		pcall(function() conn:Disconnect() end)
	end
	connections = {}

	pcall(function() RunService:UnbindFromRenderStep("SmoothTrans") end)

	if IsItOn then
		pcall(function()
			UserGameSettings.RotationType = Enum.RotationType.MovementRelative
		end)
		IsItOn = false
	end

	if speedEnabled then
		pcall(function()
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.WalkSpeed = genv.SpectatePillGui_DefaultSpeed
					or defaultSpeed
					or 16
			end
		end)
		speedEnabled = false
	end

	pcall(function()
		LocalPlayer.CameraMode = Enum.CameraMode.Classic
		LocalPlayer.CameraMaxZoomDistance = 128
		LocalPlayer.CameraMinZoomDistance = 0.5
	end)

	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		pcall(function()
			hum.PlatformStand = false
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
	end

	pcall(function() pillGui:Destroy() end)
end

genv.SpectatePillGui_Cleanup = cleanup
