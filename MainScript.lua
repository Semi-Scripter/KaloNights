-- LocalScript: Place in StarterPlayerScripts or StarterGui
-- Survive The Apocalypse — Kalo Menu

local Players             = game:GetService("Players")
local RunService          = game:GetService("RunService")
local TweenService        = game:GetService("TweenService")
local UserInputService    = game:GetService("UserInputService")
local ProximityPromptSvc  = game:GetService("ProximityPromptService")
local LocalPlayer         = Players.LocalPlayer
local PlayerGui           = LocalPlayer:WaitForChild("PlayerGui")
local Backpack            = LocalPlayer:WaitForChild("Backpack")

local DEFAULT_WALKSPEED = 16
local FAST_WALKSPEED    = 55

-- State
local walkSpeedEnabled      = false
local killAuraEnabled       = false
local killAuraRange         = 20
local killAuraConnection    = nil
local fuelCollectorEnabled  = false
local bagCollectorEnabled   = false
local instantPromptsEnabled = false
local godModeEnabled        = false
local savedPromptData       = {}
local godModeConnection     = nil
local godHumConnection      = nil

-- Active position-lock connections for Put In Bag
local bagLockConnections    = {}

local FUEL_ITEM_NAMES = {"Fuel"}

-- ============================================================
-- ITEMS LIST
-- ============================================================
local ITEM_LIST = {
    { section = "WEAPONS",    names = {"Knife","Bat","Crowbar","Machete","Pistol","Shotgun","Rifle","Sniper","Crossbow","AK47","M4A1","SMG","Revolver","RPG"} },
    { section = "THROWABLES", names = {"Grenade","Flashbang"} },
    { section = "MEDICAL",    names = {"Bandage","Bloxiade","Medkit"} },
    { section = "FOOD",       names = {"Beans","Chips","Tray","Spatula"} },
    { section = "AMMO",       names = {"Pistol Ammo","Medium Ammo","Long Ammo","Shells"} },
    { section = "RESOURCES",  names = {"Scrap","Screws","Battery","Fuel"} },
}

-- ============================================================
-- GUI SETUP
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaloMenu"; ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true; ScreenGui.Parent = PlayerGui

local KButton = Instance.new("TextButton")
KButton.Size = UDim2.new(0,44,0,44); KButton.Position = UDim2.new(0,10,0,10)
KButton.BackgroundColor3 = Color3.fromRGB(100,80,255); KButton.BorderSizePixel = 0
KButton.Text = "K"; KButton.TextColor3 = Color3.fromRGB(255,255,255)
KButton.TextSize = 20; KButton.Font = Enum.Font.GothamBlack
KButton.Visible = false; KButton.ZIndex = 10; KButton.Parent = ScreenGui
Instance.new("UICorner",KButton).CornerRadius = UDim.new(0,10)
local ks = Instance.new("UIStroke",KButton); ks.Color=Color3.fromRGB(160,140,255); ks.Thickness=2

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"; MainFrame.Size = UDim2.new(0,264,0,470)
MainFrame.Position = UDim2.new(0,10,0,10)
MainFrame.BackgroundColor3 = Color3.fromRGB(18,18,24); MainFrame.BorderSizePixel = 0
MainFrame.Active = true; MainFrame.Draggable = true; MainFrame.Parent = ScreenGui
Instance.new("UICorner",MainFrame).CornerRadius = UDim.new(0,12)
local ms = Instance.new("UIStroke",MainFrame); ms.Color=Color3.fromRGB(100,80,255); ms.Thickness=2

local TitleBar = Instance.new("Frame",MainFrame)
TitleBar.Size = UDim2.new(1,0,0,44); TitleBar.BackgroundColor3 = Color3.fromRGB(30,20,60)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner",TitleBar).CornerRadius = UDim.new(0,12)
local tbp = Instance.new("Frame",TitleBar)
tbp.Size=UDim2.new(1,0,0,12); tbp.Position=UDim2.new(0,0,1,-12)
tbp.BackgroundColor3=Color3.fromRGB(30,20,60); tbp.BorderSizePixel=0

local HeaderLabel = Instance.new("TextLabel",TitleBar)
HeaderLabel.Size=UDim2.new(1,-88,1,0); HeaderLabel.Position=UDim2.new(0,44,0,0)
HeaderLabel.BackgroundTransparency=1; HeaderLabel.Text="Kalo"
HeaderLabel.TextColor3=Color3.fromRGB(255,255,255); HeaderLabel.TextSize=22
HeaderLabel.Font=Enum.Font.GothamBlack; HeaderLabel.TextXAlignment=Enum.TextXAlignment.Center

local MinBtn = Instance.new("TextButton",TitleBar)
MinBtn.Size=UDim2.new(0,36,0,36); MinBtn.Position=UDim2.new(1,-80,0,4)
MinBtn.BackgroundColor3=Color3.fromRGB(50,40,100); MinBtn.BorderSizePixel=0
MinBtn.Text="-"; MinBtn.TextColor3=Color3.fromRGB(200,200,255)
MinBtn.TextSize=20; MinBtn.Font=Enum.Font.GothamBold
Instance.new("UICorner",MinBtn).CornerRadius=UDim.new(0,8)

local CloseBtn = Instance.new("TextButton",TitleBar)
CloseBtn.Size=UDim2.new(0,36,0,36); CloseBtn.Position=UDim2.new(1,-40,0,4)
CloseBtn.BackgroundColor3=Color3.fromRGB(160,40,60); CloseBtn.BorderSizePixel=0
CloseBtn.Text="X"; CloseBtn.TextColor3=Color3.fromRGB(255,255,255)
CloseBtn.TextSize=16; CloseBtn.Font=Enum.Font.GothamBold
Instance.new("UICorner",CloseBtn).CornerRadius=UDim.new(0,8)

