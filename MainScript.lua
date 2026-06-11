-- Exploit Menu v9  |  Structure · Items · Scripts · Fruits · Research · Extraction · Anti-Suite

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LP               = Players.LocalPlayer
local PGui             = LP:WaitForChild("PlayerGui")

if PGui:FindFirstChild("_EM9") then PGui._EM9:Destroy() end
if PGui:FindFirstChild("_EM9Toggle") then PGui._EM9Toggle:Destroy() end

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
local CFR1  = Color3.fromRGB(48,105,60)    -- common fruit
local CFR2  = Color3.fromRGB(130,90,20)    -- rare fruit
local CFR3  = Color3.fromRGB(90,30,110)    -- exotic fruit
-- ── NEW SECTION COLORS ──────────────────────────────────────
local CRES  = Color3.fromRGB(55,80,148)    -- Research / Remote Spy
local CEXT  = Color3.fromRGB(88,55,115)    -- Extraction / Source Dump
local CANT  = Color3.fromRGB(132,48,52)    -- Anti-Suite
local CVULN = Color3.fromRGB(175,75,30)    -- Vuln highlight
local CSPY  = Color3.fromRGB(40,110,118)   -- Remote Spy active

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
-- ── NEW DATA ────────────────────────────────────────────────
local VULN_KW  = {"admin","ban","kick","give","god","fly","noclip","speed","teleport",
    "btools","delete","op","promote","demote","bring","crash","shutdown","backdoor"}
local LOG_KW   = {"log","analytic","track","metric","report","telemetry","stat",
    "event","record","audit","monitor","heartbeat","ping","beacon"}
local STAFF_KW = {"admin","mod","moderator","owner","staff","dev","developer","manager",
    "operator","helper","support","lead","head","super","root"}
local KICK_KW  = {"kick","ban","remove","disconnect","teleport"}
local CLUE_PAT = {
    {p="kick",        lbl="kick logic"},
    {p=":fireserver", lbl="RemoteEvent FireServer"},
    {p=":invokeserver",lbl="RemoteFunction InvokeServer"},
    {p="anticheat",   lbl="anti-cheat reference"},
    {p="exploit",     lbl="exploit detection"},
    {p="datastore",   lbl="DataStore access"},
    {p="httpservice", lbl="HTTP requests"},
    {p="setcore",     lbl="CoreGui manipulation"},
}

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
local W,H = 310,440

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

-- Gradient on header (subtle obsidian shimmer)
local hgrad=Instance.new("UIGradient",Hdr)
hgrad.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(38,38,52)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(24,24,32)),
}
hgrad.Rotation=90

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

XBtn.MouseButton1Click:Connect(function() Main.Visible=false end)
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

-- ── FLOATING MOBILE TOGGLE ───────────────────────────────────
-- Persistent bottom-right button to show/hide menu on mobile
local TogGui=Instance.new("ScreenGui")
TogGui.Name="_EM9Toggle"; TogGui.ResetOnSpawn=false
TogGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
TogGui.IgnoreGuiInset=true; TogGui.Parent=PGui

local TogBtn=Instance.new("TextButton",TogGui)
TogBtn.Text="EM"; TogBtn.Font=Enum.Font.GothamBold; TogBtn.TextSize=13
TogBtn.TextColor3=WHITE; TogBtn.BackgroundColor3=Color3.fromRGB(35,35,50)
TogBtn.BorderSizePixel=0; TogBtn.AutoButtonColor=false
TogBtn.Size=UDim2.fromOffset(44,44)
TogBtn.Position=UDim2.new(1,-52,1,-60)
TogBtn.ZIndex=10
Instance.new("UICorner",TogBtn).CornerRadius=UDim.new(0,10)
local tgs=Instance.new("UIStroke",TogBtn); tgs.Color=CCLIP; tgs.Thickness=1.5
-- Gradient on toggle button
local tgg=Instance.new("UIGradient",TogBtn)
tgg.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(52,52,75)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(28,28,42)),
}
tgg.Rotation=135

TogBtn.MouseButton1Click:Connect(function()
    Main.Visible=not Main.Visible
    if Main.Visible and mini then
        mini=false
        Main.Size=UDim2.fromOffset(W,H)
        MinB.Text="—"
    end
    TweenService:Create(TogBtn,TweenInfo.new(0.1),{
        BackgroundColor3=Main.Visible
            and Color3.fromRGB(45,45,65)
            or  Color3.fromRGB(35,35,50)
    }):Play()
end)
TogBtn.MouseEnter:Connect(function()
    TweenService:Create(TogBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(50,50,70)}):Play()
end)
TogBtn.MouseLeave:Connect(function()
    TweenService:Create(TogBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(35,35,50)}):Play()
end)

-- ── TAB BAR ROW 1  (original 4 tabs) ────────────────────────
local TBar=Instance.new("Frame",Main)
TBar.Size=UDim2.new(1,0,0,26); TBar.Position=UDim2.new(0,0,0,34)
TBar.BackgroundColor3=PANEL; TBar.BorderSizePixel=0

local TW = 0.25

local function makeTab(label, xi, bar)
    local t=Instance.new("TextButton",bar)
    t.Text=label; t.Font=Enum.Font.GothamSemibold; t.TextSize=10
    t.TextColor3=DIM; t.BackgroundColor3=PANEL; t.BorderSizePixel=0
    t.AutoButtonColor=false
    t.Size=UDim2.new(TW,0,1,0); t.Position=UDim2.new(TW*xi,0,0,0)
    return t
end

local Tab1=makeTab("Structure",0,TBar)
local Tab2=makeTab("Items",    1,TBar)
local Tab3=makeTab("Scripts",  2,TBar)
local Tab4=makeTab("Fruits",   3,TBar)

-- Indicator row 1
local Ind=Instance.new("Frame",TBar)
Ind.Size=UDim2.new(TW,0,0,2); Ind.Position=UDim2.new(0,0,1,-2)
Ind.BackgroundColor3=CCLIP; Ind.BorderSizePixel=0; Ind.ZIndex=5

