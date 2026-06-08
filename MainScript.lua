-- Exploit Menu v9  |  Structure · Items · Test · Fruits

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LP               = Players.LocalPlayer
local PGui             = LP:WaitForChild("PlayerGui")

if PGui:FindFirstChild("_EM9") then PGui._EM9:Destroy() end

-- ── COLORS ──────────────────────────────────────────────────
local BG    = Color3.fromRGB(18,18,24)
local PANEL = Color3.fromRGB(26,26,34)
local HDR   = Color3.fromRGB(30,30,40)
local LINE  = Color3.fromRGB(46,46,60)
local TEXT  = Color3.fromRGB(218,218,228)
local DIM   = Color3.fromRGB(110,110,132)
local WHITE = Color3.fromRGB(255,255,255)
local BTN   = Color3.fromRGB(40,40,54)
local OUTBG = Color3.fromRGB(10,10,16)
local BDGE  = Color3.fromRGB(50,50,68)
local CCLIP = Color3.fromRGB(52,96,158)
local CCOPY = Color3.fromRGB(46,106,80)
local CRST  = Color3.fromRGB(116,46,54)
local CITM  = Color3.fromRGB(100,80,40)
local CSCR  = Color3.fromRGB(55,75,125)
local CAC0  = Color3.fromRGB(58,58,75)
local CAC1  = Color3.fromRGB(50,130,70)
local CTST  = Color3.fromRGB(70,50,120)
local CFR1  = Color3.fromRGB(48,105,60)    -- common fruit
local CFR2  = Color3.fromRGB(130,90,20)    -- rare fruit
local CFR3  = Color3.fromRGB(90,30,110)    -- exotic fruit

-- ── FRUIT LIST (extracted from game scan) ───────────────────
-- Each entry: { display name, internal name in ReplicatedStorage, tier }
-- tier 1=common, 2=rare, 3=exotic/special
local FRUITS = {
    -- Common crops & produce
    {"Apple",            "Apple Seed",            1},
    {"Banana",           "Banana Seed",           1},
    {"Beetroot",         "Beetroot Seed",         1},
    {"Blueberry",        "Blueberry Seed",        1},
    {"Cabbage",          "Cabbage Seed",          1},
    {"Carrot",           "Carrot Seed",           1},
    {"Cauliflower",      "Cauliflower Seed",      1},
    {"Corn",             "Corn Seed",             1},
    {"Dragonfruit",      "Dragonfruit Seed",      1},
    {"Garlic",           "Garlic Seed",           1},
    {"Grape",            "Grape Seed",            1},
    {"Kiwi",             "Kiwi Seed",             1},
    {"Mango",            "Mango Seed",            1},
    {"Melon",            "Melon Seed",            1},
    {"Mushroom",         "Mushroom Seed",         1},
    {"Onion",            "Onion Seed",            1},
    {"Papaya",           "Papaya Seed",           1},
    {"Passionfruit",     "Passionfruit Seed",     1},
    {"Peach",            "Peach Seed",            1},
    {"Pepper",           "Pepper Seed",           1},
    {"Pineapple",        "Pineapple Seed",        1},
    {"Plum",             "Plum Seed",             1},
    {"Pomegranate",      "Pomegranate Seed",      1},
    {"Potato",           "Potato Seed",           1},
    {"Pumpkin",          "Pumpkin Seed",          1},
    {"Starfruit",        "Starfruit Seed",        1},
    {"Strawberry",       "Strawberry Seed",       1},
    {"Sunflower",        "Sunflower Seed",        1},
    {"Watermelon",       "Watermelon Seed",       1},
    {"Wheat",            "Wheat Seed",            1},
    {"Cherry Blossom",   "Cherry Blossom Seed",   1},
    {"Spring Onion",     "Spring Onion Seed",     1},
    -- Rare
    {"Blood Orange",     "Blood Orange Seed",     2},
    {"Cannon Fruit",     "Cannon Fruit Seed",     2},
    {"Crowned Pear",     "Crowned Pear Seed",     2},
    {"Crystalberry",     "Crystalberry Seed",     2},
    {"Durian",           "Durian Seed",           2},
    {"Ember Fruit",      "Ember Fruit Seed",      2},
    {"Ghost Pepper",     "Ghost Pepper Seed",     2},
    {"Gilded Nectarine", "Gilded Nectarine Seed", 2},
    {"Golden Apple",     "Golden Apple Seed",     2},
    {"Honeysuckle",      "Honeysuckle Seed",      2},
    {"Horned Melon",     "Horned Melon Seed",     2},
    {"Jackpot Jackfruit","Jackpot Jackfruit Seed",2},
    {"Martian Melon",    "Martian Melon Seed",    2},
    {"Moonflower",       "Moonflower Seed",       2},
    {"Nectarine",        "Nectarine Seed",        2},
    {"Spiked Rambutan",  "Spiked Rambutan Seed",  2},
    {"Striped Starfruit","Striped Starfruit Seed",2},
    {"Beanstalk",        "Beanstalk Seed",        2},
    {"Popcorn Poppy",    "Popcorn Poppy Seed",    2},
    -- Exotic / Special
    {"Void Fruit",           "Void Fruit Seed",           3},
    {"Hex Sprout",           "Hex Sprout Seed",           3},
    {"Iron Fern",            "Iron Fern Seed",            3},
    {"Diamond Blossom",      "Diamond Blossom Seed",      3},
    {"Golden Quillflower",   "Golden Quillflower Seed",   3},
    {"Silver Artichoke",     "Silver Artichoke Seed",     3},
    {"Twinflame Tulip",      "Twinflame Tulip Seed",      3},
    {"Carousel Crownflower", "Carousel Crownflower Seed", 3},
    {"Carnival Rose",        "Carnival Rose Seed",        3},
    {"Admin Sunflower",      "Admin Sunflower Seed",      3},
    {"Admin Rose",           "Admin Rose Seed",           3},
    {"Admin Crownflower",    "Admin Crownflower Seed",    3},
}

