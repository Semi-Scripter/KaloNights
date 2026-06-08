-- Exploit Menu v7  |  Structure · Items

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LP               = Players.LocalPlayer
local PGui             = LP:WaitForChild("PlayerGui")

-- Remove old copy
if PGui:FindFirstChild("_EM7") then PGui._EM7:Destroy() end

-- ── COLORS ──────────────────────────────────────────────────
local BG     = Color3.fromRGB(18,18,24)
local PANEL  = Color3.fromRGB(26,26,34)
local HDR    = Color3.fromRGB(30,30,40)
local LINE   = Color3.fromRGB(46,46,60)
local TEXT   = Color3.fromRGB(218,218,228)
local DIM    = Color3.fromRGB(110,110,132)
local WHITE  = Color3.fromRGB(255,255,255)
local BTN    = Color3.fromRGB(40,40,54)
local OUTBG  = Color3.fromRGB(10,10,16)
local BDGE   = Color3.fromRGB(50,50,68)
local CCLIP  = Color3.fromRGB(52,96,158)
local CCOPY  = Color3.fromRGB(46,106,80)
local CRST   = Color3.fromRGB(116,46,54)
local CITM   = Color3.fromRGB(100,80,40)
local CSCR   = Color3.fromRGB(55,75,125)
local CAC0   = Color3.fromRGB(58,58,75)
local CAC1   = Color3.fromRGB(50,130,70)

-- ── KEYWORDS ────────────────────────────────────────────────
local KW = {
    "apple","apricot","avocado","banana","blackberry","blueberry","cherry",
    "clementine","coconut","cranberry","date","dragonfruit","durian","elderberry",
    "fig","grape","grapefruit","guava","honeydew","jackfruit","kiwi","lemon",
    "lime","lychee","mandarin","mango","mangosteen","melon","mulberry","nectarine",
    "olive","orange","papaya","passionfruit","peach","pear","pineapple","plum",
    "pomegranate","quince","rambutan","raspberry","soursop","starfruit","strawberry",
    "tamarind","tangerine","watermelon","yuzu",
    "mythic","divine","prismatic","corrupted","void","cosmic","rainbow","carnival",
    "tropical","bubblegum","frozen","radioactive","acid","shadowfruit","blazefruit",
    "frostfruit","venomfruit","crystalfruit","goldfruit","demonfruit","angelfruit",
    "dragonberry","phoenixfruit","riftfruit","moonberry","sunfruit","starberry","glowfruit",
    "artichoke","asparagus","bean","beet","broccoli","cabbage","carrot","cauliflower",
    "celery","chickpea","corn","cucumber","eggplant","garlic","ginger","kale",
    "leek","lentil","lettuce","okra","onion","parsnip","pea","pepper","potato",
    "pumpkin","radish","rice","spinach","squash","sugarcane","tomato","turnip",
    "wheat","yam","zucchini",
    "seed","sapling","sprout","bulb","crop","harvest","produce","plant","herb",
    "mushroom","truffle","fungi","spore","flower","rose","tulip","berry","algae",
    "food","meal","bread","meat","steak","chicken","fish","egg","milk","cheese",
    "honey","jam","jerky","soup","stew","nut","acorn","walnut","grain","flour",
    "water","canteen","flask","bottle","juice",
    "wood","log","plank","stick","branch","stone","rock","flint","coal","fiber",
    "cloth","leather","hide","fur","wool","silk","rope","iron","copper","bronze",
    "silver","gold","steel","ore","ingot","gem","crystal","diamond","emerald",
    "ruby","sapphire","obsidian","bone","claw","feather","shell","clay","oil",
    "axe","pickaxe","shovel","scythe","hammer","knife","sword","blade","spear",
    "bow","arrow","gun","pistol","rifle","shotgun","revolver","bullet","ammo",
    "grenade","shield","armor","helmet","boots","gloves","torch","lantern","trap",
    "bandage","medkit","heal","health","potion","elixir","antidote","medicine",
    "tent","campfire","backpack","bag","chest","crate","barrel","key","compass",
    "fruit","item","loot","drop","reward","resource","material","ingredient",
    "token","coin","currency","trophy","pack","bundle","jar","vial","powder",
    "weapon","equipment","supply","relic","artifact",
}

local ITEM_CLS = {
    Tool=true,HopperBin=true,Accessory=true,Hat=true,
    Shirt=true,Pants=true,ShirtGraphic=true,Gear=true,
}
local SCR_CLS = {Script=true,LocalScript=true,ModuleScript=true}

local AC_PAT = {
    "anticheat","anti_cheat","anti-cheat","kicksystem","banhandler",
    "exploitdetect","detection","sanitycheck","speedcheck","flycheck",
    "noclipcheck","fairplay","safeguard","guardian","remotechecker",
    "cheatdetect","hackdetect","securitycheck","antiexploit","exploitban",
}

