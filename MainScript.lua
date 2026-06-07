-- LocalScript: Place in StarterPlayerScripts or StarterGui

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local DEFAULT_WALKSPEED = 16
local FAST_WALKSPEED = 55

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
local godHumConnection = nil

local FUEL_KEYWORDS      = {"fuel","Fuel","gascan","GasCan","gas can","Gas Can","jerrican","Jerrican","jerrycan","Jerrycan","fuelcan","FuelCan","petrol","Petrol","gasoline","Gasoline","Canister","canister"}
local GENERATOR_KEYWORDS = {"generator","Generator","gen","Gen"}
local BATTERY_KEYWORDS   = {"battery","Battery","batteries","Batteries","batt","Batt","powercell","PowerCell","power cell","Power Cell","energycell","EnergyCell","Energy Cell","BatteryPack","batterypack"}
local SCRAP_KEYWORDS     = {"scrap","Scrap","metal","Metal","nail","Nail","nails","Nails","iron","Iron","steel","Steel","bolt","Bolt","bolts","Bolts","junk","Junk","debris","Debris","scrapwood","ScrapWood","scrap wood","Scrap Wood","ScrapMetal","scrapmetal","Wood","wood","Plank","plank"}
local WORKBENCH_KEYWORDS = {"workbench","Workbench","WorkBench","work bench","Work Bench","crafttable","CraftTable","craft table","Craft Table","craftingbench","CraftingBench","crafting","Crafting","machine","Machine","fabricator","Fabricator","workshop","Workshop","bench","Bench","UpgradeStation","upgradestation","upgrade station","Upgrade Station","RepairStation","repairstation","crafting station","CraftingStation"}

-- ==============================
-- GUI SETUP
-- ==============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaloMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local KButton = Instance.new("TextButton")
KButton.Size = UDim2.new(0, 44, 0, 44)
KButton.Position = UDim2.new(0, 10, 0, 10)
KButton.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
KButton.BorderSizePixel = 0
KButton.Text = "K"
KButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KButton.TextSize = 20
KButton.Font = Enum.Font.GothamBlack
KButton.Visible = false
KButton.ZIndex = 10
KButton.Parent = ScreenGui

local KButtonCorner = Instance.new("UICorner")
KButtonCorner.CornerRadius = UDim.new(0, 10)
KButtonCorner.Parent = KButton

local KButtonStroke = Instance.new("UIStroke")
KButtonStroke.Color = Color3.fromRGB(160, 140, 255)
KButtonStroke.Thickness = 2
KButtonStroke.Parent = KButton

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 230, 0, 420)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 80, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

local TitleBarPatch = Instance.new("Frame")
TitleBarPatch.Size = UDim2.new(1, 0, 0, 12)
TitleBarPatch.Position = UDim2.new(0, 0, 1, -12)
TitleBarPatch.BackgroundColor3 = Color3.fromRGB(30, 20, 60)
TitleBarPatch.BorderSizePixel = 0
TitleBarPatch.Parent = TitleBar

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -88, 1, 0)
HeaderLabel.Position = UDim2.new(0, 44, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "Kalo"
HeaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderLabel.TextSize = 22
HeaderLabel.Font = Enum.Font.GothamBlack
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Center
HeaderLabel.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 36, 0, 36)
MinBtn.Position = UDim2.new(1, -80, 0, 4)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 100)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = TitleBar

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 8)
MinBtnCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -40, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 60)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

-- Tab bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, 34)
TabBar.Position = UDim2.new(0, 8, 0, 48)
TabBar.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 8)
TabBarCorner.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 4)
TabLayout.Parent = TabBar

local TabPad = Instance.new("UIPadding")
TabPad.PaddingLeft = UDim.new(0, 4)
TabPad.PaddingTop = UDim.new(0, 4)
TabPad.PaddingBottom = UDim.new(0, 4)
TabPad.Parent = TabBar

local function makeTab(label, order)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.5, -4, 1, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 30, 80)
    Btn.BorderSizePixel = 0
    Btn.Text = label
    Btn.TextColor3 = Color3.fromRGB(180, 170, 255)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamSemibold
    Btn.LayoutOrder = order
    Btn.Parent = TabBar
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 6)
    C.Parent = Btn
    return Btn
end

local TabMenu = makeTab("Menu", 1)
local TabStructure = makeTab("Structure", 2)

