-- LocalScript: Place in StarterPlayerScripts or StarterGui

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer    = Players.LocalPlayer
local PlayerGui      = LocalPlayer:WaitForChild("PlayerGui")

local DEFAULT_WALKSPEED = 16
local FAST_WALKSPEED    = 55

local walkSpeedEnabled     = false
local killAuraEnabled      = false
local killAuraRange        = 20
local killAuraConnection   = nil
local fuelCollectorEnabled = false
local batteryCollectorEnabled = false
local scrapCollectorEnabled   = false
local instantPromptsEnabled   = false
local godModeEnabled          = false
local savedPromptData         = {}
local godModeConnection       = nil
local godHumConnection        = nil

local FUEL_KEYWORDS      = {"fuel","gascan","gas can","jerrican","jerrycan","fuelcan","petrol","gasoline","canister"}
local GENERATOR_KEYWORDS = {"generator","gen"}
local BATTERY_KEYWORDS   = {"battery","batteries","batt","powercell","power cell","energycell","energy cell","batterypack"}
local SCRAP_KEYWORDS     = {"scrap","metal","nail","nails","iron","steel","bolt","bolts","junk","debris","scrapwood","scrapmetal","wood","plank"}
local WORKBENCH_KEYWORDS = {"workbench","work bench","crafttable","craft table","craftingbench","crafting","machine","fabricator","workshop","bench","upgradestation","upgrade station","repairstation","crafting station"}

-- ============================================================
-- SCREEN GUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "KaloMenu"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset  = true
ScreenGui.Parent          = PlayerGui

-- Floating K restore button
local KButton = Instance.new("TextButton")
KButton.Size             = UDim2.new(0,44,0,44)
KButton.Position         = UDim2.new(0,10,0,10)
KButton.BackgroundColor3 = Color3.fromRGB(100,80,255)
KButton.BorderSizePixel  = 0
KButton.Text             = "K"
KButton.TextColor3       = Color3.fromRGB(255,255,255)
KButton.TextSize         = 20
KButton.Font             = Enum.Font.GothamBlack
KButton.Visible          = false
KButton.ZIndex           = 10
KButton.Parent           = ScreenGui
Instance.new("UICorner",KButton).CornerRadius = UDim.new(0,10)
local ks = Instance.new("UIStroke",KButton)
ks.Color = Color3.fromRGB(160,140,255); ks.Thickness = 2

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name            = "MainFrame"
MainFrame.Size            = UDim2.new(0,240,0,430)
MainFrame.Position        = UDim2.new(0,10,0,10)
MainFrame.BackgroundColor3= Color3.fromRGB(18,18,24)
MainFrame.BorderSizePixel = 0
MainFrame.Active          = true
MainFrame.Draggable       = true
MainFrame.Parent          = ScreenGui
Instance.new("UICorner",MainFrame).CornerRadius = UDim.new(0,12)
local ms = Instance.new("UIStroke",MainFrame)
ms.Color = Color3.fromRGB(100,80,255); ms.Thickness = 2

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size             = UDim2.new(1,0,0,44)
TitleBar.BackgroundColor3 = Color3.fromRGB(30,20,60)
TitleBar.BorderSizePixel  = 0
TitleBar.Parent           = MainFrame
Instance.new("UICorner",TitleBar).CornerRadius = UDim.new(0,12)
local tbp = Instance.new("Frame",TitleBar)
tbp.Size=UDim2.new(1,0,0,12); tbp.Position=UDim2.new(0,0,1,-12)
tbp.BackgroundColor3=Color3.fromRGB(30,20,60); tbp.BorderSizePixel=0