local TIER_COLORS = {CFR1, CFR2, CFR3}
local TIER_NAMES  = {"Common","Rare","Exotic"}

-- ── OTHER DATA ───────────────────────────────────────────────
local KW = {
    "apple","apricot","avocado","banana","blackberry","blueberry","cherry",
    "clementine","coconut","cranberry","date","dragonfruit","durian","elderberry",
    "fig","grape","grapefruit","guava","honeydew","jackfruit","kiwi","lemon",
    "lime","lychee","mandarin","mango","mangosteen","melon","mulberry","nectarine",
    "olive","orange","papaya","passionfruit","peach","pear","pineapple","plum",
    "pomegranate","quince","rambutan","raspberry","soursop","starfruit","strawberry",
    "tamarind","tangerine","watermelon","yuzu","mythic","divine","prismatic",
    "corrupted","void","cosmic","rainbow","carnival","tropical","bubblegum","frozen",
    "radioactive","acid","shadowfruit","blazefruit","frostfruit","venomfruit",
    "crystalfruit","goldfruit","demonfruit","angelfruit","dragonberry","phoenixfruit",
    "riftfruit","moonberry","sunfruit","starberry","glowfruit","artichoke","asparagus",
    "bean","beet","broccoli","cabbage","carrot","cauliflower","celery","chickpea",
    "corn","cucumber","eggplant","garlic","ginger","kale","leek","lentil","lettuce",
    "okra","onion","parsnip","pea","pepper","potato","pumpkin","radish","rice",
    "spinach","squash","sugarcane","tomato","turnip","wheat","yam","zucchini",
    "seed","sapling","sprout","bulb","crop","harvest","produce","plant","herb",
    "mushroom","truffle","fungi","spore","flower","rose","tulip","berry","algae",
    "food","meal","bread","meat","steak","chicken","fish","egg","milk","cheese",
    "honey","jam","jerky","soup","stew","nut","acorn","walnut","grain","flour",
    "water","canteen","flask","bottle","juice","wood","log","plank","stick",
    "branch","stone","rock","flint","coal","fiber","cloth","leather","hide","fur",
    "wool","silk","rope","iron","copper","bronze","silver","gold","steel","ore",
    "ingot","gem","crystal","diamond","emerald","ruby","sapphire","obsidian","bone",
    "claw","feather","shell","clay","oil","axe","pickaxe","shovel","scythe",
    "hammer","knife","sword","blade","spear","bow","arrow","gun","pistol","rifle",
    "shotgun","revolver","bullet","ammo","grenade","shield","armor","helmet",
    "boots","gloves","torch","lantern","trap","bandage","medkit","heal","health",
    "potion","elixir","antidote","medicine","tent","campfire","backpack","bag",
    "chest","crate","barrel","key","compass","fruit","item","loot","drop","reward",
    "resource","material","ingredient","token","coin","currency","trophy","pack",
    "bundle","jar","vial","powder","weapon","equipment","supply","relic","artifact",
}
local ITEM_CLS = {Tool=true,HopperBin=true,Accessory=true,Hat=true,Shirt=true,Pants=true,ShirtGraphic=true,Gear=true}
local SCR_CLS  = {Script=true,LocalScript=true,ModuleScript=true}
local AC_PAT   = {"anticheat","anti_cheat","anti-cheat","kicksystem","banhandler",
    "exploitdetect","detection","sanitycheck","speedcheck","flycheck","noclipcheck",
    "fairplay","safeguard","guardian","remotechecker","cheatdetect","hackdetect",
    "securitycheck","antiexploit","exploitban"}
local STRUCT_SVCS = {"Workspace","ReplicatedStorage","ReplicatedFirst","StarterGui",
    "StarterPack","StarterPlayer","Lighting","SoundService","Chat","Teams"}
local ITEM_SRCS   = {"Workspace","ReplicatedStorage","StarterPack","ReplicatedFirst"}
local SCR_SVCS    = {"Workspace","ReplicatedStorage","ReplicatedFirst","StarterGui",
    "StarterPack","StarterPlayer","Lighting","SoundService","Chat","Teams"}

-- ── UTIL ────────────────────────────────────────────────────
local function safeGet(n)
    local ok,r=pcall(game.GetService,game,n); if ok and r then return r end
    ok,r=pcall(function() return game[n] end); return ok and r or nil
end
local function doclip(txt)
    if setclipboard then
        local ok = pcall(setclipboard, txt)
        return ok
    end
    if copystring then
        local ok = pcall(copystring, txt)
        return ok
    end
    return false
end

-- ── ROOT GUI ─────────────────────────────────────────────────
local W,H = 298,410

local Gui=Instance.new("ScreenGui")
Gui.Name="_EM9"; Gui.ResetOnSpawn=false
Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset=true; Gui.Parent=PGui

local Main=Instance.new("Frame",Gui)
Main.Size=UDim2.fromOffset(W,H)
Main.Position=UDim2.new(0.5,-W/2,0.5,-H/2)
Main.BackgroundColor3=BG; Main.ClipsDescendants=true; Main.BorderSizePixel=0
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,10)
local ms=Instance.new("UIStroke",Main); ms.Color=LINE; ms.Thickness=1

-- ── HEADER ───────────────────────────────────────────────────
local Hdr=Instance.new("Frame",Main)
Hdr.Size=UDim2.new(1,0,0,34); Hdr.BackgroundColor3=HDR
Hdr.BorderSizePixel=0; Hdr.ZIndex=2
Instance.new("UICorner",Hdr).CornerRadius=UDim.new(0,10)
local hfix=Instance.new("Frame",Hdr)
hfix.Size=UDim2.new(1,0,0.5,0); hfix.Position=UDim2.new(0,0,0.5,0)
hfix.BackgroundColor3=HDR; hfix.BorderSizePixel=0

