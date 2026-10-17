-- SENOKEN HUB UI — drop-in replacement for Banana Hub's ui.luau
local Players  = game:GetService("Players")
local UIS      = game:GetService("UserInputService")
local TweenSvc = game:GetService("TweenService")
local LP       = Players.LocalPlayer

local C = {
	bg = Color3.fromRGB(6,16,12), panel = Color3.fromRGB(10,28,20),
	item = Color3.fromRGB(16,44,32), accent = Color3.fromRGB(30,190,100),
	accent2 = Color3.fromRGB(120,255,175), text = Color3.fromRGB(232,255,242),
	sub = Color3.fromRGB(130,180,155), bad = Color3.fromRGB(255,90,100),
	good = Color3.fromRGB(110,255,160),
}
local function new(cls,p,par) local o=Instance.new(cls);local o=Instance.new(cls); for k,v in pairs(p or {}) do o[k]=v end; if par then o.Parent=par end; return o end
local function corner(o,r) return new("UICorner",{CornerRadius=UDim.new(0,r or 8)},o) end
local function stroke(o,c,t) return new("UIStroke",{Color=c or C.accent,Thickness=t or 1.5,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},o) end
local function guiParent()
	local ok,h = pcall(function() return gethui and gethui() end); if ok and h then return h end
	local ok2 = pcall(function() return game:GetService("CoreGui").Name end)
	if ok2 then return game:GetService("CoreGui") end
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
local ROOT = new("ScreenGui",{Name="SenokenHub",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},guiParent())
local Lib={}
function Lib.ToggleUI() end
function Lib:Notify(cfg) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title=cfg.Title or "SENOKEN HUB",Text=cfg.Description or cfg.Text or "",Duration=cfg.Duration or 4}) end) end
local function noop() end

local function makeGroupbox(page,title,order)
	local box=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=C.bg,BackgroundTransparency=0.2,BorderSizePixel=0,LayoutOrder=order},page)
	corner(box,8); stroke(box,C.item,1)
	new("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},box)
	new("UIPadding",{PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},box)
	new("TextLabel",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Text=title,Font=Enum.Font.GothamBold,TextSize=14,TextColor3=C.accent2,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=0},box)
	local n=0; local function nextOrder() n=n+1 return n end
	local G={}

	function G:AddLabel(text)
		local l=new("TextLabel",{Size=UDim2.new(1,0,0,20),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=tostring(text or ""),Font=Enum.Font.Gotham,TextSize=13,TextColor3=C.text,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=nextOrder()},box)
		local o={}; function o:SetText(t) l.Text=tostring(t) end; return o
	end

	function G:AddToggle(id,opts)
		if type(id)=="table" then opts=id end; opts=opts or {}
		local cb=opts.Callback or noop; local state=opts.Default and true or false
		local row=new("TextButton",{Size=UDim2.new(1,0,0,38),BackgroundColor3=C.item,Text="",AutoButtonColor=false,LayoutOrder=nextOrder()},box)
		corner(row,8)
		new("TextLabel",{Size=UDim2.new(1,-64,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=tostring(opts.Text or id),Font=Enum.Font.Gotham,TextSize=13,TextColor3=C.text,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left},row)
		local pill=new("Frame",{Size=UDim2.new(0,40,0,20),Position=UDim2.new(1,-52,0.5,-10),BackgroundColor3=C.bg},row); corner(pill,10)
		local dot=new("Frame",{Size=UDim2.new(0,16,0,16),Position=UDim2.new(0,2,0.5,-8),BackgroundColor3=C.sub},pill); corner(dot,8)
		local o={Value=state}
		local function render()
			TweenSvc:Create(dot,TweenInfo.new(0.12),{Position=state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8),BackgroundColor3=state and C.accent2 or C.sub}):Play()
			pill.BackgroundColor3=state and C.accent or C.bg
		end
		function o:SetValue(v) state=v and true or false; o.Value=state; render(); task.spawn(cb,state) end
		render()
		row.MouseButton1Click:Connect(function() o:SetValue(not state) end)
		if state then task.spawn(cb,state) end
		return o
	end

	function G:AddButton(opts,fn)
		if type(opts)=="string" then opts={Text=opts,Func=fn} end; opts=opts or {}
		local cb=opts.Func or opts.Callback or noop
		local b=new("TextButton",{Size=UDim2.new(1,0,0,34),BackgroundColor3=C.accent,Text=tostring(opts.Text or "Button"),Font=Enum.Font.GothamSemibold,TextSize=13,TextColor3=C.text,TextWrapped=true,LayoutOrder=nextOrder()},box)
		corner(b,8); b.MouseButton1Click:Connect(function() task.spawn(cb) end); return b
	end
