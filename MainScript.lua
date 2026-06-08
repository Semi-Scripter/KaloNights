-- Personal Exploit Menu v6
-- 2 Tabs: Structure | Items   (compact height)

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LP               = Players.LocalPlayer
local PGui             = LP:WaitForChild("PlayerGui")

if PGui:FindFirstChild("_EM") then PGui["_EM"]:Destroy() end

-- ── THEME ────────────────────────────────────────────────────
local C = {
    BG     = Color3.fromRGB(18,18,24),
    PANEL  = Color3.fromRGB(26,26,34),
    HDR    = Color3.fromRGB(30,30,40),
    LINE   = Color3.fromRGB(46,46,60),
    TEXT   = Color3.fromRGB(218,218,228),
    DIM    = Color3.fromRGB(110,110,132),
    WHITE  = Color3.fromRGB(255,255,255),
    BTN    = Color3.fromRGB(40,40,54),
    OUT    = Color3.fromRGB(12,12,18),
    BADGE  = Color3.fromRGB(50,50,68),
    CLIP   = Color3.fromRGB(52,96,158),
    COPY   = Color3.fromRGB(46,106,80),
    RESET  = Color3.fromRGB(116,46,54),
    ITEM   = Color3.fromRGB(100,80,40),
    SCR    = Color3.fromRGB(60,80,130),
    AC0    = Color3.fromRGB(58,58,75),
    AC1    = Color3.fromRGB(50,130,70),
}

-- ── DATA ─────────────────────────────────────────────────────
local STRUCT_SVCS = {
    "Workspace","ReplicatedStorage","ReplicatedFirst",
    "StarterGui","StarterPack","StarterPlayer",
    "Lighting","SoundService","Chat","Teams",
}
local ITEM_SRCS = {"Workspace","ReplicatedStorage","StarterPack","ReplicatedFirst"}
local SCR_SVCS  = {
    "Workspace","ReplicatedStorage","ReplicatedFirst",
    "StarterGui","StarterPack","StarterPlayer",
    "Lighting","SoundService","Chat","Teams",
}
local ITEM_CLS = {Tool=true,HopperBin=true,Accessory=true,Hat=true,Shirt=true,Pants=true,ShirtGraphic=true,Gear=true}
local SCR_CLS  = {Script=true,LocalScript=true,ModuleScript=true}