local htitle=Instance.new("TextLabel",Hdr)
htitle.Text="Exploit Menu  v9"; htitle.Font=Enum.Font.GothamBold; htitle.TextSize=13
htitle.TextColor3=TEXT; htitle.BackgroundTransparency=1
htitle.Size=UDim2.new(1,-58,1,0); htitle.Position=UDim2.new(0,10,0,0)
htitle.TextXAlignment=Enum.TextXAlignment.Left; htitle.ZIndex=3

local MinB=Instance.new("TextButton",Hdr)
MinB.Text="—"; MinB.Font=Enum.Font.GothamBold; MinB.TextSize=12
MinB.TextColor3=DIM; MinB.BackgroundColor3=BTN; MinB.BorderSizePixel=0
MinB.Size=UDim2.fromOffset(22,22); MinB.Position=UDim2.new(1,-50,0.5,-11)
MinB.ZIndex=4; MinB.AutoButtonColor=false
Instance.new("UICorner",MinB).CornerRadius=UDim.new(0,5)

local XBtn=Instance.new("TextButton",Hdr)
XBtn.Text="✕"; XBtn.Font=Enum.Font.GothamBold; XBtn.TextSize=11
XBtn.TextColor3=WHITE; XBtn.BackgroundColor3=CRST; XBtn.BorderSizePixel=0
XBtn.Size=UDim2.fromOffset(22,22); XBtn.Position=UDim2.new(1,-25,0.5,-11)
XBtn.ZIndex=4; XBtn.AutoButtonColor=false
Instance.new("UICorner",XBtn).CornerRadius=UDim.new(0,5)

XBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)
local mini=false
MinB.MouseButton1Click:Connect(function()
    mini=not mini
    TweenService:Create(Main,TweenInfo.new(0.18,Enum.EasingStyle.Quint),{
        Size=mini and UDim2.fromOffset(W,34) or UDim2.fromOffset(W,H)}):Play()
    MinB.Text=mini and "▲" or "—"
end)

do local drag,ds,sp
    Hdr.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then drag=true;ds=i.Position;sp=Main.Position end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement
        or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            Main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)
end

-- ── TAB BAR  (4 tabs, manually positioned — NO UIListLayout on bar) ──
local TBar=Instance.new("Frame",Main)
TBar.Size=UDim2.new(1,0,0,26); TBar.Position=UDim2.new(0,0,0,34)
TBar.BackgroundColor3=PANEL; TBar.BorderSizePixel=0

local TW = 0.25   -- each tab = 25% width

local function makeTab(label, xi)
    local t=Instance.new("TextButton",TBar)
    t.Text=label; t.Font=Enum.Font.GothamSemibold; t.TextSize=10
    t.TextColor3=DIM; t.BackgroundColor3=PANEL; t.BorderSizePixel=0
    t.AutoButtonColor=false
    t.Size=UDim2.new(TW,0,1,0); t.Position=UDim2.new(TW*xi,0,0,0)
    return t
end

local Tab1=makeTab("Structure",0)
local Tab2=makeTab("Items",    1)
local Tab3=makeTab("Test",     2)
local Tab4=makeTab("Fruits",   3)

-- indicator (absolute position, outside any layout)
local Ind=Instance.new("Frame",TBar)
Ind.Size=UDim2.new(TW,0,0,2); Ind.Position=UDim2.new(0,0,1,-2)
Ind.BackgroundColor3=CCLIP; Ind.BorderSizePixel=0; Ind.ZIndex=5

-- divider line
local div=Instance.new("Frame",Main)
div.Size=UDim2.new(1,0,0,1); div.Position=UDim2.new(0,0,0,60)
div.BackgroundColor3=LINE; div.BorderSizePixel=0

-- ── CONTENT AREA ─────────────────────────────────────────────
local Con=Instance.new("Frame",Main)
Con.Size=UDim2.new(1,0,1,-(34+26+1))
Con.Position=UDim2.new(0,0,0,61)
Con.BackgroundTransparency=1; Con.ClipsDescendants=true

-- ── SHARED BUILDERS ──────────────────────────────────────────
local function makePanel()
    local p=Instance.new("Frame",Con)
    p.Size=UDim2.new(1,0,1,0); p.BackgroundTransparency=1; p.Visible=false
    local pad=Instance.new("UIPadding",p)
    pad.PaddingLeft=UDim.new(0,7); pad.PaddingRight=UDim.new(0,7)
    pad.PaddingTop=UDim.new(0,7);  pad.PaddingBottom=UDim.new(0,7)
    local ll=Instance.new("UIListLayout",p)
    ll.FillDirection=Enum.FillDirection.Vertical
    ll.SortOrder=Enum.SortOrder.LayoutOrder
    ll.Padding=UDim.new(0,5)
    return p
end

local function makeLbl(txt,par,ord)
    local l=Instance.new("TextLabel",par)
    l.Text=txt; l.Font=Enum.Font.GothamSemibold; l.TextSize=10
    l.TextColor3=DIM; l.BackgroundTransparency=1
    l.Size=UDim2.new(1,0,0,13); l.LayoutOrder=ord
    l.TextXAlignment=Enum.TextXAlignment.Left
    return l
end

local function makeOut(par,h,ord)
    local f=Instance.new("Frame",par)
    f.Size=UDim2.new(1,0,0,h); f.BackgroundColor3=OUTBG
    f.BorderSizePixel=0; f.LayoutOrder=ord
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
    local st=Instance.new("UIStroke",f); st.Color=LINE; st.Thickness=1
    local sc=Instance.new("ScrollingFrame",f)
    sc.Size=UDim2.new(1,-6,1,-6); sc.Position=UDim2.new(0,3,0,3)
    sc.BackgroundTransparency=1; sc.BorderSizePixel=0
    sc.ScrollBarThickness=3; sc.ScrollBarImageColor3=LINE
    sc.CanvasSize=UDim2.new(0,0,0,0)
    sc.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sc.ScrollingDirection=Enum.ScrollingDirection.Y
    local lb=Instance.new("TextLabel",sc)
    lb.Text=""; lb.Font=Enum.Font.Code; lb.TextSize=11; lb.TextColor3=DIM
    lb.Size=UDim2.new(1,-4,0,0); lb.Position=UDim2.new(0,2,0,2)
    lb.BackgroundTransparency=1
    lb.TextXAlignment=Enum.TextXAlignment.Left
    lb.TextYAlignment=Enum.TextYAlignment.Top
    lb.TextWrapped=true; lb.AutomaticSize=Enum.AutomaticSize.Y
    return f,sc,lb
