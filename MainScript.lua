-- ╔══════════════════════════════════════════════════════════╗
-- ║          Personal Exploit Menu — Structure Scanner       ║
-- ╚══════════════════════════════════════════════════════════╝

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ─── Services to scan ────────────────────────────────────────────────────────
local SCAN_TARGETS = {
    "Workspace",
    "ReplicatedStorage",
    "ReplicatedFirst",
    "StarterGui",
    "StarterPack",
    "StarterPlayer",
    "Lighting",
    "SoundService",
    "Chat",
    "Teams",
}

-- ─── Destroy old GUI if re-run ────────────────────────────────────────────────
if PlayerGui:FindFirstChild("ExploitMenuGui") then
    PlayerGui.ExploitMenuGui:Destroy()
end

-- ═══════════════════════════════════════════════════════════════════════════════
--  THEME
-- ═══════════════════════════════════════════════════════════════════════════════
local THEME = {
    BG          = Color3.fromRGB(18,  18,  24),
    SURFACE     = Color3.fromRGB(26,  26,  36),
    ACCENT      = Color3.fromRGB(120, 80, 220),
    ACCENT2     = Color3.fromRGB(80,  160, 255),
    TEXT        = Color3.fromRGB(230, 230, 240),
    TEXT_DIM    = Color3.fromRGB(130, 130, 155),
    BTN_CLIP    = Color3.fromRGB(100, 60,  200),
    BTN_COPY    = Color3.fromRGB(40,  130, 200),
    BTN_RESET   = Color3.fromRGB(180, 45,  70),
    BORDER      = Color3.fromRGB(50,  50,  70),
    OUTPUT_BG   = Color3.fromRGB(12,  12,  18),
}

-- ═══════════════════════════════════════════════════════════════════════════════
--  HELPERS
-- ═══════════════════════════════════════════════════════════════════════════════
local function newInstance(cls, props, parent)
    local obj = Instance.new(cls)
    for k, v in pairs(props) do
        obj[k] = v
    end
    if parent then obj.Parent = parent end
    return obj
end