local KW = {
    -- fruits
    "apple","apricot","avocado","banana","blackberry","blueberry","cherry","clementine",
    "coconut","cranberry","damson","date","dragonfruit","durian","elderberry","fig",
    "grape","grapefruit","guava","honeydew","jackfruit","kiwi","kumquat","lemon",
    "lime","lychee","mandarin","mango","mangosteen","melon","mulberry","nectarine",
    "olive","orange","papaya","passionfruit","peach","pear","persimmon","pineapple",
    "plantain","plum","pomegranate","pomelo","quince","rambutan","raspberry",
    "salak","soursop","starfruit","strawberry","tamarind","tangerine","watermelon","yuzu",
    -- exotic/devil fruits
    "mythic","divine","prismatic","corrupted","void","cosmic","rainbow","carnival",
    "tropical","bubblegum","frozen","radioactive","acid","moonberry","sunfruit",
    "starberry","glowfruit","shadowfruit","blazefruit","frostfruit","venomfruit",
    "crystalfruit","goldfruit","demonfruit","angelfruit","dragonberry","phoenixfruit","riftfruit",
    -- vegetables/crops
    "artichoke","asparagus","bean","beet","broccoli","cabbage","carrot","cauliflower",
    "celery","chickpea","corn","cucumber","eggplant","garlic","ginger","kale",
    "leek","lentil","lettuce","okra","onion","parsnip","pea","pepper","potato",
    "pumpkin","radish","rice","spinach","squash","sugarcane","tomato","turnip","wheat","yam","zucchini",
    -- farming
    "seed","seedpack","sapling","sprout","bulb","crop","harvest","produce","plant",
    "fertilizer","compost","herb","cactus","mushroom","truffle","fungi","spore",
    "flower","rose","tulip","daisy","sunflower","berry","algae","kelp",
    -- food/drink
    "food","meal","ration","bread","meat","steak","pork","chicken","fish","salmon",
    "tuna","shrimp","crab","egg","milk","cheese","honey","syrup","jam","jerky",
    "soup","stew","broth","nut","acorn","walnut","almond","peanut","grain","flour",
    "water","canteen","flask","bottle","juice","sap","nectar",
    -- resources
    "wood","log","plank","stick","branch","lumber","timber","stone","rock","pebble",
    "flint","coal","charcoal","ash","fiber","cloth","leather","hide","pelt","fur",
    "wool","silk","rope","vine","iron","copper","tin","bronze","silver","gold",
    "steel","ore","ingot","nugget","gem","crystal","shard","diamond","emerald",
    "ruby","sapphire","amethyst","quartz","obsidian","bone","horn","tooth","claw",
    "scale","feather","shell","sand","clay","resin","oil","tar","glass",
    -- tools/weapons
    "axe","hatchet","pickaxe","shovel","rake","scythe","hammer","knife","dagger",
    "sword","blade","spear","lance","bow","arrow","quiver","crossbow","gun",
    "pistol","rifle","shotgun","sniper","revolver","bullet","ammo","grenade",
    "explosive","shield","armor","helmet","chestplate","leggings","boots","gloves",
    "vest","torch","lantern","flashlight","lighter","trap","snare","net","fishing","bait",
    -- medicine
    "bandage","medkit","firstaid","heal","health","potion","elixir","antidote",
    "cure","remedy","medicine","pill","syringe","salve",
    -- shelter/gear
    "tent","tarp","blanket","campfire","backpack","bag","pouch","sack","chest",
    "crate","box","barrel","key","lockpick","compass","map","radio","parachute",
    -- general
    "fruit","item","goods","loot","drop","reward","prize","pickup","resource",
    "material","ingredient","token","coin","currency","trophy","badge","pack",
    "bundle","jar","vial","spray","scroll","charm","brew","powder","dust",
    "weapon","equipment","supply","cargo","relic","artifact",
}

local AC_PAT = {
    "anticheat","anti_cheat","anti-cheat","acheat","kicksystem","banhandler",
    "exploitdetect","exploitcheck","detection","sanitycheck","speedcheck",
    "flycheck","noclipcheck","fairplay","safeguard","guardian","remotechecker",
    "teleportcheck","positioncheck","cheatdetect","hackdetect",
    "securitycheck","antiexploit","anti_exploit","exploitban",
}

-- ── HELPERS ──────────────────────────────────────────────────
local function new(cls, props, par)
    local o = Instance.new(cls)
    for k,v in pairs(props) do o[k]=v end
    if par then o.Parent=par end
    return o
end
local function corner(p,r) new("UICorner",{CornerRadius=UDim.new(0,r or 6)},p) end
local function pad(p,l,r,t,b)
    new("UIPadding",{PaddingLeft=UDim.new(0,l),PaddingRight=UDim.new(0,r),
        PaddingTop=UDim.new(0,t),PaddingBottom=UDim.new(0,b)},p)
end
local function vl(p,g) new("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,
    SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,g or 5)},p) end
local function hl(p,g) new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,
    SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,g or 0)},p) end

local function btn(txt,col,par,sz,ord)
    local b = new("TextButton",{Text=txt,Font=Enum.Font.GothamBold,TextSize=12,
        TextColor3=C.WHITE,Size=sz or UDim2.new(1,0,0,28),
        BackgroundColor3=col,BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=ord or 1},par)
    corner(b,6)
    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.1),{BackgroundColor3=col:lerp(Color3.new(1,1,1),0.12)}):Play() end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.1),{BackgroundColor3=col}):Play() end)
    return b
end