end

local function makeBtnRow(par,h,ord)
    local r=Instance.new("Frame",par)
    r.Size=UDim2.new(1,0,0,h); r.BackgroundTransparency=1; r.LayoutOrder=ord
    local ll=Instance.new("UIListLayout",r)
    ll.FillDirection=Enum.FillDirection.Horizontal
    ll.SortOrder=Enum.SortOrder.LayoutOrder
    ll.Padding=UDim.new(0,5)
    return r
end

local function makeBtn(txt,col,par,sz,ord)
    local b=Instance.new("TextButton",par)
    b.Text=txt; b.Font=Enum.Font.GothamBold; b.TextSize=12
    b.TextColor3=WHITE; b.BackgroundColor3=col; b.BorderSizePixel=0
    b.Size=sz; b.LayoutOrder=ord; b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.1),{BackgroundColor3=col:lerp(Color3.new(1,1,1),0.12)}):Play() end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.1),{BackgroundColor3=col}):Play() end)
    return b
end

local function makeBadgeRow(par,ord)
    local r=Instance.new("Frame",par)
    r.Size=UDim2.new(1,0,0,18); r.BackgroundTransparency=1; r.LayoutOrder=ord
    local ll=Instance.new("UIListLayout",r)
    ll.FillDirection=Enum.FillDirection.Horizontal; ll.SortOrder=Enum.SortOrder.LayoutOrder
    ll.Padding=UDim.new(0,4)
    return r
end
local function makeBadge(txt,par)
    local f=Instance.new("Frame",par)
    f.Size=UDim2.new(0.5,-2,1,0); f.BackgroundColor3=BDGE; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,4)
    local t=Instance.new("TextLabel",f)
    t.Text=txt; t.Font=Enum.Font.Gotham; t.TextSize=10; t.TextColor3=DIM
    t.BackgroundTransparency=1; t.Size=UDim2.new(1,0,1,0)
    t.TextXAlignment=Enum.TextXAlignment.Center
    return t
end
local function makeInfo(par,ord)
    local l=Instance.new("TextLabel",par)
    l.Text=""; l.Font=Enum.Font.Gotham; l.TextSize=10; l.TextColor3=DIM
    l.BackgroundTransparency=1; l.Size=UDim2.new(1,0,0,12); l.LayoutOrder=ord
    l.TextXAlignment=Enum.TextXAlignment.Left
    return l
end

-- ════════════════════════════════════════════════════════════
--  PANEL 1 — STRUCTURE
-- ════════════════════════════════════════════════════════════
local P1=makePanel()
makeLbl("Structure Scanner",P1,1)
local _,ScS,OuS=makeOut(P1,172,2)
OuS.Text="Press [Clip] to scan the game tree."
local RS1=makeBtnRow(P1,27,3)
local BClip=makeBtn("Clip",CCLIP,RS1,UDim2.new(0.34,0,1,0),1)
local BCopy=makeBtn("Copy",CCOPY,RS1,UDim2.new(0.33,-5,1,0),2)
local BRst =makeBtn("Reset",CRST,RS1,UDim2.new(0.33,-5,1,0),3)
local AntiB=makeBtn("  Anti-Cheat Remover: OFF",CAC0,P1,UDim2.new(1,0,0,27),4)
local NodeLbl=makeInfo(P1,5)
local ACLbl  =makeInfo(P1,6)

-- ════════════════════════════════════════════════════════════
--  PANEL 2 — ITEMS
-- ════════════════════════════════════════════════════════════
local P2=makePanel()
makeLbl("Item & Script Scanner",P2,1)
local _,ScI,OuI=makeOut(P2,138,2)
OuI.Text="Press [Item Clip] or [Clip Scripts] to scan."
local RI1=makeBtnRow(P2,27,3)
local BIC =makeBtn("Item Clip",CITM,RI1,UDim2.new(0.44,0,1,0),1)
local BICp=makeBtn("Copy",CCOPY,RI1,UDim2.new(0.28,-5,1,0),2)
local BIRs=makeBtn("Reset",CRST,RI1,UDim2.new(0.28,-5,1,0),3)
local BSC=makeBtn("  Clip Scripts  (Script · LocalScript · ModuleScript)",CSCR,P2,UDim2.new(1,0,0,27),4)
local IBR1=makeBadgeRow(P2,5); local IBR2=makeBadgeRow(P2,6)
local BgTools=makeBadge("Tools:0",IBR1); local BgProduce=makeBadge("Produce:0",IBR1)
local BgAcc  =makeBadge("Acc:0",IBR2);  local BgOther  =makeBadge("Other:0",IBR2)
local SBR1=makeBadgeRow(P2,7); local SBR2=makeBadgeRow(P2,8)
local BgSc=makeBadge("Script:0",SBR1);  local BgLs=makeBadge("LocalScript:0",SBR1)
local BgMs=makeBadge("Module:0",SBR2);  local BgTt=makeBadge("Total:0",SBR2)
local ILbl=makeInfo(P2,9)

-- ════════════════════════════════════════════════════════════
--  PANEL 3 — TEST
-- ════════════════════════════════════════════════════════════
local P3=makePanel()
makeLbl("Script Self-Test",P3,1)
local _,ScT,OuT=makeOut(P3,200,2)
OuT.Text="Press [Run Tests] to verify everything is working."
local RT1=makeBtnRow(P3,27,3)
local BRunT =makeBtn("Run Tests",CTST,RT1,UDim2.new(0.6,0,1,0),1)
local BClearT=makeBtn("Clear",CRST,RT1,UDim2.new(0.4,-5,1,0),2)
local TestInfo=makeInfo(P3,4)

