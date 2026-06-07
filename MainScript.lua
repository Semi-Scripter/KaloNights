-- LocalScript: Place in StarterPlayerScripts or StarterGui

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Settings
local DEFAULT_WALKSPEED = 16
local FAST_WALKSPEED = 72

-- State
local walkSpeedEnabled = false
local killAuraEnabled = false
local killAuraRange = 20
local killAuraConnection = nil
local fuelCollectorEnabled = false
local batteryCollectorEnabled = false
local scrapCollectorEnabled = false
local instantPromptsEnabled = false
local godModeEnabled = false
local savedPromptData = {}
local godModeConnection = nil

-- Keywords
local FUEL_KEYWORDS      = {"fuel","Fuel","gascan","GasCan","gas can","Gas Can","jerrican","Jerrican","jerrycan","Jerrycan","fuelcan","FuelCan","petrol","Petrol","gasoline","Gasoline"}
local GENERATOR_KEYWORDS = {"generator","Generator","gen","Gen"}
local BATTERY_KEYWORDS   = {"battery","Battery","batteries","Batteries","batt","Batt","powercell","PowerCell","power cell","Power Cell","energycell","EnergyCell","Energy Cell"}
local SCRAP_KEYWORDS     = {"scrap","Scrap","metal","Metal","nail","Nail","nails","Nails","iron","Iron","steel","Steel","bolt","Bolt","bolts","Bolts","junk","Junk","debris","Debris","scrapwood","ScrapWood","scrap wood","Scrap Wood"}
local WORKBENCH_KEYWORDS = {"workbench","Workbench","WorkBench","work bench","Work Bench","crafttable","CraftTable","craft table","Craft Table","craftingbench","CraftingBench","crafting","Crafting","machine","Machine","fabricator","Fabricator","workshop","Workshop","bench","Bench","table","Table"}

-- ==============================
-- GUI SETUP
-- ==============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaloMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 630)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -315)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 80, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 10)
TitleBarCorner.Parent = TitleBar

local TitleBarPatch = Instance.new("Frame")
TitleBarPatch.Size = UDim2.new(1, 0, 0, 10)
TitleBarPatch.Position = UDim2.new(0, 0, 1, -10)
TitleBarPatch.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
TitleBarPatch.BorderSizePixel = 0
TitleBarPatch.Parent = TitleBar

local MenuLabel = Instance.new("TextLabel")
MenuLabel.Size = UDim2.new(0.4, 0, 1, 0)
MenuLabel.Position = UDim2.new(0.05, 0, 0, 0)
MenuLabel.BackgroundTransparency = 1
MenuLabel.Text = "Menu"
MenuLabel.TextColor3 = Color3.fromRGB(160, 140, 255)
MenuLabel.TextSize = 13
MenuLabel.Font = Enum.Font.GothamBold
MenuLabel.TextXAlignment = Enum.TextXAlignment.Left
MenuLabel.Parent = TitleBar

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -20, 1, 0)
HeaderLabel.Position = UDim2.new(0, 10, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "Kalo"
HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderLabel.TextSize = 20
HeaderLabel.Font = Enum.Font.GothamBlack
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Center
HeaderLabel.Parent = TitleBar

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0.9, 0, 0, 1)
Divider.Position = UDim2.new(0.05, 0, 0, 48)
Divider.BackgroundColor3 = Color3.fromRGB(80, 60, 160)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 55)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = ContentFrame

-- ==============================
-- HELPERS
-- ==============================
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function animateToggle(track, knob, statusLabel, enabled)
    local knobGoal = enabled
        and {Position = UDim2.new(1, -23, 0.5, -10), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}
        or  {Position = UDim2.new(0, 3, 0.5, -10),  BackgroundColor3 = Color3.fromRGB(180, 180, 200)}
    local trackGoal = enabled
        and {BackgroundColor3 = Color3.fromRGB(100, 80, 255)}
        or  {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}
    TweenService:Create(knob, tweenInfo, knobGoal):Play()
    TweenService:Create(track, tweenInfo, trackGoal):Play()
    statusLabel.Text = enabled and "ON" or "OFF"
    statusLabel.TextColor3 = enabled
        and Color3.fromRGB(160, 140, 255)
        or  Color3.fromRGB(120, 120, 150)
end

local function createToggleRow(parent, labelText, layoutOrder)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 44)
    Row.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Row.BorderSizePixel = 0
    Row.LayoutOrder = layoutOrder
    Row.Parent = parent

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 8)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(220, 220, 240)
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(0, 48, 0, 26)
    Track.Position = UDim2.new(1, -56, 0.5, -13)
    Track.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Track.BorderSizePixel = 0
    Track.Parent = Row

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = UDim2.new(0, 3, 0.5, -10)
    Knob.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
    Knob.BorderSizePixel = 0
    Knob.Parent = Track

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 14)
    StatusLabel.Position = UDim2.new(0, 0, 1, 3)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "OFF"
    StatusLabel.TextColor3 = Color3.fromRGB(120, 120, 150)
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.Parent = Track

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = Track

    return Row, Track, Knob, StatusLabel, Button