local function output(par, h, ord)
    local f = new("Frame",{Size=UDim2.new(1,0,0,h),BackgroundColor3=C.OUT,
        BorderSizePixel=0,LayoutOrder=ord},par)
    corner(f,6); new("UIStroke",{Color=C.LINE,Thickness=1},f)
    local sc = new("ScrollingFrame",{Size=UDim2.new(1,-6,1,-6),Position=UDim2.new(0,3,0,3),
        BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,
        ScrollBarImageColor3=C.LINE,CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y},f)
    local lbl = new("TextLabel",{Text="",Font=Enum.Font.Code,TextSize=11,TextColor3=C.DIM,
        Size=UDim2.new(1,-6,0,0),Position=UDim2.new(0,3,0,3),BackgroundTransparency=1,
        TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,
        TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y},sc)
    return f,sc,lbl
end

local function row(par,h,ord)
    local r=new("Frame",{Size=UDim2.new(1,0,0,h),BackgroundTransparency=1,LayoutOrder=ord},par)
    hl(r,5); return r
end

local function slbl(txt,par,ord)
    return new("TextLabel",{Text=txt,Font=Enum.Font.GothamSemibold,TextSize=10,
        TextColor3=C.DIM,BackgroundTransparency=1,Size=UDim2.new(1,0,0,13),
        LayoutOrder=ord,TextXAlignment=Enum.TextXAlignment.Left},par)
end

local function badge(txt,par)
    local f=new("Frame",{Size=UDim2.new(0.5,-2,1,0),BackgroundColor3=C.BADGE,BorderSizePixel=0},par)
    corner(f,5)
    return new("TextLabel",{Text=txt,Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.DIM,
        BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),TextXAlignment=Enum.TextXAlignment.Center},f)
end

local function safeGet(n)
    local ok,r=pcall(game.GetService,game,n)
    if ok and r then return r end
    ok,r=pcall(function() return game[n] end)
    return ok and r or nil
end

local function clip(txt)
    if setclipboard then pcall(setclipboard,txt); return true end
    if copystring   then pcall(copystring,txt);   return true end
    return false
end

-- ── SCREEN GUI ───────────────────────────────────────────────
local W,H = 300, 400   -- compact size

local Gui = new("ScreenGui",{Name="_EM",ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true},PGui)

local Main = new("Frame",{Size=UDim2.fromOffset(W,H),
    Position=UDim2.new(0.5,-W/2,0.5,-H/2),
    BackgroundColor3=C.BG,ClipsDescendants=true},Gui)
corner(Main,10); new("UIStroke",{Color=C.LINE,Thickness=1},Main)

-- ── HEADER ───────────────────────────────────────────────────
local Hdr = new("Frame",{Size=UDim2.new(1,0,0,34),BackgroundColor3=C.HDR,BorderSizePixel=0},Main)
corner(Hdr,10)
new("Frame",{Size=UDim2.new(1,0,0.5,0),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=C.HDR,BorderSizePixel=0},Hdr)
new("TextLabel",{Text="Exploit Menu",Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.TEXT,
    BackgroundTransparency=1,Size=UDim2.new(1,-64,1,0),Position=UDim2.new(0,10,0,0),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3},Hdr)
new("TextLabel",{Text="v6",Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.DIM,
    BackgroundTransparency=1,Size=UDim2.new(0,18,1,0),Position=UDim2.new(0,102,0,0),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3},Hdr)

local MinB = new("TextButton",{Text="—",Font=Enum.Font.GothamBold,TextSize=12,TextColor3=C.DIM,
    Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-52,0.5,-12),
    BackgroundColor3=C.BTN,BorderSizePixel=0,ZIndex=4},Hdr); corner(MinB,5)
local XBtn = new("TextButton",{Text="✕",Font=Enum.Font.GothamBold,TextSize=11,TextColor3=C.WHITE,
    Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-25,0.5,-12),
    BackgroundColor3=C.RESET,BorderSizePixel=0,ZIndex=4},Hdr); corner(XBtn,5)

XBtn.MouseButton1Click:Connect(function() Gui:Destroy() end)
local mini=false
MinB.MouseButton1Click:Connect(function()
    mini=not mini
    TweenService:Create(Main,TweenInfo.new(0.18,Enum.EasingStyle.Quint),{
        Size=mini and UDim2.fromOffset(W,34) or UDim2.fromOffset(W,H)}):Play()
    MinB.Text=mini and "▲" or "—"
end)