-- ════════════════════════════════════════════════════════════
--  PANEL 4 — FRUITS
-- ════════════════════════════════════════════════════════════
local P4=makePanel()

-- Status bar at top
local FruitStatus=Instance.new("TextLabel",P4)
FruitStatus.Text="Tap a fruit to give it to yourself."
FruitStatus.Font=Enum.Font.GothamSemibold; FruitStatus.TextSize=10
FruitStatus.TextColor3=DIM; FruitStatus.BackgroundTransparency=1
FruitStatus.Size=UDim2.new(1,0,0,13); FruitStatus.LayoutOrder=1
FruitStatus.TextXAlignment=Enum.TextXAlignment.Left

-- Legend row
local LegRow=makeBtnRow(P4,16,2)
for ti,lbl in ipairs({"● Common","● Rare","● Exotic"}) do
    local l=Instance.new("TextLabel",LegRow)
    l.Text=lbl; l.Font=Enum.Font.Gotham; l.TextSize=9
    l.TextColor3=TIER_COLORS[ti]; l.BackgroundTransparency=1
    l.Size=UDim2.new(1/3,-3,1,0); l.LayoutOrder=ti
    l.TextXAlignment=Enum.TextXAlignment.Center
end

-- Scrollable fruit button list
local FruitScroll=Instance.new("ScrollingFrame",P4)
FruitScroll.Size=UDim2.new(1,0,1,-40)   -- fill remaining space
FruitScroll.BackgroundColor3=OUTBG; FruitScroll.BorderSizePixel=0
FruitScroll.ScrollBarThickness=3; FruitScroll.ScrollBarImageColor3=LINE
FruitScroll.CanvasSize=UDim2.new(0,0,0,0)
FruitScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
FruitScroll.ScrollingDirection=Enum.ScrollingDirection.Y
FruitScroll.LayoutOrder=3
Instance.new("UICorner",FruitScroll).CornerRadius=UDim.new(0,6)
local fst=Instance.new("UIStroke",FruitScroll); fst.Color=LINE; fst.Thickness=1

local FruitInner=Instance.new("Frame",FruitScroll)
FruitInner.Size=UDim2.new(1,0,0,0)
FruitInner.BackgroundTransparency=1
FruitInner.AutomaticSize=Enum.AutomaticSize.Y
local fpad=Instance.new("UIPadding",FruitInner)
fpad.PaddingLeft=UDim.new(0,5); fpad.PaddingRight=UDim.new(0,5)
fpad.PaddingTop=UDim.new(0,5);  fpad.PaddingBottom=UDim.new(0,5)
local fll=Instance.new("UIListLayout",FruitInner)
fll.FillDirection=Enum.FillDirection.Vertical
fll.SortOrder=Enum.SortOrder.LayoutOrder
fll.Padding=UDim.new(0,4)

-- ── FRUIT GIVE LOGIC ────────────────────────────────────────
local function giveFruit(name)
    local RS = safeGet("ReplicatedStorage")
    if not RS then return false,"No ReplicatedStorage" end

    -- Search locations in priority order
    local locs = {
        RS:FindFirstChild("Crops"),
        RS:FindFirstChild("SpecialFruits"),
        RS:FindFirstChild("Seeds"),
        RS:FindFirstChild("Plants"),
        RS,
    }

    for _,loc in ipairs(locs) do
        if loc then
            local item = loc:FindFirstChild(name)
            if item then
                local ok,err = pcall(function()
                    local clone = item:Clone()
                    if clone:IsA("Tool") then
                        -- Goes straight to backpack
                        clone.Parent = LP.Backpack
                    else
                        -- Place in workspace near the player
                        local char = LP.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if root then
                            clone.Parent = workspace
                            local cf = root.CFrame * CFrame.new(0,3,-4)
                            if clone:IsA("Model") then
                                if clone.PrimaryPart then
                                    clone:SetPrimaryPartCFrame(cf)
                                else
                                    -- try to move all BaseParts
                                    for _,p in ipairs(clone:GetDescendants()) do
                                        if p:IsA("BasePart") then p.CFrame=cf; break end
                                    end
                                end
                            elseif clone:IsA("BasePart") then
                                clone.CFrame = cf
                            end
                        else
                            clone.Parent = LP.Backpack
                        end
                    end
                end)
                if ok then
                    return true, "Gave: "..name.." ✓"
                else
                    return false, tostring(err)
                end
            end
        end
    end
    return false, name.." not found in game"
end

-- ── BUILD FRUIT BUTTONS ──────────────────────────────────────
local lastTier = 0
for idx,info in ipairs(FRUITS) do
    local dname, iname, tier = info[1], info[2], info[3]
    local col = TIER_COLORS[tier]

    -- Tier divider label
    if tier ~= lastTier then
        lastTier = tier
        local div2=Instance.new("TextLabel",FruitInner)
        div2.Text=TIER_NAMES[tier].." Fruits"
        div2.Font=Enum.Font.GothamBold; div2.TextSize=9
        div2.TextColor3=col; div2.BackgroundTransparency=1
        div2.Size=UDim2.new(1,0,0,12); div2.LayoutOrder=idx*10-1
        div2.TextXAlignment=Enum.TextXAlignment.Left
    end

    local fb=Instance.new("TextButton",FruitInner)
    fb.Text=dname; fb.Font=Enum.Font.GothamBold; fb.TextSize=11
    fb.TextColor3=WHITE; fb.BackgroundColor3=col; fb.BorderSizePixel=0
    fb.Size=UDim2.new(1,0,0,26); fb.LayoutOrder=idx*10; fb.AutoButtonColor=false
    Instance.new("UICorner",fb).CornerRadius=UDim.new(0,6)
    fb.MouseEnter:Connect(function()
        TweenService:Create(fb,TweenInfo.new(0.1),{BackgroundColor3=col:lerp(Color3.new(1,1,1),0.15)}):Play() end)
    fb.MouseLeave:Connect(function()
        TweenService:Create(fb,TweenInfo.new(0.1),{BackgroundColor3=col}):Play() end)

    local capturedName = iname
    local capturedBtn  = fb
    fb.MouseButton1Click:Connect(function()
        capturedBtn.Text = "Giving…"
        local ok,msg = giveFruit(capturedName)
        FruitStatus.Text = msg
        FruitStatus.TextColor3 = ok and Color3.fromRGB(100,220,100) or Color3.fromRGB(220,80,80)
        capturedBtn.Text = dname
        if ok then
            TweenService:Create(capturedBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(50,180,80)}):Play()
            task.delay(0.8,function()
                TweenService:Create(capturedBtn,TweenInfo.new(0.3),{BackgroundColor3=col}):Play()
            end)
        end
    end)