-- ── TAB BAR ROW 2  (3 new tabs) ─────────────────────────────
local TBar2=Instance.new("Frame",Main)
TBar2.Size=UDim2.new(1,0,0,26); TBar2.Position=UDim2.new(0,0,0,60)
TBar2.BackgroundColor3=Color3.fromRGB(22,22,30); TBar2.BorderSizePixel=0

local TW2 = 1/3

local function makeTab2(label, xi)
    local t=Instance.new("TextButton",TBar2)
    t.Text=label; t.Font=Enum.Font.GothamSemibold; t.TextSize=10
    t.TextColor3=DIM; t.BackgroundColor3=Color3.fromRGB(22,22,30); t.BorderSizePixel=0
    t.AutoButtonColor=false
    t.Size=UDim2.new(TW2,0,1,0); t.Position=UDim2.new(TW2*xi,0,0,0)
    return t
end

local Tab5=makeTab2("Research",  0)
local Tab6=makeTab2("Extraction",1)
local Tab7=makeTab2("Anti-Suite",2)

-- Indicator row 2
local Ind2=Instance.new("Frame",TBar2)
Ind2.Size=UDim2.new(TW2,0,0,2); Ind2.Position=UDim2.new(0,0,1,-2)
Ind2.BackgroundColor3=CRES; Ind2.BorderSizePixel=0; Ind2.ZIndex=5
Ind2.Visible=false

-- Divider line (below both tab rows)
local div=Instance.new("Frame",Main)
div.Size=UDim2.new(1,0,0,1); div.Position=UDim2.new(0,0,0,86)
div.BackgroundColor3=LINE; div.BorderSizePixel=0

-- ── CONTENT AREA ─────────────────────────────────────────────
local Con=Instance.new("Frame",Main)
Con.Size=UDim2.new(1,0,1,-(34+26+26+1))
Con.Position=UDim2.new(0,0,0,87)
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

-- Scrollable panel for content-heavy tabs
local function makeScrollPanel()
    local outer=Instance.new("Frame",Con)
    outer.Size=UDim2.new(1,0,1,0); outer.BackgroundTransparency=1; outer.Visible=false
    local sc=Instance.new("ScrollingFrame",outer)
    sc.Size=UDim2.new(1,0,1,0); sc.BackgroundTransparency=1; sc.BorderSizePixel=0
    sc.ScrollBarThickness=3; sc.ScrollBarImageColor3=LINE
    sc.CanvasSize=UDim2.new(0,0,0,0)
    sc.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sc.ScrollingDirection=Enum.ScrollingDirection.Y
    local pad=Instance.new("UIPadding",sc)
    pad.PaddingLeft=UDim.new(0,7); pad.PaddingRight=UDim.new(0,7)
    pad.PaddingTop=UDim.new(0,7);  pad.PaddingBottom=UDim.new(0,7)
    local ll=Instance.new("UIListLayout",sc)
    ll.FillDirection=Enum.FillDirection.Vertical
    ll.SortOrder=Enum.SortOrder.LayoutOrder
    ll.Padding=UDim.new(0,5)
    return outer,sc
end

local function makeLbl(txt,par,ord)
    local l=Instance.new("TextLabel",par)
    l.Text=txt; l.Font=Enum.Font.GothamSemibold; l.TextSize=10
    l.TextColor3=DIM; l.BackgroundTransparency=1
    l.Size=UDim2.new(1,0,0,13); l.LayoutOrder=ord
    l.TextXAlignment=Enum.TextXAlignment.Left
    return l
end

-- Section header with colored border (for sub-sections in scroll panels)
local function makeSectionHdr(txt,par,ord,col)
    col=col or CCLIP
    local f=Instance.new("Frame",par)
    f.Size=UDim2.new(1,0,0,20); f.BackgroundColor3=Color3.fromRGB(24,24,34)
    f.BorderSizePixel=0; f.LayoutOrder=ord
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,5)
    local st=Instance.new("UIStroke",f); st.Color=col; st.Thickness=1
    -- Left accent bar
    local bar=Instance.new("Frame",f)
    bar.Size=UDim2.new(0,3,1,-4); bar.Position=UDim2.new(0,3,0,2)
    bar.BackgroundColor3=col; bar.BorderSizePixel=0
    Instance.new("UICorner",bar).CornerRadius=UDim.new(0,2)
    local t=Instance.new("TextLabel",f)
    t.Text=txt; t.Font=Enum.Font.GothamBold; t.TextSize=10
    t.TextColor3=col; t.BackgroundTransparency=1
    t.Size=UDim2.new(1,-12,1,0); t.Position=UDim2.new(0,10,0,0)
    t.TextXAlignment=Enum.TextXAlignment.Left
    return f
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

-- Full-width toggle button that shows ON/OFF state
local function makeToggleBtn(txtOff,txtOn,col0,col1,par,ord)
    local b=Instance.new("TextButton",par)
    b.Text="  "..txtOff; b.Font=Enum.Font.GothamBold; b.TextSize=11
    b.TextColor3=WHITE; b.BackgroundColor3=col0; b.BorderSizePixel=0
    b.Size=UDim2.new(1,0,0,28); b.LayoutOrder=ord; b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    local st=Instance.new("UIStroke",b); st.Color=LINE; st.Thickness=1
    local state=false
    local function refresh()
        b.Text=state and ("  "..txtOn) or ("  "..txtOff)
        TweenService:Create(b,TweenInfo.new(0.15),{BackgroundColor3=state and col1 or col0}):Play()
        TweenService:Create(st,TweenInfo.new(0.15),{Color=state and col1 or LINE}):Play()
    end
    b.MouseButton1Click:Connect(function()
        state=not state; refresh()
    end)
    return b,function() return state end, function(v) state=v; refresh() end
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
makeLbl("Item Scanner",P2,1)
local _,ScI,OuI=makeOut(P2,165,2)
OuI.Text="Press [Item Clip] to scan."
local RI1=makeBtnRow(P2,27,3)
local BIC =makeBtn("Item Clip",CITM,RI1,UDim2.new(0.44,0,1,0),1)
local BICp=makeBtn("Copy",CCOPY,RI1,UDim2.new(0.28,-5,1,0),2)
local BIRs=makeBtn("Reset",CRST,RI1,UDim2.new(0.28,-5,1,0),3)
local IBR1=makeBadgeRow(P2,4); local IBR2=makeBadgeRow(P2,5)
local BgTools=makeBadge("Tools:0",IBR1); local BgProduce=makeBadge("Produce:0",IBR1)
local BgAcc  =makeBadge("Acc:0",IBR2);  local BgOther  =makeBadge("Other:0",IBR2)
local ILbl=makeInfo(P2,6)