-- drag
do local drag,ds,sp
    Hdr.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then drag=true;ds=i.Position;sp=Main.Position end end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement
                  or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            Main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y) end end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
end

-- ── TAB BAR ──────────────────────────────────────────────────
local TBar = new("Frame",{Size=UDim2.new(1,0,0,26),Position=UDim2.new(0,0,0,34),
    BackgroundColor3=C.PANEL,BorderSizePixel=0},Main)
hl(TBar,0)

local TB = {}
for i,lbl in ipairs({"Structure","Items"}) do
    local t=new("TextButton",{Text=lbl,Font=Enum.Font.GothamSemibold,TextSize=12,
        TextColor3=C.DIM,Size=UDim2.new(0.5,0,1,0),BackgroundColor3=C.PANEL,
        BorderSizePixel=0,AutoButtonColor=false,LayoutOrder=i},TBar)
    TB[i]=t
end

local Ind=new("Frame",{Size=UDim2.new(0.5,0,0,2),Position=UDim2.new(0,0,1,-2),
    BackgroundColor3=C.CLIP,BorderSizePixel=0,ZIndex=5},TBar)

new("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,60),
    BackgroundColor3=C.LINE,BorderSizePixel=0},Main)

-- ── CONTENT ──────────────────────────────────────────────────
local Con=new("Frame",{Size=UDim2.new(1,0,1,-(34+26+1)),Position=UDim2.new(0,0,0,34+26+1),
    BackgroundTransparency=1,ClipsDescendants=true},Main)

