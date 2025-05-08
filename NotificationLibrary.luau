local NotificationSystem = {}
NotificationSystem.__index = NotificationSystem
NotificationSystem.NotificationSize = UDim2.new(0, 300, 0, 70)
NotificationSystem.Spacing = 5
NotificationSystem.AnimationSpeed = 0.3
NotificationSystem.Font = Enum.Font.GothamSemibold
NotificationSystem.TextSize = 14
NotificationSystem.TextColor = Color3.fromRGB(240, 240, 240)
NotificationSystem.BackgroundColor = Color3.fromRGB(25, 25, 25)
NotificationSystem.AccentColor = Color3.fromRGB(0, 144, 255)

function NotificationSystem.new(parent)
    local self = setmetatable({}, NotificationSystem)
    self.Container = Instance.new("Frame")
    self.Container.Name = "NotificationContainer"
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.Parent = parent
    self.Notifications = {}
    self.NextPosition = 0
    return self
end

function NotificationSystem:CalculatePosition(index)
    return UDim2.new(1, -self.NotificationSize.X.Offset - 10, 1, -((self.NotificationSize.Y.Offset + self.Spacing) * index))
end

function NotificationSystem:UpdatePositions(ignoreIndex)
    for i, notification in ipairs(self.Notifications) do
        if i ~= ignoreIndex then
            local targetPos = self:CalculatePosition(i)
            
            if notification.Position ~= targetPos then
                game:GetService("TweenService"):Create(
                    notification,
                    TweenInfo.new(self.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Position = targetPos}
                ):Play()
            end
        end
    end
end

function NotificationSystem:CreateToast(title, content, duration)
    duration = duration or 3
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.BackgroundColor3 = self.BackgroundColor
    notification.BackgroundTransparency = 0.2
    notification.BorderSizePixel = 0
    notification.Size = self.NotificationSize
    notification.Position = UDim2.new(1, self.NotificationSize.X.Offset + 10, 1, 0)
    notification.Parent = self.Container
    notification.ClipsDescendants = true
    local NewIndex = #self.Notifications + 1
    table.insert(self.Notifications, notification)
    local Accent = Instance.new("Frame")
    Accent.Name = "Accent"
    Accent.BackgroundColor3 = self.AccentColor
    Accent.BorderSizePixel = 0
    Accent.Size = UDim2.new(0, 3, 1, 0)
    Accent.Position = UDim2.new(0, 0, 0, 0)
    Accent.Parent = notification
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Text = title
    TitleLabel.Font = self.Font
    TitleLabel.TextColor3 = self.TextColor
    TitleLabel.TextSize = self.TextSize
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 8)
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Parent = notification
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Name = "Content"
    ContentLabel.Text = content
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextColor3 = self.TextColor
    ContentLabel.TextSize = self.TextSize - 2
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    ContentLabel.TextWrapped = true
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Position = UDim2.new(0, 10, 0, 30)
    ContentLabel.Size = UDim2.new(1, -20, 1, -40)
    ContentLabel.Parent = notification
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.BackgroundColor3 = self.AccentColor
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Size = UDim2.new(1, 0, 0, 2)
    ProgressBar.Position = UDim2.new(0, 0, 1, -2)
    ProgressBar.Parent = notification
    local SlideIn = game:GetService("TweenService"):Create(
        notification,
        TweenInfo.new(self.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = self:CalculatePosition(NewIndex)}
    )
    SlideIn:Play()
    self:UpdatePositions(NewIndex)
    local ProgressTween = game:GetService("TweenService"):Create(
        ProgressBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 0, 2)}
    )
    ProgressTween:Play()
    task.delay(duration, function()
        local FadeOut = game:GetService("TweenService"):Create(
            notification,
            TweenInfo.new(self.AnimationSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {BackgroundTransparency = 1, Position = UDim2.new(1, self.NotificationSize.X.Offset + 10, notification.Position.Y.Scale, notification.Position.Y.Offset)}
        )
        FadeOut:Play()
        task.wait(self.AnimationSpeed)
        for i, v in ipairs(self.Notifications) do
            if v == notification then
                table.remove(self.Notifications, i)
                break
            end
        end
        self:UpdatePositions()
        notification:Destroy()
    end)
end

return NotificationSystem