-- 3-tab bar
local TabBar = Instance.new("Frame",MainFrame)
TabBar.Size=UDim2.new(1,-16,0,34); TabBar.Position=UDim2.new(0,8,0,48)
TabBar.BackgroundColor3=Color3.fromRGB(24,24,34); TabBar.BorderSizePixel=0
Instance.new("UICorner",TabBar).CornerRadius=UDim.new(0,8)
local tbl=Instance.new("UIListLayout",TabBar)
tbl.FillDirection=Enum.FillDirection.Horizontal; tbl.Padding=UDim.new(0,3)
local tbpad=Instance.new("UIPadding",TabBar)
tbpad.PaddingLeft=UDim.new(0,3); tbpad.PaddingTop=UDim.new(0,3); tbpad.PaddingBottom=UDim.new(0,3)

local function makeTab(label,order)
    local btn=Instance.new("TextButton",TabBar)
    btn.Size=UDim2.new(1/3,-3,1,0); btn.BackgroundColor3=Color3.fromRGB(40,30,80)
    btn.BorderSizePixel=0; btn.Text=label
    btn.TextColor3=Color3.fromRGB(180,170,255); btn.TextSize=12
    btn.Font=Enum.Font.GothamSemibold; btn.LayoutOrder=order
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
    return btn
end
local TabMenu=makeTab("Menu",1); local TabItems=makeTab("Items",2); local TabStructure=makeTab("Structure",3)

-- Content panels
local MenuContent = Instance.new("Frame",MainFrame)
MenuContent.Size=UDim2.new(1,-16,1,-92); MenuContent.Position=UDim2.new(0,8,0,88)
MenuContent.BackgroundTransparency=1

local ScrollFrame = Instance.new("ScrollingFrame",MenuContent)
ScrollFrame.Size=UDim2.new(1,0,1,0); ScrollFrame.BackgroundTransparency=1
ScrollFrame.BorderSizePixel=0; ScrollFrame.ScrollBarThickness=3
ScrollFrame.ScrollBarImageColor3=Color3.fromRGB(100,80,255)
ScrollFrame.CanvasSize=UDim2.new(0,0,0,0); ScrollFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y
ScrollFrame.ScrollingDirection=Enum.ScrollingDirection.Y
local ListLayout=Instance.new("UIListLayout",ScrollFrame)
ListLayout.SortOrder=Enum.SortOrder.LayoutOrder; ListLayout.Padding=UDim.new(0,8)
Instance.new("UIPadding",ScrollFrame).PaddingBottom=UDim.new(0,8)

local ItemsContent = Instance.new("Frame",MainFrame)
ItemsContent.Size=UDim2.new(1,-16,1,-92); ItemsContent.Position=UDim2.new(0,8,0,88)
ItemsContent.BackgroundTransparency=1; ItemsContent.Visible=false

local ItemsScroll = Instance.new("ScrollingFrame",ItemsContent)
ItemsScroll.Size=UDim2.new(1,0,1,-28); ItemsScroll.BackgroundTransparency=1
ItemsScroll.BorderSizePixel=0; ItemsScroll.ScrollBarThickness=3
ItemsScroll.ScrollBarImageColor3=Color3.fromRGB(100,80,255)
ItemsScroll.CanvasSize=UDim2.new(0,0,0,0); ItemsScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
ItemsScroll.ScrollingDirection=Enum.ScrollingDirection.Y
local isl=Instance.new("UIListLayout",ItemsScroll)
isl.SortOrder=Enum.SortOrder.LayoutOrder; isl.Padding=UDim.new(0,5)
Instance.new("UIPadding",ItemsScroll).PaddingBottom=UDim.new(0,8)

local ItemsFeedback = Instance.new("TextLabel",ItemsContent)
ItemsFeedback.Size=UDim2.new(1,0,0,24); ItemsFeedback.Position=UDim2.new(0,0,1,-24)
ItemsFeedback.BackgroundColor3=Color3.fromRGB(22,22,32); ItemsFeedback.BorderSizePixel=0
ItemsFeedback.Text="Tap an item to grab it"; ItemsFeedback.TextColor3=Color3.fromRGB(140,130,200)
ItemsFeedback.TextSize=11; ItemsFeedback.Font=Enum.Font.Gotham
Instance.new("UICorner",ItemsFeedback).CornerRadius=UDim.new(0,6)

local StructureContent = Instance.new("Frame",MainFrame)
StructureContent.Size=UDim2.new(1,-16,1,-92); StructureContent.Position=UDim2.new(0,8,0,88)
StructureContent.BackgroundTransparency=1; StructureContent.Visible=false

-- Tab logic
local currentTab="menu"
local function switchTab(tab)
    currentTab=tab
    MenuContent.Visible=(tab=="menu")
    ItemsContent.Visible=(tab=="items")
    StructureContent.Visible=(tab=="structure")
    local function style(b,on)
        b.BackgroundColor3=on and Color3.fromRGB(100,80,255) or Color3.fromRGB(40,30,80)
        b.TextColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,170,255)
    end
    style(TabMenu,tab=="menu"); style(TabItems,tab=="items"); style(TabStructure,tab=="structure")
end
switchTab("menu")
TabMenu.MouseButton1Click:Connect(function() switchTab("menu") end)
TabItems.MouseButton1Click:Connect(function() switchTab("items") end)
TabStructure.MouseButton1Click:Connect(function() switchTab("structure") end)