local HeaderLabel = Instance.new("TextLabel",TitleBar)
HeaderLabel.Size              = UDim2.new(1,-88,1,0)
HeaderLabel.Position          = UDim2.new(0,44,0,0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text              = "Kalo"
HeaderLabel.TextColor3        = Color3.fromRGB(255,255,255)
HeaderLabel.TextSize          = 22
HeaderLabel.Font              = Enum.Font.GothamBlack
HeaderLabel.TextXAlignment    = Enum.TextXAlignment.Center

-- Minimize button
local MinBtn = Instance.new("TextButton",TitleBar)
MinBtn.Size=UDim2.new(0,36,0,36); MinBtn.Position=UDim2.new(1,-80,0,4)
MinBtn.BackgroundColor3=Color3.fromRGB(50,40,100); MinBtn.BorderSizePixel=0
MinBtn.Text="-"; MinBtn.TextColor3=Color3.fromRGB(200,200,255)
MinBtn.TextSize=20; MinBtn.Font=Enum.Font.GothamBold
Instance.new("UICorner",MinBtn).CornerRadius=UDim.new(0,8)

-- Close button
local CloseBtn = Instance.new("TextButton",TitleBar)
CloseBtn.Size=UDim2.new(0,36,0,36); CloseBtn.Position=UDim2.new(1,-40,0,4)
CloseBtn.BackgroundColor3=Color3.fromRGB(160,40,60); CloseBtn.BorderSizePixel=0
CloseBtn.Text="X"; CloseBtn.TextColor3=Color3.fromRGB(255,255,255)
CloseBtn.TextSize=16; CloseBtn.Font=Enum.Font.GothamBold
Instance.new("UICorner",CloseBtn).CornerRadius=UDim.new(0,8)

-- Tab bar
local TabBar = Instance.new("Frame",MainFrame)
TabBar.Size=UDim2.new(1,-16,0,34); TabBar.Position=UDim2.new(0,8,0,48)
TabBar.BackgroundColor3=Color3.fromRGB(24,24,34); TabBar.BorderSizePixel=0
Instance.new("UICorner",TabBar).CornerRadius=UDim.new(0,8)
local tbl=Instance.new("UIListLayout",TabBar)
tbl.FillDirection=Enum.FillDirection.Horizontal; tbl.Padding=UDim.new(0,4)
local tbpad=Instance.new("UIPadding",TabBar)
tbpad.PaddingLeft=UDim.new(0,4); tbpad.PaddingTop=UDim.new(0,4); tbpad.PaddingBottom=UDim.new(0,4)

local function makeTab(label, order)
    local btn=Instance.new("TextButton",TabBar)
    btn.Size=UDim2.new(0.5,-4,1,0); btn.BackgroundColor3=Color3.fromRGB(40,30,80)
    btn.BorderSizePixel=0; btn.Text=label
    btn.TextColor3=Color3.fromRGB(180,170,255); btn.TextSize=13
    btn.Font=Enum.Font.GothamSemibold; btn.LayoutOrder=order
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
    return btn
end
local TabMenu      = makeTab("Menu",1)
local TabStructure = makeTab("Structure",2)

-- Menu content area
local MenuContent = Instance.new("Frame",MainFrame)
MenuContent.Size=UDim2.new(1,-16,1,-92); MenuContent.Position=UDim2.new(0,8,0,88)
MenuContent.BackgroundTransparency=1

local ScrollFrame = Instance.new("ScrollingFrame",MenuContent)
ScrollFrame.Size=UDim2.new(1,0,1,0); ScrollFrame.BackgroundTransparency=1
ScrollFrame.BorderSizePixel=0; ScrollFrame.ScrollBarThickness=3
ScrollFrame.ScrollBarImageColor3=Color3.fromRGB(100,80,255)
ScrollFrame.CanvasSize=UDim2.new(0,0,0,0)
ScrollFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y
ScrollFrame.ScrollingDirection=Enum.ScrollingDirection.Y

local ListLayout=Instance.new("UIListLayout",ScrollFrame)
ListLayout.SortOrder=Enum.SortOrder.LayoutOrder; ListLayout.Padding=UDim.new(0,8)
local cpad=Instance.new("UIPadding",ScrollFrame); cpad.PaddingBottom=UDim.new(0,8)

-- Structure content area
local StructureContent = Instance.new("Frame",MainFrame)
StructureContent.Size=UDim2.new(1,-16,1,-92); StructureContent.Position=UDim2.new(0,8,0,88)
StructureContent.BackgroundTransparency=1; StructureContent.Visible=false

-- ============================================================
-- TAB SWITCHING
-- ============================================================
local currentTab = "menu"
local function switchTab(tab)
    currentTab = tab
    local onMenu = tab=="menu"
    MenuContent.Visible      = onMenu
    StructureContent.Visible = not onMenu
    TabMenu.BackgroundColor3      = onMenu and Color3.fromRGB(100,80,255) or Color3.fromRGB(40,30,80)
    TabMenu.TextColor3            = onMenu and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,170,255)
    TabStructure.BackgroundColor3 = onMenu and Color3.fromRGB(40,30,80)   or Color3.fromRGB(100,80,255)
    TabStructure.TextColor3       = onMenu and Color3.fromRGB(180,170,255) or Color3.fromRGB(255,255,255)
end
switchTab("menu")
TabMenu.MouseButton1Click:Connect(function() switchTab("menu") end)
TabStructure.MouseButton1Click:Connect(function() switchTab("structure") end)

-- ============================================================
-- CLOSE / MINIMIZE
-- ============================================================
local function closeGui() MainFrame.Visible=false; KButton.Visible=true end
local function openGui()  MainFrame.Visible=true;  KButton.Visible=false end
CloseBtn.MouseButton1Click:Connect(closeGui)
KButton.MouseButton1Click:Connect(openGui)

local minimized = false
local function toggleMinimize()
    minimized = not minimized
    TabBar.Visible = not minimized
    if minimized then
        MenuContent.Visible=false; StructureContent.Visible=false
    else
        switchTab(currentTab)
    end
    MainFrame.Size = minimized and UDim2.new(0,240,0,44) or UDim2.new(0,240,0,430)
    MinBtn.Text    = minimized and "+" or "-"
end
MinBtn.MouseButton1Click:Connect(toggleMinimize)

-- ============================================================
-- HELPERS
-- ============================================================
local tweenInfo = TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)

local function animateToggle(track, knob, statusLabel, enabled)
    TweenService:Create(knob, tweenInfo, enabled
        and {Position=UDim2.new(1,-25,0.5,-11), BackgroundColor3=Color3.fromRGB(255,255,255)}
        or  {Position=UDim2.new(0,3,0.5,-11),   BackgroundColor3=Color3.fromRGB(180,180,200)}):Play()
    TweenService:Create(track, tweenInfo, enabled
        and {BackgroundColor3=Color3.fromRGB(100,80,255)}
        or  {BackgroundColor3=Color3.fromRGB(60,60,80)}):Play()
    statusLabel.Text      = enabled and "ON" or "OFF"
    statusLabel.TextColor3= enabled and Color3.fromRGB(160,140,255) or Color3.fromRGB(120,120,150)
end