-- Menu content
local MenuContent = Instance.new("Frame")
MenuContent.Size = UDim2.new(1, -16, 1, -92)
MenuContent.Position = UDim2.new(0, 8, 0, 88)
MenuContent.BackgroundTransparency = 1
MenuContent.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.Parent = MenuContent

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = ScrollFrame

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingBottom = UDim.new(0, 8)
ContentPad.Parent = ScrollFrame

-- Structure content
local StructureContent = Instance.new("Frame")
StructureContent.Size = UDim2.new(1, -16, 1, -92)
StructureContent.Position = UDim2.new(0, 8, 0, 88)
StructureContent.BackgroundTransparency = 1
StructureContent.Visible = false
StructureContent.Parent = MainFrame

-- Tab switching
local function switchTab(tab)
    if tab == "menu" then
        MenuContent.Visible = true
        StructureContent.Visible = false
        TabMenu.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
        TabMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabStructure.BackgroundColor3 = Color3.fromRGB(40, 30, 80)
        TabStructure.TextColor3 = Color3.fromRGB(180, 170, 255)
    else
        MenuContent.Visible = false
        StructureContent.Visible = true
        TabStructure.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
        TabStructure.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabMenu.BackgroundColor3 = Color3.fromRGB(40, 30, 80)
        TabMenu.TextColor3 = Color3.fromRGB(180, 170, 255)
    end
end

switchTab("menu")
TabMenu.MouseButton1Click:Connect(function() switchTab("menu") end)
TabMenu.TouchTap:Connect(function() switchTab("menu") end)
TabStructure.MouseButton1Click:Connect(function() switchTab("structure") end)
TabStructure.TouchTap:Connect(function() switchTab("structure") end)

-- ==============================
-- STRUCTURE PANEL
-- ==============================
local BtnRow = Instance.new("Frame")
BtnRow.Size = UDim2.new(1, 0, 0, 82)
BtnRow.Position = UDim2.new(0, 0, 0, 0)
BtnRow.BackgroundTransparency = 1
BtnRow.Parent = StructureContent

local BtnRowLayout = Instance.new("UIListLayout")
BtnRowLayout.SortOrder = Enum.SortOrder.LayoutOrder
BtnRowLayout.Padding = UDim.new(0, 4)
BtnRowLayout.Parent = BtnRow

local R1 = Instance.new("Frame")
R1.Size = UDim2.new(1, 0, 0, 40)
R1.BackgroundTransparency = 1
R1.LayoutOrder = 1
R1.Parent = BtnRow

local R1Layout = Instance.new("UIListLayout")
R1Layout.FillDirection = Enum.FillDirection.Horizontal
R1Layout.Padding = UDim.new(0, 6)
R1Layout.Parent = R1

local ScanBtnFinal = Instance.new("TextButton")
ScanBtnFinal.Size = UDim2.new(0.62, 0, 1, 0)
ScanBtnFinal.BackgroundColor3 = Color3.fromRGB(80, 60, 200)
ScanBtnFinal.BorderSizePixel = 0
ScanBtnFinal.Text = "Scan"
ScanBtnFinal.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtnFinal.TextSize = 13
ScanBtnFinal.Font = Enum.Font.GothamSemibold
ScanBtnFinal.Parent = R1

local ScanBtnFinalCorner = Instance.new("UICorner")
ScanBtnFinalCorner.CornerRadius = UDim.new(0, 8)
ScanBtnFinalCorner.Parent = ScanBtnFinal

local ClearBtnFinal = Instance.new("TextButton")
ClearBtnFinal.Size = UDim2.new(0.38, -6, 1, 0)
ClearBtnFinal.BackgroundColor3 = Color3.fromRGB(80, 30, 40)
ClearBtnFinal.BorderSizePixel = 0
ClearBtnFinal.Text = "Clear"
ClearBtnFinal.TextColor3 = Color3.fromRGB(255, 180, 180)
ClearBtnFinal.TextSize = 13
ClearBtnFinal.Font = Enum.Font.GothamSemibold
ClearBtnFinal.Parent = R1

local ClearBtnFinalCorner = Instance.new("UICorner")
ClearBtnFinalCorner.CornerRadius = UDim.new(0, 8)
ClearBtnFinalCorner.Parent = ClearBtnFinal