for k,v in pairs(p or {}) do o[k]=v end; if par then o.Parent=par end; return o end
local function corner(o,r) return new("UICorner",{CornerRadius=UDim.new(0,r or 8)},o) end
local function stroke(o,c,t) return new("UIStroke",{Color=c or C.accent,Thickness=t or 1.5,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},o) end
local function guiParent()
	local ok,h = pcall(function() return gethui and gethui() end); if ok and h then return h end
	local ok2 = pcall(function() return game:GetService("CoreGui").Name end)
	if ok2 then return game:GetService("CoreGui") end
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
local ROOT = new("ScreenGui",{Name="SenokenHub",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},guiParent())
local Lib={}
function Lib.ToggleUI() end
function Lib:Notify(cfg) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title=cfg.Title or "SENOKEN HUB",Text=cfg.Description or cfg.Text or "",Duration=cfg.Duration or 4}) end) end
local function noop() end

local function makeGroupbox(page,title,order)
	local box=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=C.bg,BackgroundTransparency=0.2,BorderSizePixel=0,LayoutOrder=order},page)
	corner(box,8); stroke(box,C.item,1)
	new("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},box)
	new("UIPadding",{PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},box)
	new("TextLabel",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Text=title,Font=Enum.Font.GothamBold,TextSize=14,TextColor3=C.accent2,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=0},box)
	local n=0; local function nextOrder() n=n+1 return n end
	local G={}

	function G:AddLabel(text)
		local l=new("TextLabel",{Size=UDim2.new(1,0,0,20),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=tostring(text or ""),Font=Enum.Font.Gotham,TextSize=13,TextColor3=C.text,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=nextOrder()},box)
		local o={}; function o:SetText(t) l.Text=tostring(t) end; return o
	end

	function G:AddToggle(id,opts)
		if type(id)=="table" then opts=id end; opts=opts or {}
		local cb=opts.Callback or noop; local state=opts.Default and true or false
		local row=new("TextButton",{Size=UDim2.new(1,0,0,38),BackgroundColor3=C.item,Text="",AutoButtonColor=false,LayoutOrder=nextOrder()},box)
		corner(row,8)
		new("TextLabel",{Size=UDim2.new(1,-64,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=tostring(opts.Text or id),Font=Enum.Font.Gotham,TextSize=13,TextColor3=C.text,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left},row)
		local pill=new("Frame",{Size=UDim2.new(0,40,0,20),Position=UDim2.new(1,-52,0.5,-10),BackgroundColor3=C.bg},row); corner(pill,10)
		local dot=new("Frame",{Size=UDim2.new(0,16,0,16),Position=UDim2.new(0,2,0.5,-8),BackgroundColor3=C.sub},pill); corner(dot,8)
		local o={Value=state}
		local function render()
			TweenSvc:Create(dot,TweenInfo.new(0.12),{Position=state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8),BackgroundColor3=state and C.accent2 or C.sub}):Play()
			pill.BackgroundColor3=state and C.accent or C.bg
		end
		function o:SetValue(v) state=v and true or false; o.Value=state; render(); task.spawn(cb,state) end
		render()
		row.MouseButton1Click:Connect(function() o:SetValue(not state) end)
		if state then task.spawn(cb,state) end
		return o
	end

	function G:AddButton(opts,fn)
		if type(opts)=="string" then opts={Text=opts,Func=fn} end; opts=opts or {}
		local cb=opts.Func or opts.Callback or noop
		local b=new("TextButton",{Size=UDim2.new(1,0,0,34),BackgroundColor3=C.accent,Text=tostring(opts.Text or "Button"),Font=Enum.Font.GothamSemibold,TextSize=13,TextColor3=C.text,TextWrapped=true,LayoutOrder=nextOrder()},box)
		corner(b,8); b.MouseButton1Click:Connect(function() task.spawn(cb) end); return b
	end

	function G:AddDropdown(id,opts)
		if type(id)=="table" then opts=id end; opts=opts or {}
		local cb=opts.Callback or noop; local values=opts.Values or {}; local multi=opts.Multi and true or false
		local holder=new("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=nextOrder()},box)
		new("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},holder)
		local row=new("TextButton",{Size=UDim2.new(1,0,0,38),BackgroundColor3=C.item,Text="",AutoButtonColor=false,LayoutOrder=1},holder)
		corner(row,8)
		new("TextLabel",{Size=UDim2.new(0.5,-8,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=tostring(opts.Text or id),Font=Enum.Font.Gotham,TextSize=13,TextColor3=C.text,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left},row)
		local valLbl=new("TextLabel",{Size=UDim2.new(0.5,-12,1,0),Position=UDim2.new(0.5,0,0,0),BackgroundTransparency=1,Text="-  v",Font=Enum.Font.GothamSemibold,TextSize=13,TextColor3=C.accent2,TextXAlignment=Enum.TextXAlignment.Right,TextTruncate=Enum.TextTruncate.AtEnd},row)
		local list=new("ScrollingFrame",{Size=UDim2.new(1,0,0,math.min(#values*30+8,170)),BackgroundColor3=C.panel,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=C.accent,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,LayoutOrder=2},holder)
		corner(list,8)
		new("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},list)
		new("UIPadding",{PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,6)},list)
		local selected,picked,buttons=nil,{},{}
		local o={}
		local function refresh()
			if multi then local c=0 for _ in pairs(picked) do c=c+1 end valLbl.Text=c.." selected  v"
			else valLbl.Text=(selected~=nil and tostring(selected) or "-").."  v" end
		end
		local function paint()
			for _,e in ipairs(buttons) do
				local on=multi and picked[tostring(e.value)] or (not multi and e.value==selected)
				e.btn.BackgroundColor3=on and C.accent or C.item; e.btn.TextColor3=on and C.text or C.sub
			end
		end
		for i,v in ipairs(values) do
			local btn=new("TextButton",{Size=UDim2.new(1,0,0,28),BackgroundColor3=C.item,Text=tostring(v),Font=Enum.Font.Gotham,TextSize=13,TextColor3=C.sub,AutoButtonColor=false,LayoutOrder=i},list)
			corner(btn,6); buttons[#buttons+1]={btn=btn,value=v}
			btn.MouseButton1Click:Connect(function()
				if multi then local k=tostring(v); if picked[k] then picked[k]=nil else picked[k]=true end; paint(); refresh(); task.spawn(cb,k,picked[k] and true or false)
				else selected=v; paint(); refresh(); list.Visible=false; task.spawn(cb,v) end
			end)
		end
		row.MouseButton1Click:Connect(function() list.Visible=not list.Visible end)
		function o:SetValue(v)
			if multi then picked={} if type(v)=="table" then for k,on in pairs(v) do if on then picked[tostring(k)]=true end end end; paint(); refresh(); task.spawn(cb,picked)
			else selected=v; paint(); refresh(); task.spawn(cb,v) end
		end
		local d=opts.Default
		if multi then
			if type(d)=="table" then for k,on in pairs(d) do if on then picked[tostring(k)]=true end end paint(); refresh(); task.spawn(cb,picked) else refresh() end
		else
			if type(d)=="number" then d=values[d] end
			if d~=nil then selected=d; paint(); refresh(); task.spawn(cb,d) else refresh() end
		end
		return o
	end

	function G:AddSlider(id,opts)
		if type(id)=="table" then opts=id end; opts=opts or {}
		local cb=opts.Callback or noop; local min,max=opts.Min or 0,opts.Max or 100
		local rounding=opts.Rounding or 0; local value=opts.Default or min
		local row=new("Frame",{Size=UDim2.new(1,0,0,52),BackgroundColor3=C.item,LayoutOrder=nextOrder()},box); corner(row,8)
		new("TextLabel",{Size=UDim2.new(1,-80,0,22),Position=UDim2.new(0,12,0,4),BackgroundTransparency=1,Text=tostring(opts.Text or id),Font=Enum.Font.Gotham,TextSize=13,TextColor3=C.text,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd},row)
		local vl=new("TextLabel",{Size=UDim2.new(0,64,0,22),Position=UDim2.new(1,-76,0,4),BackgroundTransparency=1,Text="",Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.accent2,TextXAlignment=Enum.TextXAlignment.Right},row)
		local hit=new("Frame",{Size=UDim2.new(1,-24,0,20),Position=UDim2.new(0,12,0,28),BackgroundTransparency=1,Active=true},row)
		local bar=new("Frame",{Size=UDim2.new(1,0,0,8),Position=UDim2.new(0,0,0.5,-4),BackgroundColor3=C.bg,BorderSizePixel=0},hit); corner(bar,4)
		local fill=new("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=C.accent,BorderSizePixel=0},bar); corner(fill,4)
		local knob=new("Frame",{Size=UDim2.new(0,14,0,14),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=C.accent2,BorderSizePixel=0},fill); corner(knob,7)
		local function setV(v,fire)
			v=math.clamp(v,min,max); local m=10^rounding; v=math.floor(v*m+0.5)/m; value=v
			local a=(max>min) and (v-min)/(max-min) or 0
			fill.Size=UDim2.new(a,0,1,0); vl.Text=tostring(v)
			if fire then task.spawn(cb,v) end
		end
		local function fromX(x) local a=math.clamp((x-bar.AbsolutePosition.X)/math.max(bar.AbsoluteSize.X,1),0,1); setV(min+(max-min)*a,true) end
		local dragging=false
		hit.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; fromX(i.Position.X) end end)
		UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then fromX(i.Position.X) end end)
		UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
		setV(value,false); task.spawn(cb,value)
		local o={}; function o:SetValue(v) setV(v,true) end; return o
	end

	function G:AddInput(id,opts)
		if type(id)=="table" then opts=id end; opts=opts or {}
		local cb=opts.Callback or noop
		local row=new("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=C.item,LayoutOrder=nextOrder()},box); corner(row,8)
		new("TextLabel",{Size=UDim2.new(0.4,-8,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=tostring(opts.Text or id),Font=Enum.Font.Gotham,TextSize=13,TextColor3=C.text,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left},row)
		local tb=new("TextBox",{Size=UDim2.new(0.6,-18,0,26),Position=UDim2.new(0.4,0,0.5,-13),BackgroundColor3=C.bg,Text=tostring(opts.Default or ""),PlaceholderText=tostring(opts.Placeholder or ""),PlaceholderColor3=C.sub,ClearTextOnFocus=false,Font=Enum.Font.Gotham,TextSize=13,TextColor3=C.text,TextTruncate=Enum.TextTruncate.AtEnd},row)
		corner(tb,6); stroke(tb,C.accent,1)
		tb.FocusLost:Connect(function() task.spawn(cb,tb.Text) end)
		if tb.Text~="" then task.spawn(cb,tb.Text) end
		local o={}; function o:SetValue(v) tb.Text=tostring(v); task.spawn(cb,tb.Text) end; return o
	end

	G.AddRightGroupbox=nil
	return G
end

function Lib:CreateWindow(cfg)
	cfg=cfg or {}
	local Main=new("Frame",{Name="Main",Size=UDim2.new(0,620,0,390),Position=UDim2.new(0.5,-310,0.5,-195),BackgroundColor3=C.bg,BorderSizePixel=0,Active=true},ROOT)
	corner(Main,12); stroke(Main,C.accent,2)
	local Top=new("Frame",{Size=UDim2.new(1,0,0,42),BackgroundColor3=C.panel,BorderSizePixel=0},Main); corner(Top,12)
	new("Frame",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,1,-12),BackgroundColor3=C.panel,BorderSizePixel=0},Top)
	new("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(18,78,50),Color3.fromRGB(10,28,20))},Top)
	new("TextLabel",{Size=UDim2.new(1,-110,1,0),Position=UDim2.new(0,14,0,0),BackgroundTransparency=1,Text="SENOKEN HUB  |  Blox Fruits",Font=Enum.Font.GothamBold,TextSize=17,TextColor3=C.text,TextXAlignment=Enum.TextXAlignment.Left},Top)
	local function topButton(text,xOff,color)
		local b=new("TextButton",{Size=UDim2.new(0,30,0,26),Position=UDim2.new(1,xOff,0.5,-13),BackgroundColor3=color,Text=text,Font=Enum.Font.GothamBold,TextSize=16,TextColor3=C.text,AutoButtonColor=true},Top); corner(b,6); return b
	end
	local MinBtn=topButton("-",-74,C.item); local CloseBtn=topButton("X",-38,C.bad)
	makeDraggable(Top,Main)
	local Body=new("Frame",{Size=UDim2.new(1,0,1,-42),Position=UDim2.new(0,0,0,42),BackgroundTransparency=1},Main)
	local TabList=new("ScrollingFrame",{Size=UDim2.new(0,150,1,-12),Position=UDim2.new(0,8,0,6),BackgroundColor3=C.panel,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y},Body); corner(TabList,10)
	new("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},TabList)
	new("UIPadding",{PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,6),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)},TabList)
	local Pages=new("Frame",{Size=UDim2.new(1,-174,1,-12),Position=UDim2.new(0,166,0,6),BackgroundTransparency=1},Body)
	local Float=new("TextButton",{Size=UDim2.new(0,46,0,46),Position=UDim2.new(0,14,0.5,-23),BackgroundColor3=C.accent,Text="S",Font=Enum.Font.GothamBold,TextSize=24,TextColor3=C.text,Visible=false,Active=true},ROOT); corner(Float,23); stroke(Float,C.accent2,2)
	local function setVisible(v) Main.Visible=v; Float.Visible=not v end
	MinBtn.MouseButton1Click:Connect(function() setVisible(false) end)
	do
		local downPos
		Float.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then downPos=i.Position end end)
		Float.InputEnded:Connect(function(i) if downPos and (i.Position-downPos).Magnitude<6 then setVisible(true) end downPos=nil end)
		makeDraggable(Float,Float)
	end
	CloseBtn.MouseButton1Click:Connect(function() ROOT:Destroy(); if getgenv then getgenv().SenokenHubLoaded=nil end end)
	local Window,Tabs={},{}
	local function selectTab(t)
		for _,tab in pairs(Tabs) do
			local on=tab==t; tab.page.Visible=on
			tab.btn.BackgroundColor3=on and C.accent or C.item
			tab.btn.TextColor3=on and C.text or C.sub
		end
	end
	function Window:AddTab(name)
		local btn=new("TextButton",{Size=UDim2.new(1,0,0,32),BackgroundColor3=C.item,Text=tostring(name),Font=Enum.Font.GothamSemibold,TextSize=13,TextColor3=C.sub,AutoButtonColor=false,LayoutOrder=#Tabs+1,TextTruncate=Enum.TextTruncate.AtEnd},TabList); corner(btn,8)
		local page=new("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=C.panel,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=C.accent,CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},Pages); corner(page,10)
		new("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},page)
		new("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,10)},page)
		local tab={btn=btn,page=page}; Tabs[#Tabs+1]=tab
		btn.MouseButton1Click:Connect(function() selectTab(tab) end)
		if #Tabs==1 then selectTab(tab) end
		local T,order={},0
		function T:AddLeftGroupbox(title) order=order+1; return makeGroupbox(page,tostring(title),order) end
		T.AddRightGroupbox=T.AddLeftGroupbox
		return T
	end
	return Window
end

return Lib
