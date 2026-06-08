-- Personal Exploit Menu v3
-- Mobile-optimized | Structure | Items | Anti-Cheat Toggle

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
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
    BTN     = Color3.fromRGB(40, 40, 54),
    CLIP    = Color3.fromRGB(52, 96, 158),
    COPY    = Color3.fromRGB(46, 106, 80),
    RESET   = Color3.fromRGB(116, 46, 54),
    ITEM    = Color3.fromRGB(100, 80, 40),
    AC_OFF  = Color3.fromRGB(58, 58, 75),
    AC_ON   = Color3.fromRGB(60, 130, 75),
    OUTPUT  = Color3.fromRGB(12, 12, 18),
    BADGE   = Color3.fromRGB(50, 50, 68),
}

----------------------------------------------------------------
-- PATTERNS
----------------------------------------------------------------
local SERVICES = {
    "Workspace","ReplicatedStorage","ReplicatedFirst",
    "StarterGui","StarterPack","StarterPlayer",
    "Lighting","SoundService","Chat","Teams",
}

local ITEM_CLASSES = {
    Tool=true, HopperBin=true, Accessory=true, Hat=true,
    Shirt=true, Pants=true, ShirtGraphic=true,
    BackpackItem=true, Gear=true,
}
local ITEM_SOURCES = {
    "Workspace","ReplicatedStorage","StarterPack",
    "StarterPlayerScripts","ReplicatedFirst",
}

-- Name keywords — matches ANY class that contains these words
-- Covers fruits, crops, produce, resources, weapons, consumables
local ITEM_KEYWORDS = {
    -- Fruits
    "apple","orange","banana","grape","strawberry","watermelon","cherry",
    "mango","pineapple","peach","blueberry","raspberry","lemon","lime",
    "coconut","dragonfruit","papaya","melon","kiwi","pear","plum",
    "pomegranate","jackfruit","durian","starfruit","lychee","guava",
    "passionfruit","fig","date","apricot","avocado","tomato","pepper",
    -- Crops / Vegetables / Farming
    "carrot","potato","corn","wheat","rice","cabbage","onion","garlic",
    "broccoli","spinach","pumpkin","cucumber","zucchini","eggplant",
    "lettuce","celery","pea","bean","beet","radish","turnip","leek",
    "crop","harvest","produce","plant","sapling","sprout","bulb",
    "seed","berry","mushroom","flower","herb","cactus","sugarcane",
    -- Resources / goods
    "fruit","gem","ore","wood","stone","fish","egg","milk","honey",
    "coal","iron","gold","diamond","emerald","ruby","sapphire",
    "crystal","shard","material","resource","ingredient","food",
    "item","goods","loot","drop","reward","prize","chest","crate",
    -- Game-specific generics
    "fertilizer","spray","treat","pack","potion","elixir","scroll",
    "sword","gun","knife","bow","shield","armor","helmet","boots",
    "wand","staff","axe","hammer","pickaxe","shovel","scythe",
    "currency","coin","token","ticket","key","badge","trophy",
}

local AC_PATTERNS = {
    "anticheat","anti_cheat","anti-cheat","acheat","anticheats",
    "kicksystem","banhandler","exploitdetect","exploitcheck",
    "detection","sanitycheck","speedcheck","flycheck","noclipcheck",
    "fairplay","bypass","security","safeguard","guardian",
    "remotechecker","teleportcheck","positioncheck",
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
local function listLayout(p,dir,gap)
    return new("UIListLayout",{
        FillDirection=dir or Enum.FillDirection.Vertical,
        SortOrder=Enum.SortOrder.LayoutOrder,
        Padding=UDim.new(0,gap or 6),
    },p)
end

local function mkBtn(text, color, parent, sz, order)
    local b = new("TextButton",{
        Text=text, Font=Enum.Font.GothamBold, TextSize=12,
        TextColor3=C.WHITE, Size=sz or UDim2.new(1,0,0,34),
        BackgroundColor3=color, BorderSizePixel=0,
        AutoButtonColor=false, LayoutOrder=order or 1,
    },parent)
    corner(b,6)
    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.1),{
            BackgroundColor3=color:lerp(Color3.new(1,1,1),0.1)
        }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.1),{
            BackgroundColor3=color
        }):Play()
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
        RichText=false,
    },scroll)
    return outer, scroll, lbl