local function closeGui() MainFrame.Visible=false; KButton.Visible=true end
local function openGui()  MainFrame.Visible=true;  KButton.Visible=false end
CloseBtn.MouseButton1Click:Connect(closeGui)
KButton.MouseButton1Click:Connect(openGui)

local minimized=false
local function toggleMinimize()
    minimized=not minimized; TabBar.Visible=not minimized
    if minimized then MenuContent.Visible=false; ItemsContent.Visible=false; StructureContent.Visible=false
    else switchTab(currentTab) end
    MainFrame.Size=minimized and UDim2.new(0,264,0,44) or UDim2.new(0,264,0,470)
    MinBtn.Text=minimized and "+" or "-"
end
MinBtn.MouseButton1Click:Connect(toggleMinimize)

-- ============================================================
-- UI HELPERS
-- ============================================================
local tweenInfo=TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local function animateToggle(track,knob,sl,on)
    TweenService:Create(knob,tweenInfo,on
        and {Position=UDim2.new(1,-25,0.5,-11),BackgroundColor3=Color3.fromRGB(255,255,255)}
        or  {Position=UDim2.new(0,3,0.5,-11), BackgroundColor3=Color3.fromRGB(180,180,200)}):Play()
    TweenService:Create(track,tweenInfo,on
        and {BackgroundColor3=Color3.fromRGB(100,80,255)}
        or  {BackgroundColor3=Color3.fromRGB(60,60,80)}):Play()
    sl.Text=on and "ON" or "OFF"
    sl.TextColor3=on and Color3.fromRGB(160,140,255) or Color3.fromRGB(120,120,150)
end

local function createToggleRow(labelText,layoutOrder)
    local Row=Instance.new("Frame",ScrollFrame)
    Row.Size=UDim2.new(1,0,0,52); Row.BackgroundColor3=Color3.fromRGB(28,28,38)
    Row.BorderSizePixel=0; Row.LayoutOrder=layoutOrder
    Instance.new("UICorner",Row).CornerRadius=UDim.new(0,10)
    local L=Instance.new("TextLabel",Row)
    L.Size=UDim2.new(1,-80,1,0); L.Position=UDim2.new(0,12,0,0)
    L.BackgroundTransparency=1; L.Text=labelText
    L.TextColor3=Color3.fromRGB(220,220,240); L.TextSize=14
    L.Font=Enum.Font.GothamSemibold; L.TextXAlignment=Enum.TextXAlignment.Left
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
    return Row,Track,Knob,SL,Btn
end

local function createInfoRow(defaultText,layoutOrder)
    local Row=Instance.new("Frame",ScrollFrame)
    Row.Size=UDim2.new(1,0,0,28); Row.BackgroundColor3=Color3.fromRGB(22,22,32)
    Row.BorderSizePixel=0; Row.LayoutOrder=layoutOrder
    Instance.new("UICorner",Row).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",Row).Color=Color3.fromRGB(60,50,100)
    local L=Instance.new("TextLabel",Row)
    L.Size=UDim2.new(1,-10,1,0); L.Position=UDim2.new(0,8,0,0)
    L.BackgroundTransparency=1; L.Text=defaultText
    L.TextColor3=Color3.fromRGB(140,130,200); L.TextSize=11
    L.Font=Enum.Font.Gotham; L.TextXAlignment=Enum.TextXAlignment.Left; L.TextWrapped=true
    return L
end

local function createSectionLabel(text,order)
    local L=Instance.new("TextLabel",ScrollFrame)
    L.Size=UDim2.new(1,0,0,18); L.BackgroundTransparency=1
    L.Text=text; L.TextColor3=Color3.fromRGB(110,90,200)
    L.TextSize=11; L.Font=Enum.Font.GothamBold
    L.TextXAlignment=Enum.TextXAlignment.Left; L.LayoutOrder=order
    Instance.new("UIPadding",L).PaddingLeft=UDim.new(0,4)
end

-- ============================================================
-- CORE HELPERS
-- ============================================================
local function getModelPart(obj)
    if obj:IsA("BasePart") then return obj end
    return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true)
end

local function unanchorAll(obj)
    for _,p in ipairs(obj:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Anchored=false; p.AssemblyLinearVelocity=Vector3.zero; p.AssemblyAngularVelocity=Vector3.zero
        end
    end
    if obj:IsA("BasePart") then obj.Anchored=false end
end

local function claimOwnership(item)
    -- 1. Fire the game's own RequestNetworkOwnership remote
    local drag=item:FindFirstChild("ItemDrag")
    if drag then
        local req=drag:FindFirstChild("RequestNetworkOwnership")
        if req and req:IsA("RemoteEvent") then pcall(function() req:FireServer() end) end
    end
    -- 2. Try executor-level network owner override on every BasePart
    for _,p in ipairs(item:GetDescendants()) do
        if p:IsA("BasePart") then pcall(function() p:SetNetworkOwner(LocalPlayer) end) end
    end
    if item:IsA("BasePart") then pcall(function() item:SetNetworkOwner(LocalPlayer) end) end
end

-- Search the whole game for an object by name and class filter
local function findObject(name, classFilter)
    local services = {workspace, game:GetService("ReplicatedStorage"), game:GetService("ServerStorage")}
    for _,svc in ipairs(services) do
        pcall(function()
            for _,obj in ipairs(svc:GetDescendants()) do
                if obj.Name==name then
                    if classFilter==nil or obj:IsA(classFilter) then return obj end
                end
            end
        end)
    end
    -- Broad workspace scan
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj.Name==name then
            if classFilter==nil or obj:IsA(classFilter) then return obj end
        end
    end
    return nil
end

local function findModelInWorkspace(name)
    for _,obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("Tool")) and obj.Name==name then return obj end
    end
    return nil