local function addCorner(parent, radius)
    return newInstance("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, parent)
end

local function addStroke(parent, color, thickness)
    return newInstance("UIStroke", {
        Color     = color or THEME.BORDER,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

-- ═══════════════════════════════════════════════════════════════════════════════
--  ROOT GUI
-- ═══════════════════════════════════════════════════════════════════════════════
local ScreenGui = newInstance("ScreenGui", {
    Name             = "ExploitMenuGui",
    ResetOnSpawn     = false,
    ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset   = true,
}, PlayerGui)

-- ─── Main Window ─────────────────────────────────────────────────────────────
local WIN_W, WIN_H = 540, 480

local MainFrame = newInstance("Frame", {
    Name            = "MainFrame",
    Size            = UDim2.fromOffset(WIN_W, WIN_H),
    Position        = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
    BackgroundColor3 = THEME.BG,
    ClipsDescendants = true,
}, ScreenGui)
addCorner(MainFrame, 12)
addStroke(MainFrame, THEME.BORDER, 1)

-- ─── Top bar ─────────────────────────────────────────────────────────────────
local TopBar = newInstance("Frame", {
    Name            = "TopBar",
    Size            = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = THEME.SURFACE,
    BorderSizePixel = 0,
}, MainFrame)

newInstance("UICorner", { CornerRadius = UDim.new(0, 12) }, TopBar)

-- Flatten bottom corners of top bar
newInstance("Frame", {
    Size            = UDim2.new(1, 0, 0.5, 0),
    Position        = UDim2.new(0, 0, 0.5, 0),
    BackgroundColor3 = THEME.SURFACE,
    BorderSizePixel = 0,
    ZIndex          = 2,
}, TopBar)

-- Accent stripe
local AccentStripe = newInstance("Frame", {
    Size            = UDim2.new(0, 4, 1, -12),
    Position        = UDim2.new(0, 10, 0, 6),
    BackgroundColor3 = THEME.ACCENT,
    ZIndex          = 3,
}, TopBar)
addCorner(AccentStripe, 3)

-- Title
newInstance("TextLabel", {
    Text            = "⚙  Personal Exploit Menu",
    Font            = Enum.Font.GothamBold,
    TextSize        = 14,
    TextColor3      = THEME.TEXT,
    Size            = UDim2.new(1, -50, 1, 0),
    Position        = UDim2.new(0, 22, 0, 0),
    BackgroundTransparency = 1,
    TextXAlignment  = Enum.TextXAlignment.Left,
    ZIndex          = 4,
}, TopBar)

-- Close button
local CloseBtn = newInstance("TextButton", {
    Text            = "✕",
    Font            = Enum.Font.GothamBold,
    TextSize        = 14,
    TextColor3      = THEME.TEXT_DIM,
    Size            = UDim2.fromOffset(30, 30),
    Position        = UDim2.new(1, -35, 0.5, -15),
    BackgroundColor3 = Color3.fromRGB(60, 30, 30),
    ZIndex          = 5,
}, TopBar)
addCorner(CloseBtn, 6)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ─── Dragging ────────────────────────────────────────────────────────────────
do
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ─── Tab bar ─────────────────────────────────────────────────────────────────
local TabBar = newInstance("Frame", {
    Name            = "TabBar",
    Size            = UDim2.new(1, -20, 0, 32),
    Position        = UDim2.new(0, 10, 0, 46),
    BackgroundColor3 = THEME.SURFACE,
    BorderSizePixel = 0,
}, MainFrame)
addCorner(TabBar, 8)

local TabLayout = newInstance("UIListLayout", {
    FillDirection   = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    Padding         = UDim.new(0, 4),
    SortOrder       = Enum.SortOrder.LayoutOrder,
}, TabBar)

newInstance("UIPadding", {
    PaddingLeft  = UDim.new(0, 6),
    PaddingRight = UDim.new(0, 6),
    PaddingTop   = UDim.new(0, 4),
    PaddingBottom = UDim.new(0, 4),
}, TabBar)

local function makeTab(label, active)
    local btn = newInstance("TextButton", {
        Text            = label,
        Font            = Enum.Font.GothamSemibold,
        TextSize        = 12,
        TextColor3      = active and THEME.TEXT or THEME.TEXT_DIM,
        AutomaticSize   = Enum.AutomaticSize.X,
        Size            = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = active and THEME.ACCENT or THEME.BG,
        BorderSizePixel = 0,
    }, TabBar)
    addCorner(btn, 6)
    newInstance("UIPadding", {
        PaddingLeft  = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
    }, btn)
    return btn
end

local StructureTab = makeTab("Structure", true)

-- ═══════════════════════════════════════════════════════════════════════════════
--  STRUCTURE PANEL
-- ═══════════════════════════════════════════════════════════════════════════════
local StructurePanel = newInstance("Frame", {
    Name            = "StructurePanel",
    Size            = UDim2.new(1, -20, 1, -126),
    Position        = UDim2.new(0, 10, 0, 86),
    BackgroundTransparency = 1,
}, MainFrame)

-- ─── Output box ──────────────────────────────────────────────────────────────
local OutputFrame = newInstance("Frame", {
    Size            = UDim2.new(1, 0, 1, -50),
    Position        = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = THEME.OUTPUT_BG,
}, StructurePanel)
addCorner(OutputFrame, 8)
addStroke(OutputFrame, THEME.BORDER, 1)

local ScrollFrame = newInstance("ScrollingFrame", {
    Size            = UDim2.new(1, -8, 1, -8),
    Position        = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = THEME.ACCENT,
    CanvasSize      = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, OutputFrame)

local OutputLabel = newInstance("TextLabel", {
    Name            = "OutputLabel",
    Text            = "Press  [Clip]  to scan the game structure.",
    Font            = Enum.Font.Code,
    TextSize        = 12,
    TextColor3      = THEME.TEXT_DIM,
    Size            = UDim2.new(1, -10, 0, 0),
    Position        = UDim2.new(0, 5, 0, 5),
    BackgroundTransparency = 1,
    TextXAlignment  = Enum.TextXAlignment.Left,
    TextYAlignment  = Enum.TextYAlignment.Top,
    TextWrapped     = true,
    AutomaticSize   = Enum.AutomaticSize.Y,
    RichText        = true,
}, ScrollFrame)

-- ─── Button row ──────────────────────────────────────────────────────────────
local BtnRow = newInstance("Frame", {
    Size            = UDim2.new(1, 0, 0, 38),
    Position        = UDim2.new(0, 0, 1, -38),
    BackgroundTransparency = 1,
}, StructurePanel)

local BtnLayout = newInstance("UIListLayout", {
    FillDirection   = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Padding         = UDim.new(0, 8),
    SortOrder       = Enum.SortOrder.LayoutOrder,
}, BtnRow)

local function makeButton(label, color, order)
    local btn = newInstance("TextButton", {
        Text            = label,
        Font            = Enum.Font.GothamBold,
        TextSize        = 13,
        TextColor3      = Color3.new(1, 1, 1),
        Size            = UDim2.new(0, 148, 1, 0),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        LayoutOrder     = order,
        AutoButtonColor = false,
    }, BtnRow)
    addCorner(btn, 8)
    addStroke(btn, color:lerp(Color3.new(1,1,1), 0.15), 1)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = color:lerp(Color3.new(1,1,1), 0.12)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = color
        }):Play()
    end)
    return btn
end

local ClipBtn  = makeButton("⬡  Clip",  THEME.BTN_CLIP,  1)
local CopyBtn  = makeButton("⎘  Copy",  THEME.BTN_COPY,  2)
local ResetBtn = makeButton("↺  Reset", THEME.BTN_RESET, 3)

-- ═══════════════════════════════════════════════════════════════════════════════
--  STRUCTURE SCANNER LOGIC
-- ═══════════════════════════════════════════════════════════════════════════════
local lastOutput = ""

local function getServiceSafe(name)
    local ok, result = pcall(function()
        return game:GetService(name)
    end)
    if ok then return result end
    -- Fallback: direct index
    ok, result = pcall(function()
        return game[name]
    end)
    return ok and result or nil
end

local function buildTree(instance, depth, lines)
    local indent = string.rep("  ", depth)
    local className = instance.ClassName
    local name      = instance.Name

    -- Colour-code by class family
    local tag
    if className:find("Script") then
        tag = string.format('<font color="#a8ff78">%s</font>', className)
    elseif className:find("Model") or className == "Folder" then
        tag = string.format('<font color="#ffd700">%s</font>', className)
    elseif className:find("Part") or className:find("Mesh") or className:find("Union") then
        tag = string.format('<font color="#78c8ff">%s</font>', className)
    elseif className:find("Remote") then
        tag = string.format('<font color="#ff9f78">%s</font>', className)
    elseif className:find("Value") or className:find("Attribute") then
        tag = string.format('<font color="#c878ff">%s</font>', className)
    elseif className:find("Gui") or className:find("Frame") or className:find("Label") or className:find("Button") then
        tag = string.format('<font color="#ff78c8">%s</font>', className)
    else
        tag = string.format('<font color="#aaaacc">%s</font>', className)
    end

    local nameTag = string.format('<font color="#e8e8ff">%s</font>', name)
    table.insert(lines, indent .. tag .. "  " .. nameTag)

    -- Recurse (pcall to guard locked descendants)
    local ok, children = pcall(function()
        return instance:GetChildren()
    end)
    if ok then
        for _, child in ipairs(children) do
            buildTree(child, depth + 1, lines)
        end
    end
end

local function runClip()
    -- Flash button
    TweenService:Create(ClipBtn, TweenInfo.new(0.08), {
        BackgroundColor3 = THEME.BTN_CLIP:lerp(Color3.new(1,1,1), 0.25)
    }):Play()
    task.delay(0.15, function()
        TweenService:Create(ClipBtn, TweenInfo.new(0.12), {
            BackgroundColor3 = THEME.BTN_CLIP
        }):Play()
    end)

    OutputLabel.Text = '<font color="#ffd700">⟳ Scanning game structure…</font>'
    task.wait()

    local lines = {}

    -- Header
    table.insert(lines, string.format(
        '<font color="#888aaa">— Scanned: %s  |  PlaceId: %d —</font>',
        os.date("%H:%M:%S"), game.PlaceId
    ))
    table.insert(lines, "")

    for _, serviceName in ipairs(SCAN_TARGETS) do
        local service = getServiceSafe(serviceName)
        if service then
            table.insert(lines, string.format(
                '<font color="#ff9f78" size="13">▶ %s</font>',
                serviceName
            ))
            local ok, children = pcall(function() return service:GetChildren() end)
            if ok then
                for _, child in ipairs(children) do
                    buildTree(child, 1, lines)
                end
            else
                table.insert(lines, '  <font color="#ff5555">[Access Denied]</font>')
            end
            table.insert(lines, "")
        else
            table.insert(lines, string.format(
                '<font color="#555577">▷ %s  <font color="#ff5555">[Not Found]</font></font>',
                serviceName
            ))
            table.insert(lines, "")
        end
    end

    -- Plain-text version for clipboard (strip rich-text tags)
    local plainLines = {}
    for _, l in ipairs(lines) do
        table.insert(plainLines, l:gsub("<[^>]+>", ""))
    end
    lastOutput = table.concat(plainLines, "\n")

    OutputLabel.Text = table.concat(lines, "\n")
end

local function runCopy()
    if lastOutput == "" then
        OutputLabel.Text = '<font color="#ff5555">Nothing to copy — run Clip first.</font>'
        return
    end

    -- Flash button
    TweenService:Create(CopyBtn, TweenInfo.new(0.08), {
        BackgroundColor3 = THEME.BTN_COPY:lerp(Color3.new(1,1,1), 0.25)
    }):Play()
    task.delay(0.15, function()
        TweenService:Create(CopyBtn, TweenInfo.new(0.12), {
            BackgroundColor3 = THEME.BTN_COPY
        }):Play()
    end)

    -- Exploit clipboard (setclipboard is provided by most executors)
    local copied = false
    if setclipboard then
        pcall(setclipboard, lastOutput)
        copied = true
    elseif copystring then
        pcall(copystring, lastOutput)
        copied = true
    elseif Clipboard and Clipboard.set then
        pcall(Clipboard.set, lastOutput)
        copied = true
    end

    -- Brief status overlay
    local prev = OutputLabel.Text
    OutputLabel.Text = string.format(
        '<font color="#a8ff78">%s  Copied %d characters to clipboard!</font>',
        copied and "✓" or "ℹ", #lastOutput
    )
    task.delay(2, function()
        if OutputLabel and OutputLabel.Parent then
            OutputLabel.Text = prev
        end
    end)
end

local function runReset()
    -- Flash button
    TweenService:Create(ResetBtn, TweenInfo.new(0.08), {
        BackgroundColor3 = THEME.BTN_RESET:lerp(Color3.new(1,1,1), 0.25)
    }):Play()
    task.delay(0.15, function()
        TweenService:Create(ResetBtn, TweenInfo.new(0.12), {
            BackgroundColor3 = THEME.BTN_RESET
        }):Play()
    end)

    lastOutput = ""
    OutputLabel.Text = "Press  [Clip]  to scan the game structure."
    ScrollFrame.CanvasPosition = Vector2.zero
end

-- ─── Wire buttons ─────────────────────────────────────────────────────────────
ClipBtn.MouseButton1Click:Connect(function()
    task.spawn(runClip)
end)
CopyBtn.MouseButton1Click:Connect(function()
    task.spawn(runCopy)
end)
ResetBtn.MouseButton1Click:Connect(function()
    task.spawn(runReset)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
--  ENTRANCE ANIMATION
-- ═══════════════════════════════════════════════════════════════════════════════
MainFrame.BackgroundTransparency = 1
MainFrame.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2 + 20)

local function setTransparency(frame, value)
    for _, obj in ipairs(frame:GetDescendants()) do
        if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("TextButton") or
           obj:IsA("ScrollingFrame") then
            if obj.BackgroundTransparency < 1 then
                obj.BackgroundTransparency = value
            end
        end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            obj.TextTransparency = value
        end
    end
end

setTransparency(MainFrame, 1)

TweenService:Create(MainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {
    BackgroundTransparency = 0,
    Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
}):Play()
task.delay(0.05, function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        -- descendants handled individually below
    }):Play()
    for _, obj in ipairs(MainFrame:GetDescendants()) do
        if obj:IsA("Frame") and obj.BackgroundTransparency == 1 then
            -- keep fully transparent frames
        elseif obj:IsA("Frame") then
            TweenService:Create(obj, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if obj.BackgroundTransparency < 1 then
                TweenService:Create(obj, TweenInfo.new(0.25), { BackgroundTransparency = 0 }):Play()
            end
            TweenService:Create(obj, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
        end
    end
end)

print("[ExploitMenu] Loaded — drag the title bar to move, press Clip to scan.")