-- ════════════════════════════════════════════════════════════
--  PANEL 3 — SCRIPTS
-- ════════════════════════════════════════════════════════════
local P3=makePanel()
makeLbl("Script Scanner",P3,1)
local _,ScP,OuP=makeOut(P3,172,2)
OuP.Text="Press [Clip Scripts] to scan the entire game for scripts."
local RSP=makeBtnRow(P3,27,3)
local BCS  =makeBtn("Clip Scripts",CSCR,RSP,UDim2.new(0.44,0,1,0),1)
local BCSCp=makeBtn("Copy",CCOPY,RSP,UDim2.new(0.28,-5,1,0),2)
local BCSRs=makeBtn("Reset",CRST,RSP,UDim2.new(0.28,-5,1,0),3)
local SSR1=makeBadgeRow(P3,4); local SSR2=makeBadgeRow(P3,5)
local BgSc=makeBadge("Script:0",SSR1);  local BgLs=makeBadge("LocalScript:0",SSR1)
local BgMs=makeBadge("Module:0",SSR2);  local BgTt=makeBadge("Total:0",SSR2)
local SLbl=makeInfo(P3,6)

-- ════════════════════════════════════════════════════════════
--  PANEL 4 — FRUITS
-- ════════════════════════════════════════════════════════════
local P4=makePanel()

local FruitStatus=Instance.new("TextLabel",P4)
FruitStatus.Text="Tap a fruit to give it to yourself."
FruitStatus.Font=Enum.Font.GothamSemibold; FruitStatus.TextSize=10
FruitStatus.TextColor3=DIM; FruitStatus.BackgroundTransparency=1
FruitStatus.Size=UDim2.new(1,0,0,13); FruitStatus.LayoutOrder=1
FruitStatus.TextXAlignment=Enum.TextXAlignment.Left

local LegRow=makeBtnRow(P4,16,2)
for ti,lbl in ipairs({"● Common","● Rare","● Exotic"}) do
    local l=Instance.new("TextLabel",LegRow)
    l.Text=lbl; l.Font=Enum.Font.Gotham; l.TextSize=9
    l.TextColor3=TIER_COLORS[ti]; l.BackgroundTransparency=1
    l.Size=UDim2.new(1/3,-3,1,0); l.LayoutOrder=ti
    l.TextXAlignment=Enum.TextXAlignment.Center
end

local FruitScroll=Instance.new("ScrollingFrame",P4)
FruitScroll.Size=UDim2.new(1,0,1,-40)
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

local function giveFruit(name)
    local RS = safeGet("ReplicatedStorage")
    if not RS then return false,"No ReplicatedStorage" end
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
                        clone.Parent = LP.Backpack
                    else
                        local char = LP.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if root then
                            clone.Parent = workspace
                            local cf = root.CFrame * CFrame.new(0,3,-4)
                            if clone:IsA("Model") then
                                if clone.PrimaryPart then
                                    clone:SetPrimaryPartCFrame(cf)
                                else
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
                if ok then return true,"Gave: "..name.." ✓"
                else return false,tostring(err) end
            end
        end
    end
    return false, name.." not found in game"
end

local lastTier = 0
for idx,info in ipairs(FRUITS) do
    local dname, iname, tier = info[1], info[2], info[3]
    local col = TIER_COLORS[tier]
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
    local capturedName=iname; local capturedBtn=fb
    fb.MouseButton1Click:Connect(function()
        capturedBtn.Text="Giving…"
        local ok,msg=giveFruit(capturedName)
        FruitStatus.Text=msg
        FruitStatus.TextColor3=ok and Color3.fromRGB(100,220,100) or Color3.fromRGB(220,80,80)
        capturedBtn.Text=dname
        if ok then
            TweenService:Create(capturedBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(50,180,80)}):Play()
            task.delay(0.8,function()
                TweenService:Create(capturedBtn,TweenInfo.new(0.3),{BackgroundColor3=col}):Play()
            end)
        end
    end)
end

-- ════════════════════════════════════════════════════════════
--  PANEL 5 — RESEARCH  (Remote Spy · GUI Inspector · Vuln Scanner)
-- ════════════════════════════════════════════════════════════
local P5,SP5=makeScrollPanel()

-- ── Remote Spy ──────────────────────────────────────────────
makeSectionHdr("1. Remote Spy  (Live)",SP5,10,CSPY)
local _,_,OuRSpy=makeOut(SP5,90,11)
OuRSpy.Text="Press Start to begin capturing remote calls."
local spyConns,spyLogLines={},{}
local spyOn=false
local spyBtnRow=makeBtnRow(SP5,28,12)
local SpyStart=makeBtn("Start Spy",CSPY,spyBtnRow,UDim2.new(0.48,0,1,0),1)
local SpyStop =makeBtn("Stop",CRST,spyBtnRow,UDim2.new(0.24,-5,1,0),2)
local SpyClear=makeBtn("Clear",CAC0,spyBtnRow,UDim2.new(0.24,-5,1,0),3)
local SpyInfo=makeInfo(SP5,13)

local function spyLog(msg)
    table.insert(spyLogLines,msg)
    if #spyLogLines>120 then table.remove(spyLogLines,1) end
    OuRSpy.Text=table.concat(spyLogLines,"\n")
end

local function hookRemote(r)
    local ok1,cn=pcall(function() return r.ClassName end)
    local ok2,nm=pcall(function() return r.Name end)
    if not ok1 or not ok2 then return end
    if cn=="RemoteEvent" then
        local ok3,conn=pcall(function()
            return r.OnClientEvent:Connect(function(...)
                local args={}
                for _,a in ipairs({...}) do
                    table.insert(args,tostring(a))
                end
                spyLog(os.date("%H:%M:%S").." RE↓ "..nm.."("..table.concat(args,",")..")")
            end)
        end)
        if ok3 and conn then table.insert(spyConns,conn) end
    elseif cn=="RemoteFunction" then
        spyLog(os.date("%H:%M:%S").." RF  "..nm.." [found]")
    end
