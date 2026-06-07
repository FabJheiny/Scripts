local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local activeHeartbeat = nil

local function clearHeartbeat()
    if activeHeartbeat then
        activeHeartbeat:Disconnect()
        activeHeartbeat = nil
    end
end

local function getOrCreate(parent, className, name)
    local obj = parent:FindFirstChildOfClass(className)
    if not obj then
        obj = Instance.new(className)
        obj.Name = name or className
        obj.Parent = parent
    end
    return obj
end

local function removeAllEffects()
    clearHeartbeat()
    local EFFECTS = {
        "ColorCorrectionEffect", "BloomEffect",
        "BlurEffect", "DepthOfFieldEffect", "SunRaysEffect",
    }
    for _, className in ipairs(EFFECTS) do
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA(className) then obj:Destroy() end
        end
    end
    Lighting.Ambient              = Color3.fromRGB(127, 127, 127)
    Lighting.OutdoorAmbient       = Color3.fromRGB(127, 127, 127)
    Lighting.Brightness           = 1.0
    Lighting.ColorShift_Bottom    = Color3.fromRGB(0, 0, 0)
    Lighting.ColorShift_Top       = Color3.fromRGB(0, 0, 0)
    Lighting.ClockTime            = 14
    Lighting.FogColor             = Color3.fromRGB(192, 192, 192)
    Lighting.FogEnd               = 100000
    Lighting.FogStart             = 0
    Lighting.GeographicLatitude   = 41.7
    Lighting.ExposureCompensation = 0
    Lighting.ShadowSoftness       = 0.5
    print("[Shader Reset] ✓ Lighting restaurado ao padrão Roblox")
end

local function applyColdDusk()
    removeAllEffects()
    local CFG = {
        Ambient=Color3.fromRGB(52,62,80), OutdoorAmbient=Color3.fromRGB(68,82,105),
        Brightness=1.6, ColorShift_Bottom=Color3.fromRGB(20,30,55),
        ColorShift_Top=Color3.fromRGB(175,195,220), ClockTime=17.2,
        FogColor=Color3.fromRGB(90,110,140), FogEnd=1200, FogStart=400,
        GeographicLatitude=32, ExposureCompensation=0.08,
        CC={Brightness=-0.04,Contrast=0.18,Saturation=-0.22,TintColor=Color3.fromRGB(195,215,240)},
        Bloom={Intensity=0.30,Size=22,Threshold=0.92},
        Blur={Size=6},
        DOF={FarIntensity=0.28,FocusDistance=60,InFocusRadius=25,NearIntensity=0.10},
        SunRays={Intensity=0.04,Spread=0.55},
    }
    Lighting.Ambient=CFG.Ambient; Lighting.OutdoorAmbient=CFG.OutdoorAmbient
    Lighting.Brightness=CFG.Brightness; Lighting.ColorShift_Bottom=CFG.ColorShift_Bottom
    Lighting.ColorShift_Top=CFG.ColorShift_Top; Lighting.ClockTime=CFG.ClockTime
    Lighting.FogColor=CFG.FogColor; Lighting.FogEnd=CFG.FogEnd; Lighting.FogStart=CFG.FogStart
    Lighting.GeographicLatitude=CFG.GeographicLatitude; Lighting.ExposureCompensation=CFG.ExposureCompensation
    Lighting.ShadowSoftness=0.25
    local cc=getOrCreate(Lighting,"ColorCorrectionEffect","ColdDusk_CC")
    cc.Brightness=CFG.CC.Brightness; cc.Contrast=CFG.CC.Contrast
    cc.Saturation=CFG.CC.Saturation; cc.TintColor=CFG.CC.TintColor; cc.Enabled=true
    local bloom=getOrCreate(Lighting,"BloomEffect","ColdDusk_Bloom")
    bloom.Intensity=CFG.Bloom.Intensity; bloom.Size=CFG.Bloom.Size; bloom.Threshold=CFG.Bloom.Threshold; bloom.Enabled=true
    local blur=getOrCreate(Lighting,"BlurEffect","ColdDusk_Blur")
    blur.Size=CFG.Blur.Size; blur.Enabled=true
    local dof=getOrCreate(Lighting,"DepthOfFieldEffect","ColdDusk_DOF")
    dof.FarIntensity=CFG.DOF.FarIntensity; dof.FocusDistance=CFG.DOF.FocusDistance
    dof.InFocusRadius=CFG.DOF.InFocusRadius; dof.NearIntensity=CFG.DOF.NearIntensity; dof.Enabled=true
    local rays=getOrCreate(Lighting,"SunRaysEffect","ColdDusk_SunRays")
    rays.Intensity=CFG.SunRays.Intensity; rays.Spread=CFG.SunRays.Spread; rays.Enabled=true
    local t=0
    activeHeartbeat = RunService.Heartbeat:Connect(function(dt)
        t=t+dt*0.35
        cc.Saturation=CFG.CC.Saturation+math.sin(t)*0.04
        cc.Contrast=CFG.CC.Contrast+math.sin(t*0.7)*0.02
        cc.TintColor=Color3.fromRGB(195+math.floor(math.sin(t*0.5)*6),215+math.floor(math.sin(t*0.4)*4),240)
    end)
    print("[ColdDusk Shader] ✓ Ativo")
