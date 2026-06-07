-- Personal Exploit Menu v2
-- Mobile-optimized | Clean UI | Structure + Anti-Cheat

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

-- Remove old instance
if PlayerGui:FindFirstChild("_ExploitMenu") then
    PlayerGui["_ExploitMenu"]:Destroy()
end

----------------------------------------------------------------
-- THEME (clean, no neon)
----------------------------------------------------------------
local C = {
    BG      = Color3.fromRGB(20, 20, 26),
    PANEL   = Color3.fromRGB(28, 28, 36),
    HEADER  = Color3.fromRGB(32, 32, 42),
    LINE    = Color3.fromRGB(48, 48, 62),
    TEXT    = Color3.fromRGB(220, 220, 228),
    DIM     = Color3.fromRGB(120, 120, 140),
    WHITE   = Color3.fromRGB(255, 255, 255),
    BTN     = Color3.fromRGB(42, 42, 56),
    BTN_HOV = Color3.fromRGB(55, 55, 72),
    CLIP    = Color3.fromRGB(58, 100, 160),
    COPY    = Color3.fromRGB(50, 110, 85),
    RESET   = Color3.fromRGB(120, 50, 58),
    AC      = Color3.fromRGB(110, 60, 140),
    OUTPUT  = Color3.fromRGB(14, 14, 20),
}

----------------------------------------------------------------
-- SCAN TARGETS
----------------------------------------------------------------
local SERVICES = {
    "Workspace", "ReplicatedStorage", "ReplicatedFirst",
    "StarterGui", "StarterPack", "StarterPlayer",
    "Lighting", "SoundService", "Chat", "Teams",
}

-- Common anti-cheat script name patterns
local AC_PATTERNS = {
    "anticheat", "anti_cheat", "anti-cheat", "acheat",
    "fairplay", "byfron", "hyperion", "easyanticheat",
    "detection", "kicksystem", "banhandler", "exploitdetect",
    "remotespy", "sanitycheck", "speedcheck", "flycheck",
}

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------
local function new(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function corner(p, r)
    new("UICorner", { CornerRadius = UDim.new(0, r or 6) }, p)
end

local function divider(parent)
    local f = new("Frame", {
        Size = UDim2.new(1, -16, 0, 1),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundColor3 = C.LINE,
        BorderSizePixel = 0,
    }, parent)
    return f
end

local function label(text, size, color, parent, props)
    local p = props or {}
    local l = new("TextLabel", {
        Text = text,
        Font = Enum.Font.GothamSemibold,
        TextSize = size or 12,
        TextColor3 = color or C.TEXT,
        BackgroundTransparency = 1,
        TextXAlignment = p.align or Enum.TextXAlignment.Left,
        TextWrapped = p.wrap or false,
        Size = p.size or UDim2.new(1, 0, 0, 22),
        Position = p.pos or UDim2.new(0, 0, 0, 0),
    }, parent)
    return l
end

local function btn(text, color, parent, size)
    local b = new("TextButton", {
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = C.WHITE,
        Size = size or UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, parent)
    corner(b, 6)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.1), {
            BackgroundColor3 = color:lerp(Color3.new(1,1,1), 0.1)
        }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.1), {
            BackgroundColor3 = color
        }):Play()
    end)
    return b
end

----------------------------------------------------------------
-- ROOT GUI
----------------------------------------------------------------
local W, H = 310, 430

local Gui = new("ScreenGui", {
    Name = "_ExploitMenu",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
}, PlayerGui)

local Main = new("Frame", {
    Size = UDim2.fromOffset(W, H),
    Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
    BackgroundColor3 = C.BG,
    ClipsDescendants = true,
}, Gui)
corner(Main, 10)
new("UIStroke", { Color = C.LINE, Thickness = 1 }, Main)