-- createToggleRow: returns Row, Track, Knob, StatusLabel, Button
-- NOTE: MouseButton1Click fires on both PC and mobile — no TouchTap needed
local function createToggleRow(labelText, layoutOrder)
    local Row=Instance.new("Frame",ScrollFrame)
    Row.Size=UDim2.new(1,0,0,52); Row.BackgroundColor3=Color3.fromRGB(28,28,38)
    Row.BorderSizePixel=0; Row.LayoutOrder=layoutOrder
    Instance.new("UICorner",Row).CornerRadius=UDim.new(0,10)

    local Lbl=Instance.new("TextLabel",Row)
    Lbl.Size=UDim2.new(1,-80,1,0); Lbl.Position=UDim2.new(0,12,0,0)
    Lbl.BackgroundTransparency=1; Lbl.Text=labelText
    Lbl.TextColor3=Color3.fromRGB(220,220,240); Lbl.TextSize=15
    Lbl.Font=Enum.Font.GothamSemibold; Lbl.TextXAlignment=Enum.TextXAlignment.Left

    local Track=Instance.new("Frame",Row)
    Track.Size=UDim2.new(0,54,0,30); Track.Position=UDim2.new(1,-62,0.5,-15)
    Track.BackgroundColor3=Color3.fromRGB(60,60,80); Track.BorderSizePixel=0
    Instance.new("UICorner",Track).CornerRadius=UDim.new(1,0)

    local Knob=Instance.new("Frame",Track)
    Knob.Size=UDim2.new(0,22,0,22); Knob.Position=UDim2.new(0,3,0.5,-11)
    Knob.BackgroundColor3=Color3.fromRGB(180,180,200); Knob.BorderSizePixel=0
    Instance.new("UICorner",Knob).CornerRadius=UDim.new(1,0)

    local SL=Instance.new("TextLabel",Track)
    SL.Size=UDim2.new(1,0,0,14); SL.Position=UDim2.new(0,0,1,3)
    SL.BackgroundTransparency=1; SL.Text="OFF"
    SL.TextColor3=Color3.fromRGB(120,120,150); SL.TextSize=11
    SL.Font=Enum.Font.Gotham; SL.TextXAlignment=Enum.TextXAlignment.Center

    local Btn=Instance.new("TextButton",Row)
    Btn.Size=UDim2.new(1,0,1,0); Btn.BackgroundTransparency=1; Btn.Text=""

    return Row, Track, Knob, SL, Btn
end

local function createInfoRow(defaultText, layoutOrder)
    local Row=Instance.new("Frame",ScrollFrame)
    Row.Size=UDim2.new(1,0,0,28); Row.BackgroundColor3=Color3.fromRGB(22,22,32)
    Row.BorderSizePixel=0; Row.LayoutOrder=layoutOrder
    Instance.new("UICorner",Row).CornerRadius=UDim.new(0,8)
    local stk=Instance.new("UIStroke",Row); stk.Color=Color3.fromRGB(60,50,100); stk.Thickness=1
    local Lbl=Instance.new("TextLabel",Row)
    Lbl.Size=UDim2.new(1,-10,1,0); Lbl.Position=UDim2.new(0,8,0,0)
    Lbl.BackgroundTransparency=1; Lbl.Text=defaultText
    Lbl.TextColor3=Color3.fromRGB(140,130,200); Lbl.TextSize=11
    Lbl.Font=Enum.Font.Gotham; Lbl.TextXAlignment=Enum.TextXAlignment.Left
    Lbl.TextWrapped=true
    return Lbl
end

local function nameMatchesLower(name, keywords)
    local lower = name:lower()
    for _, kw in ipairs(keywords) do
        if lower:find(kw, 1, true) then return true end
    end
    return false
end