local PrintBtnFinal = Instance.new("TextButton")
PrintBtnFinal.Size = UDim2.new(1, 0, 0, 36)
PrintBtnFinal.BackgroundColor3 = Color3.fromRGB(30, 80, 50)
PrintBtnFinal.BorderSizePixel = 0
PrintBtnFinal.Text = "Print Full Tree to Output"
PrintBtnFinal.TextColor3 = Color3.fromRGB(160, 255, 180)
PrintBtnFinal.TextSize = 13
PrintBtnFinal.Font = Enum.Font.GothamSemibold
PrintBtnFinal.LayoutOrder = 2
PrintBtnFinal.Parent = BtnRow

local PrintBtnFinalCorner = Instance.new("UICorner")
PrintBtnFinalCorner.CornerRadius = UDim.new(0, 8)
PrintBtnFinalCorner.Parent = PrintBtnFinal

local ScanStatusLabel = Instance.new("TextLabel")
ScanStatusLabel.Size = UDim2.new(1, 2, 0, 18)
ScanStatusLabel.Position = UDim2.new(0, 2, 0, 84)
ScanStatusLabel.BackgroundTransparency = 1
ScanStatusLabel.Text = "Press Scan to inspect workspace"
ScanStatusLabel.TextColor3 = Color3.fromRGB(120, 110, 180)
ScanStatusLabel.TextSize = 11
ScanStatusLabel.Font = Enum.Font.Gotham
ScanStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
ScanStatusLabel.Parent = StructureContent

local StructureScroll = Instance.new("ScrollingFrame")
StructureScroll.Size = UDim2.new(1, 0, 1, -104)
StructureScroll.Position = UDim2.new(0, 0, 0, 104)
StructureScroll.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
StructureScroll.BorderSizePixel = 0
StructureScroll.ScrollBarThickness = 3
StructureScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 255)
StructureScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
StructureScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
StructureScroll.ScrollingDirection = Enum.ScrollingDirection.Y
StructureScroll.ClipsDescendants = true
StructureScroll.Parent = StructureContent

local StructureScrollCorner = Instance.new("UICorner")
StructureScrollCorner.CornerRadius = UDim.new(0, 8)
StructureScrollCorner.Parent = StructureScroll

local StructureList = Instance.new("UIListLayout")
StructureList.SortOrder = Enum.SortOrder.LayoutOrder
StructureList.Padding = UDim.new(0, 0)
StructureList.Parent = StructureScroll

local StructurePad = Instance.new("UIPadding")
StructurePad.PaddingLeft = UDim.new(0, 6)
StructurePad.PaddingTop = UDim.new(0, 4)
StructurePad.PaddingBottom = UDim.new(0, 6)
StructurePad.Parent = StructureScroll

local SERVICE_COLORS = {
    Workspace         = Color3.fromRGB(100, 200, 255),
    ReplicatedStorage = Color3.fromRGB(255, 200, 80),
    ReplicatedFirst   = Color3.fromRGB(255, 170, 60),
    ServerStorage     = Color3.fromRGB(180, 120, 255),
    StarterGui        = Color3.fromRGB(120, 255, 180),
    StarterPack       = Color3.fromRGB(80, 220, 150),
    StarterPlayer     = Color3.fromRGB(60, 200, 120),
    Players           = Color3.fromRGB(255, 130, 130),
    Lighting          = Color3.fromRGB(255, 255, 100),
    SoundService      = Color3.fromRGB(200, 160, 255),
    Teams             = Color3.fromRGB(255, 160, 100),
}

local CLASS_ICONS = {
    Model             = "[M]",
    Part              = "[P]",
    MeshPart          = "[MP]",
    UnionOperation    = "[U]",
    Script            = "[S]",
    LocalScript       = "[LS]",
    ModuleScript      = "[MS]",
    RemoteEvent       = "[RE]",
    RemoteFunction    = "[RF]",
    Folder            = "[F]",
    Tool              = "[T]",
    StringValue       = "[Str]",
    IntValue          = "[Int]",
    BoolValue         = "[Bool]",
    NumberValue       = "[Num]",
    Configuration     = "[Cfg]",
    BindableEvent     = "[BE]",
    BindableFunction  = "[BF]",
    ProximityPrompt   = "[PP]",
    Humanoid          = "[Hum]",
    Animation         = "[Anim]",
    Sound             = "[Snd]",
    Decal             = "[Dcl]",
    Texture           = "[Tex]",
    WeldConstraint    = "[Weld]",
    Motor6D           = "[M6D]",
}

local function getIcon(obj)
    return CLASS_ICONS[obj.ClassName] or "[-]"