----------------------------------------------------------------
-- HEADER
----------------------------------------------------------------
local Header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundColor3 = C.HEADER,
    BorderSizePixel = 0,
}, Main)
new("UICorner", { CornerRadius = UDim.new(0, 10) }, Header)
-- flatten bottom corners
new("Frame", {
    Size = UDim2.new(1, 0, 0.5, 0),
    Position = UDim2.new(0, 0, 0.5, 0),
    BackgroundColor3 = C.HEADER,
    BorderSizePixel = 0,
}, Header)

new("TextLabel", {
    Text = "Exploit Menu",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = C.TEXT,
    Size = UDim2.new(1, -70, 1, 0),
    Position = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3,
}, Header)

-- Version tag
new("TextLabel", {
    Text = "v2.0",
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextColor3 = C.DIM,
    Size = UDim2.new(0, 30, 1, 0),
    Position = UDim2.new(0, 96, 0, 0),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3,
}, Header)

-- Minimize / Close buttons
local MinBtn = new("TextButton", {
    Text = "—",
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = C.DIM,
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -60, 0.5, -13),
    BackgroundColor3 = C.BTN,
    ZIndex = 4,
}, Header)
corner(MinBtn, 5)

local CloseBtn = new("TextButton", {
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextColor3 = C.DIM,
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -30, 0.5, -13),
    BackgroundColor3 = C.RESET,
    ZIndex = 4,
}, Header)
corner(CloseBtn, 5)

CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)

local minimized = false
local ContentFrame -- declared below
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(Main, TweenInfo.new(0.2), {
            Size = UDim2.fromOffset(W, 38)
        }):Play()
        MinBtn.Text = "▲"
    else
        TweenService:Create(Main, TweenInfo.new(0.2), {
            Size = UDim2.fromOffset(W, H)
        }):Play()
        MinBtn.Text = "—"
    end
end)

-- Drag
do
    local drag, ds, sp
    Header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; ds = i.Position; sp = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
                  or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
end

----------------------------------------------------------------
-- TAB BAR
----------------------------------------------------------------
local TabBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 38),
    BackgroundColor3 = C.PANEL,
    BorderSizePixel = 0,
}, Main)

new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 1),
}, TabBar)

local function makeTab(text, order)
    local t = new("TextButton", {
        Text = text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        TextColor3 = C.DIM,
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = C.PANEL,
        BorderSizePixel = 0,
        LayoutOrder = order,
        AutoButtonColor = false,
    }, TabBar)
    return t
end

local TabStruct = makeTab("Structure", 1)
local TabAC     = makeTab("Anti-Cheat", 2)

-- Active indicator
local TabIndicator = new("Frame", {
    Size = UDim2.new(0.5, 0, 0, 2),
    Position = UDim2.new(0, 0, 1, -2),
    BackgroundColor3 = C.CLIP,
    BorderSizePixel = 0,
    ZIndex = 3,
}, TabBar)

----------------------------------------------------------------
-- CONTENT AREA
----------------------------------------------------------------
ContentFrame = new("Frame", {
    Size = UDim2.new(1, 0, 1, -68),
    Position = UDim2.new(0, 0, 0, 68),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
}, Main)

-- thin separator
divider(new("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = C.LINE,
    BorderSizePixel = 0,
}, ContentFrame))

----------------------------------------------------------------
-- STRUCTURE PANEL
----------------------------------------------------------------
local PanelStruct = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
}, ContentFrame)

new("UIPadding", {
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
    PaddingTop = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 6),
}, PanelStruct)

local PanelLayout = new("UIListLayout", {
    FillDirection = Enum.FillDirection.Vertical,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
}, PanelStruct)

-- Section label
local SectionLabel = label("  Structure Scanner", 11, C.DIM, PanelStruct, {
    size = UDim2.new(1, 0, 0, 18),
})
SectionLabel.LayoutOrder = 1