local function unanchorObject(obj)
    local parts = {obj}
    for _, d in ipairs(obj:GetDescendants()) do parts[#parts+1]=d end
    for _, p in ipairs(parts) do
        if p:IsA("BasePart") then
            p.Anchored=false; p.CanCollide=false
            p.AssemblyLinearVelocity=Vector3.zero
            p.AssemblyAngularVelocity=Vector3.zero
        end
    end
end

local function findTarget(keywords)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if nameMatchesLower(obj.Name, keywords) then
            if obj:IsA("BasePart") then return obj, obj.CFrame
            elseif obj:IsA("Model") then
                local pp = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if pp then return pp, pp.CFrame end
            end
        end
    end
    return nil, nil
end

-- Drop items on the GROUND beside the target (not inside it) so they stay pickable
local function moveItemsBesideTarget(itemKeywords, targetKeywords, infoLabel, itemLabel, targetLabel)
    local targetPart, targetCF = findTarget(targetKeywords)
    if not targetPart then
        infoLabel.Text      = targetLabel.." not found — check name in Structure tab"
        infoLabel.TextColor3= Color3.fromRGB(255,100,100)
        return
    end

    -- Find ground Y under target
    local groundY = targetPart.Position.Y - (targetPart.Size.Y / 2) - 1

    local count = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj == targetPart or targetPart:IsDescendantOf(obj) or obj:IsAncestorOf(targetPart) then continue end
        if nameMatchesLower(obj.Name, itemKeywords) then
            unanchorObject(obj)
            -- Place beside the machine, spread in a small arc so items don't stack inside it
            local angle  = (count * 45) * math.pi / 180
            local radius = 3
            local offset = Vector3.new(math.cos(angle)*radius, 0.5, math.sin(angle)*radius)
            local dropPos= Vector3.new(targetPart.Position.X + offset.X, groundY + offset.Y, targetPart.Position.Z + offset.Z)

            if obj:IsA("BasePart") then
                obj.CFrame = CFrame.new(dropPos)
                obj.AssemblyLinearVelocity = Vector3.new(0, -5, 0)
                count += 1
            elseif obj:IsA("Model") then
                local pp = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if pp then
                    obj:PivotTo(CFrame.new(dropPos))
                    pp.AssemblyLinearVelocity = Vector3.new(0, -5, 0)
                    count += 1
                end
            end
        end
    end

    if count > 0 then
        infoLabel.Text      = count.." "..itemLabel.." dropped beside "..targetLabel.." — pick up & use!"
        infoLabel.TextColor3= Color3.fromRGB(120,255,160)
    else
        infoLabel.Text      = "No "..itemLabel.." found on map"
        infoLabel.TextColor3= Color3.fromRGB(255,200,80)
    end
end

local function makeCollector(itemKeywords, targetKeywords, infoLabel, itemLabel, targetLabel)
    local active = false
    local function loop()
        task.spawn(function()
            while active do
                moveItemsBesideTarget(itemKeywords, targetKeywords, infoLabel, itemLabel, targetLabel)
                task.wait(3)
            end
        end)
    end
    return {
        enable  = function() active=true;  loop() end,
        disable = function() active=false end,
    }
end

-- ============================================================
-- SECTION LABEL helper
-- ============================================================
local function createSectionLabel(text, order)
    local lbl=Instance.new("TextLabel",ScrollFrame)
    lbl.Size=UDim2.new(1,0,0,20); lbl.BackgroundTransparency=1
    lbl.Text=text; lbl.TextColor3=Color3.fromRGB(120,100,220)
    lbl.TextSize=11; lbl.Font=Enum.Font.GothamBold
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.LayoutOrder=order
    local lpad=Instance.new("UIPadding",lbl); lpad.PaddingLeft=UDim.new(0,4)
    return lbl
end

-- ============================================================
-- WALKSPEED  (order 1)
-- ============================================================
createSectionLabel("MOVEMENT", 0)
local _, wsTrack, wsKnob, wsStatus, wsButton = createToggleRow("Walkspeed  (55)", 1)
local function setWalkSpeed(on)
    walkSpeedEnabled = on
    animateToggle(wsTrack, wsKnob, wsStatus, on)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = on and FAST_WALKSPEED or DEFAULT_WALKSPEED end
    end
end
wsButton.MouseButton1Click:Connect(function() setWalkSpeed(not walkSpeedEnabled) end)

-- ============================================================
-- KILL AURA  (order 2-4)
-- ============================================================
createSectionLabel("COMBAT", 10)
local _, kaTrack, kaKnob, kaStatus, kaButton = createToggleRow("Kill Aura", 11)
local kaInfoLabel = createInfoRow("Equip any weapon to activate", 12)

local SliderOuter=Instance.new("Frame",ScrollFrame)
SliderOuter.Size=UDim2.new(1,0,0,52); SliderOuter.BackgroundColor3=Color3.fromRGB(28,28,38)
SliderOuter.BorderSizePixel=0; SliderOuter.LayoutOrder=13
Instance.new("UICorner",SliderOuter).CornerRadius=UDim.new(0,10)

local RangeLabel=Instance.new("TextLabel",SliderOuter)
RangeLabel.Size=UDim2.new(1,-12,0,18); RangeLabel.Position=UDim2.new(0,12,0,5)
RangeLabel.BackgroundTransparency=1; RangeLabel.Text="Aura Range: 20 studs"
RangeLabel.TextColor3=Color3.fromRGB(180,170,255); RangeLabel.TextSize=12
RangeLabel.Font=Enum.Font.GothamSemibold; RangeLabel.TextXAlignment=Enum.TextXAlignment.Left

local SliderTrack=Instance.new("Frame",SliderOuter)
SliderTrack.Size=UDim2.new(1,-24,0,8); SliderTrack.Position=UDim2.new(0,12,0,34)
SliderTrack.BackgroundColor3=Color3.fromRGB(50,50,70); SliderTrack.BorderSizePixel=0
Instance.new("UICorner",SliderTrack).CornerRadius=UDim.new(1,0)

local SliderFill=Instance.new("Frame",SliderTrack)
SliderFill.Size=UDim2.new((killAuraRange-1)/99,0,1,0)
SliderFill.BackgroundColor3=Color3.fromRGB(100,80,255); SliderFill.BorderSizePixel=0
Instance.new("UICorner",SliderFill).CornerRadius=UDim.new(1,0)

local SliderHandle=Instance.new("Frame",SliderTrack)
SliderHandle.Size=UDim2.new(0,24,0,24); SliderHandle.AnchorPoint=Vector2.new(0.5,0.5)
SliderHandle.Position=UDim2.new((killAuraRange-1)/99,0,0.5,0)
SliderHandle.BackgroundColor3=Color3.fromRGB(255,255,255); SliderHandle.BorderSizePixel=0
SliderHandle.ZIndex=5
Instance.new("UICorner",SliderHandle).CornerRadius=UDim.new(1,0)

local sliderDragging=false
local function updateSlider(ix)
    local rel=math.clamp((ix-SliderTrack.AbsolutePosition.X)/SliderTrack.AbsoluteSize.X,0,1)
    killAuraRange=math.floor(rel*99+1)
    SliderFill.Size=UDim2.new(rel,0,1,0)
    SliderHandle.Position=UDim2.new(rel,0,0.5,0)
    RangeLabel.Text="Aura Range: "..killAuraRange.." studs"
end
SliderHandle.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliderDragging=true end end)
SliderTrack.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliderDragging=true; updateSlider(i.Position.X) end end)
UserInputService.InputChanged:Connect(function(i) if sliderDragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then updateSlider(i.Position.X) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliderDragging=false end end)

local function isWeaponEquipped()
    local c=LocalPlayer.Character; return c and c:FindFirstChildOfClass("Tool")~=nil
