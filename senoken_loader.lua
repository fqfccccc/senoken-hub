-- SENOKEN HUB — Key Loader + Banana Hub launcher
-- Only accepted key: SENOKEN-872529
-- Get Key URL: https://link-target.net/962265/cpZeUpgKCxnk

local KEY_URL = "https://link-target.net/962265/cpZeUpgKCxnk"
local VALID_KEY = "SENOKEN-872529"
-- URL of the patched Banana Hub file (green UI version) — fill after upload:
local BANANA_HUB_URL = "https://raw.githubusercontent.com/fqfccccc/senoken-hub/main/BananaHub_Blox_Fruits.lua"

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local C = {
	bg=Color3.fromRGB(6,16,12), panel=Color3.fromRGB(10,28,20), item=Color3.fromRGB(16,44,32),
	accent=Color3.fromRGB(30,190,100), accent2=Color3.fromRGB(120,255,175),
	text=Color3.fromRGB(232,255,242), sub=Color3.fromRGB(130,180,155),
	bad=Color3.fromRGB(255,90,100), good=Color3.fromRGB(110,255,160),
}
local function new(cls,p,par) local o=Instance.new(cls); for k,v in pairs(p or {}) do o[k]=v end; if par then o.Parent=par end; return o end
local function corner(o,r) return new("UICorner",{CornerRadius=UDim.new(0,r or 8)},o) end
local function stroke(o,c,t) return new("UIStroke",{Color=c or C.accent,Thickness=t or 1.5,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},o) end
local function guiParent()
	local ok,h=pcall(function() return gethui and gethui() end); if ok and h then return h end
	local ok2=pcall(function() return game:GetService("CoreGui").Name end); if ok2 then return game:GetService("CoreGui") end
	return LP:WaitForChild("PlayerGui")
end
local function makeDraggable(handle,target)
	local dragging,dragStart,startPos
	handle.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragging=true; dragStart=i.Position; startPos=target.Position
			i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			local d=i.Position-dragStart
			target.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
		end
	end)
end

local ROOT = new("ScreenGui",{Name="SenokenKey",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},guiParent())

local Gate=new("Frame",{Size=UDim2.new(0,380,0,260),Position=UDim2.new(0.5,-190,0.5,-130),BackgroundColor3=C.bg,BorderSizePixel=0,Active=true},ROOT)
corner(Gate,14); stroke(Gate,C.accent,2)

local GTop=new("Frame",{Size=UDim2.new(1,0,0,46),BackgroundColor3=C.panel,BorderSizePixel=0},Gate); corner(GTop,14)
new("Frame",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,1,-14),BackgroundColor3=C.panel,BorderSizePixel=0},GTop)
new("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(20,88,56),Color3.fromRGB(10,28,20))},GTop)
new("TextLabel",{Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,16,0,0),BackgroundTransparency=1,Text="SENOKEN HUB  |  Key System",Font=Enum.Font.GothamBold,TextSize=18,TextColor3=C.text,TextXAlignment=Enum.TextXAlignment.Left},GTop)
makeDraggable(GTop,Gate)

new("TextLabel",{Size=UDim2.new(1,-40,0,20),Position=UDim2.new(0,20,0,56),BackgroundTransparency=1,Text="Get your key, then paste it below",Font=Enum.Font.Gotham,TextSize=13,TextColor3=C.sub,TextXAlignment=Enum.TextXAlignment.Left},Gate)

local Input=new("TextBox",{Size=UDim2.new(1,-40,0,38),Position=UDim2.new(0,20,0,84),BackgroundColor3=C.item,PlaceholderText="Enter key...",PlaceholderColor3=C.sub,Text="",ClearTextOnFocus=false,Font=Enum.Font.Gotham,TextSize=15,TextColor3=C.text},Gate)
corner(Input,8); stroke(Input,C.accent,1)

local Msg=new("TextLabel",{Size=UDim2.new(1,-40,0,18),Position=UDim2.new(0,20,0,128),BackgroundTransparency=1,Text="",Font=Enum.Font.Gotham,TextSize=13,TextColor3=C.bad,TextXAlignment=Enum.TextXAlignment.Left},Gate)

local function gateBtn(text,x,w,color)
	local b=new("TextButton",{Size=UDim2.new(0,w,0,38),Position=UDim2.new(0,x,0,156),BackgroundColor3=color,Text=text,Font=Enum.Font.GothamBold,TextSize=14,TextColor3=C.text},Gate); corner(b,8); return b
end
local CheckBtn=gateBtn("Check Key",20,168,C.accent)
local GetBtn=gateBtn("Get Key",192,168,C.item)

new("TextLabel",{Size=UDim2.new(1,-40,0,20),Position=UDim2.new(0,20,0,204),BackgroundTransparency=1,Text="drag the top bar to move",Font=Enum.Font.Gotham,TextSize=11,TextColor3=C.sub,TextXAlignment=Enum.TextXAlignment.Left},Gate)

GetBtn.MouseButton1Click:Connect(function()
	Msg.TextColor3=C.good; Msg.Text="Opening key page..."
	pcall(setclipboard, KEY_URL)
	local ok = pcall(function() return game:GetService("GuiService"):OpenBrowserWindow(KEY_URL) end)
	if not ok then Msg.Text="Link copied: "..KEY_URL end
end)

local accepted=false
local function tryKey()
	if accepted then return end
	local k=string.upper((Input.Text:gsub("%s","")))
	if k==VALID_KEY then
		accepted=true
		Msg.TextColor3=C.good; Msg.Text="Key accepted — loading SENOKEN HUB..."
		task.wait(0.4)
		Gate:Destroy()
		pcall(function()
			if game:GetService("StarterGui") then
				game:GetService("StarterGui"):SetCore("SendNotification",{Title="SENOKEN HUB",Text="Key accepted. Loading...",Duration=3})
			end
		end)
		local ok, err = pcall(function()
    local src = game:HttpGet(BANANA_HUB_URL)
    local fn = loadstring(src)
    if not fn then error("loadstring returned nil — syntax error in BananaHub file") end
    fn()
end)
if not ok then
    -- loud, impossible-to-miss error
    Msg.TextColor3 = C.bad
    Msg.Text = "Load failed: "..tostring(err):sub(1,80)
    error("[SENOKEN HUB] Load failed: "..tostring(err))
end
	else
		Msg.TextColor3=C.bad; Msg.Text="Invalid key"
	end
end
CheckBtn.MouseButton1Click:Connect(tryKey)
Input.FocusLost:Connect(function(enter) if enter then tryKey() end end)