end

local function findPartInModel(model,partName)
    for _,d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") and d.Name==partName then return d end
    end
end

local function getDroppedItems(names)
    local folder=workspace:FindFirstChild("DroppedItems"); if not folder then return {} end
    local results={}
    for _,child in ipairs(folder:GetChildren()) do
        for _,n in ipairs(names) do
            if child.Name==n then results[#results+1]=child; break end
        end
    end
    return results
end

local function getAllDroppedItems()
    local folder=workspace:FindFirstChild("DroppedItems"); if not folder then return {} end
    local r={}; for _,c in ipairs(folder:GetChildren()) do r[#r+1]=c end; return r
end

-- ============================================================
-- PUT IN BAG — REAL FIX
-- Strategy A: if item is a Tool → clone directly into Backpack
-- Strategy B: claim ownership + Heartbeat position-lock for 8s
--             so server-touch / proximity events can fire naturally
-- ============================================================
local function grabItem(item)
    local char=LocalPlayer.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    -- Strategy A: Tool → directly into Backpack
    if item:IsA("Tool") then
        pcall(function()
            local clone=item:Clone()
            clone.Parent=Backpack
        end)
        return true
    end

    -- Strategy B: claim ownership, unanchor, lock position via Heartbeat
    claimOwnership(item)
    task.wait(0.05)
    pcall(function() unanchorAll(item) end)

    -- Immediately place at player feet
    local targetCF=root.CFrame * CFrame.new(0,-2.5,0)
    pcall(function() item:PivotTo(targetCF) end)

    -- Lock position for 8 seconds so pickup triggers
    local lockEnd=tick()+8
    local conn
    conn=RunService.Heartbeat:Connect(function()
        if tick()>lockEnd then conn:Disconnect(); bagLockConnections[item]=nil; return end
        local r2=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if r2 then pcall(function() item:PivotTo(r2.CFrame * CFrame.new(0,-2.5,0)) end) end
    end)
    bagLockConnections[item]=conn
    return true
end

local function stopAllBagLocks()
    for item,conn in pairs(bagLockConnections) do
        pcall(function() conn:Disconnect() end)
    end
    bagLockConnections={}
end

local function collectAllToBag(infoLabel)
    local char=LocalPlayer.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then infoLabel.Text="No character"; infoLabel.TextColor3=Color3.fromRGB(255,100,100); return end

    local items=getAllDroppedItems()
    if #items==0 then infoLabel.Text="DroppedItems is empty"; infoLabel.TextColor3=Color3.fromRGB(255,200,80); return end

    local count=0
    for _,item in ipairs(items) do
        if grabItem(item) then count+=1 end
    end
    infoLabel.Text=count.." items grabbed / locked to you"
    infoLabel.TextColor3=Color3.fromRGB(120,255,160)
end

-- ============================================================
-- ITEM SPAWNER — Tab Items
-- Tools: clone to Backpack immediately
-- Models: search DroppedItems → workspace → ReplicatedStorage
-- ============================================================
local function spawnItem(itemName)
    local char=LocalPlayer.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        ItemsFeedback.Text="Respawn first"; ItemsFeedback.TextColor3=Color3.fromRGB(255,100,100); return
    end

    local target=nil

    -- 1. DroppedItems first
    local folder=workspace:FindFirstChild("DroppedItems")
    if folder then
        for _,c in ipairs(folder:GetChildren()) do
            if c.Name==itemName then target=c; break end
        end
    end

    -- 2. Anywhere in workspace
    if not target then target=findModelInWorkspace(itemName) end

    -- 3. ReplicatedStorage template → clone
    if not target then
        pcall(function()
            local RS=game:GetService("ReplicatedStorage")
            for _,obj in ipairs(RS:GetDescendants()) do
                if obj.Name==itemName then
                    local clone=obj:Clone(); clone.Parent=workspace
                    target=clone; break
                end
            end
        end)
    end

    if not target then
        ItemsFeedback.Text='"'..itemName..'" not found anywhere'
        ItemsFeedback.TextColor3=Color3.fromRGB(255,120,80); return
    end

    -- Tool → straight into Backpack
    if target:IsA("Tool") then
        pcall(function()
            local clone=target:Clone(); clone.Parent=Backpack
        end)
        ItemsFeedback.Text=itemName.." added to inventory!"
        ItemsFeedback.TextColor3=Color3.fromRGB(120,255,160)
        return
    end

    -- Model → ownership + position lock
    grabItem(target)
    ItemsFeedback.Text=itemName.." pulled to you — walk to pick up"
    ItemsFeedback.TextColor3=Color3.fromRGB(120,200,255)
end

-- ============================================================
-- FUEL COLLECTOR
-- ============================================================
local function collectFuel(infoLabel)
    local genModel=findModelInWorkspace("Generator")
    if not genModel then infoLabel.Text="Generator not found"; infoLabel.TextColor3=Color3.fromRGB(255,100,100); return end
    local fuelZone=findPartInModel(genModel,"FuelZone") or findPartInModel(genModel,"MainPart") or getModelPart(genModel)
    if not fuelZone then infoLabel.Text="FuelZone not found"; infoLabel.TextColor3=Color3.fromRGB(255,100,100); return end
    local items=getDroppedItems(FUEL_ITEM_NAMES)
    if #items==0 then infoLabel.Text="No Fuel in DroppedItems"; infoLabel.TextColor3=Color3.fromRGB(255,200,80); return end
    local zoneCF=fuelZone.CFrame; local count=0
    for _,item in ipairs(items) do
        claimOwnership(item); task.wait(0.02)
        pcall(function()
            unanchorAll(item)
            local pp=getModelPart(item)
            if pp then item:PivotTo(zoneCF*CFrame.new(0,0.5+count*0.2,0)); pp.AssemblyLinearVelocity=Vector3.new(0,-8,0); count+=1 end
        end)
    end
    infoLabel.Text=count.." Fuel → Generator FuelZone"; infoLabel.TextColor3=Color3.fromRGB(120,255,160)
end

local function makeCollector(fn, infoLabel, defaultText)
    local active=false
    local function loop()
        task.spawn(function()
            while active do fn(infoLabel); task.wait(3) end
        end)
    end
    return {
        enable  = function() active=true; loop() end,
        disable = function()
            active=false; stopAllBagLocks()
            infoLabel.Text=defaultText; infoLabel.TextColor3=Color3.fromRGB(140,130,200)
        end,
    }
end

-- ============================================================
-- BUILD ITEMS TAB
-- ============================================================
local SECTION_COLORS={WEAPONS=Color3.fromRGB(255,100,100),THROWABLES=Color3.fromRGB(255,180,60),MEDICAL=Color3.fromRGB(80,220,150),FOOD=Color3.fromRGB(120,200,255),AMMO=Color3.fromRGB(200,160,255),RESOURCES=Color3.fromRGB(255,220,80)}
local itemLO=0
for _,group in ipairs(ITEM_LIST) do
    itemLO+=1
    local secLbl=Instance.new("TextLabel",ItemsScroll)
    secLbl.Size=UDim2.new(1,0,0,16); secLbl.BackgroundTransparency=1; secLbl.LayoutOrder=itemLO
    secLbl.Text=group.section; secLbl.TextSize=10; secLbl.Font=Enum.Font.GothamBold
    secLbl.TextColor3=SECTION_COLORS[group.section] or Color3.fromRGB(160,140,255)
    secLbl.TextXAlignment=Enum.TextXAlignment.Left
    Instance.new("UIPadding",secLbl).PaddingLeft=UDim.new(0,4)

    local names=group.names
    for i=1,#names,2 do
        itemLO+=1
        local row=Instance.new("Frame",ItemsScroll)
        row.Size=UDim2.new(1,0,0,36); row.BackgroundTransparency=1; row.LayoutOrder=itemLO
        local rl=Instance.new("UIListLayout",row); rl.FillDirection=Enum.FillDirection.Horizontal; rl.Padding=UDim.new(0,5)

        local function makeItemBtn(name)
            local btn=Instance.new("TextButton",row)
            btn.Size=UDim2.new(0.5,-3,1,0); btn.BackgroundColor3=Color3.fromRGB(28,24,48)
            btn.BorderSizePixel=0; btn.Text=name
            btn.TextColor3=Color3.fromRGB(210,200,255); btn.TextSize=12
            btn.Font=Enum.Font.GothamSemibold; btn.TextWrapped=true
            Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
            local stk=Instance.new("UIStroke",btn); stk.Color=Color3.fromRGB(80,60,160); stk.Thickness=1
            btn.MouseButton1Click:Connect(function()
                btn.BackgroundColor3=Color3.fromRGB(100,80,255)
                task.delay(0.2,function() btn.BackgroundColor3=Color3.fromRGB(28,24,48) end)
                spawnItem(name)
            end)
        end

        makeItemBtn(names[i])
        if names[i+1] then makeItemBtn(names[i+1]) end
    end

    itemLO+=1
    local sp=Instance.new("Frame",ItemsScroll); sp.Size=UDim2.new(1,0,0,4); sp.BackgroundTransparency=1; sp.LayoutOrder=itemLO
end

-- ============================================================
-- MENU TAB FEATURES
-- ============================================================

-- WALKSPEED
createSectionLabel("MOVEMENT",0)
local _,wsTrack,wsKnob,wsStatus,wsBtn=createToggleRow("Walkspeed (55)",1)
local function setWalkSpeed(on)
    walkSpeedEnabled=on; animateToggle(wsTrack,wsKnob,wsStatus,on)
    local char=LocalPlayer.Character
    if char then local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed=on and FAST_WALKSPEED or DEFAULT_WALKSPEED end end
end
wsBtn.MouseButton1Click:Connect(function() setWalkSpeed(not walkSpeedEnabled) end)

-- KILL AURA
createSectionLabel("COMBAT",10)
local _,kaTrack,kaKnob,kaStatus,kaBtn=createToggleRow("Kill Aura",11)
local kaInfo=createInfoRow("Equip any weapon to activate",12)
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
SliderHandle.BackgroundColor3=Color3.fromRGB(255,255,255); SliderHandle.BorderSizePixel=0; SliderHandle.ZIndex=5
Instance.new("UICorner",SliderHandle).CornerRadius=UDim.new(1,0)
local sliderDrag=false
local function updateSlider(ix)
    local rel=math.clamp((ix-SliderTrack.AbsolutePosition.X)/SliderTrack.AbsoluteSize.X,0,1)
    killAuraRange=math.floor(rel*99+1); SliderFill.Size=UDim2.new(rel,0,1,0); SliderHandle.Position=UDim2.new(rel,0,0.5,0)
    RangeLabel.Text="Aura Range: "..killAuraRange.." studs"
end
SliderHandle.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliderDrag=true end end)
SliderTrack.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliderDrag=true; updateSlider(i.Position.X) end end)
UserInputService.InputChanged:Connect(function(i) if sliderDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then updateSlider(i.Position.X) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliderDrag=false end end)

