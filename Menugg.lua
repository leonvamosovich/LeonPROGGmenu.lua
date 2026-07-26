-- Аниме стиль (Cyberpunk/Neon Anime Theme) для LeonPROGG
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flightSpeed = 50
local customWalkSpeed = 32
local isFlying = false
local isSpeedEnabled = false
local isMenuVisible = true

local bodyVelocity, bodyGyro

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LeonPROGG_AnimeMenu"
screenGui.ResetOnSpawn = false

pcall(function()
    screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Плавающая кнопка-кружок "LP" (красивая, с градиентом и обводкой)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleMenu"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 30, 0, 150)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
toggleButton.Text = "LP"
toggleButton.TextColor3 = Color3.fromRGB(255, 110, 199)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0) -- Идеальный круг
toggleCorner.Parent = toggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 110, 199)
toggleStroke.Thickness = 2
toggleStroke.Parent = toggleButton

-- Основное аниме-меню
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 220)
mainFrame.Position = UDim2.new(0, 95, 0, 150)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(160, 32, 240)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Заголовок меню
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 45)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
titleLabel.Text = " ✨ LeonPROGG ✨ "
titleLabel.TextColor3 = Color3.fromRGB(255, 150, 220)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Кнопка Fly в аниме стиле
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0, 200, 0, 45)
flyButton.Position = UDim2.new(0, 20, 0, 60)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(35, 22, 60)
flyButton.TextColor3 = Color3.fromRGB(220, 220, 255)
flyButton.TextSize = 15
flyButton.Font = Enum.Font.GothamSemibold
flyButton.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyButton

local flyStroke = Instance.new("UIStroke")
flyStroke.Color = Color3.fromRGB(110, 80, 180)
flyStroke.Thickness = 1
flyStroke.Parent = flyButton

-- Кнопка Speedhack в аниме стиле
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Size = UDim2.new(0, 200, 0, 45)
speedButton.Position = UDim2.new(0, 20, 0, 120)
speedButton.Text = "Speed: OFF"
speedButton.BackgroundColor3 = Color3.fromRGB(35, 22, 60)
speedButton.TextColor3 = Color3.fromRGB(220, 220, 255)
speedButton.TextSize = 15
speedButton.Font = Enum.Font.GothamSemibold
speedButton.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedButton

local speedStroke = Instance.new("UIStroke")
speedStroke.Color = Color3.fromRGB(110, 80, 180)
speedStroke.Thickness = 1
speedStroke.Parent = speedButton

-- Логика сворачивания/разворачивания интерфейса
toggleButton.MouseButton1Click:Connect(function()
    isMenuVisible = not isMenuVisible
    mainFrame.Visible = isMenuVisible
end)

-- Логика включения/выключения полёта
flyButton.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    
    if isFlying then
        flyButton.Text = "Fly: ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(120, 20, 100)
        flyStroke.Color = Color3.fromRGB(255, 100, 200)
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = rootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.CFrame = rootPart.CFrame
        bodyGyro.Parent = rootPart
        
        humanoid.PlatformStand = true
    else
        flyButton.Text = "Fly: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(35, 22, 60)
        flyStroke.Color = Color3.fromRGB(110, 80, 180)
        
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        
        humanoid.PlatformStand = false
    end
end)

-- Логика включения/выключения спидхака
speedButton.MouseButton1Click:Connect(function()
    isSpeedEnabled = not isSpeedEnabled
    
    if isSpeedEnabled then
        speedButton.Text = "Speed: ON"
        speedButton.BackgroundColor3 = Color3.fromRGB(120, 20, 100)
        speedStroke.Color = Color3.fromRGB(255, 100, 200)
        humanoid.WalkSpeed = customWalkSpeed
    else
        speedButton.Text = "Speed: OFF"
        speedButton.BackgroundColor3 = Color3.fromRGB(35, 22, 60)
        speedStroke.Color = Color3.fromRGB(110, 80, 180)
        humanoid.WalkSpeed = 16
    end
end)

-- Обновление физики движения камеры во время полёта
RunService.RenderStepped:Connect(function()
    if isFlying and bodyVelocity and bodyGyro then
        local camera = workspace.CurrentCamera
        bodyGyro.CFrame = camera.CFrame
        bodyVelocity.Velocity = camera.CFrame.LookVector * flightSpeed
    end
end)

-- Сброс при респавне
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    isFlying = false
    isSpeedEnabled = false
    flyButton.Text = "Fly: OFF"
    flyButton.BackgroundColor3 = Color3.fromRGB(35, 22, 60)
    flyStroke.Color = Color3.fromRGB(110, 80, 180)
    speedButton.Text = "Speed: OFF"
    speedButton.BackgroundColor3 = Color3.fromRGB(35, 22, 60)
    speedStroke.Color = Color3.fromRGB(110, 80, 180)
end)