local function panel(vis)
    local p=new("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=vis},Con)
    pad(p,7,7,7,7); vl(p,5); return p
end

-- ╔══════════════════════════════════════════════════════════╗
-- ║  PANEL 1 — STRUCTURE                                     ║
-- ╚══════════════════════════════════════════════════════════╝
local P1 = panel(true)
slbl("Structure Scanner", P1, 1)

local _,SS,OS = output(P1, 175, 2)
OS.Text = "Press [Clip] to scan the game tree."

local R1S = row(P1,28,3)
local BClip  = btn("Clip",  C.CLIP,  R1S, UDim2.new(0.34,0,1,0), 1)
local BCopy  = btn("Copy",  C.COPY,  R1S, UDim2.new(0.33,-3,1,0), 2)
local BReset = btn("Reset", C.RESET, R1S, UDim2.new(0.33,-3,1,0), 3)

local AntiB  = btn("  Anti-Cheat Remover: OFF", C.AC0, P1, UDim2.new(1,0,0,30), 4)

local NodeLbl = new("TextLabel",{Text="",Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.DIM,
    BackgroundTransparency=1,Size=UDim2.new(1,0,0,13),LayoutOrder=5,
    TextXAlignment=Enum.TextXAlignment.Left},P1)
local ACLbl   = new("TextLabel",{Text="",Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.DIM,
    BackgroundTransparency=1,Size=UDim2.new(1,0,0,13),LayoutOrder=6,
    TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true},P1)

-- ╔══════════════════════════════════════════════════════════╗
-- ║  PANEL 2 — ITEMS  (items + scripts in same output)       ║
-- ╚══════════════════════════════════════════════════════════╝
local P2 = panel(false)
slbl("Item & Script Scanner", P2, 1)

local _,SI,OI = output(P2, 148, 2)
OI.Text = "Press [Item Clip] or [Clip Scripts] to scan."

-- row: Item Clip | Copy | Reset
local R1I = row(P2,28,3)
local BIC   = btn("Item Clip",    C.ITEM,  R1I, UDim2.new(0.44,0,1,0), 1)
local BICp  = btn("Copy",         C.COPY,  R1I, UDim2.new(0.28,-3,1,0), 2)
local BIRs  = btn("Reset",        C.RESET, R1I, UDim2.new(0.28,-3,1,0), 3)

-- Clip Scripts (full width)
local BSC = btn("  Clip Scripts  (Script · LocalScript · ModuleScript)", C.SCR, P2, UDim2.new(1,0,0,30), 4)

-- item badges
local IB1=row(P2,19,5); local IB2=row(P2,19,6)
local BgTools   = badge("Tools: 0",   IB1)
local BgProduce = badge("Produce: 0", IB1)
local BgAcc     = badge("Acc: 0",     IB2)
local BgOther   = badge("Other: 0",   IB2)

-- script badges
local SB1=row(P2,19,7); local SB2=row(P2,19,8)
local BgSc = badge("Script: 0",      SB1)
local BgLs = badge("LocalScript: 0", SB1)
local BgMs = badge("Module: 0",      SB2)
local BgTt = badge("Total: 0",       SB2)

local InfoLbl = new("TextLabel",{Text="",Font=Enum.Font.Gotham,TextSize=10,TextColor3=C.DIM,
    BackgroundTransparency=1,Size=UDim2.new(1,0,0,13),LayoutOrder=9,
    TextXAlignment=Enum.TextXAlignment.Left},P2)

-- ── TAB SWITCH ───────────────────────────────────────────────
local PANELS = {P1, P2}
local TCOLS  = {C.CLIP, C.ITEM}
local curTab = 1

local function switchTab(i)
    curTab=i
    for j=1,2 do
        PANELS[j].Visible       = (j==i)
        TB[j].TextColor3        = j==i and C.TEXT or C.DIM
        TB[j].BackgroundColor3  = j==i and C.BTN  or C.PANEL
        TB[j].Font              = j==i and Enum.Font.GothamBold or Enum.Font.GothamSemibold
    end
    TweenService:Create(Ind,TweenInfo.new(0.16),{
        Position=UDim2.new((i-1)*0.5,0,1,-2),BackgroundColor3=TCOLS[i]}):Play()
end
for i=1,2 do local ix=i; TB[i].MouseButton1Click:Connect(function() switchTab(ix) end) end
switchTab(1)

-- ── STRUCTURE LOGIC ──────────────────────────────────────────
local lastS=""

local function buildTree(inst,depth,lines,cnt)
    if cnt[1]>=2500 then return end
    cnt[1]=cnt[1]+1
    local a,cn=pcall(function() return inst.ClassName end)
    local b,nm=pcall(function() return inst.Name end)
    if not a or not b then return end
    table.insert(lines,string.rep("  ",math.min(depth,10)).."["..cn.."]  "..nm)
    if depth>=8 then return end
    local c,kids=pcall(function() return inst:GetChildren() end)
    if c then for _,k in ipairs(kids) do buildTree(k,depth+1,lines,cnt) end end
end

BClip.MouseButton1Click:Connect(function()
    OS.Text="Scanning…";NodeLbl.Text=""; task.wait(0.05)
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
            else table.insert(L,">> "..n.."  [Not Found]\n") end
        end
        if cnt[1]>=2500 then table.insert(L,"\n[Capped at 2500 nodes]") end
        lastS=table.concat(L,"\n"); OS.Text=lastS; NodeLbl.Text=cnt[1].." nodes scanned"
    end)
    if not ok then OS.Text="Error:\n"..tostring(er) end
end)

BCopy.MouseButton1Click:Connect(function()
    if lastS=="" then OS.Text="Run Clip first."; return end
    local ok=clip(lastS); local prev=OS.Text
    OS.Text=ok and ("Copied "..#lastS.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OS and OS.Parent then OS.Text=prev end end)
end)

BReset.MouseButton1Click:Connect(function()
    lastS=""; OS.Text="Press [Clip] to scan the game tree."
    NodeLbl.Text=""; SS.CanvasPosition=Vector2.zero
end)

-- ── ANTI-CHEAT ───────────────────────────────────────────────
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
        local ok=pcall(function() if inst:IsA("BaseScript") then inst.Disabled=true end; inst:Destroy() end)
        if ok then k=k+1; acKilled=acKilled+1 end
    end
    if k>0 then ACLbl.Text=string.format("Removed %d this pass | session: %d",k,acKilled) end
end

local function setAC(on)
    acOn=on
    if on then
        AntiB.Text="  Anti-Cheat Remover: ON"; AntiB.BackgroundColor3=C.AC1
        ACLbl.Text="Running — scanning every 2s…"
        task.spawn(runAC)
        task.spawn(function() while acOn do task.wait(2); if acOn then runAC() end end end)
    else
        AntiB.Text="  Anti-Cheat Remover: OFF"; AntiB.BackgroundColor3=C.AC0
        ACLbl.Text=string.format("Stopped. Total removed: %d",acKilled)
    end
end
AntiB.MouseButton1Click:Connect(function() setAC(not acOn) end)
Gui.AncestryChanged:Connect(function() if not Gui.Parent then acOn=false end end)

-- ── ITEM LOGIC ───────────────────────────────────────────────
local lastI=""

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
        local a,cn=pcall(function() return c.ClassName end)
        local b,nm=pcall(function() return c.Name end)
        if a and b then
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
                 or cn:find("Sound") or cn:find("Weld") or cn:find("Motor") or cn:find("Constraint")) then
                deepItems(c,res,seen,d+1)
            end
        end
    end