local function isWeaponEquipped() local c=LocalPlayer.Character; return c and c:FindFirstChildOfClass("Tool")~=nil end
local function startKillAura()
    killAuraConnection=RunService.Heartbeat:Connect(function()
        if not isWeaponEquipped() then kaInfo.Text="Equip a weapon"; kaInfo.TextColor3=Color3.fromRGB(255,200,80); return end
        local char=LocalPlayer.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
        kaInfo.Text="Active — killing nearby enemies"; kaInfo.TextColor3=Color3.fromRGB(120,255,160)
        for _,model in ipairs(workspace:GetChildren()) do
            if model==char then continue end
            local isP=false
            for _,p in ipairs(Players:GetPlayers()) do if p.Character==model then isP=true; break end end
            if isP then continue end
            local hum=model:FindFirstChildOfClass("Humanoid") or model:FindFirstChildWhichIsA("Humanoid",true)
            if hum and hum.Health>0 then
                local rp=model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChildWhichIsA("BasePart")
                if rp and (root.Position-rp.Position).Magnitude<=killAuraRange then hum.Health=0 end
            end
        end
    end)
end
local function stopKillAura()
    if killAuraConnection then killAuraConnection:Disconnect(); killAuraConnection=nil end
    kaInfo.Text="Equip any weapon to activate"; kaInfo.TextColor3=Color3.fromRGB(140,130,200)
