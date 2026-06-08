-- Personal Exploit Menu v5
-- Mobile-optimized | Structure | Items

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer
local PlayerGui        = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("_ExploitMenu") then
    PlayerGui["_ExploitMenu"]:Destroy()
end

----------------------------------------------------------------
-- THEME
----------------------------------------------------------------
local C = {
    BG      = Color3.fromRGB(18, 18, 24),
    PANEL   = Color3.fromRGB(26, 26, 34),
    HEADER  = Color3.fromRGB(30, 30, 40),
    LINE    = Color3.fromRGB(46, 46, 60),
    TEXT    = Color3.fromRGB(218, 218, 228),
    DIM     = Color3.fromRGB(110, 110, 132),
    WHITE   = Color3.fromRGB(255, 255, 255),
    BTN     = Color3.fromRGB(40,  40,  54),
    OUTPUT  = Color3.fromRGB(12,  12,  18),
    BADGE   = Color3.fromRGB(50,  50,  68),
    CLIP    = Color3.fromRGB(52,  96, 158),
    COPY    = Color3.fromRGB(46, 106,  80),
    RESET   = Color3.fromRGB(116, 46,  54),
    ITEM    = Color3.fromRGB(100, 80,  40),
    SCRIPT  = Color3.fromRGB(60,  80, 130),
    AC_OFF  = Color3.fromRGB(58,  58,  75),
    AC_ON   = Color3.fromRGB(50, 130,  70),
}

----------------------------------------------------------------
-- DATA TABLES
----------------------------------------------------------------
local STRUCT_SERVICES = {
    "Workspace","ReplicatedStorage","ReplicatedFirst",
    "StarterGui","StarterPack","StarterPlayer",
    "Lighting","SoundService","Chat","Teams",
}

local ITEM_CLASSES = {
    Tool=true, HopperBin=true, Accessory=true, Hat=true,
    Shirt=true, Pants=true, ShirtGraphic=true, Gear=true,
}

local ITEM_SOURCES = {
    "Workspace","ReplicatedStorage","StarterPack","ReplicatedFirst",
}

local SCRIPT_SCAN_SVCS = {
    "Workspace","ReplicatedStorage","ReplicatedFirst",
    "StarterGui","StarterPack","StarterPlayer",
    "Lighting","SoundService","Chat","Teams",
}

local SCRIPT_CLASSES = {
    Script=true, LocalScript=true, ModuleScript=true,
}