end

local function startSpy()
    if spyOn then return end; spyOn=true
    SpyStart.BackgroundColor3=CSPY:lerp(Color3.new(0,0,0),0.3)
    SpyInfo.Text="Scanning & hooking remotes…"
    local function scanRemotes(inst,d)
        if d>8 then return end
        local ok,kids=pcall(function() return inst:GetChildren() end)
        if not ok then return end
        for _,c in ipairs(kids) do
            local ok1,cn=pcall(function() return c.ClassName end)
            if ok1 and (cn=="RemoteEvent" or cn=="RemoteFunction") then
                hookRemote(c)
            end
            if ok1 then scanRemotes(c,d+1) end
        end
    end
    for _,svc in ipairs({"ReplicatedStorage","Workspace","ReplicatedFirst"}) do
        local s=safeGet(svc); if s then scanRemotes(s,0) end
    end
    -- Watch for new remotes
    local ok,dc=pcall(function()
        return game.DescendantAdded:Connect(function(d)
            if not spyOn then return end
            local ok1,cn=pcall(function() return d.ClassName end)
            if ok1 and (cn=="RemoteEvent" or cn=="RemoteFunction") then
                task.wait(0.1); hookRemote(d)
            end
        end)
    end)
    if ok and dc then table.insert(spyConns,dc) end
    SpyInfo.Text="Hooked "..#spyConns.." connections"
end

local function stopSpy()
    spyOn=false
    for _,c in ipairs(spyConns) do pcall(function() c:Disconnect() end) end
    spyConns={}
    SpyStart.BackgroundColor3=CSPY
    SpyInfo.Text="Stopped. "..#spyLogLines.." events captured."
end

SpyStart.MouseButton1Click:Connect(startSpy)
SpyStop.MouseButton1Click:Connect(stopSpy)
SpyClear.MouseButton1Click:Connect(function()
    spyLogLines={}; OuRSpy.Text="Cleared."; SpyInfo.Text=""
end)

-- ── GUI Introspection ────────────────────────────────────────
makeSectionHdr("2. GUI Introspection",SP5,20,CCLIP)
local _,_,OuGUI=makeOut(SP5,80,21)
OuGUI.Text="Press Scan to list all ScreenGuis, Frames and Buttons."
local guiRow=makeBtnRow(SP5,28,22)
local GUIScan=makeBtn("Scan GUI",CCLIP,guiRow,UDim2.new(0.48,0,1,0),1)
local GUICopy=makeBtn("Copy",CCOPY,guiRow,UDim2.new(0.24,-5,1,0),2)
local GUIRst =makeBtn("Reset",CRST,guiRow,UDim2.new(0.24,-5,1,0),3)
local GUIInfo=makeInfo(SP5,23)
local lastGUIOut=""

GUIScan.MouseButton1Click:Connect(function()
    OuGUI.Text="Scanning…"; GUIInfo.Text=""; task.wait(0.05)
    local L={}; local counts={ScreenGui=0,Frame=0,TextButton=0,ImageButton=0}
    local target={ScreenGui=true,Frame=true,TextButton=true,ImageButton=true,ScrollingFrame=true}
    local function scan(inst,d)
        if d>7 then return end
        local ok,kids=pcall(function() return inst:GetChildren() end)
        if not ok then return end
        for _,c in ipairs(kids) do
            local ok1,cn=pcall(function() return c.ClassName end)
            local ok2,nm=pcall(function() return c.Name end)
            if ok1 and ok2 and target[cn] then
                table.insert(L,string.rep("  ",d).."["..cn.."] "..nm)
                if counts[cn] then counts[cn]=counts[cn]+1 end
            end
            if ok1 then scan(c,d+1) end
        end
    end
    table.insert(L,">> PlayerGui")
    scan(PGui,1)
    local sg=safeGet("StarterGui"); if sg then table.insert(L,">> StarterGui"); scan(sg,1) end
    if #L<=2 then table.insert(L,"No GUI objects found.") end
    lastGUIOut=table.concat(L,"\n"); OuGUI.Text=lastGUIOut
    GUIInfo.Text=string.format("SG:%d Fr:%d Btn:%d+%d",
        counts.ScreenGui,counts.Frame,counts.TextButton,counts.ImageButton)
end)
GUICopy.MouseButton1Click:Connect(function()
    if lastGUIOut=="" then OuGUI.Text="Run Scan first."; return end
    local ok=doclip(lastGUIOut)
    OuGUI.Text=ok and "Copied!" or "setclipboard unavailable."
    task.delay(2,function() if OuGUI and OuGUI.Parent then OuGUI.Text=lastGUIOut end end)
end)
GUIRst.MouseButton1Click:Connect(function()
    lastGUIOut=""; OuGUI.Text="Press Scan to list all ScreenGuis, Frames and Buttons."; GUIInfo.Text=""
end)

-- ── Vulnerability Scanner ────────────────────────────────────
makeSectionHdr("3. Vulnerability Scanner",SP5,30,CVULN)
local _,_,OuVuln=makeOut(SP5,80,31)
OuVuln.Text="Press Scan to flag high-risk remotes."
local vulnRow=makeBtnRow(SP5,28,32)
local VulnScan=makeBtn("Scan Vulns",CVULN,vulnRow,UDim2.new(0.48,0,1,0),1)
local VulnCopy=makeBtn("Copy",CCOPY,vulnRow,UDim2.new(0.24,-5,1,0),2)
local VulnRst =makeBtn("Reset",CRST,vulnRow,UDim2.new(0.24,-5,1,0),3)
local VulnInfo=makeInfo(SP5,33)
local lastVulnOut=""