end
local function setKillAura(on) killAuraEnabled=on; animateToggle(kaTrack,kaKnob,kaStatus,on); if on then startKillAura() else stopKillAura() end end
kaBtn.MouseButton1Click:Connect(function() setKillAura(not killAuraEnabled) end)

-- COLLECTORS
createSectionLabel("COLLECTORS",20)
local _,fcTrack,fcKnob,fcStatus,fcBtn=createToggleRow("Fuel Collector",21)
local fuelInfo=createInfoRow("Sends Fuel to Generator FuelZone",22)
local fuelColl=makeCollector(collectFuel,fuelInfo,"Sends Fuel to Generator FuelZone")
local function setFuelCollector(on)
    fuelCollectorEnabled=on; animateToggle(fcTrack,fcKnob,fcStatus,on)
    if on then fuelColl.enable() else fuelColl.disable() end
end
fcBtn.MouseButton1Click:Connect(function() setFuelCollector(not fuelCollectorEnabled) end)

local _,bgTrack,bgKnob,bgStatus,bgBtn=createToggleRow("Put In Bag",23)
local bagInfo=createInfoRow("Grabs ALL dropped items — Tools go to inventory directly",24)
local bagColl=makeCollector(collectAllToBag,bagInfo,"Grabs ALL dropped items — Tools go to inventory directly")
local function setBagCollector(on)
    bagCollectorEnabled=on; animateToggle(bgTrack,bgKnob,bgStatus,on)
    if on then bagColl.enable() else bagColl.disable() end
end
bgBtn.MouseButton1Click:Connect(function() setBagCollector(not bagCollectorEnabled) end)

-- INSTANT PROMPTS
createSectionLabel("MISC",30)
local _,ipTrack,ipKnob,ipStatus,ipBtn=createToggleRow("Instant Prompts",31)
local promptAddedConn=nil
local function applyInstant(p) if not savedPromptData[p] then savedPromptData[p]={p.HoldDuration} end; p.HoldDuration=0 end
local function restorePrompt(p) if savedPromptData[p] then p.HoldDuration=savedPromptData[p][1]; savedPromptData[p]=nil end end
local function enableInstant()
    for _,o in ipairs(workspace:GetDescendants()) do if o:IsA("ProximityPrompt") then applyInstant(o) end end
    promptAddedConn=workspace.DescendantAdded:Connect(function(o) if o:IsA("ProximityPrompt") then task.wait(); applyInstant(o) end end)
end
local function disableInstant()
    if promptAddedConn then promptAddedConn:Disconnect(); promptAddedConn=nil end
    for pr in pairs(savedPromptData) do restorePrompt(pr) end
end
local function setInstant(on)
    instantPromptsEnabled=on; animateToggle(ipTrack,ipKnob,ipStatus,on)
    if on then enableInstant() else disableInstant() end
end
ipBtn.MouseButton1Click:Connect(function() setInstant(not instantPromptsEnabled) end)

-- GOD MODE
local _,gmTrack,gmKnob,gmStatus,gmBtn=createToggleRow("God Mode",32)
local godInfo=createInfoRow("HP locked — cannot die",33)
local GOD_HP=999999
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
    godInfo.Text="HP locked at max — cannot die"; godInfo.TextColor3=Color3.fromRGB(120,255,160)
end
local function stopGodMode()
    if godModeConnection then godModeConnection:Disconnect(); godModeConnection=nil end
    if godHumConnection  then godHumConnection:Disconnect(); godHumConnection=nil end
    local char=LocalPlayer.Character
    if char then local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.MaxHealth=100; hum.Health=100 end end
    godInfo.Text="HP locked — cannot die"; godInfo.TextColor3=Color3.fromRGB(140,130,200)
end
local function setGodMode(on)
    godModeEnabled=on; animateToggle(gmTrack,gmKnob,gmStatus,on)
    if on then local c=LocalPlayer.Character; if c then applyGodMode(c) end else stopGodMode() end
end
gmBtn.MouseButton1Click:Connect(function() setGodMode(not godModeEnabled) end)

