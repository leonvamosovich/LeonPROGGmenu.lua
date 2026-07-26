-- Инициализация графического интерфейса мода «LeonPROGG» для мобильных устройств
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Параметры
local flightSpeed = 50
local customWalkSpeed = 32
local isFlying = false
local isSpeedEnabled = false
local isMenuVisible = true

local bodyVelocity, bodyGyro

-- Создание главного окна GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LeonPROGG_Menu"
screenGui.ResetOnSpawn = false

pcall(function()
    screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Основная панель (меню)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 200)
mainFrame.Position = UDim2.new(0, 50, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Скругление углов панели
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- Заголовок меню
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleLabel.Text = "LeonPROGG"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- Кнопка сворачивания/открытия меню (плавающая иконка)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleMenu"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 100)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.Text = "LP"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 20)
toggleCorner.Parent = toggleButton

-- Кнопка Fly в меню
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0, 180, 0, 45)
flyButton.Position = UDim2.new(0, 20, 0, 55)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 16
flyButton.Font = Enum.Font.SourceSans
flyButton.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyButton

-- Кнопка Speedhack в меню
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Size = UDim2.new(0, 180, 0, 45)
speedButton.Position = UDim2.new(0, 20, 0, 115)
speedButton.Text = "Speedhack: OFF"
speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 16
speedButton.Font = Enum.Font.SourceSans
speedButton.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedButton

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
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        
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
        flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        
        humanoid.PlatformStand = false
    end
end)

-- Логика включения/выключения спидхака
speedButton.MouseButton1Click:Connect(function()
    isSpeedEnabled = not isSpeedEnabled
    
    if isSpeedEnabled then
        speedButton.Text = "Speedhack: ON"
        speedButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        humanoid.WalkSpeed = customWalkSpeed
    else
        speedButton.Text = "Speedhack: OFF"
        speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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

-- Перезагрузка переменных при респавне персонажа
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    isFlying = false
    isSpeedEnabled = false
    flyButton.Text = "Fly: OFF"
    flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    speedButton.Text = "Speedhack: OFF"
    speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)