end

local function mkBtnRow(parent, order)
    local row = new("Frame",{
        Size=UDim2.new(1,0,0,34), BackgroundTransparency=1,
        LayoutOrder=order,
    },parent)
    listLayout(row,Enum.FillDirection.Horizontal,6)
    return row
end

local function sectionLabel(text, parent, order)
    local l = new("TextLabel",{
        Text=text, Font=Enum.Font.GothamSemibold, TextSize=10,
        TextColor3=C.DIM, Size=UDim2.new(1,0,0,14),
        BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,
        LayoutOrder=order,
    },parent)
    return l
end

local function safeGet(name)
    local ok,r = pcall(game.GetService,game,name)
    if ok and r then return r end
    ok,r = pcall(function() return game[name] end)
    return ok and r or nil
end

----------------------------------------------------------------
-- ROOT GUI
----------------------------------------------------------------
local W, H = 310, 460

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
new("Frame",{  -- flatten bottom corners
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
    Text="v3.0", Font=Enum.Font.Gotham, TextSize=10,
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
-- TAB BAR  (3 tabs)
----------------------------------------------------------------
local TabBar = new("Frame",{
    Size=UDim2.new(1,0,0,28),
    Position=UDim2.new(0,0,0,38),
    BackgroundColor3=C.PANEL, BorderSizePixel=0,
},Main)
listLayout(TabBar,Enum.FillDirection.Horizontal,0)

local function mkTab(text,order)
    local t = new("TextButton",{
        Text=text, Font=Enum.Font.GothamSemibold, TextSize=11,
        TextColor3=C.DIM, Size=UDim2.new(1/3,0,1,0),
        BackgroundColor3=C.PANEL, BorderSizePixel=0,
        AutoButtonColor=false, LayoutOrder=order,
    },TabBar)
    return t
end

local Tabs = {
    mkTab("Structure",1),
    mkTab("Items",2),
    mkTab("Anti-Cheat",3),
}

local Indicator = new("Frame",{
    Size=UDim2.new(1/3,0,0,2),
    Position=UDim2.new(0,0,1,-2),
    BackgroundColor3=C.CLIP, BorderSizePixel=0, ZIndex=5,
},TabBar)

-- thin rule below tab bar
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

----------------------------------------------------------------
-- PANEL BUILDER
----------------------------------------------------------------
local function mkPanel(visible)
    local p = new("Frame",{
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1, Visible=visible,
    },Content)
    pad(p,8,8,8,8)
    listLayout(p,Enum.FillDirection.Vertical,6)
    return p
end

----------------------------------------------------------------
-- PANEL 1 — STRUCTURE
----------------------------------------------------------------
local PStruct = mkPanel(true)

sectionLabel("Structure Scanner",PStruct,1)

local _,ScrollStruct,OutStruct = mkOutput(PStruct,222,2)
OutStruct.Text = "Press [Clip] to scan the game tree."

local RowStruct = mkBtnRow(PStruct,3)
local BtnClip   = mkBtn("Clip",  C.CLIP,  RowStruct, UDim2.new(0.34,0,1,0), 1)
local BtnSCopy  = mkBtn("Copy",  C.COPY,  RowStruct, UDim2.new(0.33,-3,1,0),2)
local BtnSReset = mkBtn("Reset", C.RESET, RowStruct, UDim2.new(0.33,-3,1,0),3)

-- Structure info row
local InfoRow = new("Frame",{
    Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, LayoutOrder=4,
},PStruct)
local NodeCount = new("TextLabel",{
    Text="", Font=Enum.Font.Gotham, TextSize=10,
    TextColor3=C.DIM, BackgroundTransparency=1,
    Size=UDim2.new(1,0,1,0),
    TextXAlignment=Enum.TextXAlignment.Left,
},InfoRow)

----------------------------------------------------------------
-- PANEL 2 — ITEMS
----------------------------------------------------------------
local PItems = mkPanel(false)

sectionLabel("Item Scanner  (Tools · Produce · Accessories · More)",PItems,1)

local _,ScrollItems,OutItems = mkOutput(PItems,188,2)
OutItems.Text = "Press [Item Clip] to find all items, fruits, crops and tools."

local RowItems  = mkBtnRow(PItems,3)
local BtnIClip  = mkBtn("Item Clip", C.ITEM,  RowItems, UDim2.new(0.44,0,1,0), 1)
local BtnICopy  = mkBtn("Copy",      C.COPY,  RowItems, UDim2.new(0.28,-3,1,0),2)
local BtnIReset = mkBtn("Reset",     C.RESET, RowItems, UDim2.new(0.28,-3,1,0),3)

-- Item summary badges (2 rows of 2)
local BadgeRow1 = new("Frame",{
    Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, LayoutOrder=4,
},PItems)
listLayout(BadgeRow1,Enum.FillDirection.Horizontal,4)

local BadgeRow2 = new("Frame",{
    Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, LayoutOrder=5,
},PItems)
listLayout(BadgeRow2,Enum.FillDirection.Horizontal,4)

local function mkBadge(label,parent)
    local f = new("Frame",{
        Size=UDim2.new(0.5,-2,1,0), BackgroundColor3=C.BADGE,
        BorderSizePixel=0,
    },parent)
    corner(f,5)
    local t = new("TextLabel",{
        Text=label, Font=Enum.Font.Gotham, TextSize=10,
        TextColor3=C.DIM, BackgroundTransparency=1,
        Size=UDim2.new(1,0,1,0),
        TextXAlignment=Enum.TextXAlignment.Center,
    },f)
    return f,t
end

local _,BadgeTools   = mkBadge("Tools: 0",    BadgeRow1)
local _,BadgeProduce = mkBadge("Produce: 0",  BadgeRow1)
local _,BadgeAcc     = mkBadge("Accessories: 0", BadgeRow2)
local _,BadgeOther   = mkBadge("Other: 0",    BadgeRow2)

----------------------------------------------------------------
-- PANEL 3 — ANTI-CHEAT
----------------------------------------------------------------
local PAC = mkPanel(false)

sectionLabel("Anti-Cheat Remover",PAC,1)

-- Toggle button (big, centered)
local ToggleOuter = new("Frame",{
    Size=UDim2.new(1,0,0,52), BackgroundColor3=C.PANEL,
    BorderSizePixel=0, LayoutOrder=2,
},PAC)
corner(ToggleOuter,8)
new("UIStroke",{Color=C.LINE,Thickness=1},ToggleOuter)

local ToggleBtn = new("TextButton",{
    Text="  AC Remover: OFF",
    Font=Enum.Font.GothamBold, TextSize=14,
    TextColor3=C.DIM, BackgroundColor3=C.AC_OFF,
    Size=UDim2.new(1,-16,0,36),
    Position=UDim2.new(0,8,0.5,-18),
    BorderSizePixel=0, AutoButtonColor=false,
},ToggleOuter)
corner(ToggleBtn,7)

-- Status strip under toggle
local StatusLabel = new("TextLabel",{
    Text="Toggle ON to continuously strip all anti-cheat scripts.",
    Font=Enum.Font.Gotham, TextSize=10,
    TextColor3=C.DIM, BackgroundTransparency=1,
    Size=UDim2.new(1,0,0,16), LayoutOrder=3,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextWrapped=true,
},PAC)

local _,ScrollAC,OutAC = mkOutput(PAC,196,4)
OutAC.Text = "AC Remover log will appear here."

local ACClearBtn = mkBtn("Clear Log", C.RESET, PAC, UDim2.new(1,0,0,30), 5)

----------------------------------------------------------------
-- TAB SWITCHING
----------------------------------------------------------------
local tabColors = {C.CLIP, C.ITEM, C.AC_ON}
local panels    = {PStruct, PItems, PAC}
local activeTab = 1

local function switchTab(idx)
    activeTab = idx
    for i,p in ipairs(panels) do
        p.Visible = (i==idx)
        Tabs[i].TextColor3      = i==idx and C.TEXT or C.DIM
        Tabs[i].BackgroundColor3 = i==idx and C.BTN  or C.PANEL
        Tabs[i].Font            = i==idx and Enum.Font.GothamBold or Enum.Font.GothamSemibold
    end
    TweenService:Create(Indicator,TweenInfo.new(0.18),{
        Position=UDim2.new((idx-1)/3,0,1,-2),
        BackgroundColor3=tabColors[idx],
    }):Play()
end

for i,t in ipairs(Tabs) do
    t.MouseButton1Click:Connect(function() switchTab(i) end)
end
switchTab(1)

----------------------------------------------------------------
-- STRUCTURE SCANNER
----------------------------------------------------------------
local lastStructOutput = ""

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
        for _,child in ipairs(kids) do
            buildTree(child, depth+1, lines, count)
        end
    end
end

BtnClip.MouseButton1Click:Connect(function()
    OutStruct.Text = "Scanning..."
    NodeCount.Text = ""
    task.wait(0.05)
    local ok,err = pcall(function()
        local lines = {}
        local count = {0}
        table.insert(lines, string.format(
            "[ %s  |  PlaceId: %d ]\n", os.date("%H:%M:%S"), game.PlaceId
        ))
        for _,name in ipairs(SERVICES) do
            local svc = safeGet(name)
            if svc then
                table.insert(lines, ">> "..name)
                local ok2,kids = pcall(function() return svc:GetChildren() end)
                if ok2 then
                    for _,child in ipairs(kids) do
                        buildTree(child,1,lines,count)
                    end
                else
                    table.insert(lines,"  [Access Denied]")
                end
                table.insert(lines,"")
            else
                table.insert(lines,">> "..name.."  [Not Found]\n")
            end
        end
        if count[1] >= 2500 then
            table.insert(lines,"\n[Capped at 2500 nodes]")
        end
        lastStructOutput = table.concat(lines,"\n")
        OutStruct.Text   = lastStructOutput
        NodeCount.Text   = count[1].." nodes scanned"
    end)
    if not ok then OutStruct.Text = "Scan error:\n"..tostring(err) end
end)

BtnSCopy.MouseButton1Click:Connect(function()
    if lastStructOutput=="" then OutStruct.Text="Run Clip first."; return end
    local copied=false
    if setclipboard  then pcall(setclipboard,lastStructOutput);  copied=true
    elseif copystring then pcall(copystring, lastStructOutput); copied=true end
    local prev=OutStruct.Text
    OutStruct.Text = copied and ("Copied "..#lastStructOutput.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OutStruct and OutStruct.Parent then OutStruct.Text=prev end end)
end)

BtnSReset.MouseButton1Click:Connect(function()
    lastStructOutput=""
    OutStruct.Text="Press [Clip] to scan the game tree."
    NodeCount.Text=""
    ScrollStruct.CanvasPosition=Vector2.zero
end)

----------------------------------------------------------------
-- ITEM SCANNER
----------------------------------------------------------------
local lastItemOutput = ""

-- Returns true if instance matches by Roblox class
local function matchByClass(cn)
    return ITEM_CLASSES[cn] == true
end

-- Returns true if the name contains any item keyword
local function matchByKeyword(nm)
    local low = nm:lower()
    for _,kw in ipairs(ITEM_KEYWORDS) do
        if low:find(kw, 1, true) then return true end
    end
    return false
end

-- Categorise a found entry
local function categorise(cn, nm)
    local low = nm:lower()
    if cn=="Tool" or cn=="HopperBin" or cn=="Gear" then
        return "tool"
    elseif cn=="Accessory" or cn=="Hat" or cn=="Shirt" or cn=="Pants" or cn=="ShirtGraphic" then
        return "acc"
    elseif low:find("fruit",1,true) or low:find("crop",1,true) or low:find("seed",1,true)
        or low:find("berry",1,true) or low:find("harvest",1,true) or low:find("produce",1,true)
        or low:find("vegeta",1,true) or low:find("plant",1,true) or low:find("mushroom",1,true)
        or low:find("flower",1,true) or low:find("egg",1,true) or low:find("fish",1,true)
        or low:find("apple",1,true) or low:find("orange",1,true) or low:find("banana",1,true)
        or low:find("grape",1,true) or low:find("mango",1,true) or low:find("melon",1,true)
        or low:find("carrot",1,true) or low:find("potato",1,true) or low:find("corn",1,true)
        or low:find("tomato",1,true) or low:find("pumpkin",1,true) or low:find("wheat",1,true)
        or low:find("sprout",1,true) or low:find("sapling",1,true) or low:find("cactus",1,true)
        or low:find("cherry",1,true) or low:find("lemon",1,true) or low:find("lime",1,true)
        or low:find("peach",1,true) or low:find("pear",1,true) or low:find("kiwi",1,true) then
        return "produce"
    else
        return "other"
    end
end

-- Deep dual scanner: class match OR name keyword match
local function scanItems(root, results, seen, depth)
    if depth > 12 then return end
    local ok, kids = pcall(function() return root:GetChildren() end)
    if not ok then return end
    for _, child in ipairs(kids) do
        local okC,cn = pcall(function() return child.ClassName end)
        local okN,nm = pcall(function() return child.Name      end)
        if okC and okN then
            local ptr = tostring(child)
            if not seen[ptr] then
                local byClass   = matchByClass(cn)
                local byKeyword = matchByKeyword(nm)
                if byClass or byKeyword then
                    seen[ptr] = true
                    table.insert(results, {
                        inst=child, cn=cn, nm=nm,
                        cat=categorise(cn,nm),
                        how=(byClass and byKeyword) and "class+name"
                            or byClass and "class" or "keyword",
                    })
                end
            end
            -- Always recurse into containers
            if cn=="Folder" or cn=="Model" or cn=="Tool"
            or cn=="Configuration" or cn=="Frame" then
                scanItems(child, results, seen, depth+1)
            elseif not (cn:find("Part") or cn:find("Mesh") or cn:find("Decal")
                     or cn:find("Sound") or cn:find("Weld") or cn:find("Motor")) then
                scanItems(child, results, seen, depth+1)
            end
        end
    end
end

BtnIClip.MouseButton1Click:Connect(function()
    OutItems.Text = "Deep scanning for items, fruits, crops..."
    BadgeTools.Text   = "Tools: ?"
    BadgeProduce.Text = "Produce: ?"
    BadgeAcc.Text     = "Acc: ?"
    BadgeOther.Text   = "Other: ?"
    task.wait(0.05)

    local ok, err = pcall(function()
        local results = {}
        local seen    = {}
        local lines   = {}
        local tC,pC,aC,oC = 0,0,0,0

        -- 1. LocalPlayer Backpack
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            local before = #results
            scanItems(bp, results, seen, 0)
            local added = {}
            for i=before+1,#results do table.insert(added,results[i]) end
            if #added > 0 then
                table.insert(lines,">> LocalPlayer.Backpack")
                for _,e in ipairs(added) do
                    table.insert(lines,"  ["..e.cn.."]  "..e.nm.."  ("..e.how..")")
                end
                table.insert(lines,"")
            end
        end

        -- 2. Equipped character
        local char = LocalPlayer.Character
        if char then
            local before = #results
            scanItems(char, results, seen, 0)
            local added = {}
            for i=before+1,#results do table.insert(added,results[i]) end
            if #added > 0 then
                table.insert(lines,">> Character (Equipped)")
                for _,e in ipairs(added) do
                    table.insert(lines,"  ["..e.cn.."]  "..e.nm.."  ("..e.how..")")
                end
                table.insert(lines,"")
            end
        end

        -- 3. Game services
        for _,svcName in ipairs(ITEM_SOURCES) do
            local svc = safeGet(svcName)
            if svc then
                local before = #results
                scanItems(svc, results, seen, 0)
                local added = {}
                for i=before+1,#results do table.insert(added,results[i]) end
                if #added > 0 then
                    table.insert(lines,">> "..svcName)
                    for _,e in ipairs(added) do
                        table.insert(lines,"  ["..e.cn.."]  "..e.nm.."  ("..e.how..")")
                    end
                    table.insert(lines,"")
                end
            end
        end

        -- 4. Count categories
        for _,e in ipairs(results) do
            if     e.cat=="tool"    then tC=tC+1
            elseif e.cat=="produce" then pC=pC+1
            elseif e.cat=="acc"     then aC=aC+1
            else                         oC=oC+1 end
        end

        if #results == 0 then
            table.insert(lines,"No items found.")
        else
            table.insert(lines, string.format(
                "-- Total: %d  (Tools:%d  Produce:%d  Acc:%d  Other:%d)",
                #results, tC, pC, aC, oC
            ))
        end

        lastItemOutput    = table.concat(lines,"\n")
        OutItems.Text     = lastItemOutput
        BadgeTools.Text   = "Tools: "..tC
        BadgeProduce.Text = "Produce: "..pC
        BadgeAcc.Text     = "Acc: "..aC
        BadgeOther.Text   = "Other: "..oC
    end)

    if not ok then OutItems.Text = "Item scan error:\n"..tostring(err) end
end)

BtnICopy.MouseButton1Click:Connect(function()
    if lastItemOutput=="" then OutItems.Text="Run Item Clip first."; return end
    local copied=false
    if setclipboard  then pcall(setclipboard,lastItemOutput);  copied=true
    elseif copystring then pcall(copystring, lastItemOutput); copied=true end
    local prev=OutItems.Text
    OutItems.Text = copied and ("Copied "..#lastItemOutput.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OutItems and OutItems.Parent then OutItems.Text=prev end end)
end)

BtnIReset.MouseButton1Click:Connect(function()
    lastItemOutput=""
    OutItems.Text="Press [Item Clip] to find all items, fruits, crops and tools."
    BadgeTools.Text="Tools: 0"
    BadgeProduce.Text="Produce: 0"
    BadgeAcc.Text="Acc: 0"
    BadgeOther.Text="Other: 0"
    ScrollItems.CanvasPosition=Vector2.zero
end)

----------------------------------------------------------------
-- ANTI-CHEAT TOGGLE
----------------------------------------------------------------
local AC_SEARCH_SVC  = {"Workspace","ReplicatedStorage","StarterGui","ReplicatedFirst","StarterPack"}
local acEnabled      = false
local acConn         = nil
local acTotalRemoved = 0
local acLog          = {}

local function nameIsAC(name)
    local low = name:lower()
    for _,p in ipairs(AC_PATTERNS) do
        if low:find(p,1,true) then return true end
    end
    return false
end

local function deepScanAC(root, found, depth)
    if depth > 7 then return end
    local ok,kids = pcall(function() return root:GetChildren() end)
    if not ok then return end
    for _,child in ipairs(kids) do
        local okN,nm  = pcall(function() return child.Name      end)
        local okC,cls = pcall(function() return child.ClassName end)
        if okN and okC then
            if nameIsAC(nm) then
                table.insert(found,child)
            end
            -- only recurse into containers
            if cls=="Folder" or cls=="Model" or cls=="Configuration"
            or cls=="ReplicatedStorage" or cls=="Workspace" then
                deepScanAC(child,found,depth+1)
            end
        end
    end
end

local function runACPass()
    local found  = {}
    for _,svcName in ipairs(AC_SEARCH_SVC) do
        local svc = safeGet(svcName)
        if svc then deepScanAC(svc,found,0) end
    end

    local newRemoved = 0
    for _,inst in ipairs(found) do
        local okN,nm = pcall(function() return inst.Name end)
        local name   = okN and nm or "?"
        local ok = pcall(function()
            if inst:IsA("BaseScript") then inst.Disabled=true end
            inst:Destroy()
        end)
        if ok then
            newRemoved=newRemoved+1
            acTotalRemoved=acTotalRemoved+1
            table.insert(acLog,1,"+ Removed: "..name)
            if #acLog>80 then table.remove(acLog) end
        end
    end

    if newRemoved>0 then
        OutAC.Text = string.format(
            "[ Total removed: %d ]\n\n%s",
            acTotalRemoved, table.concat(acLog,"\n")
        )
    end
end

local function setACToggle(on)
    acEnabled = on
    if on then
        ToggleBtn.Text            = "  AC Remover: ON"
        ToggleBtn.TextColor3      = C.WHITE
        ToggleBtn.BackgroundColor3 = C.AC_ON
        StatusLabel.Text          = "Running — scanning every 2s for anti-cheat scripts."
        TweenService:Create(Indicator,TweenInfo.new(0.15),{BackgroundColor3=C.AC_ON}):Play()

        -- Initial pass immediately
        task.spawn(runACPass)

        -- Recurring scan every 2 seconds
        acConn = task.spawn(function()
            while acEnabled do
                task.wait(2)
                if acEnabled then runACPass() end
            end
        end)
    else
        acEnabled = false
        ToggleBtn.Text             = "  AC Remover: OFF"
        ToggleBtn.TextColor3       = C.DIM
        ToggleBtn.BackgroundColor3 = C.AC_OFF
        StatusLabel.Text           = "Toggle ON to continuously strip all anti-cheat scripts."
        TweenService:Create(Indicator,TweenInfo.new(0.15),{BackgroundColor3=C.AC_OFF}):Play()
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    setACToggle(not acEnabled)
end)

ACClearBtn.MouseButton1Click:Connect(function()
    acLog            = {}
    acTotalRemoved   = 0
    OutAC.Text       = "AC Remover log will appear here."
    ScrollAC.CanvasPosition = Vector2.zero
end)

-- Stop AC loop when GUI is destroyed
Gui.AncestryChanged:Connect(function()
    if not Gui.Parent then acEnabled=false end
end)

----------------------------------------------------------------
-- OPEN ANIMATION
----------------------------------------------------------------
Main.BackgroundTransparency = 1
Main.Position = UDim2.new(0.5,-W/2, 0.5,-H/2+16)

TweenService:Create(Main,TweenInfo.new(0.22,Enum.EasingStyle.Quint),{
    BackgroundTransparency=0,
    Position=UDim2.new(0.5,-W/2,0.5,-H/2),
}):Play()
task.delay(0.06,function()
    for _,o in ipairs(Main:GetDescendants()) do
        if (o:IsA("Frame") or o:IsA("TextButton") or o:IsA("TextLabel"))
        and o.BackgroundTransparency < 1 then
            TweenService:Create(o,TweenInfo.new(0.18),{BackgroundTransparency=0}):Play()
        end
        if (o:IsA("TextLabel") or o:IsA("TextButton")) then
            TweenService:Create(o,TweenInfo.new(0.18),{TextTransparency=0}):Play()
        end
    end
end)

print("[ExploitMenu v3] Loaded.")