end
local function startKillAura()
    killAuraConnection=RunService.Heartbeat:Connect(function()
        if not isWeaponEquipped() then
            kaInfoLabel.Text="Equip a weapon to activate"; kaInfoLabel.TextColor3=Color3.fromRGB(255,200,80); return
        end
        local char=LocalPlayer.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
        kaInfoLabel.Text="Active — killing nearby enemies"; kaInfoLabel.TextColor3=Color3.fromRGB(120,255,160)
        for _,model in ipairs(workspace:GetChildren()) do
            if model==char then continue end
            local isPlayer=false
            for _,p in ipairs(Players:GetPlayers()) do if p.Character==model then isPlayer=true; break end end
            if isPlayer then continue end
            local hum=model:FindFirstChildOfClass("Humanoid") or model:FindFirstChildWhichIsA("Humanoid",true)
            if hum and hum.Health>0 then
                local rp=model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso") or model:FindFirstChildWhichIsA("BasePart")
                if rp and (root.Position-rp.Position).Magnitude<=killAuraRange then hum.Health=0 end
            end
        end
    end)
end
local function stopKillAura()
    if killAuraConnection then killAuraConnection:Disconnect(); killAuraConnection=nil end
    kaInfoLabel.Text="Equip any weapon to activate"; kaInfoLabel.TextColor3=Color3.fromRGB(140,130,200)
end
local function setKillAura(on)
    killAuraEnabled=on; animateToggle(kaTrack,kaKnob,kaStatus,on)
    if on then startKillAura() else stopKillAura() end
end
kaButton.MouseButton1Click:Connect(function() setKillAura(not killAuraEnabled) end)

-- ============================================================
-- COLLECTORS  (order 20+)
-- ============================================================
createSectionLabel("COLLECTORS", 20)
local _, fcTrack, fcKnob, fcStatus, fcButton = createToggleRow("Fuel Collector", 21)
local fuelInfoLabel = createInfoRow("Drops fuel cans beside Generator", 22)
local fuelCollector = makeCollector(FUEL_KEYWORDS, GENERATOR_KEYWORDS, fuelInfoLabel, "fuel cans", "Generator")
local function setFuelCollector(on)
    fuelCollectorEnabled=on; animateToggle(fcTrack,fcKnob,fcStatus,on)
    if on then fuelCollector.enable() else fuelCollector.disable()
        fuelInfoLabel.Text="Drops fuel cans beside Generator"; fuelInfoLabel.TextColor3=Color3.fromRGB(140,130,200)
    end
end
fcButton.MouseButton1Click:Connect(function() setFuelCollector(not fuelCollectorEnabled) end)

local _, bcTrack, bcKnob, bcStatus, bcButton = createToggleRow("Battery Collector", 23)
local batteryInfoLabel = createInfoRow("Drops batteries beside Workbench", 24)
local batteryCollector = makeCollector(BATTERY_KEYWORDS, WORKBENCH_KEYWORDS, batteryInfoLabel, "batteries", "Workbench")
local function setBatteryCollector(on)
    batteryCollectorEnabled=on; animateToggle(bcTrack,bcKnob,bcStatus,on)
    if on then batteryCollector.enable() else batteryCollector.disable()
        batteryInfoLabel.Text="Drops batteries beside Workbench"; batteryInfoLabel.TextColor3=Color3.fromRGB(140,130,200)
    end
end
bcButton.MouseButton1Click:Connect(function() setBatteryCollector(not batteryCollectorEnabled) end)

local _, scTrack, scKnob, scStatus, scButton = createToggleRow("Scrap Collector", 25)
local scrapInfoLabel = createInfoRow("Drops scrap/metal beside Workbench", 26)
local scrapCollectorObj = makeCollector(SCRAP_KEYWORDS, WORKBENCH_KEYWORDS, scrapInfoLabel, "scrap", "Workbench")
local function setScrapCollector(on)
    scrapCollectorEnabled=on; animateToggle(scTrack,scKnob,scStatus,on)
    if on then scrapCollectorObj.enable() else scrapCollectorObj.disable()
        scrapInfoLabel.Text="Drops scrap/metal beside Workbench"; scrapInfoLabel.TextColor3=Color3.fromRGB(140,130,200)
    end
end
scButton.MouseButton1Click:Connect(function() setScrapCollector(not scrapCollectorEnabled) end)

-- ============================================================
-- INSTANT PROMPTS  (order 30)
-- ============================================================
createSectionLabel("MISC", 30)
local _, ipTrack, ipKnob, ipStatus, ipButton = createToggleRow("Instant Prompts", 31)
local promptAddedConn = nil
local function applyInstant(p) if not savedPromptData[p] then savedPromptData[p]={p.HoldDuration} end; p.HoldDuration=0 end
local function restorePrompt(p) if savedPromptData[p] then p.HoldDuration=savedPromptData[p][1]; savedPromptData[p]=nil end end
local function enableInstant()
    for _,o in ipairs(workspace:GetDescendants()) do if o:IsA("ProximityPrompt") then applyInstant(o) end end
    promptAddedConn=workspace.DescendantAdded:Connect(function(o) if o:IsA("ProximityPrompt") then task.wait(); applyInstant(o) end end)
end
local function disableInstant()
    if promptAddedConn then promptAddedConn:Disconnect(); promptAddedConn=nil end
    for p in pairs(savedPromptData) do restorePrompt(p) end
end
local function setInstant(on)
    instantPromptsEnabled=on; animateToggle(ipTrack,ipKnob,ipStatus,on)
    if on then enableInstant() else disableInstant() end
end
ipButton.MouseButton1Click:Connect(function() setInstant(not instantPromptsEnabled) end)