-- Output box
local OutputOuter = new("Frame", {
    Size = UDim2.new(1, 0, 0, 228),
    BackgroundColor3 = C.OUTPUT,
    BorderSizePixel = 0,
    LayoutOrder = 2,
}, PanelStruct)
corner(OutputOuter, 6)
new("UIStroke", { Color = C.LINE, Thickness = 1 }, OutputOuter)

local Scroll = new("ScrollingFrame", {
    Size = UDim2.new(1, -6, 1, -6),
    Position = UDim2.new(0, 3, 0, 3),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.LINE,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
}, OutputOuter)

local OutText = new("TextLabel", {
    Text = "Press [Clip] to scan the game tree.",
    Font = Enum.Font.Code,
    TextSize = 11,
    TextColor3 = C.DIM,
    Size = UDim2.new(1, -6, 0, 0),
    Position = UDim2.new(0, 3, 0, 3),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    AutomaticSize = Enum.AutomaticSize.Y,
    RichText = false,
}, Scroll)

-- Buttons row
local BtnOuter = new("Frame", {
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundTransparency = 1,
    LayoutOrder = 3,
}, PanelStruct)

new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, BtnOuter)

local BtnClip  = btn("Clip",  C.CLIP,  BtnOuter, UDim2.new(0.34, 0, 1, 0))
local BtnCopy  = btn("Copy",  C.COPY,  BtnOuter, UDim2.new(0.33, -3, 1, 0))
local BtnReset = btn("Reset", C.RESET, BtnOuter, UDim2.new(0.33, -3, 1, 0))
BtnClip.LayoutOrder  = 1
BtnCopy.LayoutOrder  = 2
BtnReset.LayoutOrder = 3

----------------------------------------------------------------
-- ANTI-CHEAT PANEL
----------------------------------------------------------------
local PanelAC = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
}, ContentFrame)

new("UIPadding", {
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 8),
}, PanelAC)

local ACLayout = new("UIListLayout", {
    FillDirection = Enum.FillDirection.Vertical,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8),
}, PanelAC)

label("  Anti-Cheat Remover", 11, C.DIM, PanelAC, {
    size = UDim2.new(1, 0, 0, 16),
}).LayoutOrder = 1

-- Info box
local InfoBox = new("Frame", {
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundColor3 = C.PANEL,
    BorderSizePixel = 0,
    LayoutOrder = 2,
}, PanelAC)
corner(InfoBox, 6)
new("UIStroke", { Color = C.LINE, Thickness = 1 }, InfoBox)

local InfoLabel = new("TextLabel", {
    Text = "Scans Workspace, ReplicatedStorage & StarterGui for scripts matching common anti-cheat names and disables them.",
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextColor3 = C.DIM,
    Size = UDim2.new(1, -12, 1, -8),
    Position = UDim2.new(0, 6, 0, 4),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
}, InfoBox)

-- Result log
local LogOuter = new("Frame", {
    Size = UDim2.new(1, 0, 0, 170),
    BackgroundColor3 = C.OUTPUT,
    LayoutOrder = 3,
}, PanelAC)
corner(LogOuter, 6)
new("UIStroke", { Color = C.LINE, Thickness = 1 }, LogOuter)

local LogScroll = new("ScrollingFrame", {
    Size = UDim2.new(1, -6, 1, -6),
    Position = UDim2.new(0, 3, 0, 3),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.LINE,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, LogOuter)

local LogText = new("TextLabel", {
    Text = "Press [Remove ACs] to begin.",
    Font = Enum.Font.Code,
    TextSize = 11,
    TextColor3 = C.DIM,
    Size = UDim2.new(1, -6, 0, 0),
    Position = UDim2.new(0, 3, 0, 3),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    AutomaticSize = Enum.AutomaticSize.Y,
    RichText = false,
}, LogScroll)

-- AC Buttons
local ACBtnRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundTransparency = 1,
    LayoutOrder = 4,
}, PanelAC)

new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, ACBtnRow)

