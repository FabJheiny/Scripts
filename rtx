local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
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
end

local shaders = {
    { label = "Remove Shader",  fn = removeAllEffects },
    { label = "Cold Dusk",      fn = applyColdDusk    },
    { label = "Arctic White",   fn = applyArcticWhite },
    { label = "Golden Noon",    fn = applyGoldenNoon  },
    { label = "Ash Wasteland",  fn = applyAshWasteland},
}

local B    = Color3.fromRGB(0,   0,   0)
local W    = Color3.fromRGB(255, 255, 255)
local D    = Color3.fromRGB(15,  15,  15)
local G    = Color3.fromRGB(50,  50,  50)
local FONT = Enum.Font.Code

local function o(cls, props, par)
    local x = Instance.new(cls)
    for k, v in pairs(props) do x[k] = v end
    if par then x.Parent = par end
    return x
end
local function stroke(par, t, c)
    o("UIStroke", {
        Color = c or W, Thickness = t or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, par)
end
local function mkBtn(txt, parent, sz, pos)
    local b = o("TextButton", {
        Size = sz, Position = pos,
        BackgroundColor3 = B, BorderSizePixel = 0,
        Text = txt, TextColor3 = W, TextSize = 10, Font = FONT,
        AutoButtonColor = false,
    }, parent)
    stroke(b, 1)
    b.MouseEnter:Connect(function()  b.BackgroundColor3 = D end)
    b.MouseLeave:Connect(function()  b.BackgroundColor3 = B end)
    return b
end

local topH   = 24
local btnH   = 22
local btnGap = 4
local pad    = 6
local menuW  = 160
local contentH  = pad + (#shaders * (btnH + btnGap)) - btnGap + pad
local fullHeight = topH + contentH

local gui = o("ScreenGui", {
    Name = "ShadersMenu",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
}, playerGui)

local win = o("Frame", {
    Size = UDim2.new(0, menuW, 0, fullHeight),
    Position = UDim2.new(0.5, -80, 0.5, -100),
    BackgroundColor3 = B, BorderSizePixel = 0,
    Active = true, ClipsDescendants = true,
}, gui)
stroke(win, 1)

local top = o("Frame", {
    Size = UDim2.new(1, 0, 0, topH),
    BackgroundColor3 = B, BorderSizePixel = 0,
    Active = true, ZIndex = 10,
}, win)

o("TextLabel", {
    Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1, Text = "> SHADERS <",
    TextColor3 = W, TextSize = 10, Font = FONT,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 10,
}, top)

o("Frame", {Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-66,0,0), BackgroundColor3=W, BorderSizePixel=0, ZIndex=12}, top)
o("Frame", {Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-33,0,0), BackgroundColor3=W, BorderSizePixel=0, ZIndex=12}, top)

local MinBtn = o("TextButton", {
    Size=UDim2.new(0,32,1,0), Position=UDim2.new(1,-65,0,0),
    BackgroundColor3=B, BorderSizePixel=0,
    Text="-", TextColor3=W, TextSize=18, Font=FONT,
    AutoButtonColor=false, ZIndex=11,
}, top)
local XBtn = o("TextButton", {
    Size=UDim2.new(0,32,1,0), Position=UDim2.new(1,-32,0,0),
    BackgroundColor3=B, BorderSizePixel=0,
    Text="x", TextColor3=W, TextSize=14, Font=FONT,
    AutoButtonColor=false, ZIndex=11,
}, top)
for _, b in ipairs({MinBtn, XBtn}) do
    b.MouseEnter:Connect(function() b.BackgroundColor3 = D end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = B end)
end

o("Frame", {
    Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0,topH),
    BackgroundColor3=W, BorderSizePixel=0, ZIndex=20,
}, win)

do
    local dragging, dragStart, startPos = false, nil, nil
    top.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = inp.Position
            startPos  = win.Position
        end
    end)
    top.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            win.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

local body = o("Frame", {
    Size = UDim2.new(1, 0, 1, -topH - 1),
    Position = UDim2.new(0, 0, 0, topH + 1),
    BackgroundColor3 = B, BorderSizePixel = 0,
    ClipsDescendants = true,
}, win)

for i, shader in ipairs(shaders) do
    local yPos = pad + (i - 1) * (btnH + btnGap)
    mkBtn(shader.label, body,
        UDim2.new(0, menuW - 16, 0, btnH),
        UDim2.new(0, 8, 0, yPos)
    ).MouseButton1Click:Connect(shader.fn)
end

local pillGui = o("ScreenGui", {
    Name = "ShadersPill",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 9999,
})
local ok = pcall(function() pillGui.Parent = CoreGui end)
if not ok then pillGui.Parent = playerGui end

local pill = o("Frame", {
    Size = UDim2.new(0, 60, 0, 18),
    Position = UDim2.new(1, -66, 1, -146),
    BackgroundColor3 = B, BorderSizePixel = 0,
    Visible = false, ZIndex = 200,
}, pillGui)
stroke(pill, 1)

local pillBtn = o("TextButton", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "> shaders", TextSize = 9, Font = FONT,
    TextColor3 = W, BorderSizePixel = 0,
    ZIndex = 201,
}, pill)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        win.Size    = UDim2.new(0, menuW, 0, topH)
        MinBtn.Text = "+"
    else
        win.Size    = UDim2.new(0, menuW, 0, fullHeight)
        MinBtn.Text = "-"
    end
end)

XBtn.MouseButton1Click:Connect(function()
    win.Visible  = false
    pill.Visible = true
end)

pillBtn.MouseButton1Click:Connect(function()
    win.Visible  = true
    pill.Visible = false
end)