local ITEM_KEYWORDS = {
    -- Common fruits
    "apple","apricot","avocado","banana","blackberry","blueberry",
    "boysenberry","cantaloupe","cherry","clementine","coconut","cranberry",
    "currant","damson","date","dragonfruit","durian","elderberry",
    "feijoa","fig","gooseberry","grape","grapefruit","guava",
    "honeydew","jackfruit","jujube","kiwi","kumquat","lemon",
    "lime","lychee","mandarin","mango","mangosteen","melon",
    "mulberry","nectarine","olive","orange","papaya","passionfruit",
    "peach","pear","persimmon","pineapple","plantain","plum",
    "pomegranate","pomelo","quince","rambutan","raspberry","redcurrant",
    "salak","soursop","starfruit","strawberry","tamarind","tangerine",
    "watermelon","yuzu",
    -- Roblox exotic / devil fruits
    "mythic","divine","prismatic","corrupted","void","cosmic","rainbow",
    "carnival","tropical","bubblegum","frozen","radioactive","acid",
    "moonberry","sunfruit","starberry","glowfruit","shadowfruit",
    "blazefruit","frostfruit","venomfruit","crystalfruit","goldfruit",
    "demonfruit","angelfruit","dragonberry","phoenixfruit","riftfruit",
    -- Vegetables / Crops
    "artichoke","asparagus","bean","beet","beetroot","broccoli",
    "cabbage","carrot","cauliflower","celery","chard","chickpea",
    "corn","cucumber","eggplant","garlic","ginger","kale",
    "leek","lentil","lettuce","okra","onion","parsnip","pea",
    "pepper","potato","pumpkin","radish","rice","spinach","squash",
    "sugarcane","tomato","turnip","wheat","yam","zucchini",
    -- Farming / garden
    "seed","seedpack","sapling","sprout","bulb","crop","harvest",
    "produce","plant","fertilizer","compost","herb","cactus","fern",
    "mushroom","truffle","fungi","spore","flower","rose","tulip",
    "daisy","sunflower","orchid","lily","berry","algae","kelp",
    -- Survival – food & drink
    "food","meal","ration","bread","meat","steak","pork","chicken",
    "fish","salmon","tuna","shrimp","crab","egg","milk","cheese",
    "honey","syrup","jam","jerky","soup","stew","broth","nut",
    "acorn","walnut","almond","peanut","grain","flour","cooked",
    "water","canteen","flask","bottle","juice","sap","nectar",
    -- Survival – raw resources
    "wood","log","plank","stick","twig","branch","lumber","timber",
    "stone","rock","pebble","flint","slate","granite","coal",
    "charcoal","ash","ember","tinder","fiber","cloth","leather",
    "hide","pelt","fur","wool","silk","rope","vine","iron",
    "copper","tin","bronze","silver","gold","steel","ore","ingot",
    "nugget","mineral","gem","crystal","shard","diamond","emerald",
    "ruby","sapphire","amethyst","quartz","obsidian","bone","horn",
    "tooth","claw","scale","feather","shell","sand","clay","resin",
    "oil","tar","rubber","glass",
    -- Survival – tools & weapons
    "axe","hatchet","pickaxe","shovel","spade","rake","scythe",
    "hammer","mallet","chisel","saw","wrench","knife","dagger",
    "sword","blade","spear","lance","bow","arrow","quiver",
    "crossbow","gun","pistol","rifle","shotgun","sniper","revolver",
    "bullet","ammo","grenade","explosive","shield","armor","helmet",
    "chestplate","leggings","boots","gloves","vest","cloak",
    "torch","lantern","flashlight","lighter","match","flare",
    "trap","snare","net","hook","fishing","bait","lure",
    -- Survival – medicine
    "bandage","medkit","firstaid","heal","health","potion","elixir",
    "antidote","cure","remedy","medicine","pill","syringe","salve",
    -- Survival – shelter & gear
    "tent","tarp","blanket","campfire","backpack","bag","pouch",
    "sack","chest","crate","box","barrel","key","lockpick",
    "compass","map","radio","signal","whistle","parachute",
    -- General
    "fruit","item","goods","loot","drop","reward","prize","pickup",
    "resource","material","ingredient","component","token","coin",
    "currency","trophy","badge","medal","ticket","voucher","pack",
    "bundle","jar","vial","spray","treat","scroll","charm","amulet",
    "brew","mixture","powder","dust","essence","tool","gear",
    "weapon","equipment","supply","cargo","relic","artifact",
}

local AC_PATTERNS = {
    "anticheat","anti_cheat","anti-cheat","acheat","anticheats",
    "kicksystem","banhandler","exploitdetect","exploitcheck",
    "detection","sanitycheck","speedcheck","flycheck","noclipcheck",
    "fairplay","safeguard","guardian","remotechecker",
    "teleportcheck","positioncheck","cheatdetect","hackdetect",
    "securitycheck","antiexploit","anti_exploit","exploitban",
}

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------
local function new(cls, props, parent)
    local o = Instance.new(cls)
    for k,v in pairs(props) do o[k]=v end
    if parent then o.Parent=parent end
    return o
end

local function corner(p,r)
    new("UICorner",{CornerRadius=UDim.new(0,r or 6)},p)
end

local function pad(p,l,r,t,b)
    new("UIPadding",{
        PaddingLeft=UDim.new(0,l or 0), PaddingRight=UDim.new(0,r or 0),
        PaddingTop=UDim.new(0,t or 0),  PaddingBottom=UDim.new(0,b or 0),
    },p)
end

local function vlist(p,gap)
    new("UIListLayout",{
        FillDirection=Enum.FillDirection.Vertical,
        SortOrder=Enum.SortOrder.LayoutOrder,
        Padding=UDim.new(0,gap or 6),
    },p)
end

local function hlist(p,gap)
    new("UIListLayout",{
        FillDirection=Enum.FillDirection.Horizontal,
        SortOrder=Enum.SortOrder.LayoutOrder,
        Padding=UDim.new(0,gap or 0),
    },p)
end

local function mkBtn(text, color, parent, sz, order)
    local b = new("TextButton",{
        Text=text, Font=Enum.Font.GothamBold, TextSize=12,
        TextColor3=C.WHITE, Size=sz or UDim2.new(1,0,0,30),
        BackgroundColor3=color, BorderSizePixel=0,
        AutoButtonColor=false, LayoutOrder=order or 1,
    },parent)
    corner(b,6)
    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.1),{
            BackgroundColor3=color:lerp(Color3.new(1,1,1),0.12)
        }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.1),{BackgroundColor3=color}):Play()
    end)
    return b
end