local BtnRemoveAC = btn("Remove ACs", C.AC,    ACBtnRow, UDim2.new(0.63, 0, 1, 0))
local BtnACReset  = btn("Clear Log",  C.RESET, ACBtnRow, UDim2.new(0.37, -6, 1, 0))
BtnRemoveAC.LayoutOrder = 1
BtnACReset.LayoutOrder  = 2

----------------------------------------------------------------
-- TAB SWITCHING
----------------------------------------------------------------
local function switchTab(toStruct)
    PanelStruct.Visible = toStruct
    PanelAC.Visible     = not toStruct
    TabStruct.TextColor3 = toStruct and C.TEXT or C.DIM
    TabAC.TextColor3     = toStruct and C.DIM  or C.TEXT
    TabStruct.BackgroundColor3 = toStruct and C.BTN  or C.PANEL
    TabAC.BackgroundColor3     = toStruct and C.PANEL or C.BTN

    TweenService:Create(TabIndicator, TweenInfo.new(0.18), {
        Position = toStruct and UDim2.new(0, 0, 1, -2) or UDim2.new(0.5, 0, 1, -2)
    }):Play()
end

TabStruct.MouseButton1Click:Connect(function() switchTab(true)  end)
TabAC.MouseButton1Click:Connect(function()     switchTab(false) end)
switchTab(true)

----------------------------------------------------------------
-- STRUCTURE SCANNER LOGIC (FIXED)
----------------------------------------------------------------
local lastOutput = ""

local function safeGet(name)
    local ok, r = pcall(game.GetService, game, name)
    if ok and r then return r end
    ok, r = pcall(function() return game[name] end)
    return ok and r or nil
end

local function buildTree(inst, depth, lines, count)
    if count[1] > 2000 then return end -- hard cap to prevent overflow
    count[1] = count[1] + 1

    local indent = string.rep("  ", math.min(depth, 12))
    local ok, cn = pcall(function() return inst.ClassName end)
    local ok2, nm = pcall(function() return inst.Name    end)
    if not ok or not ok2 then return end

    table.insert(lines, indent .. "[" .. cn .. "]  " .. nm)

    local ok3, children = pcall(function() return inst:GetChildren() end)
    if ok3 and depth < 8 then
        for _, child in ipairs(children) do
            buildTree(child, depth + 1, lines, count)
        end
    end
end

BtnClip.MouseButton1Click:Connect(function()
    OutText.Text = "Scanning..."
    task.wait(0.05)

    local ok_all, err = pcall(function()
        local lines  = {}
        local count  = {0}
        local header = string.format(
            "[ Scanned %s  |  PlaceId: %d ]\n",
            os.date("%H:%M:%S"), game.PlaceId
        )
        table.insert(lines, header)

        for _, name in ipairs(SERVICES) do
            local svc = safeGet(name)
            if svc then
                table.insert(lines, ">> " .. name)
                local ok, kids = pcall(function() return svc:GetChildren() end)
                if ok then
                    for _, child in ipairs(kids) do
                        buildTree(child, 1, lines, count)
                    end
                else
                    table.insert(lines, "  [Access Denied]")
                end
                table.insert(lines, "")
            else
                table.insert(lines, ">> " .. name .. "  [Not Found]\n")
            end
        end

        if count[1] >= 2000 then
            table.insert(lines, "\n[Output capped at 2000 nodes]")
        end

        lastOutput = table.concat(lines, "\n")
        OutText.Text = lastOutput
    end)

    if not ok_all then
        OutText.Text = "Error during scan:\n" .. tostring(err)
    end
end)