end

-- ════════════════════════════════════════════════════════════
--  TAB SWITCHING
-- ════════════════════════════════════════════════════════════
local ALL_TABS   = {Tab1,Tab2,Tab3,Tab4}
local ALL_PANELS = {P1,P2,P3,P4}
local ALL_COLS   = {CCLIP,CITM,CTST,CFR1}
local curTab     = 0

local function switchTab(idx)
    if curTab==idx then return end; curTab=idx
    for i=1,4 do
        ALL_PANELS[i].Visible       = (i==idx)
        ALL_TABS[i].TextColor3      = (i==idx) and TEXT or DIM
        ALL_TABS[i].BackgroundColor3= (i==idx) and BTN  or PANEL
        ALL_TABS[i].Font            = (i==idx) and Enum.Font.GothamBold or Enum.Font.GothamSemibold
    end
    TweenService:Create(Ind,TweenInfo.new(0.15),{
        Position=UDim2.new(TW*(idx-1),0,1,-2),
        BackgroundColor3=ALL_COLS[idx],
    }):Play()
end

Tab1.MouseButton1Click:Connect(function() switchTab(1) end)
Tab2.MouseButton1Click:Connect(function() switchTab(2) end)
Tab3.MouseButton1Click:Connect(function() switchTab(3) end)
Tab4.MouseButton1Click:Connect(function() switchTab(4) end)
switchTab(1)

-- ════════════════════════════════════════════════════════════
--  STRUCTURE LOGIC
-- ════════════════════════════════════════════════════════════
local lastSOut=""
local function buildTree(inst,depth,lines,cnt)
    if cnt[1]>=2500 then return end; cnt[1]=cnt[1]+1
    local a,cn=pcall(function() return inst.ClassName end)
    local b,nm=pcall(function() return inst.Name end)
    if not a or not b then return end
    table.insert(lines,string.rep("  ",math.min(depth,10)).."["..cn.."]  "..nm)
    if depth>=8 then return end
    local c,kids=pcall(function() return inst:GetChildren() end)
    if c then for _,k in ipairs(kids) do buildTree(k,depth+1,lines,cnt) end end