-- ============================================================
-- GOD MODE  (order 32)
-- ============================================================
local _, gmTrack, gmKnob, gmStatus, gmButton = createToggleRow("God Mode", 32)
local godInfoLabel = createInfoRow("HP locked — cannot die", 33)
local GOD_HP = 999999
local function applyGodMode(char)
    local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.MaxHealth=GOD_HP; hum.Health=GOD_HP
    if godHumConnection then godHumConnection:Disconnect() end
    godHumConnection=hum.HealthChanged:Connect(function(hp) if godModeEnabled and hp<GOD_HP then hum.Health=GOD_HP end end)
    if godModeConnection then godModeConnection:Disconnect() end
    godModeConnection=RunService.Heartbeat:Connect(function()
        if not godModeEnabled then return end
        if hum and hum.Parent then
            if hum.Health<GOD_HP then hum.Health=GOD_HP end
            if hum.MaxHealth<GOD_HP then hum.MaxHealth=GOD_HP end
        end
    end)
    godInfoLabel.Text="HP locked at max — cannot die"; godInfoLabel.TextColor3=Color3.fromRGB(120,255,160)
end
local function stopGodMode()
    if godModeConnection then godModeConnection:Disconnect(); godModeConnection=nil end
    if godHumConnection  then godHumConnection:Disconnect();  godHumConnection=nil  end
    local char=LocalPlayer.Character
    if char then local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.MaxHealth=100; hum.Health=100 end end
    godInfoLabel.Text="HP locked — cannot die"; godInfoLabel.TextColor3=Color3.fromRGB(140,130,200)
end
local function setGodMode(on)
    godModeEnabled=on; animateToggle(gmTrack,gmKnob,gmStatus,on)
    if on then local c=LocalPlayer.Character; if c then applyGodMode(c) end else stopGodMode() end
end
gmButton.MouseButton1Click:Connect(function() setGodMode(not godModeEnabled) end)

-- ============================================================
-- REMOVE ANTI  (order 40)
-- ============================================================
createSectionLabel("ANTI-CHEAT", 40)

local RemAntiRow=Instance.new("Frame",ScrollFrame)
RemAntiRow.Size=UDim2.new(1,0,0,44); RemAntiRow.BackgroundColor3=Color3.fromRGB(28,20,20)
RemAntiRow.BorderSizePixel=0; RemAntiRow.LayoutOrder=41
Instance.new("UICorner",RemAntiRow).CornerRadius=UDim.new(0,10)

local RemAntiBtn=Instance.new("TextButton",RemAntiRow)
RemAntiBtn.Size=UDim2.new(1,-16,1,-12); RemAntiBtn.Position=UDim2.new(0,8,0,6)
RemAntiBtn.BackgroundColor3=Color3.fromRGB(160,40,60); RemAntiBtn.BorderSizePixel=0
RemAntiBtn.Text="Remove Anti Scripts"; RemAntiBtn.TextColor3=Color3.fromRGB(255,255,255)
RemAntiBtn.TextSize=14; RemAntiBtn.Font=Enum.Font.GothamSemibold
Instance.new("UICorner",RemAntiBtn).CornerRadius=UDim.new(0,8)

local RemAntiInfo=createInfoRow("Destroys scripts/objects with 'Anti' in name", 42)

local ANTI_SERVICES = {
    workspace,
    game:GetService("ReplicatedStorage"),
    game:GetService("ReplicatedFirst"),
    game:GetService("StarterGui"),
    game:GetService("StarterPack"),
    game:GetService("StarterPlayer"),
    game:GetService("Lighting"),
}

RemAntiBtn.MouseButton1Click:Connect(function()
    local killed = 0
    for _, svc in ipairs(ANTI_SERVICES) do
        pcall(function()
            for _, obj in ipairs(svc:GetDescendants()) do
                if obj.Name:lower():find("anti", 1, true) then
                    -- disable scripts, destroy the rest
                    if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                        obj.Disabled = true
                        pcall(function() obj:Destroy() end)
                    else
                        pcall(function() obj:Destroy() end)
                    end
                    killed += 1
                end
            end
        end)
    end
    RemAntiInfo.Text = killed>0 and (killed.." anti objects removed!") or "None found with 'Anti' in name"
    RemAntiInfo.TextColor3 = killed>0 and Color3.fromRGB(120,255,160) or Color3.fromRGB(255,200,80)
end)

-- ============================================================
-- RESPAWN
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    if walkSpeedEnabled then local hum=char:WaitForChild("Humanoid"); hum.WalkSpeed=FAST_WALKSPEED end
    if killAuraEnabled  then stopKillAura(); task.wait(0.5); startKillAura() end
    if instantPromptsEnabled then task.wait(1); disableInstant(); enableInstant() end
    if godModeEnabled   then
        if godModeConnection then godModeConnection:Disconnect(); godModeConnection=nil end
        if godHumConnection  then godHumConnection:Disconnect();  godHumConnection=nil  end
        task.wait(0.5); applyGodMode(char)
    end
end)

-- ============================================================
-- STRUCTURE PANEL
-- ============================================================
local scannedText = ""  -- accumulated string for copy

-- Button row 1: Scan | Clear
local SR1=Instance.new("Frame",StructureContent)
SR1.Size=UDim2.new(1,0,0,38); SR1.Position=UDim2.new(0,0,0,0)
SR1.BackgroundTransparency=1
local sr1l=Instance.new("UIListLayout",SR1)
sr1l.FillDirection=Enum.FillDirection.Horizontal; sr1l.Padding=UDim.new(0,5)