local STRUCT_SVCS = {"Workspace","ReplicatedStorage","ReplicatedFirst","StarterGui",
    "StarterPack","StarterPlayer","Lighting","SoundService","Chat","Teams"}
local ITEM_SRCS   = {"Workspace","ReplicatedStorage","StarterPack","ReplicatedFirst"}
local SCR_SVCS    = {"Workspace","ReplicatedStorage","ReplicatedFirst","StarterGui",
    "StarterPack","StarterPlayer","Lighting","SoundService","Chat","Teams"}

-- ── UTIL FUNCTIONS ───────────────────────────────────────────
local function safeGet(n)
    local ok,r = pcall(game.GetService,game,n)
    if ok and r then return r end
    ok,r = pcall(function() return game[n] end)
    return ok and r or nil
end

local function doclip(txt)
    if setclipboard then pcall(setclipboard,txt); return true end
    if copystring   then pcall(copystring,txt);   return true end
    return false
end

-- ── BUILD GUI ────────────────────────────────────────────────
local W,H = 298, 390

local Gui = Instance.new("ScreenGui")
Gui.Name = "_EM7"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = true
Gui.Parent = PGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(W,H)
Main.Position = UDim2.new(0.5,-W/2,0.5,-H/2)
Main.BackgroundColor3 = BG
Main.ClipsDescendants = true
Main.BorderSizePixel = 0
Main.Parent = Gui
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,10)
local ms = Instance.new("UIStroke",Main)
ms.Color = LINE; ms.Thickness = 1

-- ── HEADER ───────────────────────────────────────────────────
local Hdr = Instance.new("Frame")
Hdr.Size = UDim2.new(1,0,0,34)
Hdr.Position = UDim2.new(0,0,0,0)
Hdr.BackgroundColor3 = HDR
Hdr.BorderSizePixel = 0
Hdr.ZIndex = 2
Hdr.Parent = Main
Instance.new("UICorner",Hdr).CornerRadius = UDim.new(0,10)
-- flatten bottom corners
local hfix = Instance.new("Frame",Hdr)
hfix.Size = UDim2.new(1,0,0.5,0)
hfix.Position = UDim2.new(0,0,0.5,0)
hfix.BackgroundColor3 = HDR
hfix.BorderSizePixel = 0
hfix.ZIndex = 2

local title = Instance.new("TextLabel",Hdr)
title.Text = "Exploit Menu  v7"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextColor3 = TEXT
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.new(0,10,0,0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

local MinB = Instance.new("TextButton",Hdr)
MinB.Text = "—"; MinB.Font = Enum.Font.GothamBold; MinB.TextSize = 12
MinB.TextColor3 = DIM; MinB.BackgroundColor3 = BTN; MinB.BorderSizePixel = 0
MinB.Size = UDim2.fromOffset(24,24)
MinB.Position = UDim2.new(1,-52,0.5,-12)
MinB.ZIndex = 4
MinB.AutoButtonColor = false
Instance.new("UICorner",MinB).CornerRadius = UDim.new(0,5)

local XBtn = Instance.new("TextButton",Hdr)
XBtn.Text = "✕"; XBtn.Font = Enum.Font.GothamBold; XBtn.TextSize = 11
XBtn.TextColor3 = WHITE; XBtn.BackgroundColor3 = CRST; XBtn.BorderSizePixel = 0
XBtn.Size = UDim2.fromOffset(24,24)
XBtn.Position = UDim2.new(1,-25,0.5,-12)
XBtn.ZIndex = 4
XBtn.AutoButtonColor = false
Instance.new("UICorner",XBtn).CornerRadius = UDim.new(0,5)

XBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)
local mini = false
MinB.MouseButton1Click:Connect(function()
    mini = not mini
    TweenService:Create(Main,TweenInfo.new(0.18,Enum.EasingStyle.Quint),{
        Size = mini and UDim2.fromOffset(W,34) or UDim2.fromOffset(W,H)
    }):Play()
    MinB.Text = mini and "▲" or "—"
end)