-- ============================================================
-- REMOVE ANTI — MAXIMUM AGGRESSION
-- Targets: anti-cheat, anti-exploit, kick, ban, detect, monitor,
--          backdoor, guard, security scripts + remote events
-- Scans: workspace, ReplicatedStorage, ReplicatedFirst, StarterGui,
--        StarterPack, StarterPlayer, Lighting, Players, SoundService
-- ============================================================
createSectionLabel("ANTI-CHEAT",40)
local RARaw=Instance.new("Frame",ScrollFrame)
RARaw.Size=UDim2.new(1,0,0,44); RARaw.BackgroundColor3=Color3.fromRGB(28,20,20)
RARaw.BorderSizePixel=0; RARaw.LayoutOrder=41
Instance.new("UICorner",RARaw).CornerRadius=UDim.new(0,10)
local RABtn=Instance.new("TextButton",RARaw)
RABtn.Size=UDim2.new(1,-16,1,-12); RABtn.Position=UDim2.new(0,8,0,6)
RABtn.BackgroundColor3=Color3.fromRGB(160,40,60); RABtn.BorderSizePixel=0
RABtn.Text="Nuke All Anti-Cheat / Exploits"; RABtn.TextColor3=Color3.fromRGB(255,255,255)
RABtn.TextSize=13; RABtn.Font=Enum.Font.GothamSemibold
Instance.new("UICorner",RABtn).CornerRadius=UDim.new(0,8)
local RAInfo=createInfoRow("Destroys anti-cheat, anti-exploit, kick, ban, detect, guard scripts",42)

-- Keywords that flag a script as anti-cheat/exploit
local ANTI_KEYWORDS = {
    "anti","exploit","cheat","kick","ban","detect","backdoor",
    "byfron","hyperion","monitor","security","guard","protect",
    "punish","report","sanity","check","enforce","firewall",
}

local SCAN_SERVICES = {
    workspace,
    game:GetService("ReplicatedStorage"),
    game:GetService("ReplicatedFirst"),
    game:GetService("StarterGui"),
    game:GetService("StarterPack"),
    game:GetService("StarterPlayer"),
    game:GetService("Lighting"),
    game:GetService("SoundService"),
    game:GetService("Players"),
    game:GetService("Teams"),
}

local function nameMatches(name)
    local low=name:lower()
    for _,kw in ipairs(ANTI_KEYWORDS) do
        if low:find(kw,1,true) then return true end
    end
    return false
end

RABtn.MouseButton1Click:Connect(function()
    local killed=0
    for _,svc in ipairs(SCAN_SERVICES) do
        pcall(function()
            -- GetDescendants snapshot so we don't iterate a live-changing table
            local descendants=svc:GetDescendants()
            for _,obj in ipairs(descendants) do
                if not obj or not obj.Parent then continue end
                if nameMatches(obj.Name) then
                    -- Disable scripts immediately before destroy (stops execution)
                    if obj:IsA("BaseScript") then
                        pcall(function() obj.Disabled=true end)
                    end
                    -- Disconnect remote events so they can't fire server-side callbacks
                    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("BindableEvent") then
                        pcall(function() obj.OnClientEvent:Connect(function() end) end)
                    end
                    pcall(function() obj:Destroy() end)
                    killed+=1
                end
            end
        end)
    end

    -- Also nuke any LocalScripts inside PlayerGui that match
    pcall(function()
        for _,obj in ipairs(PlayerGui:GetDescendants()) do
            if obj:IsA("BaseScript") and nameMatches(obj.Name) then
                pcall(function() obj.Disabled=true; obj:Destroy() end)
                killed+=1
            end
        end
    end)

    RAInfo.Text=killed>0 and (killed.." anti-cheat objects destroyed!") or "Nothing flagged — already clean"
    RAInfo.TextColor3=killed>0 and Color3.fromRGB(120,255,160) or Color3.fromRGB(255,200,80)
end)

-- ============================================================
-- RESPAWN — reapply all active features
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    if walkSpeedEnabled then local hum=char:WaitForChild("Humanoid"); hum.WalkSpeed=FAST_WALKSPEED end
    if killAuraEnabled  then stopKillAura(); task.wait(0.5); startKillAura() end
    if instantPromptsEnabled then task.wait(1); disableInstant(); enableInstant() end
    if godModeEnabled then
        if godModeConnection then godModeConnection:Disconnect(); godModeConnection=nil end
        if godHumConnection  then godHumConnection:Disconnect(); godHumConnection=nil end
        task.wait(0.5); applyGodMode(char)
    end
end)

-- ============================================================
-- STRUCTURE PANEL
-- ============================================================
local scannedText=""
local SR1=Instance.new("Frame",StructureContent)
SR1.Size=UDim2.new(1,0,0,38); SR1.Position=UDim2.new(0,0,0,0); SR1.BackgroundTransparency=1
Instance.new("UIListLayout",SR1).FillDirection=Enum.FillDirection.Horizontal
Instance.new("UIListLayout",SR1).Padding=UDim.new(0,5)
local sr1l=SR1:FindFirstChildOfClass("UIListLayout"); sr1l.FillDirection=Enum.FillDirection.Horizontal; sr1l.Padding=UDim.new(0,5)

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

local SR2=Instance.new("Frame",StructureContent)
SR2.Size=UDim2.new(1,0,0,34); SR2.Position=UDim2.new(0,0,0,42); SR2.BackgroundTransparency=1
local sr2l=Instance.new("UIListLayout",SR2); sr2l.FillDirection=Enum.FillDirection.Horizontal; sr2l.Padding=UDim.new(0,5)

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

local ScanStatus=Instance.new("TextLabel",StructureContent)
ScanStatus.Size=UDim2.new(1,0,0,16); ScanStatus.Position=UDim2.new(0,0,0,80)
ScanStatus.BackgroundTransparency=1; ScanStatus.Text="Press Scan to inspect workspace"
ScanStatus.TextColor3=Color3.fromRGB(120,110,180); ScanStatus.TextSize=10
ScanStatus.Font=Enum.Font.Gotham; ScanStatus.TextXAlignment=Enum.TextXAlignment.Left

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

