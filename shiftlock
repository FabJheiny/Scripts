local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserGameSettings   = UserSettings():GetService("UserGameSettings")
local CoreGui            = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Cam         = workspace.CurrentCamera

local function getHui()
	local fn = rawget(getfenv(), "gethui")
	if type(fn) == "function" then
		local ok, res = pcall(fn)
		if ok and res then return res end
	end
end

local parentTarget = getHui() or CoreGui

local IsItOn = false

local UI = {
	MainGui = Instance.new("ScreenGui"),
	MouseLock = Instance.new("Frame"),
	Container = Instance.new("Frame"),
	Background = Instance.new("Frame"),
	UICorner = Instance.new("UICorner"),
	Icon = Instance.new("Frame"),
	ImageLabel = Instance.new("ImageLabel"),
	UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint"),
	Button = Instance.new("TextButton")
}

UI.MainGui.Name = "MouseLockGui"
UI.MainGui.IgnoreGuiInset = true
UI.MainGui.ResetOnSpawn = false
if not pcall(function() UI.MainGui.Parent = parentTarget end) then
	UI.MainGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

UI.MouseLock.Size = UDim2.new(0, 44, 0, 44)
UI.MouseLock.BackgroundTransparency = 1
UI.MouseLock.BorderSizePixel = 0
UI.MouseLock.Position = UDim2.new(0, 15, 0, 155)
UI.MouseLock.Parent = UI.MainGui

UI.Container.Size = UDim2.new(1, 0, 1, 0)
UI.Container.BackgroundTransparency = 1
UI.Container.BorderSizePixel = 0
UI.Container.Parent = UI.MouseLock

UI.Background.Size = UDim2.new(1, 0, 1, 0)
UI.Background.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
UI.Background.BackgroundTransparency = 0.08
UI.Background.BorderSizePixel = 0
UI.Background.Parent = UI.Container

UI.UICorner.CornerRadius = UDim.new(1, 0)
UI.UICorner.Parent = UI.Background

UI.Icon.Size = UDim2.new(1, 0, 1, 0)
UI.Icon.BackgroundTransparency = 1
UI.Icon.ZIndex = 5
UI.Icon.Parent = UI.Container

UI.ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
UI.ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.ImageLabel.Size = UDim2.new(0.7, 0, 0.7, 0)
UI.ImageLabel.BackgroundTransparency = 1
UI.ImageLabel.Image = "rbxassetid://80450981243325"
UI.ImageLabel.Parent = UI.Icon

UI.UIAspectRatioConstraint.Parent = UI.ImageLabel

UI.Button.Size = UDim2.new(1, 0, 1, 0)
UI.Button.BackgroundTransparency = 1
UI.Button.ZIndex = 6
UI.Button.Text = ""
UI.Button.Parent = UI.Container

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

UI.Button.MouseButton1Click:Connect(function()
	IsItOn = not IsItOn
	if IsItOn == true then
		UserGameSettings.RotationType = Enum.RotationType.CameraRelative
	else
		UserGameSettings.RotationType = Enum.RotationType.MovementRelative
	end
end)

local PILL_BG    = Color3.fromRGB(18, 18, 21)
local PILL_LINE  = Color3.fromRGB(55, 55, 62)
local MID        = Color3.fromRGB(220, 225, 230)
local W          = Color3.fromRGB(255, 255, 255)
local BLUE       = Color3.fromRGB(90, 200, 255)
local FONT       = Enum.Font.GothamMedium
local BAR_TRANS  = 0.08

local players      = {}
local currentIndex = 1
local menuOpen     = false

local function new(cls, props, parent)
	local inst = Instance.new(cls)
	for k, v in pairs(props) do inst[k] = v end
	if parent then inst.Parent = parent end
	return inst
end