end
BClip.MouseButton1Click:Connect(function()
    OuS.Text="Scanning…"; NodeLbl.Text=""; task.wait(0.05)
    local ok,er=pcall(function()
        local L,cnt={},{0}
        table.insert(L,string.format("[ %s | PlaceId:%d ]\n",os.date("%H:%M:%S"),game.PlaceId))
        for _,n in ipairs(STRUCT_SVCS) do
            local s=safeGet(n)
            if s then
                table.insert(L,">> "..n)
                local ok2,kids=pcall(function() return s:GetChildren() end)
                if ok2 then for _,c in ipairs(kids) do buildTree(c,1,L,cnt) end
                else table.insert(L,"  [Access Denied]") end
                table.insert(L,"")
            else table.insert(L,">> "..n.."  [Not Found]\n") end
        end
        if cnt[1]>=2500 then table.insert(L,"\n[Capped at 2500 nodes]") end
        lastSOut=table.concat(L,"\n"); OuS.Text=lastSOut; NodeLbl.Text=cnt[1].." nodes scanned"
    end)
    if not ok then OuS.Text="Error:\n"..tostring(er) end
end)
BCopy.MouseButton1Click:Connect(function()
    if lastSOut=="" then OuS.Text="Run Clip first."; return end
    local ok=doclip(lastSOut); local prev=OuS.Text
    OuS.Text=ok and ("Copied "..#lastSOut.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OuS and OuS.Parent then OuS.Text=prev end end)
end)
BRst.MouseButton1Click:Connect(function()
    lastSOut=""; OuS.Text="Press [Clip] to scan the game tree."
    NodeLbl.Text=""; ScS.CanvasPosition=Vector2.zero
end)

-- Anti-Cheat
local acOn,acKilled=false,0
local function nameIsAC(nm)
    local lo=nm:lower()
    for _,p in ipairs(AC_PAT) do if lo:find(p,1,true) then return true end end; return false
end
local function deepAC(root,found,d)
    if d>8 then return end
    local ok,kids=pcall(function() return root:GetChildren() end)
    if not ok then return end
    for _,c in ipairs(kids) do
        local a,nm=pcall(function() return c.Name end)
        local b,cn=pcall(function() return c.ClassName end)
        if a and b then
            if nameIsAC(nm) then table.insert(found,c) end
            if cn=="Folder" or cn=="Model" or cn=="Configuration" then deepAC(c,found,d+1) end
        end
    end
end
local function runAC()
    local found={}
    for _,n in ipairs({"Workspace","ReplicatedStorage","StarterGui","ReplicatedFirst","StarterPack","StarterPlayer"}) do
        local s=safeGet(n); if s then deepAC(s,found,0) end
    end
    local k=0
    for _,inst in ipairs(found) do
        local ok=pcall(function() if inst:IsA("BaseScript") then inst.Disabled=true end; inst:Destroy() end)
        if ok then k=k+1; acKilled=acKilled+1 end
    end
    if k>0 then ACLbl.Text=string.format("Removed %d this pass | total:%d",k,acKilled) end
end
local function setAC(on)
    acOn=on
    if on then
        AntiB.Text="  Anti-Cheat Remover: ON"; AntiB.BackgroundColor3=CAC1
        ACLbl.Text="Running — scanning every 2s…"; task.spawn(runAC)
        task.spawn(function() while acOn do task.wait(2); if acOn then runAC() end end end)
    else
        AntiB.Text="  Anti-Cheat Remover: OFF"; AntiB.BackgroundColor3=CAC0
        ACLbl.Text=string.format("Stopped. Total removed:%d",acKilled)
    end
end
AntiB.MouseButton1Click:Connect(function() setAC(not acOn) end)
Gui.AncestryChanged:Connect(function() if not Gui.Parent then acOn=false end end)

-- ════════════════════════════════════════════════════════════
--  ITEM LOGIC
-- ════════════════════════════════════════════════════════════
local lastIOut=""
local function matchCls(cn) return ITEM_CLS[cn]==true end
local function matchKW(nm)
    local lo=nm:lower()
    for _,k in ipairs(KW) do if lo:find(k,1,true) then return true end end; return false
end
local function itemCat(cn,nm)
    local lo=nm:lower()
    if cn=="Tool" or cn=="HopperBin" or cn=="Gear" then return "tool" end
    if cn=="Accessory" or cn=="Hat" or cn=="Shirt" or cn=="Pants" or cn=="ShirtGraphic" then return "acc" end
    local pKW={"fruit","seed","crop","berry","plant","mushroom","flower","egg","fish","harvest",
        "produce","apple","orange","banana","mango","melon","grape","carrot","potato","corn",
        "tomato","pumpkin","sprout","sapling","cherry","lemon","peach","pear","kiwi","coconut",
        "dragonfruit","strawberry"}
    for _,k in ipairs(pKW) do if lo:find(k,1,true) then return "produce" end end
    return "other"
end
local function deepItems(root,res,seen,d)
    if d>12 then return end
    local ok,kids=pcall(function() return root:GetChildren() end)
    if not ok then return end
    for _,c in ipairs(kids) do
        local ok1,cn=pcall(function() return c.ClassName end)
        local ok2,nm=pcall(function() return c.Name end)
        if ok1 and ok2 then
            local ptr=tostring(c)
            if not seen[ptr] then
                local bc=matchCls(cn); local bk=matchKW(nm)
                if bc or bk then seen[ptr]=true
                    table.insert(res,{cn=cn,nm=nm,cat=itemCat(cn,nm),
                        how=(bc and bk) and "class+kw" or bc and "class" or "keyword"}) end
            end
            if not(cn:find("Part") or cn:find("Mesh") or cn:find("Decal")
                or cn:find("Sound") or cn:find("Weld") or cn:find("Motor") or cn:find("Constraint")) then
                deepItems(c,res,seen,d+1) end
        end
    end
end
BIC.MouseButton1Click:Connect(function()
    OuI.Text="Scanning items…"; ILbl.Text=""
    BgTools.Text="…"; BgProduce.Text="…"; BgAcc.Text="…"; BgOther.Text="…"; task.wait(0.05)
    local ok,er=pcall(function()
        local res,seen,L={},{},{}; local tC,pC,aC,oC=0,0,0,0
        local function sec(lbl,root)
            local bef=#res; deepItems(root,res,seen,0)
            if #res>bef then table.insert(L,">> "..lbl)
                for i=bef+1,#res do local e=res[i]
                    table.insert(L,"  ["..e.cn.."]  "..e.nm.."  ("..e.how..")") end
                table.insert(L,"") end
        end
        local bp=LP:FindFirstChild("Backpack"); if bp then sec("Backpack",bp) end
        local ch=LP.Character; if ch then sec("Character",ch) end
        for _,n in ipairs(ITEM_SRCS) do local s=safeGet(n); if s then sec(n,s) end end
        for _,e in ipairs(res) do
            if e.cat=="tool" then tC=tC+1 elseif e.cat=="produce" then pC=pC+1
            elseif e.cat=="acc" then aC=aC+1 else oC=oC+1 end end
        if #res==0 then table.insert(L,"No items found.")
        else table.insert(L,string.format("-- Total:%d (Tools:%d Produce:%d Acc:%d Other:%d)",#res,tC,pC,aC,oC)) end
        lastIOut=table.concat(L,"\n"); OuI.Text=lastIOut; ILbl.Text=#res.." items found"
        BgTools.Text="Tools:"..tC; BgProduce.Text="Produce:"..pC
        BgAcc.Text="Acc:"..aC;     BgOther.Text="Other:"..oC
    end)
    if not ok then OuI.Text="Item error:\n"..tostring(er) end
end)
BICp.MouseButton1Click:Connect(function()
    if lastIOut=="" then OuI.Text="Run Item Clip first."; return end
    local ok=doclip(lastIOut); local prev=OuI.Text
    OuI.Text=ok and ("Copied "..#lastIOut.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OuI and OuI.Parent then OuI.Text=prev end end)
end)
BIRs.MouseButton1Click:Connect(function()
    lastIOut=""; OuI.Text="Press [Item Clip] or [Clip Scripts] to scan."
    BgTools.Text="Tools:0"; BgProduce.Text="Produce:0"; BgAcc.Text="Acc:0"; BgOther.Text="Other:0"
    BgSc.Text="Script:0"; BgLs.Text="LocalScript:0"; BgMs.Text="Module:0"; BgTt.Text="Total:0"
    ILbl.Text=""; ScI.CanvasPosition=Vector2.zero
end)
local lastScOut=""
local function deepScripts(root,res,seen,d)
    if d>12 then return end
    local ok,kids=pcall(function() return root:GetChildren() end)
    if not ok then return end
    for _,c in ipairs(kids) do
        local ok1,cn=pcall(function() return c.ClassName end)
        local ok2,nm=pcall(function() return c.Name end)
        if ok1 and ok2 then
            local ptr=tostring(c)
            if SCR_CLS[cn] and not seen[ptr] then seen[ptr]=true
                local dis=""
                pcall(function() if c:IsA("BaseScript") and c.Disabled then dis=" [DISABLED]" end end)
                table.insert(res,{cn=cn,nm=nm,dis=dis}) end
            deepScripts(c,res,seen,d+1)
        end
    end
end
BSC.MouseButton1Click:Connect(function()
    OuI.Text="Scanning scripts…"; ILbl.Text=""
    BgSc.Text="…"; BgLs.Text="…"; BgMs.Text="…"; BgTt.Text="…"; task.wait(0.05)
    local ok,er=pcall(function()
        local res,seen,L={},{},{}; local scC,lsC,msC=0,0,0
        table.insert(L,string.format("[ %s | PlaceId:%d ]\n",os.date("%H:%M:%S"),game.PlaceId))
        for _,n in ipairs(SCR_SVCS) do
            local s=safeGet(n)
            if s then
                local bef=#res; deepScripts(s,res,seen,0)
                if #res>bef then table.insert(L,">> "..n)
                    for i=bef+1,#res do local e=res[i]
                        table.insert(L,"  ["..e.cn.."]  "..e.nm..e.dis) end
                    table.insert(L,"") end
            end
        end
        local ch=LP.Character
        if ch then
            local bef=#res; deepScripts(ch,res,seen,0)
            if #res>bef then table.insert(L,">> Character")
                for i=bef+1,#res do local e=res[i]
                    table.insert(L,"  ["..e.cn.."]  "..e.nm..e.dis) end
                table.insert(L,"") end
        end
        local ps=LP:FindFirstChild("PlayerScripts")
        if ps then
            local bef=#res; deepScripts(ps,res,seen,0)
            if #res>bef then table.insert(L,">> PlayerScripts")
                for i=bef+1,#res do local e=res[i]
                    table.insert(L,"  ["..e.cn.."]  "..e.nm..e.dis) end
                table.insert(L,"") end
        end
        for _,e in ipairs(res) do
            if e.cn=="Script" then scC=scC+1 elseif e.cn=="LocalScript" then lsC=lsC+1
            elseif e.cn=="ModuleScript" then msC=msC+1 end
        end
        local tot=#res
        if tot==0 then table.insert(L,"No accessible scripts found.")
        else table.insert(L,string.format("-- Total:%d (Script:%d LocalScript:%d Module:%d)",tot,scC,lsC,msC)) end
        lastScOut=table.concat(L,"\n"); OuI.Text=lastScOut; ILbl.Text=tot.." scripts found"
        BgSc.Text="Script:"..scC; BgLs.Text="LocalScript:"..lsC; BgMs.Text="Module:"..msC; BgTt.Text="Total:"..tot
    end)
    if not ok then OuI.Text="Script error:\n"..tostring(er) end
end)

-- ════════════════════════════════════════════════════════════
--  TEST LOGIC
-- ════════════════════════════════════════════════════════════
BRunT.MouseButton1Click:Connect(function()
    OuT.Text="Running…"; TestInfo.Text=""; task.wait(0.1)
    local lines={}; local pass,fail=0,0
    local function check(name,fn)
        local ok,res=pcall(fn); local s=ok and res
        if s then pass=pass+1; table.insert(lines,"[PASS]  "..name)
        else fail=fail+1; table.insert(lines,"[FAIL]  "..name.." — "..(ok and "false" or tostring(res))) end
    end
    check("GUI in PlayerGui",              function() return PGui:FindFirstChild("_EM9")~=nil end)
    check("Main frame visible",            function() return Main.Visible==true end)
    check("Panel 1 (Structure) exists",    function() return P1:IsA("Frame") end)
    check("Panel 2 (Items) exists",        function() return P2:IsA("Frame") end)
    check("Panel 3 (Test) exists",         function() return P3:IsA("Frame") end)
    check("Panel 4 (Fruits) exists",       function() return P4:IsA("Frame") end)
    check("All 4 tabs exist",              function() return Tab1 and Tab2 and Tab3 and Tab4 end)
    check("Workspace accessible",          function() return safeGet("Workspace")~=nil end)
    check("ReplicatedStorage accessible",  function() return safeGet("ReplicatedStorage")~=nil end)
    check("LocalPlayer exists",            function() return LP~=nil end)
    check("Clipboard available",           function() return setclipboard~=nil or copystring~=nil end)
    check("Fruits table has 60+ entries",  function() return #FRUITS>=60 end)
    check("On Test tab (P3 visible)",      function() return P3.Visible==true end)
    check("P1 not visible on Test tab",    function() return P1.Visible==false end)
    check("P4 not visible on Test tab",    function() return P4.Visible==false end)
    table.insert(lines,""); table.insert(lines,string.format("Done — %d passed / %d failed",pass,fail))
    OuT.Text=table.concat(lines,"\n"); TestInfo.Text=string.format("%d/%d tests passed",pass,pass+fail)
end)
BClearT.MouseButton1Click:Connect(function()
    OuT.Text="Press [Run Tests] to verify everything is working."
    TestInfo.Text=""; ScT.CanvasPosition=Vector2.zero
end)

-- ── OPEN ANIMATION ───────────────────────────────────────────
Main.BackgroundTransparency=1
Main.Position=UDim2.new(0.5,-W/2,0.5,-H/2+12)
TweenService:Create(Main,TweenInfo.new(0.2,Enum.EasingStyle.Quint),{
    BackgroundTransparency=0,
    Position=UDim2.new(0.5,-W/2,0.5,-H/2),
}):Play()

print("[ExploitMenu v9]  Structure | Items | Test | Fruits — all panels ready")