-- drag
do
    local drag,ds,sp
    Hdr.InputBegan:Connect(function(i)
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

-- ── TAB BAR ──────────────────────────────────────────────────
local TBar = Instance.new("Frame")
TBar.Size = UDim2.new(1,0,0,26)
TBar.Position = UDim2.new(0,0,0,34)
TBar.BackgroundColor3 = PANEL
TBar.BorderSizePixel = 0
TBar.Parent = Main
local tbl = Instance.new("UIListLayout",TBar)
tbl.FillDirection = Enum.FillDirection.Horizontal
tbl.SortOrder = Enum.SortOrder.LayoutOrder
tbl.Padding = UDim.new(0,0)

local Tab1 = Instance.new("TextButton",TBar)
Tab1.Text = "Structure"; Tab1.Font = Enum.Font.GothamBold
Tab1.TextSize = 12; Tab1.TextColor3 = TEXT
Tab1.BackgroundColor3 = BTN; Tab1.BorderSizePixel = 0
Tab1.Size = UDim2.new(0.5,0,1,0); Tab1.LayoutOrder = 1
Tab1.AutoButtonColor = false

local Tab2 = Instance.new("TextButton",TBar)
Tab2.Text = "Items"; Tab2.Font = Enum.Font.GothamSemibold
Tab2.TextSize = 12; Tab2.TextColor3 = DIM
Tab2.BackgroundColor3 = PANEL; Tab2.BorderSizePixel = 0
Tab2.Size = UDim2.new(0.5,0,1,0); Tab2.LayoutOrder = 2
Tab2.AutoButtonColor = false

local Ind = Instance.new("Frame",TBar)
Ind.Size = UDim2.new(0.5,0,0,2)
Ind.Position = UDim2.new(0,0,1,-2)
Ind.BackgroundColor3 = CCLIP
Ind.BorderSizePixel = 0
Ind.ZIndex = 5

-- divider
local div = Instance.new("Frame",Main)
div.Size = UDim2.new(1,0,0,1)
div.Position = UDim2.new(0,0,0,60)
div.BackgroundColor3 = LINE
div.BorderSizePixel = 0

-- ── CONTENT AREA ─────────────────────────────────────────────
local Con = Instance.new("Frame")
Con.Size = UDim2.new(1,0,1,-(34+26+1))
Con.Position = UDim2.new(0,0,0,34+26+1)   -- 61px from top
Con.BackgroundTransparency = 1
Con.ClipsDescendants = true
Con.Parent = Main

-- ════════════════════════════════════════════════════════════
--  PANEL 1 — STRUCTURE
-- ════════════════════════════════════════════════════════════
local P1 = Instance.new("Frame")
P1.Name = "P1_Structure"
P1.Size = UDim2.new(1,0,1,0)
P1.BackgroundTransparency = 1
P1.Visible = true
P1.Parent = Con
do
    local pl = Instance.new("UIPadding",P1)
    pl.PaddingLeft=UDim.new(0,7); pl.PaddingRight=UDim.new(0,7)
    pl.PaddingTop=UDim.new(0,7);  pl.PaddingBottom=UDim.new(0,7)
    local ll = Instance.new("UIListLayout",P1)
    ll.FillDirection = Enum.FillDirection.Vertical
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding = UDim.new(0,5)
end

-- section label
local slS = Instance.new("TextLabel",P1)
slS.Text="Structure Scanner"; slS.Font=Enum.Font.GothamSemibold; slS.TextSize=10
slS.TextColor3=DIM; slS.BackgroundTransparency=1
slS.Size=UDim2.new(1,0,0,13); slS.LayoutOrder=1
slS.TextXAlignment=Enum.TextXAlignment.Left

-- output box
local OuterS = Instance.new("Frame",P1)
OuterS.Size=UDim2.new(1,0,0,170); OuterS.BackgroundColor3=OUTBG
OuterS.BorderSizePixel=0; OuterS.LayoutOrder=2
Instance.new("UICorner",OuterS).CornerRadius=UDim.new(0,6)
local usSt=Instance.new("UIStroke",OuterS); usSt.Color=LINE; usSt.Thickness=1

local ScS=Instance.new("ScrollingFrame",OuterS)
ScS.Size=UDim2.new(1,-6,1,-6); ScS.Position=UDim2.new(0,3,0,3)
ScS.BackgroundTransparency=1; ScS.BorderSizePixel=0
ScS.ScrollBarThickness=3; ScS.ScrollBarImageColor3=LINE
ScS.CanvasSize=UDim2.new(0,0,0,0)
ScS.AutomaticCanvasSize=Enum.AutomaticSize.Y
ScS.ScrollingDirection=Enum.ScrollingDirection.Y

local OuS=Instance.new("TextLabel",ScS)
OuS.Text="Press [Clip] to scan the game tree."
OuS.Font=Enum.Font.Code; OuS.TextSize=11; OuS.TextColor3=DIM
OuS.Size=UDim2.new(1,-4,0,0); OuS.Position=UDim2.new(0,2,0,2)
OuS.BackgroundTransparency=1
OuS.TextXAlignment=Enum.TextXAlignment.Left
OuS.TextYAlignment=Enum.TextYAlignment.Top
OuS.TextWrapped=true; OuS.AutomaticSize=Enum.AutomaticSize.Y

-- button row: Clip | Copy | Reset
local Row1S=Instance.new("Frame",P1)
Row1S.Size=UDim2.new(1,0,0,28); Row1S.BackgroundTransparency=1; Row1S.LayoutOrder=3
do local rl=Instance.new("UIListLayout",Row1S)
    rl.FillDirection=Enum.FillDirection.Horizontal
    rl.SortOrder=Enum.SortOrder.LayoutOrder
    rl.Padding=UDim.new(0,5) end

local BClip=Instance.new("TextButton",Row1S)
BClip.Text="Clip"; BClip.Font=Enum.Font.GothamBold; BClip.TextSize=12
BClip.TextColor3=WHITE; BClip.BackgroundColor3=CCLIP; BClip.BorderSizePixel=0
BClip.Size=UDim2.new(0.34,0,1,0); BClip.LayoutOrder=1; BClip.AutoButtonColor=false
Instance.new("UICorner",BClip).CornerRadius=UDim.new(0,6)

local BCopy=Instance.new("TextButton",Row1S)
BCopy.Text="Copy"; BCopy.Font=Enum.Font.GothamBold; BCopy.TextSize=12
BCopy.TextColor3=WHITE; BCopy.BackgroundColor3=CCOPY; BCopy.BorderSizePixel=0
BCopy.Size=UDim2.new(0.33,-5,1,0); BCopy.LayoutOrder=2; BCopy.AutoButtonColor=false
Instance.new("UICorner",BCopy).CornerRadius=UDim.new(0,6)

local BRst=Instance.new("TextButton",Row1S)
BRst.Text="Reset"; BRst.Font=Enum.Font.GothamBold; BRst.TextSize=12
BRst.TextColor3=WHITE; BRst.BackgroundColor3=CRST; BRst.BorderSizePixel=0
BRst.Size=UDim2.new(0.33,-5,1,0); BRst.LayoutOrder=3; BRst.AutoButtonColor=false
Instance.new("UICorner",BRst).CornerRadius=UDim.new(0,6)

-- Anti button
local AntiB=Instance.new("TextButton",P1)
AntiB.Text="  Anti-Cheat Remover: OFF"; AntiB.Font=Enum.Font.GothamBold; AntiB.TextSize=12
AntiB.TextColor3=WHITE; AntiB.BackgroundColor3=CAC0; AntiB.BorderSizePixel=0
AntiB.Size=UDim2.new(1,0,0,28); AntiB.LayoutOrder=4; AntiB.AutoButtonColor=false
Instance.new("UICorner",AntiB).CornerRadius=UDim.new(0,6)

local NodeLbl=Instance.new("TextLabel",P1)
NodeLbl.Text=""; NodeLbl.Font=Enum.Font.Gotham; NodeLbl.TextSize=10
NodeLbl.TextColor3=DIM; NodeLbl.BackgroundTransparency=1
NodeLbl.Size=UDim2.new(1,0,0,12); NodeLbl.LayoutOrder=5
NodeLbl.TextXAlignment=Enum.TextXAlignment.Left

local ACLbl=Instance.new("TextLabel",P1)
ACLbl.Text=""; ACLbl.Font=Enum.Font.Gotham; ACLbl.TextSize=10
ACLbl.TextColor3=DIM; ACLbl.BackgroundTransparency=1
ACLbl.Size=UDim2.new(1,0,0,12); ACLbl.LayoutOrder=6
ACLbl.TextXAlignment=Enum.TextXAlignment.Left

-- ════════════════════════════════════════════════════════════
--  PANEL 2 — ITEMS  (Item Clip + Clip Scripts)
-- ════════════════════════════════════════════════════════════
local P2 = Instance.new("Frame")
P2.Name = "P2_Items"
P2.Size = UDim2.new(1,0,1,0)
P2.BackgroundTransparency = 1
P2.Visible = false          -- hidden until tab clicked
P2.Parent = Con
do
    local pl=Instance.new("UIPadding",P2)
    pl.PaddingLeft=UDim.new(0,7); pl.PaddingRight=UDim.new(0,7)
    pl.PaddingTop=UDim.new(0,7);  pl.PaddingBottom=UDim.new(0,7)
    local ll=Instance.new("UIListLayout",P2)
    ll.FillDirection=Enum.FillDirection.Vertical
    ll.SortOrder=Enum.SortOrder.LayoutOrder
    ll.Padding=UDim.new(0,5)
end

local slI=Instance.new("TextLabel",P2)
slI.Text="Item & Script Scanner"; slI.Font=Enum.Font.GothamSemibold; slI.TextSize=10
slI.TextColor3=DIM; slI.BackgroundTransparency=1
slI.Size=UDim2.new(1,0,0,13); slI.LayoutOrder=1
slI.TextXAlignment=Enum.TextXAlignment.Left

-- shared output
local OuterI=Instance.new("Frame",P2)
OuterI.Size=UDim2.new(1,0,0,140); OuterI.BackgroundColor3=OUTBG
OuterI.BorderSizePixel=0; OuterI.LayoutOrder=2
Instance.new("UICorner",OuterI).CornerRadius=UDim.new(0,6)
local usIt=Instance.new("UIStroke",OuterI); usIt.Color=LINE; usIt.Thickness=1

local ScI=Instance.new("ScrollingFrame",OuterI)
ScI.Size=UDim2.new(1,-6,1,-6); ScI.Position=UDim2.new(0,3,0,3)
ScI.BackgroundTransparency=1; ScI.BorderSizePixel=0
ScI.ScrollBarThickness=3; ScI.ScrollBarImageColor3=LINE
ScI.CanvasSize=UDim2.new(0,0,0,0)
ScI.AutomaticCanvasSize=Enum.AutomaticSize.Y
ScI.ScrollingDirection=Enum.ScrollingDirection.Y

local OuI=Instance.new("TextLabel",ScI)
OuI.Text="Press [Item Clip] or [Clip Scripts] to scan."
OuI.Font=Enum.Font.Code; OuI.TextSize=11; OuI.TextColor3=DIM
OuI.Size=UDim2.new(1,-4,0,0); OuI.Position=UDim2.new(0,2,0,2)
OuI.BackgroundTransparency=1
OuI.TextXAlignment=Enum.TextXAlignment.Left
OuI.TextYAlignment=Enum.TextYAlignment.Top
OuI.TextWrapped=true; OuI.AutomaticSize=Enum.AutomaticSize.Y

-- row: Item Clip | Copy | Reset
local Row1I=Instance.new("Frame",P2)
Row1I.Size=UDim2.new(1,0,0,28); Row1I.BackgroundTransparency=1; Row1I.LayoutOrder=3
do local rl=Instance.new("UIListLayout",Row1I)
    rl.FillDirection=Enum.FillDirection.Horizontal
    rl.SortOrder=Enum.SortOrder.LayoutOrder
    rl.Padding=UDim.new(0,5) end

local BIC=Instance.new("TextButton",Row1I)
BIC.Text="Item Clip"; BIC.Font=Enum.Font.GothamBold; BIC.TextSize=12
BIC.TextColor3=WHITE; BIC.BackgroundColor3=CITM; BIC.BorderSizePixel=0
BIC.Size=UDim2.new(0.44,0,1,0); BIC.LayoutOrder=1; BIC.AutoButtonColor=false
Instance.new("UICorner",BIC).CornerRadius=UDim.new(0,6)

local BICp=Instance.new("TextButton",Row1I)
BICp.Text="Copy"; BICp.Font=Enum.Font.GothamBold; BICp.TextSize=12
BICp.TextColor3=WHITE; BICp.BackgroundColor3=CCOPY; BICp.BorderSizePixel=0
BICp.Size=UDim2.new(0.28,-5,1,0); BICp.LayoutOrder=2; BICp.AutoButtonColor=false
Instance.new("UICorner",BICp).CornerRadius=UDim.new(0,6)

local BIRs=Instance.new("TextButton",Row1I)
BIRs.Text="Reset"; BIRs.Font=Enum.Font.GothamBold; BIRs.TextSize=12
BIRs.TextColor3=WHITE; BIRs.BackgroundColor3=CRST; BIRs.BorderSizePixel=0
BIRs.Size=UDim2.new(0.28,-5,1,0); BIRs.LayoutOrder=3; BIRs.AutoButtonColor=false
Instance.new("UICorner",BIRs).CornerRadius=UDim.new(0,6)

-- Clip Scripts (full width)
local BSC=Instance.new("TextButton",P2)
BSC.Text="  Clip Scripts  (Script · LocalScript · ModuleScript)"
BSC.Font=Enum.Font.GothamBold; BSC.TextSize=11
BSC.TextColor3=WHITE; BSC.BackgroundColor3=CSCR; BSC.BorderSizePixel=0
BSC.Size=UDim2.new(1,0,0,28); BSC.LayoutOrder=4; BSC.AutoButtonColor=false
Instance.new("UICorner",BSC).CornerRadius=UDim.new(0,6)

-- item badges row 1
local IBR1=Instance.new("Frame",P2)
IBR1.Size=UDim2.new(1,0,0,18); IBR1.BackgroundTransparency=1; IBR1.LayoutOrder=5
do local rl=Instance.new("UIListLayout",IBR1)
    rl.FillDirection=Enum.FillDirection.Horizontal
    rl.SortOrder=Enum.SortOrder.LayoutOrder
    rl.Padding=UDim.new(0,4) end

local function mkBadge(txt,par)
    local f=Instance.new("Frame",par)
    f.Size=UDim2.new(0.5,-2,1,0); f.BackgroundColor3=BDGE; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,4)
    local t=Instance.new("TextLabel",f)
    t.Text=txt; t.Font=Enum.Font.Gotham; t.TextSize=10
    t.TextColor3=DIM; t.BackgroundTransparency=1
    t.Size=UDim2.new(1,0,1,0)
    t.TextXAlignment=Enum.TextXAlignment.Center
    return t