end

local function applyArcticWhite()
    removeAllEffects()
    local CFG = {
        Ambient=Color3.fromRGB(165,185,218), OutdoorAmbient=Color3.fromRGB(188,208,238),
        Brightness=1.8, ColorShift_Bottom=Color3.fromRGB(128,158,210),
        ColorShift_Top=Color3.fromRGB(218,232,255), ClockTime=11,
        FogColor=Color3.fromRGB(212,222,245), FogEnd=900, FogStart=220,
        GeographicLatitude=68, ExposureCompensation=0.18,
        CC={Brightness=0.08,Contrast=0.12,Saturation=-0.48,TintColor=Color3.fromRGB(205,220,255)},
        Bloom={Intensity=0.42,Size=26,Threshold=0.84},
        Blur={Size=2},
        DOF={FarIntensity=0.20,FocusDistance=60,InFocusRadius=25,NearIntensity=0.05},
        SunRays={Intensity=0.05,Spread=0.88},
    }
    Lighting.Ambient=CFG.Ambient; Lighting.OutdoorAmbient=CFG.OutdoorAmbient
    Lighting.Brightness=CFG.Brightness; Lighting.ColorShift_Bottom=CFG.ColorShift_Bottom
    Lighting.ColorShift_Top=CFG.ColorShift_Top; Lighting.ClockTime=CFG.ClockTime
    Lighting.FogColor=CFG.FogColor; Lighting.FogEnd=CFG.FogEnd; Lighting.FogStart=CFG.FogStart
    Lighting.GeographicLatitude=CFG.GeographicLatitude; Lighting.ExposureCompensation=CFG.ExposureCompensation
    Lighting.ShadowSoftness=0.40
    local cc=getOrCreate(Lighting,"ColorCorrectionEffect","ArcticWhite_CC")
    cc.Brightness=CFG.CC.Brightness; cc.Contrast=CFG.CC.Contrast
    cc.Saturation=CFG.CC.Saturation; cc.TintColor=CFG.CC.TintColor; cc.Enabled=true
    local bloom=getOrCreate(Lighting,"BloomEffect","ArcticWhite_Bloom")
    bloom.Intensity=CFG.Bloom.Intensity; bloom.Size=CFG.Bloom.Size; bloom.Threshold=CFG.Bloom.Threshold; bloom.Enabled=true
    local blur=getOrCreate(Lighting,"BlurEffect","ArcticWhite_Blur")
    blur.Size=CFG.Blur.Size; blur.Enabled=true
    local dof=getOrCreate(Lighting,"DepthOfFieldEffect","ArcticWhite_DOF")
    dof.FarIntensity=CFG.DOF.FarIntensity; dof.FocusDistance=CFG.DOF.FocusDistance
    dof.InFocusRadius=CFG.DOF.InFocusRadius; dof.NearIntensity=CFG.DOF.NearIntensity; dof.Enabled=true
    local rays=getOrCreate(Lighting,"SunRaysEffect","ArcticWhite_SunRays")
    rays.Intensity=CFG.SunRays.Intensity; rays.Spread=CFG.SunRays.Spread; rays.Enabled=true
    local t=0
    activeHeartbeat = RunService.Heartbeat:Connect(function(dt)
        t=t+dt*0.12
        cc.Brightness=CFG.CC.Brightness+math.sin(t)*0.04
        cc.Saturation=CFG.CC.Saturation+math.sin(t*0.8)*0.03
        cc.TintColor=Color3.fromRGB(
            205+math.floor(math.sin(t*0.3)*4),
            220+math.floor(math.sin(t*0.4)*3),
            255
        )
    end)
    print("[ArcticWhite Shader] ✓ Ativo")