local function mkOutput(parent, h, order)
    local outer = new("Frame",{
        Size=UDim2.new(1,0,0,h), BackgroundColor3=C.OUTPUT,
        BorderSizePixel=0, LayoutOrder=order,
    },parent)
    corner(outer,6)
    new("UIStroke",{Color=C.LINE,Thickness=1},outer)
    local scroll = new("ScrollingFrame",{
        Size=UDim2.new(1,-6,1,-6), Position=UDim2.new(0,3,0,3),
        BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=3, ScrollBarImageColor3=C.LINE,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ScrollingDirection=Enum.ScrollingDirection.Y,
    },outer)
    local lbl = new("TextLabel",{
        Text="", Font=Enum.Font.Code, TextSize=11,
        TextColor3=C.DIM, Size=UDim2.new(1,-6,0,0),
        Position=UDim2.new(0,3,0,3), BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Top,
        TextWrapped=true, AutomaticSize=Enum.AutomaticSize.Y,
    },scroll)
    return outer, scroll, lbl
end

local function hRow(parent, h, order)
    local r = new("Frame",{
        Size=UDim2.new(1,0,0,h), BackgroundTransparency=1,
        LayoutOrder=order,
    },parent)
    hlist(r,6)
    return r
end

local function sectionLbl(text, parent, order)
    return new("TextLabel",{
        Text=text, Font=Enum.Font.GothamSemibold, TextSize=10,
        TextColor3=C.DIM, BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,14), LayoutOrder=order,
        TextXAlignment=Enum.TextXAlignment.Left,
    },parent)
end

local function safeGet(name)
    local ok,r = pcall(game.GetService,game,name)
    if ok and r then return r end
    ok,r = pcall(function() return game[name] end)
    return ok and r or nil
end

local function copyToClipboard(text)
    if setclipboard then pcall(setclipboard,text); return true end
    if copystring   then pcall(copystring,text);   return true end
    return false
end

----------------------------------------------------------------
-- ROOT GUI
----------------------------------------------------------------
local W, H = 310, 490

local Gui = new("ScreenGui",{
    Name="_ExploitMenu", ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset=true,
},PlayerGui)

local Main = new("Frame",{
    Size=UDim2.fromOffset(W,H),
    Position=UDim2.new(0.5,-W/2,0.5,-H/2),
    BackgroundColor3=C.BG, ClipsDescendants=true,
},Gui)
corner(Main,10)
new("UIStroke",{Color=C.LINE,Thickness=1},Main)

----------------------------------------------------------------
-- HEADER
----------------------------------------------------------------
local Header = new("Frame",{
    Size=UDim2.new(1,0,0,38),
    BackgroundColor3=C.HEADER, BorderSizePixel=0,
},Main)
corner(Header,10)
new("Frame",{
    Size=UDim2.new(1,0,0.5,0), Position=UDim2.new(0,0,0.5,0),
    BackgroundColor3=C.HEADER, BorderSizePixel=0,
},Header)
new("TextLabel",{
    Text="Exploit Menu", Font=Enum.Font.GothamBold, TextSize=13,
    TextColor3=C.TEXT, BackgroundTransparency=1,
    Size=UDim2.new(1,-72,1,0), Position=UDim2.new(0,12,0,0),
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
},Header)
new("TextLabel",{
    Text="v5.0", Font=Enum.Font.Gotham, TextSize=10,
    TextColor3=C.DIM, BackgroundTransparency=1,
    Size=UDim2.new(0,28,1,0), Position=UDim2.new(0,98,0,0),
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
},Header)

local MinBtn = new("TextButton",{
    Text="—", Font=Enum.Font.GothamBold, TextSize=12,
    TextColor3=C.DIM, Size=UDim2.fromOffset(26,26),
    Position=UDim2.new(1,-58,0.5,-13),
    BackgroundColor3=C.BTN, BorderSizePixel=0, ZIndex=4,
},Header)
corner(MinBtn,5)

local CloseBtn = new("TextButton",{
    Text="✕", Font=Enum.Font.GothamBold, TextSize=11,
    TextColor3=C.WHITE, Size=UDim2.fromOffset(26,26),
    Position=UDim2.new(1,-28,0.5,-13),
    BackgroundColor3=C.RESET, BorderSizePixel=0, ZIndex=4,
},Header)
corner(CloseBtn,5)

CloseBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(Main,TweenInfo.new(0.2,Enum.EasingStyle.Quint),{
        Size = minimized and UDim2.fromOffset(W,38) or UDim2.fromOffset(W,H)
    }):Play()
    MinBtn.Text = minimized and "▲" or "—"