end

local BgTools   = mkBadge("Tools: 0",   IBR1)
local BgProduce = mkBadge("Produce: 0", IBR1)

local IBR2=Instance.new("Frame",P2)
IBR2.Size=UDim2.new(1,0,0,18); IBR2.BackgroundTransparency=1; IBR2.LayoutOrder=6
do local rl=Instance.new("UIListLayout",IBR2)
    rl.FillDirection=Enum.FillDirection.Horizontal
    rl.SortOrder=Enum.SortOrder.LayoutOrder
    rl.Padding=UDim.new(0,4) end
local BgAcc   = mkBadge("Acc: 0",   IBR2)
local BgOther = mkBadge("Other: 0", IBR2)

-- script badges row 1
local SBR1=Instance.new("Frame",P2)
SBR1.Size=UDim2.new(1,0,0,18); SBR1.BackgroundTransparency=1; SBR1.LayoutOrder=7
do local rl=Instance.new("UIListLayout",SBR1)
    rl.FillDirection=Enum.FillDirection.Horizontal
    rl.SortOrder=Enum.SortOrder.LayoutOrder
    rl.Padding=UDim.new(0,4) end
local BgSc = mkBadge("Script: 0",      SBR1)
local BgLs = mkBadge("LocalScript: 0", SBR1)