end

local function applyGoldenNoon()
    removeAllEffects()
    local CFG = {
        Ambient=Color3.fromRGB(115,105,85), OutdoorAmbient=Color3.fromRGB(155,145,118),
        Brightness=2.0, ColorShift_Bottom=Color3.fromRGB(75,55,20),
        ColorShift_Top=Color3.fromRGB(255,238,195), ClockTime=12.5,
        FogColor=Color3.fromRGB(252,245,225), FogEnd=5000, FogStart=2500,
        GeographicLatitude=22, ExposureCompensation=0.10,
        CC={Brightness=0.02,Contrast=0.16,Saturation=0.08,TintColor=Color3.fromRGB(255,242,210)},
        Bloom={Intensity=0.30,Size=22,Threshold=0.88},
        DOF={FarIntensity=0.08,FocusDistance=90,InFocusRadius=50,NearIntensity=0.03},
        SunRays={Intensity=0.10,Spread=0.72},
    }
    Lighting.Ambient=CFG.Ambient; Lighting.OutdoorAmbient=CFG.OutdoorAmbient
    Lighting.Brightness=CFG.Brightness; Lighting.ColorShift_Bottom=CFG.ColorShift_Bottom
    Lighting.ColorShift_Top=CFG.ColorShift_Top; Lighting.ClockTime=CFG.ClockTime
    Lighting.FogColor=CFG.FogColor; Lighting.FogEnd=CFG.FogEnd; Lighting.FogStart=CFG.FogStart
    Lighting.GeographicLatitude=CFG.GeographicLatitude; Lighting.ExposureCompensation=CFG.ExposureCompensation
    Lighting.ShadowSoftness=0.20
    local cc=getOrCreate(Lighting,"ColorCorrectionEffect","GoldenNoon_CC")
    cc.Brightness=CFG.CC.Brightness; cc.Contrast=CFG.CC.Contrast
    cc.Saturation=CFG.CC.Saturation; cc.TintColor=CFG.CC.TintColor; cc.Enabled=true
    local bloom=getOrCreate(Lighting,"BloomEffect","GoldenNoon_Bloom")
    bloom.Intensity=CFG.Bloom.Intensity; bloom.Size=CFG.Bloom.Size; bloom.Threshold=CFG.Bloom.Threshold; bloom.Enabled=true
    local dof=getOrCreate(Lighting,"DepthOfFieldEffect","GoldenNoon_DOF")
    dof.FarIntensity=CFG.DOF.FarIntensity; dof.FocusDistance=CFG.DOF.FocusDistance
    dof.InFocusRadius=CFG.DOF.InFocusRadius; dof.NearIntensity=CFG.DOF.NearIntensity; dof.Enabled=true
    local rays=getOrCreate(Lighting,"SunRaysEffect","GoldenNoon_SunRays")
    rays.Intensity=CFG.SunRays.Intensity; rays.Spread=CFG.SunRays.Spread; rays.Enabled=true
    local t=0
    activeHeartbeat = RunService.Heartbeat:Connect(function(dt)
        t=t+dt*0.25
        cc.Brightness=CFG.CC.Brightness+math.sin(t)*0.015
        cc.TintColor=Color3.fromRGB(
            255,
            242+math.floor(math.sin(t*0.5)*3),
            210+math.floor(math.sin(t*0.35)*5)
        )
    end)
    print("[GoldenNoon Shader] ✓ Ativo")
end