end

local function createInfoRow(parent, defaultText, layoutOrder)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 30)
    Row.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    Row.BorderSizePixel = 0
    Row.LayoutOrder = layoutOrder
    Row.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Row

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(60, 50, 100)
    Stroke.Thickness = 1
    Stroke.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = defaultText
    Label.TextColor3 = Color3.fromRGB(140, 130, 200)
    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.Parent = Row

    return Label
end

local function nameMatches(name, keywords)
    local lower = name:lower()
    for _, kw in ipairs(keywords) do
        if lower:find(kw:lower(), 1, true) then return true end
    end
    return false
end

local function findTargetPosition(keywords)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if nameMatches(obj.Name, keywords) then
            if obj:IsA("BasePart") then
                return obj.Position
            elseif obj:IsA("Model") then
                local pp = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if pp then return pp.Position end
            end
        end
    end
    return nil
end

local function moveItemsTo(itemKeywords, targetPos, infoLabel, itemLabel, targetLabel)
    local count = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if nameMatches(obj.Name, itemKeywords) then
            local dest = targetPos + Vector3.new(0, 2 + count * 0.6, 0)
            if obj:IsA("BasePart") and not obj.Anchored then
                obj.CFrame = CFrame.new(dest)
                count += 1
            elseif obj:IsA("Model") then
                local pp = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if pp then
                    obj:PivotTo(CFrame.new(dest))
                    count += 1
                end
            end
        end
    end
    if count > 0 then
        infoLabel.Text = "Collected " .. count .. " " .. itemLabel .. " → " .. targetLabel .. " ✓"
        infoLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
    else
        infoLabel.Text = "No " .. itemLabel .. " found on map."
        infoLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
    end
end

local function makeCollector(itemKeywords, targetKeywords, infoLabel, itemLabel, targetLabel)
    local enabled = false
    local function loop()
        task.spawn(function()
            while enabled do
                local pos = findTargetPosition(targetKeywords)
                if pos then
                    moveItemsTo(itemKeywords, pos, infoLabel, itemLabel, targetLabel)
                else
                    infoLabel.Text = targetLabel .. " not found!"
                    infoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
                task.wait(2)
            end
        end)
    end
    return {
        enable = function() enabled = true; loop() end,
        disable = function() enabled = false end,
        isEnabled = function() return enabled end
    }
end

-- ==============================
-- WALKSPEED TOGGLE  (Order 1)
-- ==============================
local _, wsTrack, wsKnob, wsStatus, wsButton = createToggleRow(ContentFrame, "Walkspeed", 1)

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

-- ==============================
-- KILL AURA TOGGLE  (Order 2)
-- ==============================
local _, kaTrack, kaKnob, kaStatus, kaButton = createToggleRow(ContentFrame, "Kill Aura", 2)

-- Slider (Order 3)
local SliderContainer = Instance.new("Frame")
SliderContainer.Size = UDim2.new(1, 0, 0, 48)
SliderContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
SliderContainer.BorderSizePixel = 0
SliderContainer.LayoutOrder = 3
SliderContainer.Parent = ContentFrame

local SliderContainerCorner = Instance.new("UICorner")
SliderContainerCorner.CornerRadius = UDim.new(0, 8)
SliderContainerCorner.Parent = SliderContainer

local RangeHeaderLabel = Instance.new("TextLabel")
RangeHeaderLabel.Size = UDim2.new(1, -12, 0, 18)
RangeHeaderLabel.Position = UDim2.new(0, 12, 0, 4)
RangeHeaderLabel.BackgroundTransparency = 1
RangeHeaderLabel.Text = "Aura Range: 20 studs"
RangeHeaderLabel.TextColor3 = Color3.fromRGB(180, 170, 255)
RangeHeaderLabel.TextSize = 12
RangeHeaderLabel.Font = Enum.Font.GothamSemibold
RangeHeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
RangeHeaderLabel.Parent = SliderContainer

local SliderTrack = Instance.new("Frame")
SliderTrack.Size = UDim2.new(1, -20, 0, 6)
SliderTrack.Position = UDim2.new(0, 10, 0, 30)
SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = SliderContainer