local SBR2=Instance.new("Frame",P2)
SBR2.Size=UDim2.new(1,0,0,18); SBR2.BackgroundTransparency=1; SBR2.LayoutOrder=8
do local rl=Instance.new("UIListLayout",SBR2)
    rl.FillDirection=Enum.FillDirection.Horizontal
    rl.SortOrder=Enum.SortOrder.LayoutOrder
    rl.Padding=UDim.new(0,4) end
local BgMs = mkBadge("Module: 0", SBR2)
local BgTt = mkBadge("Total: 0",  SBR2)

local InfoLbl=Instance.new("TextLabel",P2)
InfoLbl.Text=""; InfoLbl.Font=Enum.Font.Gotham; InfoLbl.TextSize=10
InfoLbl.TextColor3=DIM; InfoLbl.BackgroundTransparency=1
InfoLbl.Size=UDim2.new(1,0,0,12); InfoLbl.LayoutOrder=9
InfoLbl.TextXAlignment=Enum.TextXAlignment.Left

-- ════════════════════════════════════════════════════════════
--  TAB SWITCHING  (completely explicit, no table tricks)
-- ════════════════════════════════════════════════════════════
local function showStructure()
    P1.Visible = true
    P2.Visible = false
    Tab1.TextColor3 = TEXT;  Tab1.BackgroundColor3 = BTN;   Tab1.Font = Enum.Font.GothamBold
    Tab2.TextColor3 = DIM;   Tab2.BackgroundColor3 = PANEL; Tab2.Font = Enum.Font.GothamSemibold
    TweenService:Create(Ind,TweenInfo.new(0.15),{Position=UDim2.new(0,0,1,-2),BackgroundColor3=CCLIP}):Play()