BtnCopy.MouseButton1Click:Connect(function()
    if lastOutput == "" then
        OutText.Text = "Nothing to copy — Clip first."
        return
    end
    local copied = false
    if setclipboard  then pcall(setclipboard, lastOutput);  copied = true
    elseif copystring then pcall(copystring,  lastOutput);  copied = true end
    local prev = OutText.Text
    OutText.Text = copied
        and ("Copied " .. #lastOutput .. " chars to clipboard!")
        or  ("setclipboard not available on this executor.")
    task.delay(2.5, function()
        if OutText and OutText.Parent then OutText.Text = prev end
    end)
end)

BtnReset.MouseButton1Click:Connect(function()
    lastOutput   = ""
    OutText.Text = "Press [Clip] to scan the game tree."
    Scroll.CanvasPosition = Vector2.zero
end)

----------------------------------------------------------------
-- ANTI-CHEAT REMOVER LOGIC
----------------------------------------------------------------
local AC_SEARCH = { "Workspace", "ReplicatedStorage", "StarterGui", "ReplicatedFirst" }

local function nameMatchesAC(name)
    local lower = name:lower()
    for _, pat in ipairs(AC_PATTERNS) do
        if lower:find(pat, 1, true) then return true end
    end
    return false
end

local function scanForAC(root, found)
    local ok, kids = pcall(function() return root:GetChildren() end)
    if not ok then return end
    for _, child in ipairs(kids) do
        local okN, nm  = pcall(function() return child.Name      end)
        local okC, cls = pcall(function() return child.ClassName end)
        if okN and okC then
            if nameMatchesAC(nm) then
                table.insert(found, child)
            end
            -- recurse only into containers, not every instance (performance)
            if cls == "Folder" or cls == "Model" or cls:find("Script") == nil then
                scanForAC(child, found)
            end
        end
    end
end

BtnRemoveAC.MouseButton1Click:Connect(function()
    LogText.Text = "Scanning for anti-cheats..."
    task.wait(0.05)

    local found   = {}
    local removed = {}
    local failed  = {}

    for _, svcName in ipairs(AC_SEARCH) do
        local svc = safeGet(svcName)
        if svc then scanForAC(svc, found) end
    end

    if #found == 0 then
        LogText.Text = "No anti-cheat scripts detected."
        return
    end

    for _, inst in ipairs(found) do
        local nm  = pcall(function() return inst.Name end) and inst.Name or "?"
        -- Try disabling first (scripts), then destroying
        local ok, e = pcall(function()
            if inst:IsA("BaseScript") then
                inst.Disabled = true
            end
            inst:Destroy()
        end)
        if ok then
            table.insert(removed, nm)
        else
            table.insert(failed, nm .. " (" .. tostring(e):sub(1,40) .. ")")
        end
    end

    local log = {}
    table.insert(log, string.format("Scan complete — %d found\n", #found))
    if #removed > 0 then
        table.insert(log, "Removed (" .. #removed .. "):")
        for _, n in ipairs(removed) do table.insert(log, "  + " .. n) end
    end
    if #failed > 0 then
        table.insert(log, "\nFailed (" .. #failed .. "):")
        for _, n in ipairs(failed) do table.insert(log, "  x " .. n) end
    end
    LogText.Text = table.concat(log, "\n")
end)

BtnACReset.MouseButton1Click:Connect(function()
    LogText.Text = "Press [Remove ACs] to begin."
    LogScroll.CanvasPosition = Vector2.zero
end)

----------------------------------------------------------------
-- OPEN ANIMATION
----------------------------------------------------------------
Main.BackgroundTransparency = 1
Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2 + 16)
TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
    BackgroundTransparency = 0,
    Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
}):Play()
task.delay(0.08, function()
    for _, o in ipairs(Main:GetDescendants()) do
        if o:IsA("Frame") or o:IsA("TextButton") or o:IsA("TextLabel") then
            if o.BackgroundTransparency < 1 then
                TweenService:Create(o, TweenInfo.new(0.18), { BackgroundTransparency = 0 }):Play()
            end
            if o:IsA("TextLabel") or o:IsA("TextButton") then
                TweenService:Create(o, TweenInfo.new(0.18), { TextTransparency = 0 }):Play()
            end
        end
    end
end)

print("[ExploitMenu v2] Ready.")