local SliderTrackCorner = Instance.new("UICorner")
SliderTrackCorner.CornerRadius = UDim.new(1, 0)
SliderTrackCorner.Parent = SliderTrack

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((killAuraRange - 1) / 99, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

local SliderHandle = Instance.new("Frame")
SliderHandle.Size = UDim2.new(0, 16, 0, 16)
SliderHandle.AnchorPoint = Vector2.new(0.5, 0.5)
SliderHandle.Position = UDim2.new((killAuraRange - 1) / 99, 0, 0.5, 0)
SliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderHandle.BorderSizePixel = 0
SliderHandle.ZIndex = 5
SliderHandle.Parent = SliderTrack

local HandleCorner = Instance.new("UICorner")
HandleCorner.CornerRadius = UDim.new(1, 0)
HandleCorner.Parent = SliderHandle

local MinLabel = Instance.new("TextLabel")
MinLabel.Size = UDim2.new(0, 20, 0, 12)
MinLabel.Position = UDim2.new(0, 10, 1, -14)
MinLabel.BackgroundTransparency = 1
MinLabel.Text = "1"
MinLabel.TextColor3 = Color3.fromRGB(120, 120, 150)
MinLabel.TextSize = 10
MinLabel.Font = Enum.Font.Gotham
MinLabel.TextXAlignment = Enum.TextXAlignment.Left
MinLabel.Parent = SliderContainer

local MaxLabel = Instance.new("TextLabel")
MaxLabel.Size = UDim2.new(0, 30, 0, 12)
MaxLabel.Position = UDim2.new(1, -40, 1, -14)
MaxLabel.BackgroundTransparency = 1
MaxLabel.Text = "100"
MaxLabel.TextColor3 = Color3.fromRGB(120, 120, 150)
MaxLabel.TextSize = 10
MaxLabel.Font = Enum.Font.Gotham
MaxLabel.TextXAlignment = Enum.TextXAlignment.Right
MaxLabel.Parent = SliderContainer

local sliderDragging = false
local function updateSlider(inputX)
    local rel = math.clamp((inputX - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
    killAuraRange = math.floor(rel * 99 + 1)
    SliderFill.Size = UDim2.new(rel, 0, 1, 0)
    SliderHandle.Position = UDim2.new(rel, 0, 0.5, 0)
    RangeHeaderLabel.Text = "Aura Range: " .. killAuraRange .. " studs"
end

SliderHandle.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)
SliderTrack.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        updateSlider(i.Position.X)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if sliderDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(i.Position.X)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

local function startKillAura()
    killAuraConnection = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Health > 0 then
                local pm = obj.Parent
                if pm == char then continue end
                local isPlayer = false
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Character == pm then isPlayer = true; break end
                end
                if isPlayer then continue end
                local nr = pm:FindFirstChild("HumanoidRootPart")
                    or pm:FindFirstChild("Torso")
                    or pm:FindFirstChild("UpperTorso")
                if nr and (root.Position - nr.Position).Magnitude <= killAuraRange then
                    obj.Health = 0
                end
            end
        end
    end)
end

local function stopKillAura()
    if killAuraConnection then killAuraConnection:Disconnect(); killAuraConnection = nil end
end

local function setKillAura(on)
    killAuraEnabled = on
    animateToggle(kaTrack, kaKnob, kaStatus, on)
    if on then startKillAura() else stopKillAura() end
end
kaButton.MouseButton1Click:Connect(function() setKillAura(not killAuraEnabled) end)

-- ==============================
-- FUEL COLLECTOR  (Order 4-5)
-- ==============================
local _, fcTrack, fcKnob, fcStatus, fcButton = createToggleRow(ContentFrame, "Fuel Collector", 4)
local fuelInfoLabel = createInfoRow(ContentFrame, "Moves all fuel → Generator", 5)
local fuelCollector = makeCollector(FUEL_KEYWORDS, GENERATOR_KEYWORDS, fuelInfoLabel, "fuel", "Generator")

local function setFuelCollector(on)
    fuelCollectorEnabled = on
    animateToggle(fcTrack, fcKnob, fcStatus, on)
    if on then
        fuelCollector.enable()
    else
        fuelCollector.disable()
        fuelInfoLabel.Text = "Moves all fuel → Generator"
        fuelInfoLabel.TextColor3 = Color3.fromRGB(140, 130, 200)
    end
end
fcButton.MouseButton1Click:Connect(function() setFuelCollector(not fuelCollectorEnabled) end)

-- ==============================
-- BATTERY COLLECTOR  (Order 6-7)
-- ==============================
local _, bcTrack, bcKnob, bcStatus, bcButton = createToggleRow(ContentFrame, "Battery Collector", 6)
local batteryInfoLabel = createInfoRow(ContentFrame, "Moves all batteries → Workbench", 7)
local batteryCollector = makeCollector(BATTERY_KEYWORDS, WORKBENCH_KEYWORDS, batteryInfoLabel, "batteries", "Workbench")

local function setBatteryCollector(on)
    batteryCollectorEnabled = on
    animateToggle(bcTrack, bcKnob, bcStatus, on)
    if on then
        batteryCollector.enable()
    else
        batteryCollector.disable()
        batteryInfoLabel.Text = "Moves all batteries → Workbench"
        batteryInfoLabel.TextColor3 = Color3.fromRGB(140, 130, 200)
    end
end
bcButton.MouseButton1Click:Connect(function() setBatteryCollector(not batteryCollectorEnabled) end)

-- ==============================
-- SCRAP COLLECTOR  (Order 8-9)
-- ==============================
local _, scTrack, scKnob, scStatus, scButton = createToggleRow(ContentFrame, "Scrap Collector", 8)
local scrapInfoLabel = createInfoRow(ContentFrame, "Moves all scrap/metal → Workbench", 9)
local scrapCollectorObj = makeCollector(SCRAP_KEYWORDS, WORKBENCH_KEYWORDS, scrapInfoLabel, "scrap", "Workbench")

local function setScrapCollector(on)
    scrapCollectorEnabled = on
    animateToggle(scTrack, scKnob, scStatus, on)
    if on then
        scrapCollectorObj.enable()
    else
        scrapCollectorObj.disable()
        scrapInfoLabel.Text = "Moves all scrap/metal → Workbench"
        scrapInfoLabel.TextColor3 = Color3.fromRGB(140, 130, 200)
    end
end
scButton.MouseButton1Click:Connect(function() setScrapCollector(not scrapCollectorEnabled) end)

-- ==============================
-- INSTANT PROMPTS TOGGLE  (Order 10)
-- ==============================
local _, ipTrack, ipKnob, ipStatus, ipButton = createToggleRow(ContentFrame, "Instant Prompts", 10)
local promptAddedConnection = nil

local function applyInstantToPrompt(prompt)
    if not savedPromptData[prompt] then
        savedPromptData[prompt] = { HoldDuration = prompt.HoldDuration }
    end
    prompt.HoldDuration = 0
end

local function restorePrompt(prompt)
    local data = savedPromptData[prompt]
    if data then
        prompt.HoldDuration = data.HoldDuration
        savedPromptData[prompt] = nil
    end
end

local function enableInstantPrompts()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            applyInstantToPrompt(obj)
        end
    end
    promptAddedConnection = workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("ProximityPrompt") then
            task.wait()
            applyInstantToPrompt(obj)
        end
    end)