end)

-- Drag
do
    local drag,ds,sp
    Header.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            drag=true; ds=i.Position; sp=Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement
                  or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            Main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)
end

----------------------------------------------------------------
-- TAB BAR  (2 tabs: Structure | Items)
----------------------------------------------------------------
local TabBar = new("Frame",{
    Size=UDim2.new(1,0,0,28),
    Position=UDim2.new(0,0,0,38),
    BackgroundColor3=C.PANEL, BorderSizePixel=0,
},Main)
hlist(TabBar,0)

local TabBtns    = {}
local TAB_LABELS = {"Structure","Items"}
local TAB_COLORS = {C.CLIP, C.ITEM}

for i,lbl in ipairs(TAB_LABELS) do
    local t = new("TextButton",{
        Text=lbl, Font=Enum.Font.GothamSemibold, TextSize=12,
        TextColor3=C.DIM, Size=UDim2.new(0.5,0,1,0),
        BackgroundColor3=C.PANEL, BorderSizePixel=0,
        AutoButtonColor=false, LayoutOrder=i,
    },TabBar)
    TabBtns[i] = t
end

local Indicator = new("Frame",{
    Size=UDim2.new(0.5,0,0,2),
    Position=UDim2.new(0,0,1,-2),
    BackgroundColor3=C.CLIP, BorderSizePixel=0, ZIndex=5,
},TabBar)

new("Frame",{
    Size=UDim2.new(1,0,0,1),
    Position=UDim2.new(0,0,0,66),
    BackgroundColor3=C.LINE, BorderSizePixel=0,
},Main)

----------------------------------------------------------------
-- CONTENT AREA
----------------------------------------------------------------
local Content = new("Frame",{
    Size=UDim2.new(1,0,1,-(38+28+1)),
    Position=UDim2.new(0,0,0,38+28+1),
    BackgroundTransparency=1, ClipsDescendants=true,
},Main)

local function mkPanel(startVisible)
    local p = new("Frame",{
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1, Visible=startVisible,
    },Content)
    pad(p,8,8,8,8)
    vlist(p,6)
    return p
end

----------------------------------------------------------------
-- PANEL 1 — STRUCTURE
-- Rows: [Clip | Copy | Reset]  then  [Anti-Cheat Remover]
----------------------------------------------------------------
local PStruct = mkPanel(true)
sectionLbl("Structure Scanner", PStruct, 1)

local _,ScrollStruct,OutStruct = mkOutput(PStruct, 200, 2)
OutStruct.Text = "Press [Clip] to scan the game tree."

local Row1S = hRow(PStruct, 30, 3)
local BtnClip   = mkBtn("Clip",  C.CLIP,  Row1S, UDim2.new(0.34,0,1,0), 1)
local BtnSCopy  = mkBtn("Copy",  C.COPY,  Row1S, UDim2.new(0.33,-3,1,0), 2)
local BtnSReset = mkBtn("Reset", C.RESET, Row1S, UDim2.new(0.33,-3,1,0), 3)

local AntiBtn = mkBtn("  Anti-Cheat Remover: OFF", C.AC_OFF, PStruct, UDim2.new(1,0,0,34), 4)

local NodeCount = new("TextLabel",{
    Text="", Font=Enum.Font.Gotham, TextSize=10,
    TextColor3=C.DIM, BackgroundTransparency=1,
    Size=UDim2.new(1,0,0,14), LayoutOrder=5,
    TextXAlignment=Enum.TextXAlignment.Left,
},PStruct)

local ACStatus = new("TextLabel",{
    Text="", Font=Enum.Font.Gotham, TextSize=10,
    TextColor3=C.DIM, BackgroundTransparency=1,
    Size=UDim2.new(1,0,0,14), LayoutOrder=6,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextWrapped=true,
},PStruct)

----------------------------------------------------------------
-- PANEL 2 — ITEMS
-- Buttons: [Item Clip | Copy | Reset]  then  [Clip Scripts]
----------------------------------------------------------------
local PItems = mkPanel(false)
sectionLbl("Item & Script Scanner", PItems, 1)

local _,ScrollItems,OutItems = mkOutput(PItems, 164, 2)
OutItems.Text = "Press [Item Clip] or [Clip Scripts] to scan."

-- Row: Item Clip | Copy | Reset
local Row1I = hRow(PItems, 30, 3)
local BtnIClip  = mkBtn("Item Clip", C.ITEM,   Row1I, UDim2.new(0.44,0,1,0), 1)
local BtnICopy  = mkBtn("Copy",      C.COPY,   Row1I, UDim2.new(0.28,-3,1,0), 2)
local BtnIReset = mkBtn("Reset",     C.RESET,  Row1I, UDim2.new(0.28,-3,1,0), 3)