end

local lineOrder = 0
local function addLine(text, color, indent)
    lineOrder += 1
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -8, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = string.rep("  ", indent) .. text
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 220)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Code
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.LayoutOrder = lineOrder
    lbl.Parent = StructureScroll
end

local function clearStructure()
    for _, c in ipairs(StructureScroll:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    lineOrder = 0
end

local MAX_DEPTH = 6
local MAX_CHILDREN = 40

local SERVICES_TO_SCAN = {
    {name = "Workspace",         ref = workspace},
    {name = "ReplicatedStorage", ref = game:GetService("ReplicatedStorage")},
    {name = "ReplicatedFirst",   ref = game:GetService("ReplicatedFirst")},
    {name = "StarterGui",        ref = game:GetService("StarterGui")},
    {name = "StarterPack",       ref = game:GetService("StarterPack")},
    {name = "StarterPlayer",     ref = game:GetService("StarterPlayer")},
    {name = "Players",           ref = game:GetService("Players")},
    {name = "Lighting",          ref = game:GetService("Lighting")},
    {name = "SoundService",      ref = game:GetService("SoundService")},
    {name = "Teams",             ref = game:GetService("Teams")},
}

local function scanGuiLevel(obj, depth)
    if depth > MAX_DEPTH then return end
    local children = obj:GetChildren()
    local shown = 0
    for _, child in ipairs(children) do
        shown += 1
        if shown > MAX_CHILDREN then
            addLine(string.format("... +%d more children", #children - MAX_CHILDREN), Color3.fromRGB(100, 100, 120), depth)
            break
        end
        local icon = getIcon(child)
        local cc = #child:GetChildren()
        local suffix = cc > 0 and string.format(" [+%d]", cc) or ""
        addLine(string.format("%s %s (%s)%s", icon, child.Name, child.ClassName, suffix), Color3.fromRGB(190, 190, 210), depth)
        if cc > 0 then
            scanGuiLevel(child, depth + 1)
        end
    end
end

local function scanService(service, serviceName, printMode)
    local color = SERVICE_COLORS[serviceName] or Color3.fromRGB(200, 200, 220)
    local children = service:GetChildren()
    if not printMode then
        addLine(string.format("[%s]  (%d children)", serviceName, #children), color, 0)
        scanGuiLevel(service, 1)
        addLine("", Color3.fromRGB(40, 40, 60), 0)
    else
        print(string.rep("  ", 0) .. "[" .. serviceName .. "]  (" .. #children .. " children)")
        local function deepPrint(obj, d)
            for _, child in ipairs(obj:GetChildren()) do
                local icon = getIcon(child)
                local cc = #child:GetChildren()
                local suffix = cc > 0 and string.format(" [+%d]", cc) or ""
                print(string.rep("  ", d) .. icon .. " " .. child.Name .. " (" .. child.ClassName .. ")" .. suffix)
                if cc > 0 then deepPrint(child, d + 1) end
            end
        end
        deepPrint(service, 1)
        print("")
    end
end

ScanBtnFinal.MouseButton1Click:Connect(function()
    clearStructure()
    ScanStatusLabel.Text = "Scanning..."
    ScanStatusLabel.TextColor3 = Color3.fromRGB(180, 170, 255)
    task.wait()
    local total = 0
    for _, s in ipairs(SERVICES_TO_SCAN) do
        pcall(function()
            total += #s.ref:GetDescendants()
            scanService(s.ref, s.name, false)
        end)
    end
    ScanStatusLabel.Text = string.format("Done — %d total objects", total)
    ScanStatusLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
end)
ScanBtnFinal.TouchTap:Connect(function() ScanBtnFinal.MouseButton1Click:Fire() end)

ClearBtnFinal.MouseButton1Click:Connect(function()
    clearStructure()
    ScanStatusLabel.Text = "Press Scan to inspect workspace"
    ScanStatusLabel.TextColor3 = Color3.fromRGB(120, 110, 180)
end)
ClearBtnFinal.TouchTap:Connect(function() ClearBtnFinal.MouseButton1Click:Fire() end)

PrintBtnFinal.MouseButton1Click:Connect(function()
    ScanStatusLabel.Text = "Printing to Output..."
    ScanStatusLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
    task.wait()
    print("========== KALO STRUCTURE DUMP ==========")
    for _, s in ipairs(SERVICES_TO_SCAN) do
        pcall(function() scanService(s.ref, s.name, true) end)
    end
    print("========== END OF STRUCTURE DUMP ==========")
    ScanStatusLabel.Text = "Full tree printed to Output tab"
    ScanStatusLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
end)
PrintBtnFinal.TouchTap:Connect(function() PrintBtnFinal.MouseButton1Click:Fire() end)

-- ==============================
-- CLOSE / MINIMIZE
-- ==============================
local function closeGui()
    MainFrame.Visible = false
    KButton.Visible = true
end
local function openGui()
    MainFrame.Visible = true
    KButton.Visible = false
end
CloseBtn.MouseButton1Click:Connect(closeGui)
CloseBtn.TouchTap:Connect(closeGui)
KButton.MouseButton1Click:Connect(openGui)
KButton.TouchTap:Connect(openGui)

local minimized = false
local function toggleMinimize()
    minimized = not minimized
    TabBar.Visible = not minimized
    MenuContent.Visible = not minimized and TabMenu.BackgroundColor3 == Color3.fromRGB(100, 80, 255)
    StructureContent.Visible = not minimized and TabStructure.BackgroundColor3 == Color3.fromRGB(100, 80, 255)
    MainFrame.Size = minimized and UDim2.new(0, 230, 0, 44) or UDim2.new(0, 230, 0, 420)
    MinBtn.Text = minimized and "+" or "-"
end
MinBtn.MouseButton1Click:Connect(toggleMinimize)
MinBtn.TouchTap:Connect(toggleMinimize)

-- ==============================
-- HELPERS
-- ==============================
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function animateToggle(track, knob, statusLabel, enabled)
    local knobGoal = enabled
        and {Position = UDim2.new(1, -25, 0.5, -11), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}
        or  {Position = UDim2.new(0, 3, 0.5, -11),   BackgroundColor3 = Color3.fromRGB(180, 180, 200)}
    local trackGoal = enabled
        and {BackgroundColor3 = Color3.fromRGB(100, 80, 255)}
        or  {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}
    TweenService:Create(knob, tweenInfo, knobGoal):Play()
    TweenService:Create(track, tweenInfo, trackGoal):Play()
    statusLabel.Text = enabled and "ON" or "OFF"
    statusLabel.TextColor3 = enabled and Color3.fromRGB(160, 140, 255) or Color3.fromRGB(120, 120, 150)
end

local function createToggleRow(labelText, layoutOrder)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 52)
    Row.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    Row.BorderSizePixel = 0
    Row.LayoutOrder = layoutOrder
    Row.Parent = ScrollFrame

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 10)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -80, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(220, 220, 240)
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(0, 54, 0, 30)
    Track.Position = UDim2.new(1, -62, 0.5, -15)
    Track.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Track.BorderSizePixel = 0
    Track.Parent = Row

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 22, 0, 22)
    Knob.Position = UDim2.new(0, 3, 0.5, -11)
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
    Button.Parent = Row

    return Row, Track, Knob, StatusLabel, Button
end

local function createInfoRow(defaultText, layoutOrder)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 28)
    Row.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    Row.BorderSizePixel = 0
    Row.LayoutOrder = layoutOrder
    Row.Parent = ScrollFrame

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

local function unanchorObject(obj)
    if obj:IsA("BasePart") then
        obj.Anchored = false
        obj.CanCollide = false
        obj.AssemblyLinearVelocity = Vector3.zero
        obj.AssemblyAngularVelocity = Vector3.zero
    end
    for _, part in ipairs(obj:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            part.CanCollide = false
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

local function findTarget(keywords)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if nameMatches(obj.Name, keywords) then
            if obj:IsA("BasePart") then return obj, obj.CFrame
            elseif obj:IsA("Model") then
                local pp = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if pp then return pp, pp.CFrame end
            end
        end
    end
    return nil, nil
end

local function moveItemsIntoTarget(itemKeywords, targetKeywords, infoLabel, itemLabel, targetLabel)
    local targetPart, targetCFrame = findTarget(targetKeywords)
    if not targetPart then
        infoLabel.Text = targetLabel .. " not found! Check name."
        infoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    local targetRoot = targetPart.Parent
    for _, d in ipairs(targetRoot:GetDescendants()) do
        if d:IsA("ProximityPrompt") then d.HoldDuration = 0 end
    end
    local count = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsAncestorOf(targetPart) or obj == targetPart or targetPart:IsDescendantOf(obj) then continue end
        if nameMatches(obj.Name, itemKeywords) then
            unanchorObject(obj)
            local dropCF = targetCFrame * CFrame.new(0, 0.5 + count * 0.3, 0)
            if obj:IsA("BasePart") then
                obj.CFrame = dropCF
                obj.AssemblyLinearVelocity = Vector3.new(0, -15, 0)
                count += 1
            elseif obj:IsA("Model") then
                local pp = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if pp then
                    obj:PivotTo(dropCF)
                    pp.AssemblyLinearVelocity = Vector3.new(0, -15, 0)
                    count += 1
                end
            end
        end
    end
    if count > 0 then
        infoLabel.Text = count .. " " .. itemLabel .. " placed into " .. targetLabel .. " ✓"
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
                moveItemsIntoTarget(itemKeywords, targetKeywords, infoLabel, itemLabel, targetLabel)
                task.wait(2)
            end
        end)
    end
    return {
        enable  = function() enabled = true; loop() end,
        disable = function() enabled = false end,
    }
end

-- ==============================
-- WALKSPEED
-- ==============================
local _, wsTrack, wsKnob, wsStatus, wsButton = createToggleRow("Walkspeed", 1)
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
wsButton.TouchTap:Connect(function() setWalkSpeed(not walkSpeedEnabled) end)

-- ==============================
-- KILL AURA
-- ==============================
local _, kaTrack, kaKnob, kaStatus, kaButton = createToggleRow("Kill Aura", 2)
local kaInfoLabel = createInfoRow("Equip any weapon to activate", 3)

local SliderOuter = Instance.new("Frame")
SliderOuter.Size = UDim2.new(1, 0, 0, 52)
SliderOuter.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
SliderOuter.BorderSizePixel = 0
SliderOuter.LayoutOrder = 4
SliderOuter.Parent = ScrollFrame

local SliderOuterCorner = Instance.new("UICorner")
SliderOuterCorner.CornerRadius = UDim.new(0, 10)
SliderOuterCorner.Parent = SliderOuter

local RangeLabel = Instance.new("TextLabel")
RangeLabel.Size = UDim2.new(1, -12, 0, 18)
RangeLabel.Position = UDim2.new(0, 12, 0, 5)
RangeLabel.BackgroundTransparency = 1
RangeLabel.Text = "Aura Range: 20 studs"
RangeLabel.TextColor3 = Color3.fromRGB(180, 170, 255)
RangeLabel.TextSize = 12
RangeLabel.Font = Enum.Font.GothamSemibold
RangeLabel.TextXAlignment = Enum.TextXAlignment.Left
RangeLabel.Parent = SliderOuter

local SliderTrack = Instance.new("Frame")
SliderTrack.Size = UDim2.new(1, -24, 0, 8)
SliderTrack.Position = UDim2.new(0, 12, 0, 34)
SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = SliderOuter

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
SliderHandle.Size = UDim2.new(0, 24, 0, 24)
SliderHandle.AnchorPoint = Vector2.new(0.5, 0.5)
SliderHandle.Position = UDim2.new((killAuraRange - 1) / 99, 0, 0.5, 0)
SliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderHandle.BorderSizePixel = 0
SliderHandle.ZIndex = 5
SliderHandle.Parent = SliderTrack

local HandleCorner = Instance.new("UICorner")
HandleCorner.CornerRadius = UDim.new(1, 0)
HandleCorner.Parent = SliderHandle

local sliderDragging = false
local function updateSlider(inputX)
    local rel = math.clamp((inputX - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
    killAuraRange = math.floor(rel * 99 + 1)
    SliderFill.Size = UDim2.new(rel, 0, 1, 0)
    SliderHandle.Position = UDim2.new(rel, 0, 0.5, 0)
    RangeLabel.Text = "Aura Range: " .. killAuraRange .. " studs"
end
SliderHandle.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliderDragging = true end
end)
SliderTrack.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliderDragging = true; updateSlider(i.Position.X) end
end)
UserInputService.InputChanged:Connect(function(i)
    if sliderDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then updateSlider(i.Position.X) end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliderDragging = false end
end)

local function isWeaponEquipped()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Tool") ~= nil
end

local function startKillAura()
    killAuraConnection = RunService.Heartbeat:Connect(function()
        if not isWeaponEquipped() then
            kaInfoLabel.Text = "Equip a weapon to activate"
            kaInfoLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
            return
        end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        kaInfoLabel.Text = "Swinging - killing zombies"
        kaInfoLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
        for _, model in ipairs(workspace:GetChildren()) do
            if model == char then continue end
            local isRealPlayer = false
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character == model then isRealPlayer = true; break end
            end
            if isRealPlayer then continue end
            local hum = model:FindFirstChildOfClass("Humanoid") or model:FindFirstChildWhichIsA("Humanoid", true)
            if hum and hum.Health > 0 then
                local rootPart = model:FindFirstChild("HumanoidRootPart")
                    or model:FindFirstChild("Torso")
                    or model:FindFirstChild("UpperTorso")
                    or model:FindFirstChildWhichIsA("BasePart")
                if rootPart and (root.Position - rootPart.Position).Magnitude <= killAuraRange then
                    hum.Health = 0
                end
            end
        end
    end)
end

local function stopKillAura()
    if killAuraConnection then killAuraConnection:Disconnect(); killAuraConnection = nil end
    kaInfoLabel.Text = "Equip any weapon to activate"
    kaInfoLabel.TextColor3 = Color3.fromRGB(140, 130, 200)
end

local function setKillAura(on)
    killAuraEnabled = on
    animateToggle(kaTrack, kaKnob, kaStatus, on)
    if on then startKillAura() else stopKillAura() end
end
kaButton.MouseButton1Click:Connect(function() setKillAura(not killAuraEnabled) end)
kaButton.TouchTap:Connect(function() setKillAura(not killAuraEnabled) end)

-- ==============================
-- FUEL COLLECTOR
-- ==============================
local _, fcTrack, fcKnob, fcStatus, fcButton = createToggleRow("Fuel Collector", 5)
local fuelInfoLabel = createInfoRow("Places fuel inside Generator", 6)
local fuelCollector = makeCollector(FUEL_KEYWORDS, GENERATOR_KEYWORDS, fuelInfoLabel, "fuel", "Generator")
local function setFuelCollector(on)
    fuelCollectorEnabled = on
    animateToggle(fcTrack, fcKnob, fcStatus, on)
    if on then fuelCollector.enable() else
        fuelCollector.disable()
        fuelInfoLabel.Text = "Places fuel inside Generator"
        fuelInfoLabel.TextColor3 = Color3.fromRGB(140, 130, 200)
    end
end
fcButton.MouseButton1Click:Connect(function() setFuelCollector(not fuelCollectorEnabled) end)
fcButton.TouchTap:Connect(function() setFuelCollector(not fuelCollectorEnabled) end)

-- ==============================
-- BATTERY COLLECTOR
-- ==============================
local _, bcTrack, bcKnob, bcStatus, bcButton = createToggleRow("Battery Collector", 7)
local batteryInfoLabel = createInfoRow("Places batteries into Workbench", 8)
local batteryCollector = makeCollector(BATTERY_KEYWORDS, WORKBENCH_KEYWORDS, batteryInfoLabel, "batteries", "Workbench")
local function setBatteryCollector(on)
    batteryCollectorEnabled = on
    animateToggle(bcTrack, bcKnob, bcStatus, on)
    if on then batteryCollector.enable() else
        batteryCollector.disable()
        batteryInfoLabel.Text = "Places batteries into Workbench"
        batteryInfoLabel.TextColor3 = Color3.fromRGB(140, 130, 200)
    end
end
bcButton.MouseButton1Click:Connect(function() setBatteryCollector(not batteryCollectorEnabled) end)
bcButton.TouchTap:Connect(function() setBatteryCollector(not batteryCollectorEnabled) end)

-- ==============================
-- SCRAP COLLECTOR
-- ==============================
local _, scTrack, scKnob, scStatus, scButton = createToggleRow("Scrap Collector", 9)
local scrapInfoLabel = createInfoRow("Places scrap/metal into Workbench", 10)
local scrapCollectorObj = makeCollector(SCRAP_KEYWORDS, WORKBENCH_KEYWORDS, scrapInfoLabel, "scrap", "Workbench")
local function setScrapCollector(on)
    scrapCollectorEnabled = on
    animateToggle(scTrack, scKnob, scStatus, on)
    if on then scrapCollectorObj.enable() else
        scrapCollectorObj.disable()
        scrapInfoLabel.Text = "Places scrap/metal into Workbench"
        scrapInfoLabel.TextColor3 = Color3.fromRGB(140, 130, 200)
    end
end
scButton.MouseButton1Click:Connect(function() setScrapCollector(not scrapCollectorEnabled) end)
scButton.TouchTap:Connect(function() setScrapCollector(not scrapCollectorEnabled) end)

-- ==============================
-- INSTANT PROMPTS
-- ==============================
local _, ipTrack, ipKnob, ipStatus, ipButton = createToggleRow("Instant Prompts", 11)
local promptAddedConnection = nil

local function applyInstantToPrompt(prompt)
    if not savedPromptData[prompt] then savedPromptData[prompt] = {HoldDuration = prompt.HoldDuration} end
    prompt.HoldDuration = 0
end
local function restorePrompt(prompt)
    local data = savedPromptData[prompt]
    if data then prompt.HoldDuration = data.HoldDuration; savedPromptData[prompt] = nil end
end
local function enableInstantPrompts()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then applyInstantToPrompt(obj) end
    end
    promptAddedConnection = workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("ProximityPrompt") then task.wait(); applyInstantToPrompt(obj) end
    end)
end
local function disableInstantPrompts()
    if promptAddedConnection then promptAddedConnection:Disconnect(); promptAddedConnection = nil end
    for prompt in pairs(savedPromptData) do restorePrompt(prompt) end
end
local function setInstantPrompts(on)
    instantPromptsEnabled = on
    animateToggle(ipTrack, ipKnob, ipStatus, on)
    if on then enableInstantPrompts() else disableInstantPrompts() end
end
ipButton.MouseButton1Click:Connect(function() setInstantPrompts(not instantPromptsEnabled) end)
ipButton.TouchTap:Connect(function() setInstantPrompts(not instantPromptsEnabled) end)

-- ==============================
-- GOD MODE
-- ==============================
local _, gmTrack, gmKnob, gmStatus, gmButton = createToggleRow("God Mode", 12)
local godInfoLabel = createInfoRow("HP locked - cannot die", 13)
local GOD_HP = 999999

local function applyGodMode(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.MaxHealth = GOD_HP
    hum.Health = GOD_HP
    if godHumConnection then godHumConnection:Disconnect() end
    godHumConnection = hum.HealthChanged:Connect(function(newHp)
        if godModeEnabled and newHp < GOD_HP then hum.Health = GOD_HP end
    end)
    if godModeConnection then godModeConnection:Disconnect() end
    godModeConnection = RunService.Heartbeat:Connect(function()
        if not godModeEnabled then return end
        if hum and hum.Parent then
            if hum.Health < GOD_HP then hum.Health = GOD_HP end
            if hum.MaxHealth < GOD_HP then hum.MaxHealth = GOD_HP end
        end
    end)
    godInfoLabel.Text = "HP locked at max - cannot die"
    godInfoLabel.TextColor3 = Color3.fromRGB(120, 255, 160)
end

local function stopGodMode()
    if godModeConnection then godModeConnection:Disconnect(); godModeConnection = nil end
    if godHumConnection then godHumConnection:Disconnect(); godHumConnection = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.MaxHealth = 100; hum.Health = 100 end
    end
    godInfoLabel.Text = "HP locked - cannot die"
    godInfoLabel.TextColor3 = Color3.fromRGB(140, 130, 200)
end

local function setGodMode(on)
    godModeEnabled = on
    animateToggle(gmTrack, gmKnob, gmStatus, on)
    if on then
        local char = LocalPlayer.Character
        if char then applyGodMode(char) end
    else stopGodMode() end
end
gmButton.MouseButton1Click:Connect(function() setGodMode(not godModeEnabled) end)
gmButton.TouchTap:Connect(function() setGodMode(not godModeEnabled) end)

-- ==============================
-- RESPAWN HANDLING
-- ==============================
LocalPlayer.CharacterAdded:Connect(function(char)
    if walkSpeedEnabled then
        local hum = char:WaitForChild("Humanoid")
        hum.WalkSpeed = FAST_WALKSPEED
    end
    if killAuraEnabled then stopKillAura(); task.wait(0.5); startKillAura() end
    if instantPromptsEnabled then task.wait(1); disableInstantPrompts(); enableInstantPrompts() end
    if godModeEnabled then
        if godModeConnection then godModeConnection:Disconnect(); godModeConnection = nil end
        if godHumConnection then godHumConnection:Disconnect(); godHumConnection = nil end
        task.wait(0.5)
        applyGodMode(char)
    end
end)