VulnScan.MouseButton1Click:Connect(function()
    OuVuln.Text="Scanning…"; VulnInfo.Text=""; task.wait(0.05)
    local L={}; local found=0
    local function scan(inst,d)
        if d>8 then return end
        local ok,kids=pcall(function() return inst:GetChildren() end)
        if not ok then return end
        for _,c in ipairs(kids) do
            local ok1,cn=pcall(function() return c.ClassName end)
            local ok2,nm=pcall(function() return c.Name end)
            if ok1 and ok2 and (cn=="RemoteEvent" or cn=="RemoteFunction") then
                local lo=nm:lower()
                for _,kw in ipairs(VULN_KW) do
                    if lo:find(kw,1,true) then
                        table.insert(L,"⚠ ["..cn.."] "..nm.."  →  kw:"..kw)
                        found=found+1; break
                    end
                end
            end
            if ok1 then scan(c,d+1) end
        end
    end
    for _,svc in ipairs({"ReplicatedStorage","Workspace","ReplicatedFirst"}) do
        local s=safeGet(svc); if s then table.insert(L,">> "..svc); scan(s,0) end
    end
    if found==0 then table.insert(L,"No high-risk remotes detected.") end
    lastVulnOut=table.concat(L,"\n"); OuVuln.Text=lastVulnOut
    VulnInfo.Text=found.." high-risk remote(s) flagged"
    if found>0 then VulnInfo.TextColor3=CVULN else VulnInfo.TextColor3=DIM end
end)
VulnCopy.MouseButton1Click:Connect(function()
    if lastVulnOut=="" then OuVuln.Text="Run Scan first."; return end
    local ok=doclip(lastVulnOut)
    OuVuln.Text=ok and "Copied!" or "setclipboard unavailable."
    task.delay(2,function() if OuVuln and OuVuln.Parent then OuVuln.Text=lastVulnOut end end)
end)
VulnRst.MouseButton1Click:Connect(function()
    lastVulnOut=""; OuVuln.Text="Press Scan to flag high-risk remotes."; VulnInfo.Text=""
end)

-- ════════════════════════════════════════════════════════════
--  PANEL 6 — EXTRACTION  (Mass Source Dump · Code Clues)
-- ════════════════════════════════════════════════════════════
local P6,SP6=makeScrollPanel()

-- ── Mass Source Dumper ───────────────────────────────────────
makeSectionHdr("1. Mass Source Dumper",SP6,10,CEXT)
local _,_,OuSrc=makeOut(SP6,95,11)
OuSrc.Text="Press Dump to crawl all accessible script sources."
local srcRow=makeBtnRow(SP6,28,12)
local SrcDump=makeBtn("Dump",CEXT,srcRow,UDim2.new(0.34,0,1,0),1)
local SrcCopy=makeBtn("Copy All",CCOPY,srcRow,UDim2.new(0.33,-5,1,0),2)
local SrcRst =makeBtn("Reset",CRST,srcRow,UDim2.new(0.33,-5,1,0),3)
local SrcBR=makeBadgeRow(SP6,13)
local BgSrcS=makeBadge("Script:0",SrcBR); local BgSrcL=makeBadge("Local:0",SrcBR)
local SrcInfo=makeInfo(SP6,14)
local lastSrcOut=""

-- ── Code Clues ───────────────────────────────────────────────
makeSectionHdr("2. Code Clues",SP6,20,Color3.fromRGB(140,115,40))
local _,_,OuClue=makeOut(SP6,80,21)
OuClue.Text="Run Dump first, then press Analyze."
local clueRow=makeBtnRow(SP6,28,22)
local ClueAnalyze=makeBtn("Analyze",Color3.fromRGB(140,115,40),clueRow,UDim2.new(0.48,0,1,0),1)
local ClueCopy   =makeBtn("Copy",CCOPY,clueRow,UDim2.new(0.24,-5,1,0),2)
local ClueRst    =makeBtn("Reset",CRST,clueRow,UDim2.new(0.24,-5,1,0),3)
local ClueInfo=makeInfo(SP6,23)
local lastClueOut=""
local cachedSources={}

