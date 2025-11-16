-- FaultReportInterface.lua (for GitHub)

-- Accept player as parameter
local player = ...

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