-- Row: Clip Scripts (full width)
local BtnSclip = mkBtn("  Clip Scripts  (Script · LocalScript · ModuleScript)", C.SCRIPT, PItems, UDim2.new(1,0,0,34), 4)

-- Item badges
local IBR1 = hRow(PItems, 20, 5)
local IBR2 = hRow(PItems, 20, 6)

local function mkBadge(txt, parent)
    local f = new("Frame",{Size=UDim2.new(0.5,-2,1,0),BackgroundColor3=C.BADGE,BorderSizePixel=0},parent)
    corner(f,5)
    return new("TextLabel",{
        Text=txt, Font=Enum.Font.Gotham, TextSize=10,
        TextColor3=C.DIM, BackgroundTransparency=1,
        Size=UDim2.new(1,0,1,0), TextXAlignment=Enum.TextXAlignment.Center,
    },f)
end

local BadgeTools   = mkBadge("Tools: 0",   IBR1)
local BadgeProduce = mkBadge("Produce: 0", IBR1)
local BadgeAcc     = mkBadge("Acc: 0",     IBR2)
local BadgeOther   = mkBadge("Other: 0",   IBR2)

-- Script badges
local SBR1 = hRow(PItems, 20, 7)
local SBR2 = hRow(PItems, 20, 8)

local BadgeSc = mkBadge("Script: 0",      SBR1)
local BadgeLs = mkBadge("LocalScript: 0", SBR1)
local BadgeMs = mkBadge("Module: 0",      SBR2)
local BadgeSs = mkBadge("Total: 0",       SBR2)

local ScanInfo = new("TextLabel",{
    Text="", Font=Enum.Font.Gotham, TextSize=10,
    TextColor3=C.DIM, BackgroundTransparency=1,
    Size=UDim2.new(1,0,0,14), LayoutOrder=9,
    TextXAlignment=Enum.TextXAlignment.Left,
},PItems)

----------------------------------------------------------------
-- TAB SWITCHING
----------------------------------------------------------------
local TAB_PANELS = {PStruct, PItems}
local activeTab  = 1

local function switchTab(idx)
    activeTab = idx
    for i=1,2 do
        TAB_PANELS[i].Visible       = (i==idx)
        TabBtns[i].TextColor3       = i==idx and C.TEXT or C.DIM
        TabBtns[i].BackgroundColor3 = i==idx and C.BTN  or C.PANEL
        TabBtns[i].Font             = i==idx and Enum.Font.GothamBold or Enum.Font.GothamSemibold
    end
    TweenService:Create(Indicator,TweenInfo.new(0.18),{
        Position=UDim2.new((idx-1)*0.5,0,1,-2),
        BackgroundColor3=TAB_COLORS[idx],
    }):Play()
end

for i=1,2 do
    local idx=i
    TabBtns[i].MouseButton1Click:Connect(function() switchTab(idx) end)
end
switchTab(1)

----------------------------------------------------------------
-- STRUCTURE SCANNER
----------------------------------------------------------------
local lastStructOut = ""

local function buildTree(inst, depth, lines, count)
    if count[1] >= 2500 then return end
    count[1] = count[1]+1
    local ok1,cn = pcall(function() return inst.ClassName end)
    local ok2,nm = pcall(function() return inst.Name      end)
    if not ok1 or not ok2 then return end
    local indent = string.rep("  ", math.min(depth,10))
    table.insert(lines, indent.."["..cn.."]  "..nm)
    if depth >= 8 then return end
    local ok3,kids = pcall(function() return inst:GetChildren() end)
    if ok3 then
        for _,child in ipairs(kids) do buildTree(child, depth+1, lines, count) end
    end
end

BtnClip.MouseButton1Click:Connect(function()
    OutStruct.Text="Scanning…"; NodeCount.Text=""
    task.wait(0.05)
    local ok,err = pcall(function()
        local lines,count = {},{0}
        table.insert(lines, string.format("[ %s  |  PlaceId: %d ]\n",os.date("%H:%M:%S"),game.PlaceId))
        for _,name in ipairs(STRUCT_SERVICES) do
            local svc = safeGet(name)
            if svc then
                table.insert(lines,">> "..name)
                local ok2,kids = pcall(function() return svc:GetChildren() end)
                if ok2 then
                    for _,child in ipairs(kids) do buildTree(child,1,lines,count) end
                else table.insert(lines,"  [Access Denied]") end
                table.insert(lines,"")
            else
                table.insert(lines,">> "..name.."  [Not Found]\n")
            end
        end
        if count[1]>=2500 then table.insert(lines,"\n[Capped at 2500 nodes]") end
        lastStructOut  = table.concat(lines,"\n")
        OutStruct.Text = lastStructOut
        NodeCount.Text = count[1].." nodes scanned"
    end)
    if not ok then OutStruct.Text="Scan error:\n"..tostring(err) end
end)