local function addStroke(parent, thickness, color)
	new("UIStroke", {
		Color = color or PILL_LINE,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, parent)
end

local sg = new("ScreenGui", {
	Name = "SpectateGui",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 0,
})
if not pcall(function() sg.Parent = parentTarget end) then
	sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local bar = new("Frame", {
	Name = "Bar",
	Position = UDim2.new(-1, -100, 0.88, -25),
	Size = UDim2.new(0, 220, 0, 50),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = BAR_TRANS,
	BorderSizePixel = 0,
}, sg)
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
	TextSize = 16,
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
	TextSize = 16,
	AutoButtonColor = false,
}, bar)
nex.MouseEnter:Connect(function() nex.TextColor3 = BLUE end)
nex.MouseLeave:Connect(function() nex.TextColor3 = MID end)

local title = new("TextButton", {
	Name = "Title",
	Position = UDim2.new(0.22, 0, 0, 0),
	Size = UDim2.new(0.56, 0, 1, 0),
	Text = "",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Font = FONT,
	TextColor3 = W,
	TextSize = 14,
	TextScaled = true,
	AutoButtonColor = false,
}, bar)
title.MouseEnter:Connect(function() title.TextColor3 = BLUE end)
title.MouseLeave:Connect(function() title.TextColor3 = W end)

local pillGui = new("ScreenGui", {
	Name = "SpectatePillGui",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 0,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
if not pcall(function() pillGui.Parent = parentTarget end) then
	pillGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local pill = new("Frame", {
	Name = "PillSpectate",
	Position = UDim2.new(0, 15, 0, 105),
	Size = UDim2.new(0, 44, 0, 44),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 1,
}, pillGui)

local container = new("Frame", {
	Name = "Container",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 1,
}, pill)

local pillBg = new("Frame", {
	Name = "Background",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundColor3 = PILL_BG,
	BackgroundTransparency = 0.08,
	BorderSizePixel = 0,
	ZIndex = 1,
}, container)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, pillBg)

local icon = new("Frame", {
	Name = "Icon",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 5,
}, container)

local iconImage = new("ImageLabel", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0.7, 0, 0.7, 0),
	BackgroundTransparency = 1,
	Image = "rbxassetid://95367294955296",
	ImageColor3 = Color3.fromRGB(255, 255, 255),
	ImageTransparency = 0,
	ZIndex = 5,
}, icon)
new("UIAspectRatioConstraint", {}, iconImage)

local pillBtn = new("TextButton", {
	Name = "Button",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Text = "",
	ZIndex = 6,
}, container)

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

	if #players == 0 then
		currentIndex = 1
		return
	end

	if previous then
		for i, p in ipairs(players) do
			if p == previous then
				currentIndex = i
				return
			end
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

Players.PlayerAdded:Connect(function()
	task.wait(0.1)
	refreshPlayers()
	if menuOpen then updateCameraAndTitle(currentIndex) end
end)

Players.PlayerRemoving:Connect(function()
	task.wait(0.1)
	refreshPlayers()
	if menuOpen then updateCameraAndTitle(currentIndex) end
end)

task.spawn(function()
	while true do
		task.wait(10)
		refreshPlayers()
		if menuOpen then updateCameraAndTitle(currentIndex) end
	end
end)

pillBtn.MouseButton1Click:Connect(function()
	if not menuOpen then
		menuOpen = true
		refreshPlayers()
		currentIndex = 1
		bar.Position = UDim2.new(0.5, -110, 0.88, -25)
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
	if idx ~= currentIndex then
		currentIndex = idx
		updateCameraAndTitle(currentIndex)
	end
end)

nex.MouseButton1Click:Connect(function()
	if currentIndex >= #players then return end
	local idx = findNextValid(currentIndex + 1, 1)
	if idx ~= currentIndex then
		currentIndex = idx
		updateCameraAndTitle(currentIndex)
	end
end)

title.MouseButton1Click:Connect(function()
	local target = getCurrentTarget()
	if not target then return end

	local myChar     = LocalPlayer.Character
	local targetChar = target.Character
	if not myChar or not targetChar then return end

	local myRoot     = myChar:FindFirstChild("HumanoidRootPart")
	local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
	if not myRoot or not targetRoot then return end

	myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -3)
end)