SrcDump.MouseButton1Click:Connect(function()
    OuSrc.Text="Crawling scripts…"; SrcInfo.Text=""; task.wait(0.05)
    local L={}; local seen={}; local scC,lsC,msC=0,0,0
    cachedSources={}
    table.insert(L,string.format("[ %s | PlaceId:%d ]\n",os.date("%H:%M:%S"),game.PlaceId))
    local function scan(inst,d)
        if d>12 then return end
        local ok,kids=pcall(function() return inst:GetChildren() end)
        if not ok then return end
        for _,c in ipairs(kids) do
            local ok1,cn=pcall(function() return c.ClassName end)
            local ok2,nm=pcall(function() return c.Name end)
            if ok1 and ok2 and SCR_CLS[cn] then
                local ptr=tostring(c)
                if not seen[ptr] then
                    seen[ptr]=true
                    local hasSrc,src=pcall(function() return c.Source end)
                    if hasSrc and src and #src>0 then
                        table.insert(L,"-- ["..cn.."] "..nm.." ("..#src.." chars)")
                        local preview=src:sub(1,400)
                        table.insert(L,preview)
                        if #src>400 then table.insert(L,"... [truncated]") end
                        table.insert(L,"")
                        table.insert(cachedSources,{cn=cn,nm=nm,src=src})
                        if cn=="Script" then scC=scC+1
                        elseif cn=="LocalScript" then lsC=lsC+1
                        else msC=msC+1 end
                    else
                        table.insert(L,"-- ["..cn.."] "..nm.." [No Source Access]")
                    end
                end
            end
            scan(c,d+1)
        end
    end
    for _,svc in ipairs(SCR_SVCS) do
        local s=safeGet(svc)
        if s then table.insert(L,">> "..svc); scan(s,0); table.insert(L,"") end
    end
    local ch=LP.Character; if ch then scan(ch,0) end
    local ps=LP:FindFirstChild("PlayerScripts"); if ps then scan(ps,0) end
    local tot=scC+lsC+msC
    if tot==0 then table.insert(L,"No accessible script sources found.") end
    lastSrcOut=table.concat(L,"\n"); OuSrc.Text=lastSrcOut
    BgSrcS.Text="Script:"..scC; BgSrcL.Text="Local:"..lsC
    SrcInfo.Text=tot.." scripts with source | Module:"..msC
    OuClue.Text="Run Analyze to extract logic clues."
end)
SrcCopy.MouseButton1Click:Connect(function()
    if lastSrcOut=="" then OuSrc.Text="Run Dump first."; return end
    local ok=doclip(lastSrcOut)
    OuSrc.Text=ok and ("Copied "..#lastSrcOut.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OuSrc and OuSrc.Parent then OuSrc.Text=lastSrcOut end end)
end)
SrcRst.MouseButton1Click:Connect(function()
    lastSrcOut=""; cachedSources={}
    OuSrc.Text="Press Dump to crawl all accessible script sources."
    BgSrcS.Text="Script:0"; BgSrcL.Text="Local:0"; SrcInfo.Text=""
end)

ClueAnalyze.MouseButton1Click:Connect(function()
    if #cachedSources==0 then OuClue.Text="Run Dump first."; return end
    local L={}; local hits=0
    table.insert(L,"Code Clues  ("..#cachedSources.." scripts analyzed)\n")
    for _,entry in ipairs(cachedSources) do
        local lo=entry.src:lower()
        local found={}
        for _,pat in ipairs(CLUE_PAT) do
            if lo:find(pat.p,1,true) then table.insert(found,pat.lbl) end
        end
        if #found>0 then
            table.insert(L,"["..entry.cn.."] "..entry.nm)
            for _,clue in ipairs(found) do
                table.insert(L,"  → "..clue)
                hits=hits+1
            end
        end
    end
    if hits==0 then table.insert(L,"No notable patterns detected.") end
    lastClueOut=table.concat(L,"\n"); OuClue.Text=lastClueOut
    ClueInfo.Text=hits.." clue(s) found across "..#cachedSources.." scripts"
end)
ClueCopy.MouseButton1Click:Connect(function()
    if lastClueOut=="" then OuClue.Text="Run Analyze first."; return end
    local ok=doclip(lastClueOut)
    OuClue.Text=ok and "Copied!" or "setclipboard unavailable."
    task.delay(2,function() if OuClue and OuClue.Parent then OuClue.Text=lastClueOut end end)
end)
ClueRst.MouseButton1Click:Connect(function()
    lastClueOut=""; OuClue.Text="Run Dump first, then press Analyze."; ClueInfo.Text=""
end)

-- ════════════════════════════════════════════════════════════
--  PANEL 7 — ANTI-SUITE  (Anti-Log · Anti-AFK · Staff Detector · Kick Protection)
-- ════════════════════════════════════════════════════════════
local P7,SP7=makeScrollPanel()

-- ── Anti-Log ─────────────────────────────────────────────────
makeSectionHdr("1. Anti-Log",SP7,10,CANT)
local antiLogLbl=makeInfo(SP7,11)
antiLogLbl.Text="Removes analytics/telemetry remotes from the game."
local antiLogBtn,getAntiLogState,setAntiLogState=makeToggleBtn(
    "Anti-Log: OFF","Anti-Log: ON",CAC0,CAC1,SP7,12)
local antiLogInfo=makeInfo(SP7,13)

local function runAntiLog()
    local removed=0
    local function scan(inst,d)
        if d>8 then return end
        local ok,kids=pcall(function() return inst:GetChildren() end)
        if not ok then return end
        for _,c in ipairs(kids) do
            local ok1,cn=pcall(function() return c.ClassName end)
            local ok2,nm=pcall(function() return c.Name end)
            if ok1 and ok2 and (cn=="RemoteEvent" or cn=="RemoteFunction") then
                local lo=nm:lower()
                for _,kw in ipairs(LOG_KW) do
                    if lo:find(kw,1,true) then
                        local ok3=pcall(function() c:Destroy() end)
                        if ok3 then removed=removed+1 end
                        break
                    end
                end
            end
            if ok1 then scan(c,d+1) end
        end
    end
    for _,svc in ipairs({"ReplicatedStorage","Workspace","ReplicatedFirst"}) do
        local s=safeGet(svc); if s then scan(s,0) end
    end
    return removed
end

local antiLogConn
antiLogBtn.MouseButton1Click:Connect(function()
    local on=getAntiLogState()
    if on then
        local n=runAntiLog()
        antiLogInfo.Text=string.format("Removed %d analytics remote(s)",n)
        antiLogInfo.TextColor3=n>0 and CAC1 or DIM
        if antiLogConn then antiLogConn:Disconnect(); antiLogConn=nil end
        local ok; ok,antiLogConn=pcall(function()
            return game.DescendantAdded:Connect(function(d)
                if not getAntiLogState() then return end
                local ok1,cn=pcall(function() return d.ClassName end)
                local ok2,nm=pcall(function() return d.Name end)
                if ok1 and ok2 and (cn=="RemoteEvent" or cn=="RemoteFunction") then
                    local lo=nm:lower()
                    for _,kw in ipairs(LOG_KW) do
                        if lo:find(kw,1,true) then
                            pcall(function() d:Destroy() end); break
                        end
                    end
                end
            end)
        end)
    else
        if antiLogConn then antiLogConn:Disconnect(); antiLogConn=nil end
        antiLogInfo.Text="Anti-Log stopped."
        antiLogInfo.TextColor3=DIM
    end
end)

-- ── Anti-AFK ──────────────────────────────────────────────────
makeSectionHdr("2. Anti-AFK",SP7,20,Color3.fromRGB(60,100,140))
local afkLbl=makeInfo(SP7,21)
afkLbl.Text="Simulates input every 25s to prevent idle kick."
local afkBtn,getAFKState,setAFKState=makeToggleBtn(
    "Anti-AFK: OFF","Anti-AFK: ON",CAC0,Color3.fromRGB(50,110,155),SP7,22)
local afkInfo=makeInfo(SP7,23)
local afkConn,afkTimer

afkBtn.MouseButton1Click:Connect(function()
    local on=getAFKState()
    if on then
        afkTimer=0
        afkConn=game:GetService("RunService").Heartbeat:Connect(function(dt)
            if not getAFKState() then return end
            afkTimer=afkTimer+dt
            if afkTimer>=25 then
                afkTimer=0
                local VU=pcall(game.GetService,game,"VirtualUser") and game:GetService("VirtualUser") or nil
                if VU then
                    pcall(function() VU:Button1Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)
                    task.wait(0.05)
                    pcall(function() VU:Button1Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)
                    afkInfo.Text=os.date("%H:%M:%S").." — input simulated"
                else
                    afkInfo.Text="VirtualUser not available"
                end
            end
        end)
        afkInfo.Text="Running — fires every 25s"
        afkInfo.TextColor3=Color3.fromRGB(60,180,220)
    else
        if afkConn then afkConn:Disconnect(); afkConn=nil end
        afkInfo.Text="Anti-AFK stopped."; afkInfo.TextColor3=DIM
    end
end)

-- ── Staff Detector ───────────────────────────────────────────
makeSectionHdr("3. Staff Detector  (Live)",SP7,30,Color3.fromRGB(180,140,20))
local staffLbl=makeInfo(SP7,31)
staffLbl.Text="Alerts when a staff/admin player joins the server."
local staffBtn,getStaffState,setStaffState=makeToggleBtn(
    "Staff Monitor: OFF","Staff Monitor: ON",CAC0,Color3.fromRGB(160,120,10),SP7,32)
local staffStatus=Instance.new("TextLabel",SP7)
staffStatus.Text="No alerts yet."; staffStatus.Font=Enum.Font.Gotham; staffStatus.TextSize=10
staffStatus.TextColor3=DIM; staffStatus.BackgroundColor3=OUTBG
staffStatus.Size=UDim2.new(1,0,0,28); staffStatus.LayoutOrder=33; staffStatus.BorderSizePixel=0
staffStatus.TextXAlignment=Enum.TextXAlignment.Left
staffStatus.TextWrapped=true
Instance.new("UICorner",staffStatus).CornerRadius=UDim.new(0,5)
local ssp=Instance.new("UIPadding",staffStatus)
ssp.PaddingLeft=UDim.new(0,6); ssp.PaddingRight=UDim.new(0,6)

local staffAlertCount=0
local staffConn

local function checkStaffPlayer(p)
    local nm=(p.Name or ""):lower()
    local dn=(p.DisplayName or ""):lower()
    for _,kw in ipairs(STAFF_KW) do
        if nm:find(kw,1,true) or dn:find(kw,1,true) then
            return true, kw
        end
    end
    -- Try group rank check
    local ok,rank=pcall(function()
        for _,g in ipairs(p:GetGroupsAsync()) do
            if g.Rank>=200 then return g.Rank,g.Name end
        end
        return nil
    end)
    if ok and rank then return true,"rank "..tostring(rank) end
    return false,nil
end

staffBtn.MouseButton1Click:Connect(function()
    local on=getStaffState()
    if on then
        staffStatus.Text="Monitoring — watching for staff joins…"
        staffStatus.TextColor3=Color3.fromRGB(200,180,40)
        -- Check existing players
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP then
                local isStaff,reason=checkStaffPlayer(p)
                if isStaff then
                    staffAlertCount=staffAlertCount+1
                    staffStatus.Text="⚠ STAFF: "..p.Name.." ("..tostring(reason)..") already in server"
                    staffStatus.TextColor3=CVULN
                end
            end
        end
        staffConn=Players.PlayerAdded:Connect(function(p)
            if not getStaffState() then return end
            task.wait(1)
            local isStaff,reason=checkStaffPlayer(p)
            if isStaff then
                staffAlertCount=staffAlertCount+1
                staffStatus.Text="⚠ STAFF JOINED: "..p.Name.." ("..tostring(reason)..")"
                staffStatus.TextColor3=CVULN
                TweenService:Create(staffStatus,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(80,30,10)}):Play()
                task.delay(3,function()
                    TweenService:Create(staffStatus,TweenInfo.new(0.5),{BackgroundColor3=OUTBG}):Play()
                end)
            end
        end)
    else
        if staffConn then staffConn:Disconnect(); staffConn=nil end
        staffStatus.Text="Monitor stopped. Alerts: "..staffAlertCount
        staffStatus.TextColor3=DIM
    end
end)

-- ── Kick Protection ───────────────────────────────────────────
makeSectionHdr("4. Kick Protection",SP7,40,CRST)
local kickLbl=makeInfo(SP7,41)
kickLbl.Text="Alerts on client-side kick attempts (heads-up only)."
local kickBtn,getKickState,setKickState=makeToggleBtn(
    "Kick Guard: OFF","Kick Guard: ON",CAC0,Color3.fromRGB(140,50,55),SP7,42)
local kickStatus=Instance.new("TextLabel",SP7)
kickStatus.Text="No kick attempts detected."; kickStatus.Font=Enum.Font.Gotham; kickStatus.TextSize=10
kickStatus.TextColor3=DIM; kickStatus.BackgroundColor3=OUTBG
kickStatus.Size=UDim2.new(1,0,0,28); kickStatus.LayoutOrder=43; kickStatus.BorderSizePixel=0
kickStatus.TextXAlignment=Enum.TextXAlignment.Left; kickStatus.TextWrapped=true
Instance.new("UICorner",kickStatus).CornerRadius=UDim.new(0,5)
local ksp=Instance.new("UIPadding",kickStatus)
ksp.PaddingLeft=UDim.new(0,6); ksp.PaddingRight=UDim.new(0,6)

local kickConns={}
local function startKickGuard()
    -- Hook kick-named remotes (OnClientEvent)
    local function hookKickRemote(r)
        local ok1,cn=pcall(function() return r.ClassName end)
        local ok2,nm=pcall(function() return r.Name end)
        if not ok1 or not ok2 then return end
        local lo=nm:lower()
        local isKick=false
        for _,kw in ipairs(KICK_KW) do if lo:find(kw,1,true) then isKick=true; break end end
        if not isKick then return end
        if cn=="RemoteEvent" then
            local ok3,conn=pcall(function()
                return r.OnClientEvent:Connect(function(...)
                    if not getKickState() then return end
                    kickStatus.Text="⚠ KICK REMOTE FIRED: "..nm.." at "..os.date("%H:%M:%S")
                    kickStatus.TextColor3=CRST
                    TweenService:Create(kickStatus,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(80,20,20)}):Play()
                    task.delay(4,function()
                        TweenService:Create(kickStatus,TweenInfo.new(0.5),{BackgroundColor3=OUTBG}):Play()
                    end)
                end)
            end)
            if ok3 and conn then table.insert(kickConns,conn) end
        end
    end
    local function scan(inst,d)
        if d>8 then return end
        local ok,kids=pcall(function() return inst:GetChildren() end)
        if not ok then return end
        for _,c in ipairs(kids) do
            local ok1=pcall(function() return c.ClassName end)
            if ok1 then hookKickRemote(c); scan(c,d+1) end
        end
    end
    for _,svc in ipairs({"ReplicatedStorage","Workspace","ReplicatedFirst"}) do
        local s=safeGet(svc); if s then scan(s,0) end
    end
    -- Watch for character removal (force disconnect indicator)
    local ok2,conn2=pcall(function()
        return LP.AncestryChanged:Connect(function()
            if not LP.Parent and getKickState() then
                kickStatus.Text="⚠ LocalPlayer ancestry changed — possible kick/removal"
                kickStatus.TextColor3=CRST
            end
        end)
    end)
    if ok2 and conn2 then table.insert(kickConns,conn2) end
    kickStatus.Text="Watching "..#kickConns.." kick vector(s)…"
    kickStatus.TextColor3=Color3.fromRGB(150,200,150)
end

kickBtn.MouseButton1Click:Connect(function()
    local on=getKickState()
    if on then
        startKickGuard()
    else
        for _,c in ipairs(kickConns) do pcall(function() c:Disconnect() end) end
        kickConns={}
        kickStatus.Text="Kick Guard stopped."; kickStatus.TextColor3=DIM
    end
end)

-- ════════════════════════════════════════════════════════════
--  TAB SWITCHING  (7 tabs, 2 rows)
-- ════════════════════════════════════════════════════════════
local ALL_TABS   = {Tab1,Tab2,Tab3,Tab4,Tab5,Tab6,Tab7}
local ALL_PANELS = {P1,P2,P3,P4,P5,P6,P7}
local ALL_COLS   = {CCLIP,CITM,CSCR,CFR1,CRES,CEXT,CANT}
local ALL_ROW    = {1,1,1,1,2,2,2}   -- which tab bar row each tab belongs to
local curTab     = 0

local function switchTab(idx)
    if curTab==idx then return end; curTab=idx
    -- Show / hide panels
    for i=1,7 do
        ALL_PANELS[i].Visible=(i==idx)
        local isRow1=(ALL_ROW[i]==1)
        local barCol=isRow1 and PANEL or Color3.fromRGB(22,22,30)
        ALL_TABS[i].TextColor3      = (i==idx) and TEXT  or DIM
        ALL_TABS[i].BackgroundColor3= (i==idx) and BTN   or barCol
        ALL_TABS[i].Font            = (i==idx) and Enum.Font.GothamBold or Enum.Font.GothamSemibold
    end
    -- Animate indicator in the correct row; hide the other
    local row=ALL_ROW[idx]
    if row==1 then
        Ind.Visible=true; Ind2.Visible=false
        TweenService:Create(Ind,TweenInfo.new(0.15),{
            Position=UDim2.new(TW*(idx-1),0,1,-2),
            BackgroundColor3=ALL_COLS[idx],
        }):Play()
    else
        Ind.Visible=false; Ind2.Visible=true
        local xi=idx-5   -- 0,1,2 for tabs 5,6,7
        TweenService:Create(Ind2,TweenInfo.new(0.15),{
            Position=UDim2.new(TW2*xi,0,1,-2),
            BackgroundColor3=ALL_COLS[idx],
        }):Play()
    end
    -- Slide-in animation on content area
    Con.Position=UDim2.new(0,8,0,87)
    TweenService:Create(Con,TweenInfo.new(0.14,Enum.EasingStyle.Quint),{
        Position=UDim2.new(0,0,0,87)
    }):Play()
end

Tab1.MouseButton1Click:Connect(function() switchTab(1) end)
Tab2.MouseButton1Click:Connect(function() switchTab(2) end)
Tab3.MouseButton1Click:Connect(function() switchTab(3) end)
Tab4.MouseButton1Click:Connect(function() switchTab(4) end)
Tab5.MouseButton1Click:Connect(function() switchTab(5) end)
Tab6.MouseButton1Click:Connect(function() switchTab(6) end)
Tab7.MouseButton1Click:Connect(function() switchTab(7) end)
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
    lastIOut=""; OuI.Text="Press [Item Clip] to scan."
    BgTools.Text="Tools:0"; BgProduce.Text="Produce:0"; BgAcc.Text="Acc:0"; BgOther.Text="Other:0"
    ILbl.Text=""; ScI.CanvasPosition=Vector2.zero
end)

