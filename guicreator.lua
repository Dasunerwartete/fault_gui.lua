-- FaultReportInterface.lua (for GitHub)

-- Accept player as parameter
local player = ...
local playerGui = player:WaitForChild("PlayerGui")

-- Safety check
if not player or not player:IsA("Player") then
    warn("[FaultReportInterface] Invalid player passed!")
    return
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FaultReportInterface"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 25
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame1 = Instance.new("Frame")
Frame1.Name = "FaultBackdrop"
Frame1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame1.Size = UDim2.new(1, 0, 1, 0)
Frame1.Parent = ScreenGui

local Frame2 = Instance.new("Frame")
Frame2.Name = "CoreContentArea"
Frame2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Frame2.Position = UDim2.new(0.047, 0, 0.063, 0)
Frame2.Size = UDim2.new(0.905, 0, 0.872, 0)
Frame2.Parent = Frame1

local TextLabel1 = Instance.new("TextLabel")
TextLabel1.Name = "DiagnostricsFooter"
TextLabel1.BackgroundTransparency = 1
TextLabel1.Size = UDim2.new(0.473, 0, 0.018, 0)
TextLabel1.Position = UDim2.new(0.263, 0, 0.935, 0)
TextLabel1.Font = Enum.Font.GothamMedium
TextLabel1.RichText = true
TextLabel1.Text = 'If you continue to receive this page, please contact customer service at <b>info@roblox.com</b>.'
TextLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel1.TextScaled = true
TextLabel1.Parent = Frame1

local Image = Instance.new("ImageLabel")
Image.Name = "StatusIcon"
Image.BackgroundTransparency = 1
Image.Position = UDim2.new(0.575, 0, 0.213, 0)
Image.Size = UDim2.new(0.403, 0, 0.573, 0)
Image.Image = "rbxassetid://1069610351"
Image.Parent = Frame2

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.Parent = Image

local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Name = "DiagnosticsHeader"
TextLabel2.BackgroundTransparency = 1
TextLabel2.Size = UDim2.new(0.381, 0, 0.074, 0)
TextLabel2.Position = UDim2.new(0.028, 0, 0.053, 0)
TextLabel2.Font = Enum.Font.GothamMedium
TextLabel2.RichText = true
TextLabel2.Text = 'Internal Server Error'
TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel2.TextScaled = true
TextLabel2.Parent = Frame2
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left

local TextLabel3 = Instance.new("TextLabel")
TextLabel3.Name = "DiagnosticsMessage"
TextLabel3.BackgroundTransparency = 1
TextLabel3.Size = UDim2.new(0.406, 0, 0.033, 0)
TextLabel3.Position = UDim2.new(0.028, 0, 0.148, 0)
TextLabel3.Font = Enum.Font.Gotham
TextLabel3.RichText = true
TextLabel3.Text = '500 | An unexpected error occurred'
TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel3.TextScaled = true
TextLabel3.Parent = Frame2
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left

local localScript = Instance.new("LocalScript")
localScript.Name = "DiagnosticsController"
localScript.Parent = ScreenGui
localScript.Source = [[
--[[
	DiagnosticsController.lua
	==================
	This LocalScript ensures that the FaultReportInterface GUI remains fully visible
	at all times in case of a error. It enforces visibility recursively on all descendant
	GuiObjects, handles dynamically added elements, and restores the GUI if it is
	reparented or removed.
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--Local player reference
local LocalPlayer = Players.LocalPlayer
assert(LocalPlayer, "[FaultReportHandler] LocalPlayer not found!")

-- PlayerGui reference
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
assert(PlayerGui, "[FaultReportHandler] PlayerGui not found!")

-- Top-level ScreenGui
local FaultReportInterface = PlayerGui:WaitForChild("FaultReportInterface")
assert(FaultReportInterface:IsA("ScreenGui"), "[FaultReportHandler] FaultReportInterface is not a ScreenGui!")

--[[==========================================================================
	Function: EnforceVisibility
	-----------------------------------
	Recursively enforces Enabled = true for the ScreenGui and Visible = true for
	all GuiObject descendants. Also hooks ChildAdded to ensure dynamically added
	elements remain visible.
===========================================================================]]
local function EnforceVisibility(GuiObject)
	if not GuiObject or not GuiObject:IsA("GuiObject") then return end

	-- Force visibility immediately
	GuiObject.Visible = true

	-- Hook Visible property changes
	GuiObject:GetPropertyChangedSignal("Visible"):Connect(function()
		if GuiObject.Visible == false then
			GuiObject.Visible = true
		end
	end)

	-- Hook destruction for this GuiObject
	GuiObject.Destroying:Connect(function()
		if GuiObject.Parent then
			task.spawn(function()
				local Clone = GuiObject:Clone()
				Clone.Parent = GuiObject.Parent
				EnforceVisibility(Clone)
			end)
		end
	end)

	-- Recurse through children
	for _, Child in ipairs(GuiObject:GetChildren()) do
		EnforceVisibility(Child)
	end

	-- Hook dynamically added children
	GuiObject.ChildAdded:Connect(function(Child)
		EnforceVisibility(Child)
	end)
end

--[[==========================================================================
	Anti-Delete System
	--------------------------
	Monitors the FaultReportInterface for destruction. If destroyed, clones it
	and restores it in PlayerGui.
===========================================================================]]

local function InitializeAntiDeletion(GuiObject)
	print(GuiObject.Name)
	if not GuiObject or not GuiObject:IsA("ScreenGui") then return end

	GuiObject.Destroying:Connect(function()
		warn("[FaultReportHandler] FaultReportInterface is being destroyed! Restoring...")

		local Clone = GuiObject:Clone()
		Clone.Parent = GuiObject.Parent

		EnforceVisibility(Clone)
		
		InitializeAntiDeletion(Clone)
	end)
end

--[[==========================================================================
	Continuous Enforcement Loop
	----------------------------------------
	Ensures the ScreenGui itselfs stays Enabled = true.
===========================================================================]]
task.spawn(function()
	while task.wait() do
		if FaultReportInterface.Enabled ~= true then
			FaultReportInterface.Enabled = true
		end
		
		for _, GuiObject in ipairs(FaultReportInterface:GetDescendants()) do
			EnforceVisibility(GuiObject)
			InitializeAntiDeletion(GuiObject)
		end
	end
end)

--[[==========================================================================
	Ancestry Protection
	--------------------------
	If the ScreenGui is removed or reparented, restore it immediately to PlayerGui.
===========================================================================]]
FaultReportInterface.AncestryChanged:Connect(function(_, Parent)
	if Parent ~= PlayerGui then
		warn("[FaultReportHandler] FaultReportInterface removed or reparented! Restoring...")
		FaultReportInterface.Parent = PlayerGui
	end
end)

InitializeAntiDeletion(FaultReportInterface)

]]