end

local function disableInstantPrompts()
    if promptAddedConnection then
        promptAddedConnection:Disconnect()
        promptAddedConnection = nil
    end
    for prompt, _ in pairs(savedPromptData) do
        restorePrompt(prompt)
    end
end

local function setInstantPrompts(on)
    instantPromptsEnabled = on
    animateToggle(ipTrack, ipKnob, ipStatus, on)
    if on then enableInstantPrompts() else disableInstantPrompts() end
end
ipButton.MouseButton1Click:Connect(function() setInstantPrompts(not instantPromptsEnabled) end)

-- ==============================
-- GOD MODE TOGGLE  (Order 11)
-- ==============================
local _, gmTrack, gmKnob, gmStatus, gmButton = createToggleRow(ContentFrame, "God Mode", 11)

local function applyGodMode(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    -- Continuously refill HP every frame so damage is immediately undone
    godModeConnection = RunService.Heartbeat:Connect(function()
        if hum and hum.Parent then
            if hum.Health < hum.MaxHealth then
                hum.Health = math.huge
            end
        end
    end)
end

local function stopGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    -- Restore normal max health
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end
end

local function setGodMode(on)
    godModeEnabled = on
    animateToggle(gmTrack, gmKnob, gmStatus, on)
    if on then
        local char = LocalPlayer.Character
        if char then applyGodMode(char) end
    else
        stopGodMode()
    end
end
gmButton.MouseButton1Click:Connect(function() setGodMode(not godModeEnabled) end)

-- ==============================
-- RESPAWN HANDLING
-- ==============================
LocalPlayer.CharacterAdded:Connect(function(char)
    if walkSpeedEnabled then
        local hum = char:WaitForChild("Humanoid")
        hum.WalkSpeed = FAST_WALKSPEED
    end
    if killAuraEnabled then
        stopKillAura()
        startKillAura()
    end
    if instantPromptsEnabled then
        task.wait(1)
        disableInstantPrompts()
        enableInstantPrompts()
    end
    if godModeEnabled then
        if godModeConnection then godModeConnection:Disconnect(); godModeConnection = nil end
        task.wait(0.5)
        applyGodMode(char)
    end
end)