-- ════════════════════════════════════════════════════════════
--  SCRIPTS LOGIC
-- ════════════════════════════════════════════════════════════
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
BCS.MouseButton1Click:Connect(function()
    OuP.Text="Scanning scripts…"; SLbl.Text=""
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
        lastScOut=table.concat(L,"\n"); OuP.Text=lastScOut; SLbl.Text=tot.." scripts found"
        BgSc.Text="Script:"..scC; BgLs.Text="LocalScript:"..lsC; BgMs.Text="Module:"..msC; BgTt.Text="Total:"..tot
    end)
    if not ok then OuP.Text="Script error:\n"..tostring(er) end
end)
BCSCp.MouseButton1Click:Connect(function()
    if lastScOut=="" then OuP.Text="Run Clip Scripts first."; return end
    local ok=doclip(lastScOut); local prev=OuP.Text
    OuP.Text=ok and ("Copied "..#lastScOut.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OuP and OuP.Parent then OuP.Text=prev end end)
end)
BCSRs.MouseButton1Click:Connect(function()
    lastScOut=""; OuP.Text="Press [Clip Scripts] to scan the entire game for scripts."
    BgSc.Text="Script:0"; BgLs.Text="LocalScript:0"; BgMs.Text="Module:0"; BgTt.Text="Total:0"
    SLbl.Text=""; ScP.CanvasPosition=Vector2.zero
end)

-- ── OPEN ANIMATION  (Back easing for a satisfying spring-in) ─
Main.BackgroundTransparency=1
Main.Position=UDim2.new(0.5,-W/2,0.5,-H/2+18)
TweenService:Create(Main,TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    BackgroundTransparency=0,
    Position=UDim2.new(0.5,-W/2,0.5,-H/2),
}):Play()