local ScanBtn=Instance.new("TextButton",SR1)
ScanBtn.Size=UDim2.new(0.55,0,1,0); ScanBtn.BackgroundColor3=Color3.fromRGB(70,50,190)
ScanBtn.BorderSizePixel=0; ScanBtn.Text="Scan"; ScanBtn.TextColor3=Color3.fromRGB(255,255,255)
ScanBtn.TextSize=13; ScanBtn.Font=Enum.Font.GothamSemibold
Instance.new("UICorner",ScanBtn).CornerRadius=UDim.new(0,8)

local ClearBtn=Instance.new("TextButton",SR1)
ClearBtn.Size=UDim2.new(0.45,-5,1,0); ClearBtn.BackgroundColor3=Color3.fromRGB(80,30,40)
ClearBtn.BorderSizePixel=0; ClearBtn.Text="Clear"; ClearBtn.TextColor3=Color3.fromRGB(255,180,180)
ClearBtn.TextSize=13; ClearBtn.Font=Enum.Font.GothamSemibold
Instance.new("UICorner",ClearBtn).CornerRadius=UDim.new(0,8)

-- Button row 2: Print | Copy
local SR2=Instance.new("Frame",StructureContent)
SR2.Size=UDim2.new(1,0,0,34); SR2.Position=UDim2.new(0,0,0,42)
SR2.BackgroundTransparency=1
local sr2l=Instance.new("UIListLayout",SR2)
sr2l.FillDirection=Enum.FillDirection.Horizontal; sr2l.Padding=UDim.new(0,5)

local PrintBtn=Instance.new("TextButton",SR2)
PrintBtn.Size=UDim2.new(0.55,0,1,0); PrintBtn.BackgroundColor3=Color3.fromRGB(30,80,50)
PrintBtn.BorderSizePixel=0; PrintBtn.Text="Print to Output"; PrintBtn.TextColor3=Color3.fromRGB(160,255,180)
PrintBtn.TextSize=12; PrintBtn.Font=Enum.Font.GothamSemibold
Instance.new("UICorner",PrintBtn).CornerRadius=UDim.new(0,8)

local CopyBtn=Instance.new("TextButton",SR2)
CopyBtn.Size=UDim2.new(0.45,-5,1,0); CopyBtn.BackgroundColor3=Color3.fromRGB(40,60,120)
CopyBtn.BorderSizePixel=0; CopyBtn.Text="Copy Output"; CopyBtn.TextColor3=Color3.fromRGB(160,200,255)
CopyBtn.TextSize=12; CopyBtn.Font=Enum.Font.GothamSemibold
Instance.new("UICorner",CopyBtn).CornerRadius=UDim.new(0,8)

-- Status label
local ScanStatus=Instance.new("TextLabel",StructureContent)
ScanStatus.Size=UDim2.new(1,0,0,16); ScanStatus.Position=UDim2.new(0,0,0,80)
ScanStatus.BackgroundTransparency=1; ScanStatus.Text="Press Scan to inspect workspace"
ScanStatus.TextColor3=Color3.fromRGB(120,110,180); ScanStatus.TextSize=10
ScanStatus.Font=Enum.Font.Gotham; ScanStatus.TextXAlignment=Enum.TextXAlignment.Left

-- Structure scroll
local StructureScroll=Instance.new("ScrollingFrame",StructureContent)
StructureScroll.Size=UDim2.new(1,0,1,-100); StructureScroll.Position=UDim2.new(0,0,0,100)
StructureScroll.BackgroundColor3=Color3.fromRGB(14,14,20); StructureScroll.BorderSizePixel=0
StructureScroll.ScrollBarThickness=3; StructureScroll.ScrollBarImageColor3=Color3.fromRGB(100,80,255)
StructureScroll.CanvasSize=UDim2.new(0,0,0,0); StructureScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
StructureScroll.ScrollingDirection=Enum.ScrollingDirection.Y; StructureScroll.ClipsDescendants=true
Instance.new("UICorner",StructureScroll).CornerRadius=UDim.new(0,8)
local strl=Instance.new("UIListLayout",StructureScroll); strl.Padding=UDim.new(0,0)
local strp=Instance.new("UIPadding",StructureScroll)
strp.PaddingLeft=UDim.new(0,6); strp.PaddingTop=UDim.new(0,4); strp.PaddingBottom=UDim.new(0,6)

local SERVICE_COLORS={
    Workspace=Color3.fromRGB(100,200,255), ReplicatedStorage=Color3.fromRGB(255,200,80),
    ReplicatedFirst=Color3.fromRGB(255,170,60), ServerStorage=Color3.fromRGB(180,120,255),
    StarterGui=Color3.fromRGB(120,255,180), StarterPack=Color3.fromRGB(80,220,150),
    StarterPlayer=Color3.fromRGB(60,200,120), Players=Color3.fromRGB(255,130,130),
    Lighting=Color3.fromRGB(255,255,100), SoundService=Color3.fromRGB(200,160,255),
    Teams=Color3.fromRGB(255,160,100),
}
local CLASS_ICONS={
    Model="[M]",Part="[P]",MeshPart="[MP]",UnionOperation="[U]",
    Script="[S]",LocalScript="[LS]",ModuleScript="[MS]",
    RemoteEvent="[RE]",RemoteFunction="[RF]",Folder="[F]",Tool="[T]",
    StringValue="[Str]",IntValue="[Int]",BoolValue="[Bool]",NumberValue="[Num]",
    Configuration="[Cfg]",BindableEvent="[BE]",BindableFunction="[BF]",
    ProximityPrompt="[PP]",Humanoid="[Hum]",Animation="[Anim]",Sound="[Snd]",
    Decal="[Dcl]",Texture="[Tex]",WeldConstraint="[Weld]",Motor6D="[M6D]",
}
local function getIcon(obj) return CLASS_ICONS[obj.ClassName] or "[-]" end