BtnSCopy.MouseButton1Click:Connect(function()
    if lastStructOut=="" then OutStruct.Text="Run Clip first."; return end
    local copied=copyToClipboard(lastStructOut)
    local prev=OutStruct.Text
    OutStruct.Text = copied and ("Copied "..#lastStructOut.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OutStruct and OutStruct.Parent then OutStruct.Text=prev end end)
end)

BtnSReset.MouseButton1Click:Connect(function()
    lastStructOut="" ; OutStruct.Text="Press [Clip] to scan the game tree."
    NodeCount.Text="" ; ScrollStruct.CanvasPosition=Vector2.zero
end)

----------------------------------------------------------------
-- ANTI-CHEAT TOGGLE  (Structure panel)
----------------------------------------------------------------
local acEnabled     = false
local acTotalKilled = 0

local function nameIsAC(name)
    local low = name:lower()
    for _,p in ipairs(AC_PATTERNS) do
        if low:find(p,1,true) then return true end
    end
    return false
end

local AC_SVCS = {
    "Workspace","ReplicatedStorage","StarterGui",
    "ReplicatedFirst","StarterPack","StarterPlayer",
}

local function deepScanAC(root, found, depth)
    if depth > 8 then return end
    local ok,kids = pcall(function() return root:GetChildren() end)
    if not ok then return end
    for _,child in ipairs(kids) do
        local okN,nm  = pcall(function() return child.Name      end)
        local okC,cls = pcall(function() return child.ClassName end)
        if okN and okC then
            if nameIsAC(nm) then table.insert(found,child) end
            if cls=="Folder" or cls=="Model" or cls=="Configuration" then
                deepScanAC(child, found, depth+1)
            end
        end
    end
end

local function runACPass()
    local found = {}
    for _,svcName in ipairs(AC_SVCS) do
        local svc = safeGet(svcName)
        if svc then deepScanAC(svc, found, 0) end
    end
    local killed = 0
    for _,inst in ipairs(found) do
        local ok = pcall(function()
            if inst:IsA("BaseScript") then inst.Disabled=true end
            inst:Destroy()
        end)
        if ok then killed=killed+1; acTotalKilled=acTotalKilled+1 end
    end
    if killed > 0 then
        ACStatus.Text = string.format("Removed %d this pass  |  session total: %d", killed, acTotalKilled)
    end
end

local function setACToggle(on)
    acEnabled = on
    if on then
        AntiBtn.Text             = "  Anti-Cheat Remover: ON"
        AntiBtn.BackgroundColor3 = C.AC_ON
        ACStatus.Text            = "Running — scanning every 2 s…"
        task.spawn(runACPass)
        task.spawn(function()
            while acEnabled do
                task.wait(2)
                if acEnabled then runACPass() end
            end
        end)
    else
        AntiBtn.Text             = "  Anti-Cheat Remover: OFF"
        AntiBtn.BackgroundColor3 = C.AC_OFF
        ACStatus.Text            = string.format("Stopped.  Total removed: %d", acTotalKilled)
    end
end

AntiBtn.MouseButton1Click:Connect(function() setACToggle(not acEnabled) end)
Gui.AncestryChanged:Connect(function()
    if not Gui.Parent then acEnabled=false end
end)

----------------------------------------------------------------
-- ITEM SCANNER
----------------------------------------------------------------
local lastItemOut = ""

local function itemMatchClass(cn) return ITEM_CLASSES[cn]==true end

local function itemMatchKeyword(nm)
    local low = nm:lower()
    for _,kw in ipairs(ITEM_KEYWORDS) do
        if low:find(kw,1,true) then return true end
    end
    return false
end

local function itemCategory(cn,nm)
    local low = nm:lower()
    if cn=="Tool" or cn=="HopperBin" or cn=="Gear" then return "tool" end
    if cn=="Accessory" or cn=="Hat" or cn=="Shirt" or cn=="Pants" or cn=="ShirtGraphic" then return "acc" end
    local produceKw={
        "fruit","seed","crop","berry","plant","mushroom","flower","egg","fish",
        "harvest","produce","apple","orange","banana","mango","melon","grape",
        "carrot","potato","corn","tomato","pumpkin","sprout","sapling","cherry",
        "lemon","peach","pear","kiwi","coconut","dragonfruit","strawberry",
    }
    for _,k in ipairs(produceKw) do
        if low:find(k,1,true) then return "produce" end
    end
    return "other"
end

local function deepScanItems(root, results, seen, depth)
    if depth > 12 then return end
    local ok,kids = pcall(function() return root:GetChildren() end)
    if not ok then return end
    for _,child in ipairs(kids) do
        local okC,cn = pcall(function() return child.ClassName end)
        local okN,nm = pcall(function() return child.Name      end)
        if okC and okN then
            local ptr = tostring(child)
            if not seen[ptr] then
                local byClass=itemMatchClass(cn)
                local byKw=itemMatchKeyword(nm)
                if byClass or byKw then
                    seen[ptr]=true
                    table.insert(results,{
                        cn=cn, nm=nm, cat=itemCategory(cn,nm),
                        how=(byClass and byKw) and "class+kw" or byClass and "class" or "keyword",
                    })
                end
            end
            if not (cn:find("Part") or cn:find("Mesh") or cn:find("Decal")
                 or cn:find("Sound") or cn:find("Weld") or cn:find("Motor")
                 or cn:find("Constraint")) then
                deepScanItems(child, results, seen, depth+1)
            end
        end
    end
end

local function resetItemBadges(label)
    BadgeTools.Text=label ; BadgeProduce.Text=label
    BadgeAcc.Text=label   ; BadgeOther.Text=label
end

local function resetScriptBadges(label)
    BadgeSc.Text=label ; BadgeLs.Text=label
    BadgeMs.Text=label ; BadgeSs.Text=label
end

BtnIClip.MouseButton1Click:Connect(function()
    OutItems.Text="Scanning items…"
    resetItemBadges("…") ; ScanInfo.Text=""
    task.wait(0.05)
    local ok,err = pcall(function()
        local results,seen,lines = {},{},{}
        local tC,pC,aC,oC = 0,0,0,0
        local function addSec(label, root)
            local before=#results
            deepScanItems(root,results,seen,0)
            if #results>before then
                table.insert(lines,">> "..label)
                for i=before+1,#results do
                    local e=results[i]
                    table.insert(lines,"  ["..e.cn.."]  "..e.nm.."  ("..e.how..")")
                end
                table.insert(lines,"")
            end
        end
        local bp=LocalPlayer:FindFirstChild("Backpack")
        if bp then addSec("LocalPlayer.Backpack",bp) end
        local char=LocalPlayer.Character
        if char then addSec("Character (Equipped)",char) end
        for _,svcName in ipairs(ITEM_SOURCES) do
            local svc=safeGet(svcName)
            if svc then addSec(svcName,svc) end
        end
        for _,e in ipairs(results) do
            if     e.cat=="tool"    then tC=tC+1
            elseif e.cat=="produce" then pC=pC+1
            elseif e.cat=="acc"     then aC=aC+1
            else                         oC=oC+1 end
        end
        if #results==0 then
            table.insert(lines,"No items found.")
        else
            table.insert(lines,string.format(
                "-- Total: %d  (Tools:%d  Produce:%d  Acc:%d  Other:%d)",
                #results,tC,pC,aC,oC))
        end
        lastItemOut       = table.concat(lines,"\n")
        OutItems.Text     = lastItemOut
        ScanInfo.Text     = #results.." items found"
        BadgeTools.Text   = "Tools: "..tC
        BadgeProduce.Text = "Produce: "..pC
        BadgeAcc.Text     = "Acc: "..aC
        BadgeOther.Text   = "Other: "..oC
    end)
    if not ok then OutItems.Text="Item scan error:\n"..tostring(err) end
end)

BtnICopy.MouseButton1Click:Connect(function()
    if lastItemOut=="" then OutItems.Text="Run Item Clip first."; return end
    local copied=copyToClipboard(lastItemOut)
    local prev=OutItems.Text
    OutItems.Text=copied and ("Copied "..#lastItemOut.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OutItems and OutItems.Parent then OutItems.Text=prev end end)
end)

BtnIReset.MouseButton1Click:Connect(function()
    lastItemOut=""
    OutItems.Text="Press [Item Clip] or [Clip Scripts] to scan."
    resetItemBadges("Tools: 0") ; BadgeProduce.Text="Produce: 0"
    BadgeAcc.Text="Acc: 0" ; BadgeOther.Text="Other: 0"
    resetScriptBadges("Script: 0") ; BadgeLs.Text="LocalScript: 0"
    BadgeMs.Text="Module: 0" ; BadgeSs.Text="Total: 0"
    ScanInfo.Text="" ; ScrollItems.CanvasPosition=Vector2.zero
end)

----------------------------------------------------------------
-- SCRIPT SCANNER  (inside Items panel)
----------------------------------------------------------------
local lastScriptOut = ""

local function deepScanScripts(root, results, seen, depth)
    if depth > 12 then return end
    local ok,kids = pcall(function() return root:GetChildren() end)
    if not ok then return end
    for _,child in ipairs(kids) do
        local okC,cn = pcall(function() return child.ClassName end)
        local okN,nm = pcall(function() return child.Name      end)
        if okC and okN then
            local ptr = tostring(child)
            if SCRIPT_CLASSES[cn] and not seen[ptr] then
                seen[ptr]=true
                local dis=""
                pcall(function()
                    if child:IsA("BaseScript") and child.Disabled then dis=" [DISABLED]" end
                end)
                table.insert(results,{cn=cn, nm=nm, dis=dis})
            end
            deepScanScripts(child, results, seen, depth+1)
        end
    end
end

BtnSclip.MouseButton1Click:Connect(function()
    OutItems.Text="Scanning for scripts…"
    resetScriptBadges("…") ; ScanInfo.Text=""
    task.wait(0.05)
    local ok,err = pcall(function()
        local results,seen,lines = {},{},{}
        local scC,lsC,msC = 0,0,0
        table.insert(lines, string.format("[ %s  |  PlaceId: %d ]\n",os.date("%H:%M:%S"),game.PlaceId))
        for _,svcName in ipairs(SCRIPT_SCAN_SVCS) do
            local svc=safeGet(svcName)
            if svc then
                local before=#results
                deepScanScripts(svc,results,seen,0)
                if #results>before then
                    table.insert(lines,">> "..svcName)
                    for i=before+1,#results do
                        local e=results[i]
                        table.insert(lines,"  ["..e.cn.."]  "..e.nm..e.dis)
                    end
                    table.insert(lines,"")
                end
            end
        end
        -- Character scripts
        local char=LocalPlayer.Character
        if char then
            local before=#results
            deepScanScripts(char,results,seen,0)
            if #results>before then
                table.insert(lines,">> Character")
                for i=before+1,#results do
                    local e=results[i]
                    table.insert(lines,"  ["..e.cn.."]  "..e.nm..e.dis)
                end
                table.insert(lines,"")
            end
        end
        -- PlayerScripts
        local ps=LocalPlayer:FindFirstChild("PlayerScripts")
        if ps then
            local before=#results
            deepScanScripts(ps,results,seen,0)
            if #results>before then
                table.insert(lines,">> PlayerScripts")
                for i=before+1,#results do
                    local e=results[i]
                    table.insert(lines,"  ["..e.cn.."]  "..e.nm..e.dis)
                end
                table.insert(lines,"")
            end
        end
        for _,e in ipairs(results) do
            if     e.cn=="Script"       then scC=scC+1
            elseif e.cn=="LocalScript"  then lsC=lsC+1
            elseif e.cn=="ModuleScript" then msC=msC+1 end
        end
        local total=#results
        if total==0 then
            table.insert(lines,"No accessible scripts found.")
        else
            table.insert(lines,string.format(
                "-- Total: %d  (Script:%d  LocalScript:%d  Module:%d)",
                total,scC,lsC,msC))
        end
        lastScriptOut   = table.concat(lines,"\n")
        OutItems.Text   = lastScriptOut
        ScanInfo.Text   = total.." scripts found"
        BadgeSc.Text    = "Script: "..scC
        BadgeLs.Text    = "LocalScript: "..lsC
        BadgeMs.Text    = "Module: "..msC
        BadgeSs.Text    = "Total: "..total
    end)
    if not ok then OutItems.Text="Script scan error:\n"..tostring(err) end
end)

----------------------------------------------------------------
-- OPEN ANIMATION
----------------------------------------------------------------
Main.BackgroundTransparency = 1
Main.Position = UDim2.new(0.5,-W/2,0.5,-H/2+14)
TweenService:Create(Main,TweenInfo.new(0.22,Enum.EasingStyle.Quint),{
    BackgroundTransparency=0,
    Position=UDim2.new(0.5,-W/2,0.5,-H/2),
}):Play()

print("[ExploitMenu v5] Loaded — Structure | Items (+Scripts)")