local function applyAshWasteland()
    removeAllEffects()
    local CFG = {
        Ambient=Color3.fromRGB(75,68,55), OutdoorAmbient=Color3.fromRGB(95,86,70),
        Brightness=1.15, ColorShift_Bottom=Color3.fromRGB(45,38,28),
        ColorShift_Top=Color3.fromRGB(170,155,122), ClockTime=13,
        FogColor=Color3.fromRGB(148,136,113), FogEnd=850, FogStart=120,
        GeographicLatitude=20, ExposureCompensation=-0.12,
        CC={Brightness=-0.06,Contrast=0.28,Saturation=-0.65,TintColor=Color3.fromRGB(215,198,170)},
        Bloom={Intensity=0.12,Size=14,Threshold=0.96},
        Blur={Size=4},
        DOF={FarIntensity=0.45,FocusDistance=45,InFocusRadius=12,NearIntensity=0.08},
        SunRays={Intensity=0.02,Spread=0.25},
    }
    Lighting.Ambient=CFG.Ambient; Lighting.OutdoorAmbient=CFG.OutdoorAmbient
    Lighting.Brightness=CFG.Brightness; Lighting.ColorShift_Bottom=CFG.ColorShift_Bottom
    Lighting.ColorShift_Top=CFG.ColorShift_Top; Lighting.ClockTime=CFG.ClockTime
    Lighting.FogColor=CFG.FogColor; Lighting.FogEnd=CFG.FogEnd; Lighting.FogStart=CFG.FogStart
    Lighting.GeographicLatitude=CFG.GeographicLatitude; Lighting.ExposureCompensation=CFG.ExposureCompensation
    Lighting.ShadowSoftness=0.10
    local cc=getOrCreate(Lighting,"ColorCorrectionEffect","AshWasteland_CC")
    cc.Brightness=CFG.CC.Brightness; cc.Contrast=CFG.CC.Contrast
    cc.Saturation=CFG.CC.Saturation; cc.TintColor=CFG.CC.TintColor; cc.Enabled=true
    local bloom=getOrCreate(Lighting,"BloomEffect","AshWasteland_Bloom")
    bloom.Intensity=CFG.Bloom.Intensity; bloom.Size=CFG.Bloom.Size; bloom.Threshold=CFG.Bloom.Threshold; bloom.Enabled=true
    local blur=getOrCreate(Lighting,"BlurEffect","AshWasteland_Blur")
    blur.Size=CFG.Blur.Size; blur.Enabled=true
    local dof=getOrCreate(Lighting,"DepthOfFieldEffect","AshWasteland_DOF")
    dof.FarIntensity=CFG.DOF.FarIntensity; dof.FocusDistance=CFG.DOF.FocusDistance
    dof.InFocusRadius=CFG.DOF.InFocusRadius; dof.NearIntensity=CFG.DOF.NearIntensity; dof.Enabled=true
    local rays=getOrCreate(Lighting,"SunRaysEffect","AshWasteland_SunRays")
    rays.Intensity=CFG.SunRays.Intensity; rays.Spread=CFG.SunRays.Spread; rays.Enabled=true
    local t=0
    activeHeartbeat = RunService.Heartbeat:Connect(function(dt)
        t=t+dt*0.18
        cc.Saturation=CFG.CC.Saturation+math.sin(t)*0.04
        cc.Contrast=CFG.CC.Contrast+math.sin(t*0.55)*0.03
        cc.Brightness=CFG.CC.Brightness+math.sin(t*0.35)*0.02
    end)
    print("[AshWasteland Shader] ✓ Ativo")
end

local shaders = {
    { label = "Remove Shader",  fn = removeAllEffects },
    { label = "Cold Dusk",      fn = applyColdDusk    },
    { label = "Arctic White",   fn = applyArcticWhite },
    { label = "Golden Noon",    fn = applyGoldenNoon  },
    { label = "Ash Wasteland",  fn = applyAshWasteland},
}