local lineOrder2=0
local function addLine(text, color, indent)
    lineOrder2+=1
    local lbl=Instance.new("TextLabel",StructureScroll)
    lbl.Size=UDim2.new(1,-8,0,16); lbl.BackgroundTransparency=1
    lbl.Text=string.rep("  ",indent)..text
    lbl.TextColor3=color or Color3.fromRGB(200,200,220); lbl.TextSize=11
    lbl.Font=Enum.Font.Code; lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.TextTruncate=Enum.TextTruncate.AtEnd; lbl.LayoutOrder=lineOrder2
end

local function clearStructure()
    for _,c in ipairs(StructureScroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
    lineOrder2=0; scannedText=""
end

local SERVICES_TO_SCAN={
    {name="Workspace",         ref=workspace},
    {name="ReplicatedStorage", ref=game:GetService("ReplicatedStorage")},
    {name="ReplicatedFirst",   ref=game:GetService("ReplicatedFirst")},
    {name="StarterGui",        ref=game:GetService("StarterGui")},
    {name="StarterPack",       ref=game:GetService("StarterPack")},
    {name="StarterPlayer",     ref=game:GetService("StarterPlayer")},
    {name="Players",           ref=game:GetService("Players")},
    {name="Lighting",          ref=game:GetService("Lighting")},
    {name="SoundService",      ref=game:GetService("SoundService")},
    {name="Teams",             ref=game:GetService("Teams")},
}

local MAX_DEPTH=6
local MAX_CHILDREN=40

local function scanGuiLevel(obj, depth, textBuf)
    if depth>MAX_DEPTH then return end
    local children=obj:GetChildren()
    local shown=0
    for _,child in ipairs(children) do
        shown+=1
        if shown>MAX_CHILDREN then
            local s=string.format("... +%d more",#children-MAX_CHILDREN)
            addLine(s,Color3.fromRGB(100,100,120),depth)
            textBuf[#textBuf+1]=string.rep("  ",depth)..s.."\n"
            break
        end
        local icon=getIcon(child)
        local cc=#child:GetChildren()
        local suf=cc>0 and string.format(" [+%d]",cc) or ""
        local line=string.format("%s %s (%s)%s",icon,child.Name,child.ClassName,suf)
        addLine(line,Color3.fromRGB(190,190,210),depth)
        textBuf[#textBuf+1]=string.rep("  ",depth)..line.."\n"
        if cc>0 then scanGuiLevel(child,depth+1,textBuf) end
    end
end

local function scanAllServices(guiMode, printMode)
    local buf={}
    local total=0
    for _,s in ipairs(SERVICES_TO_SCAN) do
        pcall(function()
            total+=#s.ref:GetDescendants()
            local color=SERVICE_COLORS[s.name] or Color3.fromRGB(200,200,220)
            local hdr=string.format("[%s] (%d children)",s.name,#s.ref:GetChildren())
            if guiMode then addLine(hdr,color,0) end
            if printMode then print(hdr) end
            buf[#buf+1]=hdr.."\n"
            local function dp(obj,d)
                for _,child in ipairs(obj:GetChildren()) do
                    local icon=getIcon(child); local cc=#child:GetChildren()
                    local suf=cc>0 and string.format(" [+%d]",cc) or ""
                    local line=string.format("%s %s (%s)%s",icon,child.Name,child.ClassName,suf)
                    if guiMode and d<=MAX_DEPTH then addLine(line,Color3.fromRGB(190,190,210),d) end
                    if printMode then print(string.rep("  ",d)..line) end
                    buf[#buf+1]=string.rep("  ",d)..line.."\n"
                    if cc>0 then dp(child,d+1) end
                end
            end
            dp(s.ref,1)
            if guiMode then addLine("",Color3.fromRGB(40,40,60),0) end
            if printMode then print("") end
            buf[#buf+1]="\n"
        end)
    end
    return table.concat(buf), total
end

ScanBtn.MouseButton1Click:Connect(function()
    clearStructure()
    ScanStatus.Text="Scanning..."; ScanStatus.TextColor3=Color3.fromRGB(180,170,255)
    task.wait()
    local text, total = scanAllServices(true, false)
    scannedText = text
    ScanStatus.Text=string.format("Done — %d objects  (use Copy to copy)",total)
    ScanStatus.TextColor3=Color3.fromRGB(120,255,160)
end)

ClearBtn.MouseButton1Click:Connect(function()
    clearStructure()
    ScanStatus.Text="Press Scan to inspect workspace"; ScanStatus.TextColor3=Color3.fromRGB(120,110,180)
end)

PrintBtn.MouseButton1Click:Connect(function()
    ScanStatus.Text="Printing..."; ScanStatus.TextColor3=Color3.fromRGB(180,200,255)
    task.wait()
    print("===== KALO STRUCTURE DUMP =====")
    local text, _ = scanAllServices(false, true)
    scannedText = text
    print("===== END DUMP =====")
    ScanStatus.Text="Printed to Output tab"; ScanStatus.TextColor3=Color3.fromRGB(120,255,160)
end)

CopyBtn.MouseButton1Click:Connect(function()
    if scannedText=="" then
        ScanStatus.Text="Run Scan first!"; ScanStatus.TextColor3=Color3.fromRGB(255,200,80)
        return
    end
    pcall(function() setclipboard(scannedText) end)
    ScanStatus.Text="Copied to clipboard!"; ScanStatus.TextColor3=Color3.fromRGB(120,255,160)
end)