local SVCCOLORS={Workspace=Color3.fromRGB(100,200,255),ReplicatedStorage=Color3.fromRGB(255,200,80),ReplicatedFirst=Color3.fromRGB(255,170,60),StarterGui=Color3.fromRGB(120,255,180),StarterPack=Color3.fromRGB(80,220,150),StarterPlayer=Color3.fromRGB(60,200,120),Players=Color3.fromRGB(255,130,130),Lighting=Color3.fromRGB(255,255,100),SoundService=Color3.fromRGB(200,160,255),Teams=Color3.fromRGB(255,160,100)}
local CICONS={Model="[M]",Part="[P]",MeshPart="[MP]",UnionOperation="[U]",Script="[S]",LocalScript="[LS]",ModuleScript="[MS]",RemoteEvent="[RE]",RemoteFunction="[RF]",Folder="[F]",Tool="[T]",Configuration="[Cfg]",ProximityPrompt="[PP]",Humanoid="[Hum]",Sound="[Snd]",WeldConstraint="[Weld]",Motor6D="[M6D]",DragDetector="[DD]"}
local function getIcon(obj) return CICONS[obj.ClassName] or "[-]" end

local lineOrd2=0
local function addLine(text,color,indent)
    lineOrd2+=1
    local lbl=Instance.new("TextLabel",StructureScroll)
    lbl.Size=UDim2.new(1,-8,0,16); lbl.BackgroundTransparency=1
    lbl.Text=string.rep("  ",indent)..text
    lbl.TextColor3=color or Color3.fromRGB(200,200,220); lbl.TextSize=11
    lbl.Font=Enum.Font.Code; lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.TextTruncate=Enum.TextTruncate.AtEnd; lbl.LayoutOrder=lineOrd2
end

local function clearStructure()
    for _,c in ipairs(StructureScroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
    lineOrd2=0; scannedText=""
end

local SCAN_SVCS2={
    {name="Workspace",ref=workspace},{name="ReplicatedStorage",ref=game:GetService("ReplicatedStorage")},
    {name="ReplicatedFirst",ref=game:GetService("ReplicatedFirst")},{name="StarterGui",ref=game:GetService("StarterGui")},
    {name="StarterPack",ref=game:GetService("StarterPack")},{name="StarterPlayer",ref=game:GetService("StarterPlayer")},
    {name="Players",ref=game:GetService("Players")},{name="Lighting",ref=game:GetService("Lighting")},
    {name="SoundService",ref=game:GetService("SoundService")},{name="Teams",ref=game:GetService("Teams")},
}
local function scanAllServices(guiMode,printMode)
    local buf={}; local total=0
    for _,s in ipairs(SCAN_SVCS2) do
        pcall(function()
            total+=#s.ref:GetDescendants()
            local color=SVCCOLORS[s.name] or Color3.fromRGB(200,200,220)
            local hdr=string.format("[%s] (%d children)",s.name,#s.ref:GetChildren())
            if guiMode then addLine(hdr,color,0) end
            if printMode then print(hdr) end
            buf[#buf+1]=hdr.."\n"
            local function dp(obj,d)
                for _,child in ipairs(obj:GetChildren()) do
                    local icon=getIcon(child); local cc=#child:GetChildren()
                    local suf=cc>0 and string.format(" [+%d]",cc) or ""
                    local line=string.format("%s %s (%s)%s",icon,child.Name,child.ClassName,suf)
                    if guiMode and d<=6 then addLine(line,Color3.fromRGB(190,190,210),d) end
                    if printMode then print(string.rep("  ",d)..line) end
                    buf[#buf+1]=string.rep("  ",d)..line.."\n"
                    if cc>0 then dp(child,d+1) end
                end
            end
            dp(s.ref,1)
            if guiMode then addLine("",Color3.fromRGB(40,40,60),0) end
            buf[#buf+1]="\n"
        end)
    end
    return table.concat(buf),total
end

ScanBtn.MouseButton1Click:Connect(function()
    clearStructure(); ScanStatus.Text="Scanning..."; ScanStatus.TextColor3=Color3.fromRGB(180,170,255); task.wait()
    local text,total=scanAllServices(true,false); scannedText=text
    ScanStatus.Text=string.format("Done — %d objects",total); ScanStatus.TextColor3=Color3.fromRGB(120,255,160)
end)
ClearBtn.MouseButton1Click:Connect(function()
    clearStructure(); ScanStatus.Text="Press Scan to inspect workspace"; ScanStatus.TextColor3=Color3.fromRGB(120,110,180)
end)
PrintBtn.MouseButton1Click:Connect(function()
    ScanStatus.Text="Printing..."; ScanStatus.TextColor3=Color3.fromRGB(180,200,255); task.wait()
    print("===== KALO STRUCTURE DUMP ====="); local text,_=scanAllServices(false,true); scannedText=text
    print("===== END ====="); ScanStatus.Text="Printed to Output tab"; ScanStatus.TextColor3=Color3.fromRGB(120,255,160)
end)
CopyBtn.MouseButton1Click:Connect(function()
    if scannedText=="" then ScanStatus.Text="Run Scan first!"; ScanStatus.TextColor3=Color3.fromRGB(255,200,80); return end
    pcall(function() setclipboard(scannedText) end)
    ScanStatus.Text="Copied to clipboard!"; ScanStatus.TextColor3=Color3.fromRGB(120,255,160)
end)