end

local function showItems()
    P1.Visible = false
    P2.Visible = true
    Tab1.TextColor3 = DIM;  Tab1.BackgroundColor3 = PANEL; Tab1.Font = Enum.Font.GothamSemibold
    Tab2.TextColor3 = TEXT; Tab2.BackgroundColor3 = BTN;   Tab2.Font = Enum.Font.GothamBold
    TweenService:Create(Ind,TweenInfo.new(0.15),{Position=UDim2.new(0.5,0,1,-2),BackgroundColor3=CITM}):Play()
end

Tab1.MouseButton1Click:Connect(showStructure)
Tab2.MouseButton1Click:Connect(showItems)
showStructure()   -- start on Structure

-- ════════════════════════════════════════════════════════════
--  STRUCTURE LOGIC
-- ════════════════════════════════════════════════════════════
local lastStructOut = ""

local function buildTree(inst,depth,lines,cnt)
    if cnt[1]>=2500 then return end
    cnt[1]=cnt[1]+1
    local ok1,cn=pcall(function() return inst.ClassName end)
    local ok2,nm=pcall(function() return inst.Name end)
    if not ok1 or not ok2 then return end
    table.insert(lines,string.rep("  ",math.min(depth,10)).."["..cn.."]  "..nm)
    if depth>=8 then return end
    local ok3,kids=pcall(function() return inst:GetChildren() end)
    if ok3 then for _,k in ipairs(kids) do buildTree(k,depth+1,lines,cnt) end end
end

BClip.MouseButton1Click:Connect(function()
    OuS.Text="Scanning…"; NodeLbl.Text=""; task.wait(0.05)
    local ok,er=pcall(function()
        local L,cnt={},{0}
        table.insert(L,string.format("[ %s | PlaceId: %d ]\n",os.date("%H:%M:%S"),game.PlaceId))
        for _,n in ipairs(STRUCT_SVCS) do
            local s=safeGet(n)
            if s then
                table.insert(L,">> "..n)
                local ok2,kids=pcall(function() return s:GetChildren() end)
                if ok2 then for _,c in ipairs(kids) do buildTree(c,1,L,cnt) end
                else table.insert(L,"  [Access Denied]") end
                table.insert(L,"")
            else
                table.insert(L,">> "..n.."  [Not Found]\n")
            end
        end
        if cnt[1]>=2500 then table.insert(L,"\n[Capped at 2500 nodes]") end
        lastStructOut=table.concat(L,"\n"); OuS.Text=lastStructOut
        NodeLbl.Text=cnt[1].." nodes scanned"
    end)
    if not ok then OuS.Text="Error:\n"..tostring(er) end
end)