local TOPBAR_H   = 24
local BTN_H      = 22
local BTN_GAP    = 4
local PADDING    = 6
local MENU_W     = 160
local contentH   = PADDING + (#shaders * (BTN_H + BTN_GAP)) + PADDING - BTN_GAP
local fullHeight = TOPBAR_H + contentH
local miniHeight = TOPBAR_H

local gui = Instance.new("ScreenGui")
gui.Name          = "ShadersMenu"
gui.ResetOnSpawn  = false
gui.Parent        = playerGui

local frame = Instance.new("Frame", gui)
frame.Size                 = UDim2.new(0, MENU_W, 0, fullHeight)
frame.Position             = UDim2.new(0.5, -80, 0.5, -100)
frame.BackgroundColor3     = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0
frame.BorderSizePixel      = 0
frame.Active               = true
frame.Draggable            = true
frame.ClipsDescendants     = true

local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color           = Color3.fromRGB(255, 255, 255)
frameStroke.Thickness       = 1
frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local topBar = Instance.new("Frame", frame)
topBar.Size             = UDim2.new(1, 0, 0, TOPBAR_H)
topBar.Position         = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
topBar.BackgroundTransparency = 0
topBar.BorderSizePixel  = 0

local topSep = Instance.new("Frame", topBar)
topSep.Size             = UDim2.new(1, 0, 0, 1)
topSep.Position         = UDim2.new(0, 0, 1, -1)
topSep.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
topSep.BackgroundTransparency = 0
topSep.BorderSizePixel  = 0

local titulo = Instance.new("TextLabel", topBar)
titulo.Size             = UDim2.new(1, -50, 1, 0)
titulo.Position         = UDim2.new(0, 10, 0, 0)
titulo.BackgroundTransparency = 1
titulo.TextColor3       = Color3.fromRGB(255, 255, 255)
titulo.TextSize         = 10
titulo.TextXAlignment   = Enum.TextXAlignment.Left
titulo.Text             = "Shaders"
titulo.Font             = Enum.Font.SourceSansBold

local recolherBtn = Instance.new("TextButton", topBar)
recolherBtn.Size             = UDim2.new(0, 18, 0, 14)
recolherBtn.Position         = UDim2.new(1, -42, 0.5, -7)
recolherBtn.Text             = "-"
recolherBtn.TextSize         = 12
recolherBtn.Font             = Enum.Font.SourceSansBold
recolherBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
recolherBtn.BackgroundTransparency = 0
recolherBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
recolherBtn.BorderSizePixel  = 0
recolherBtn.AutoButtonColor  = false

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size             = UDim2.new(0, 18, 0, 14)
closeBtn.Position         = UDim2.new(1, -20, 0.5, -7)
closeBtn.Text             = "x"
closeBtn.TextSize         = 10
closeBtn.Font             = Enum.Font.SourceSansBold
closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.BackgroundTransparency = 0
closeBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel  = 0
closeBtn.AutoButtonColor  = false

for i, shader in ipairs(shaders) do
    local yPos = TOPBAR_H + PADDING + (i - 1) * (BTN_H + BTN_GAP)
    local btn = Instance.new("TextButton", frame)
    btn.Size             = UDim2.new(0, MENU_W - 16, 0, BTN_H)
    btn.Position         = UDim2.new(0, 8, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel  = 0
    btn.Text             = shader.label
    btn.TextSize         = 10
    btn.Font             = Enum.Font.SourceSansBold
    btn.TextColor3       = Color3.fromRGB(220, 220, 220)
    btn.AutoButtonColor  = false
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color           = Color3.fromRGB(60, 60, 60)
    btnStroke.Thickness       = 1
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 3)
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35,35,35) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(18,18,18) end)
    btn.MouseButton1Down:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(50,50,50) end)
    btn.MouseButton1Up:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35,35,35) end)
    btn.MouseButton1Click:Connect(shader.fn)
end

local recolhido = false
recolherBtn.MouseButton1Click:Connect(function()
    recolhido = not recolhido
    if recolhido then
        frame.Size = UDim2.new(0, MENU_W, 0, miniHeight)
        recolherBtn.Text = "+"
    else
        frame.Size = UDim2.new(0, MENU_W, 0, fullHeight)
        recolherBtn.Text = "-"
    end
end)

local CoreGui = game:GetService("CoreGui")
local pillGui = Instance.new("ScreenGui")
pillGui.Name         = "ShadersPill"
pillGui.ResetOnSpawn = false
pillGui.DisplayOrder = 9999
local ok = pcall(function() pillGui.Parent = CoreGui end)
if not ok then pillGui.Parent = playerGui end

local pill = Instance.new("Frame", pillGui)
pill.Name             = "ShadersPill"
pill.Size             = UDim2.new(0, 50, 0, 18)
pill.Position         = UDim2.new(1, -56, 1, -146)
pill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
pill.BorderSizePixel  = 0
pill.Visible          = false

local pillStroke = Instance.new("UIStroke", pill)
pillStroke.Color           = Color3.fromRGB(255, 255, 255)
pillStroke.Thickness       = 1
pillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local pillBtn = Instance.new("TextButton", pill)
pillBtn.Size             = UDim2.new(1, 0, 1, 0)
pillBtn.Text             = "> shaders"
pillBtn.TextSize         = 9
pillBtn.Font             = Enum.Font.SourceSansBold
pillBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
pillBtn.BackgroundTransparency = 1
pillBtn.BorderSizePixel  = 0
pillBtn.AutoButtonColor  = false

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    pill.Visible  = true
end)

pillBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    pill.Visible  = false
end)