end

local function resetIBadges()
    BgTools.Text="Tools: 0"; BgProduce.Text="Produce: 0"
    BgAcc.Text="Acc: 0"; BgOther.Text="Other: 0"
end
local function resetSBadges()
    BgSc.Text="Script: 0"; BgLs.Text="LocalScript: 0"
    BgMs.Text="Module: 0"; BgTt.Text="Total: 0"
end

BIC.MouseButton1Click:Connect(function()
    OI.Text="Scanning items…"; InfoLbl.Text=""
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
        else table.insert(L,string.format("-- Total: %d (Tools:%d Produce:%d Acc:%d Other:%d)",
            #res,tC,pC,aC,oC)) end
        lastI=table.concat(L,"\n"); OI.Text=lastI; InfoLbl.Text=#res.." items found"
        BgTools.Text="Tools: "..tC; BgProduce.Text="Produce: "..pC
        BgAcc.Text="Acc: "..aC;     BgOther.Text="Other: "..oC
    end)
    if not ok then OI.Text="Item error:\n"..tostring(er) end
end)

BICp.MouseButton1Click:Connect(function()
    if lastI=="" then OI.Text="Run Item Clip first."; return end
    local ok=clip(lastI); local prev=OI.Text
    OI.Text=ok and ("Copied "..#lastI.." chars!") or "setclipboard unavailable."
    task.delay(2.5,function() if OI and OI.Parent then OI.Text=prev end end)
end)

BIRs.MouseButton1Click:Connect(function()
    lastI=""; OI.Text="Press [Item Clip] or [Clip Scripts] to scan."
    resetIBadges(); resetSBadges(); InfoLbl.Text=""; SI.CanvasPosition=Vector2.zero
end)

-- ── SCRIPT LOGIC ─────────────────────────────────────────────
local lastSC=""

local function deepScripts(root,res,seen,d)
    if d>12 then return end
    local ok,kids=pcall(function() return root:GetChildren() end)
    if not ok then return end
    for _,c in ipairs(kids) do
        local a,cn=pcall(function() return c.ClassName end)
        local b,nm=pcall(function() return c.Name end)
        if a and b then
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
    OI.Text="Scanning scripts…"; InfoLbl.Text=""
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
        else table.insert(L,string.format("-- Total: %d (Script:%d LocalScript:%d Module:%d)",
            tot,scC,lsC,msC)) end
        lastSC=table.concat(L,"\n"); OI.Text=lastSC; InfoLbl.Text=tot.." scripts found"
        BgSc.Text="Script: "..scC; BgLs.Text="LocalScript: "..lsC
        BgMs.Text="Module: "..msC; BgTt.Text="Total: "..tot
    end)
    if not ok then OI.Text="Script error:\n"..tostring(er) end
end)

-- ── OPEN ANIMATION ───────────────────────────────────────────
Main.BackgroundTransparency=1
Main.Position=UDim2.new(0.5,-W/2,0.5,-H/2+12)
TweenService:Create(Main,TweenInfo.new(0.2,Enum.EasingStyle.Quint),{
    BackgroundTransparency=0,Position=UDim2.new(0.5,-W/2,0.5,-H/2)}):Play()

print("[ExploitMenu v6] Loaded — Structure | Items")