BCopy.MouseButton1Click:Connect(function()
    if lastStructOut=="" then OuS.Text="Run Clip first."; return end
    local ok=doclip(lastStructOut); local prev=OuS.Text
    OuS.Text=ok and ("Copied "..#lastStructOut.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OuS and OuS.Parent then OuS.Text=prev end end)
end)

BRst.MouseButton1Click:Connect(function()
    lastStructOut=""; OuS.Text="Press [Clip] to scan the game tree."
    NodeLbl.Text=""; ScS.CanvasPosition=Vector2.zero
end)

-- ════════════════════════════════════════════════════════════
--  ANTI-CHEAT
-- ════════════════════════════════════════════════════════════
local acOn,acKilled=false,0

local function nameIsAC(nm)
    local lo=nm:lower()
    for _,p in ipairs(AC_PAT) do if lo:find(p,1,true) then return true end end
    return false
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
        local ok=pcall(function()
            if inst:IsA("BaseScript") then inst.Disabled=true end; inst:Destroy()
        end)
        if ok then k=k+1; acKilled=acKilled+1 end
    end
    if k>0 then ACLbl.Text=string.format("Removed %d this pass | total: %d",k,acKilled) end
end
local function setAC(on)
    acOn=on
    if on then
        AntiB.Text="  Anti-Cheat Remover: ON"; AntiB.BackgroundColor3=CAC1
        ACLbl.Text="Running — scanning every 2s…"
        task.spawn(runAC)
        task.spawn(function() while acOn do task.wait(2); if acOn then runAC() end end end)
    else
        AntiB.Text="  Anti-Cheat Remover: OFF"; AntiB.BackgroundColor3=CAC0
        ACLbl.Text=string.format("Stopped. Total removed: %d",acKilled)
    end
end
AntiB.MouseButton1Click:Connect(function() setAC(not acOn) end)
Gui.AncestryChanged:Connect(function() if not Gui.Parent then acOn=false end end)

-- ════════════════════════════════════════════════════════════
--  ITEM SCANNER LOGIC
-- ════════════════════════════════════════════════════════════
local lastItemOut=""

local function matchCls(cn) return ITEM_CLS[cn]==true end
local function matchKW(nm)
    local lo=nm:lower()
    for _,k in ipairs(KW) do if lo:find(k,1,true) then return true end end
    return false
end
local function itemCat(cn,nm)
    local lo=nm:lower()
    if cn=="Tool" or cn=="HopperBin" or cn=="Gear" then return "tool" end
    if cn=="Accessory" or cn=="Hat" or cn=="Shirt" or cn=="Pants" or cn=="ShirtGraphic" then return "acc" end
    local pKW={"fruit","seed","crop","berry","plant","mushroom","flower","egg","fish","harvest",
        "produce","apple","orange","banana","mango","melon","grape","carrot","potato",
        "corn","tomato","pumpkin","sprout","sapling","cherry","lemon","peach","pear",
        "kiwi","coconut","dragonfruit","strawberry"}
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
                if bc or bk then
                    seen[ptr]=true
                    table.insert(res,{cn=cn,nm=nm,cat=itemCat(cn,nm),
                        how=(bc and bk) and "class+kw" or bc and "class" or "keyword"})
                end
            end
            if not (cn:find("Part") or cn:find("Mesh") or cn:find("Decal")
                 or cn:find("Sound") or cn:find("Weld") or cn:find("Motor")
                 or cn:find("Constraint")) then
                deepItems(c,res,seen,d+1)
            end
        end
    end
end

BIC.MouseButton1Click:Connect(function()
    OuI.Text="Scanning items…"; InfoLbl.Text=""
    BgTools.Text="…"; BgProduce.Text="…"; BgAcc.Text="…"; BgOther.Text="…"
    task.wait(0.05)
    local ok,er=pcall(function()
        local res,seen,L={},{},{}
        local tC,pC,aC,oC=0,0,0,0
        local function sec(lbl,root)
            local bef=#res; deepItems(root,res,seen,0)
            if #res>bef then
                table.insert(L,">> "..lbl)
                for i=bef+1,#res do local e=res[i]
                    table.insert(L,"  ["..e.cn.."]  "..e.nm.."  ("..e.how..")") end
                table.insert(L,"")
            end
        end
        local bp=LP:FindFirstChild("Backpack"); if bp then sec("Backpack",bp) end
        local ch=LP.Character; if ch then sec("Character",ch) end
        for _,n in ipairs(ITEM_SRCS) do local s=safeGet(n); if s then sec(n,s) end end
        for _,e in ipairs(res) do
            if e.cat=="tool" then tC=tC+1
            elseif e.cat=="produce" then pC=pC+1
            elseif e.cat=="acc" then aC=aC+1
            else oC=oC+1 end
        end
        if #res==0 then table.insert(L,"No items found.")
        else table.insert(L,string.format("-- Total:%d (Tools:%d Produce:%d Acc:%d Other:%d)",
            #res,tC,pC,aC,oC)) end
        lastItemOut=table.concat(L,"\n"); OuI.Text=lastItemOut
        InfoLbl.Text=#res.." items found"
        BgTools.Text="Tools: "..tC; BgProduce.Text="Produce: "..pC
        BgAcc.Text="Acc: "..aC;     BgOther.Text="Other: "..oC
    end)
    if not ok then OuI.Text="Item error:\n"..tostring(er) end
end)

BICp.MouseButton1Click:Connect(function()
    if lastItemOut=="" then OuI.Text="Run Item Clip first."; return end
    local ok=doclip(lastItemOut); local prev=OuI.Text
    OuI.Text=ok and ("Copied "..#lastItemOut.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OuI and OuI.Parent then OuI.Text=prev end end)
end)

BIRs.MouseButton1Click:Connect(function()
    lastItemOut=""; OuI.Text="Press [Item Clip] or [Clip Scripts] to scan."
    BgTools.Text="Tools: 0"; BgProduce.Text="Produce: 0"
    BgAcc.Text="Acc: 0";     BgOther.Text="Other: 0"
    BgSc.Text="Script: 0";   BgLs.Text="LocalScript: 0"
    BgMs.Text="Module: 0";   BgTt.Text="Total: 0"
    InfoLbl.Text=""; ScI.CanvasPosition=Vector2.zero
end)

-- ════════════════════════════════════════════════════════════
--  SCRIPT SCANNER LOGIC
-- ════════════════════════════════════════════════════════════
local lastScriptOut=""

local function deepScripts(root,res,seen,d)
    if d>12 then return end
    local ok,kids=pcall(function() return root:GetChildren() end)
    if not ok then return end
    for _,c in ipairs(kids) do
        local ok1,cn=pcall(function() return c.ClassName end)
        local ok2,nm=pcall(function() return c.Name end)
        if ok1 and ok2 then
            local ptr=tostring(c)
            if SCR_CLS[cn] and not seen[ptr] then
                seen[ptr]=true
                local dis=""
                pcall(function() if c:IsA("BaseScript") and c.Disabled then dis=" [DISABLED]" end end)
                table.insert(res,{cn=cn,nm=nm,dis=dis})
            end
            deepScripts(c,res,seen,d+1)
        end
    end
end

BSC.MouseButton1Click:Connect(function()
    OuI.Text="Scanning scripts…"; InfoLbl.Text=""
    BgSc.Text="…"; BgLs.Text="…"; BgMs.Text="…"; BgTt.Text="…"
    task.wait(0.05)
    local ok,er=pcall(function()
        local res,seen,L={},{},{}
        local scC,lsC,msC=0,0,0
        table.insert(L,string.format("[ %s | PlaceId: %d ]\n",os.date("%H:%M:%S"),game.PlaceId))
        for _,n in ipairs(SCR_SVCS) do
            local s=safeGet(n)
            if s then
                local bef=#res; deepScripts(s,res,seen,0)
                if #res>bef then
                    table.insert(L,">> "..n)
                    for i=bef+1,#res do local e=res[i]
                        table.insert(L,"  ["..e.cn.."]  "..e.nm..e.dis) end
                    table.insert(L,"")
                end
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
            if e.cn=="Script" then scC=scC+1
            elseif e.cn=="LocalScript" then lsC=lsC+1
            elseif e.cn=="ModuleScript" then msC=msC+1 end
        end
        local tot=#res
        if tot==0 then table.insert(L,"No accessible scripts found.")
        else table.insert(L,string.format("-- Total:%d (Script:%d LocalScript:%d Module:%d)",
            tot,scC,lsC,msC)) end
        lastScriptOut=table.concat(L,"\n"); OuI.Text=lastScriptOut
        InfoLbl.Text=tot.." scripts found"
        BgSc.Text="Script: "..scC; BgLs.Text="LocalScript: "..lsC
        BgMs.Text="Module: "..msC; BgTt.Text="Total: "..tot
    end)
    if not ok then OuI.Text="Script error:\n"..tostring(er) end
end)

-- ── OPEN ANIMATION ───────────────────────────────────────────
Main.BackgroundTransparency=1
Main.Position=UDim2.new(0.5,-W/2,0.5,-H/2+12)
TweenService:Create(Main,TweenInfo.new(0.2,Enum.EasingStyle.Quint),{
    BackgroundTransparency=0,
    Position=UDim2.new(0.5,-W/2,0.5,-H/2),
}):Play()

print("[ExploitMenu v7] Loaded  |  Structure tab & Items tab ready")
