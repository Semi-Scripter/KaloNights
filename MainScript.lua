-- MainMenu LocalScript
-- Place this inside StarterGui in Roblox Studio
-- ================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Pickup RemoteEvent (your game's real pickup system)
local PickUpItem = ReplicatedStorage:WaitForChild("Remotes")
    :WaitForChild("Interaction")
    :WaitForChild("PickUpItem")

-- ================================================
-- GUI SETUP
-- ================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainMenu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player.PlayerGui

-- Main window frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 1.5

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 2
titleBar.Parent = mainFrame

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

-- Patch to square off the bottom corners of title bar
local titlePatch = Instance.new("Frame", titleBar)
titlePatch.Size = UDim2.new(1, 0, 0.5, 0)
titlePatch.Position = UDim2.new(0, 0, 0.5, 0)
titlePatch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titlePatch.BorderSizePixel = 0
titlePatch.ZIndex = 2

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -45, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MENU"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextScaled = true
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 3

-- Close button
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.ZIndex = 5
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- ================================================
-- SECTION: "Main"
-- ================================================

local sectionLabel = Instance.new("TextLabel", mainFrame)
sectionLabel.Size = UDim2.new(1, -20, 0, 22)
sectionLabel.Position = UDim2.new(0, 10, 0, 46)
sectionLabel.BackgroundTransparency = 1
sectionLabel.Text = "── Main ──"
sectionLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
sectionLabel.Font = Enum.Font.GothamBold
sectionLabel.TextScaled = true
sectionLabel.ZIndex = 2

-- ================================================
-- TOGGLE: Auto Store Fuel
-- ================================================

local toggleRow = Instance.new("Frame", mainFrame)
toggleRow.Name = "AutoStoreFuelRow"
toggleRow.Size = UDim2.new(1, -20, 0, 42)
toggleRow.Position = UDim2.new(0, 10, 0, 75)
toggleRow.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
toggleRow.BorderSizePixel = 0
toggleRow.ZIndex = 2
Instance.new("UICorner", toggleRow).CornerRadius = UDim.new(0, 8)

local rowStroke = Instance.new("UIStroke", toggleRow)
rowStroke.Color = Color3.fromRGB(50, 50, 50)
rowStroke.Thickness = 1

local rowLabel = Instance.new("TextLabel", toggleRow)
rowLabel.Size = UDim2.new(1, -70, 1, 0)
rowLabel.Position = UDim2.new(0, 12, 0, 0)
rowLabel.BackgroundTransparency = 1
rowLabel.Text = "Auto Store Fuel"
rowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
rowLabel.Font = Enum.Font.Gotham
rowLabel.TextScaled = true
rowLabel.TextXAlignment = Enum.TextXAlignment.Left
rowLabel.ZIndex = 3

-- Toggle pill
local pill = Instance.new("Frame", toggleRow)
pill.Size = UDim2.new(0, 48, 0, 26)
pill.Position = UDim2.new(1, -58, 0.5, -13)
pill.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
pill.BorderSizePixel = 0
pill.ZIndex = 3
Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

local circle = Instance.new("Frame", pill)
circle.Size = UDim2.new(0, 20, 0, 20)
circle.Position = UDim2.new(0, 3, 0.5, -10)
circle.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
circle.BorderSizePixel = 0
circle.ZIndex = 4
Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

-- Invisible click catcher over the whole row
local clickCatcher = Instance.new("TextButton", toggleRow)
clickCatcher.Size = UDim2.new(1, 0, 1, 0)
clickCatcher.BackgroundTransparency = 1
clickCatcher.Text = ""
clickCatcher.ZIndex = 5

-- ================================================
-- OPEN BUTTON (shown when menu is closed)
-- ================================================

local openBtn = Instance.new("TextButton", screenGui)
openBtn.Name = "OpenBtn"
openBtn.Size = UDim2.new(0, 38, 0, 38)
openBtn.Position = UDim2.new(0, 10, 0.5, -19)
openBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
openBtn.BorderSizePixel = 0
openBtn.Text = "☰"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextScaled = true
openBtn.Visible = false
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)

local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Color = Color3.fromRGB(255, 255, 255)
openStroke.Thickness = 1.5

-- ================================================
-- TOGGLE ANIMATION
-- ================================================

local isEnabled = false
local loopThread = nil

local function animateToggle(state)
    TweenService:Create(pill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = state
            and Color3.fromRGB(255, 255, 255)
            or Color3.fromRGB(55, 55, 55)
    }):Play()
    TweenService:Create(circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Position = state
            and UDim2.new(1, -23, 0.5, -10)
            or UDim2.new(0, 3, 0.5, -10),
        BackgroundColor3 = state
            and Color3.fromRGB(0, 0, 0)
            or Color3.fromRGB(180, 180, 180)
    }):Play()
end

-- ================================================
-- AUTO STORE FUEL LOGIC
-- ================================================

local function getFuelItems()
    local droppedItems = workspace:FindFirstChild("DroppedItems")
    if not droppedItems then return {} end

    local found = {}
    for _, item in ipairs(droppedItems:GetChildren()) do
        local name = item.Name
        -- Matches both "Fuel" and "Refined Fuel" exactly
        if name == "Fuel" or name == "Refined Fuel" then
            table.insert(found, item)
        end
    end
    return found
end

local function getBasePart(model)
    if model:IsA("Model") then
        return model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end

local function teleportTo(item)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local part = getBasePart(item)
    if not hrp or not part then return end

    -- Teleport slightly above the item so physics settles
    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 4, 0))
    task.wait(0.3)
end

local function pickUpItem(item)
    -- Fire your game's real pickup RemoteEvent
    -- The server will handle moving it into BackpackStorage
    if item and item.Parent then
        PickUpItem:FireServer(item)
    end
end

local function startLoop()
    loopThread = task.spawn(function()
        while isEnabled do
            local fuels = getFuelItems()
            if #fuels > 0 then
                for _, fuel in ipairs(fuels) do
                    if not isEnabled then break end
                    if fuel and fuel.Parent then
                        teleportTo(fuel)
                        pickUpItem(fuel)
                        task.wait(0.5)
                    end
                end
            end
            task.wait(1.5)
        end
        loopThread = nil
    end)
end

-- ================================================
-- BUTTON CONNECTIONS
-- ================================================

clickCatcher.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    animateToggle(isEnabled)
    if isEnabled then
        startLoop()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)
