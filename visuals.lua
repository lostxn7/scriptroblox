--[[
    Arquivo separado automaticamente a partir do seu código original.
    Observação: esses arquivos foram separados para organização no VS Code.
    Para gerar o script final único, use o build.lua deste pacote ou copie na ordem indicada no README.
]]

--! Visuals Handler

local VisualsHandler = {}

function VisualsHandler:Visualize(Object)
    if not DEBUG and Fluent and getfenv().Drawing and getfenv().Drawing.new and typeof(Object) == "string" then
        if string.lower(Object) == "fov" then
            local FoV = getfenv().Drawing.new("Circle")
            FoV.Visible = false
            FoV.ZIndex = 4
            FoV.NumSides = 1000
            FoV.Radius = Configuration.FoVRadius
            FoV.Thickness = Configuration.FoVThickness
            FoV.Transparency = Configuration.FoVOpacity
            FoV.Filled = Configuration.FoVFilled
            FoV.Color = Configuration.FoVColour
            return FoV
        elseif string.lower(Object) == "espbox" then
            local ESPBox = getfenv().Drawing.new("Square")
            ESPBox.Visible = false
            ESPBox.ZIndex = 2
            ESPBox.Thickness = Configuration.ESPThickness
            ESPBox.Transparency = Configuration.ESPOpacity
            ESPBox.Filled = Configuration.ESPBoxFilled
            ESPBox.Color = Configuration.ESPColour
            return ESPBox
        elseif string.lower(Object) == "nameesp" then
            local NameESP = getfenv().Drawing.new("Text")
            NameESP.Visible = false
            NameESP.ZIndex = 3
            NameESP.Center = true
            NameESP.Outline = true
            NameESP.OutlineColor = Configuration.NameESPOutlineColour
            NameESP.Font = getfenv().Drawing.Fonts and getfenv().Drawing.Fonts[Configuration.NameESPFont]
            NameESP.Size = Configuration.NameESPSize
            NameESP.Transparency = Configuration.ESPOpacity
            NameESP.Color = Configuration.ESPColour
            return NameESP
        elseif string.lower(Object) == "traceresp" then
            local TracerESP = getfenv().Drawing.new("Line")
            TracerESP.Visible = false
            TracerESP.ZIndex = 1
            TracerESP.Thickness = Configuration.ESPThickness
            TracerESP.Transparency = Configuration.ESPOpacity
            TracerESP.Color = Configuration.ESPColour
            return TracerESP
        end
    end
    return nil
end

local Visuals = { FoV = VisualsHandler:Visualize("FoV") }

function VisualsHandler:ClearVisual(Visual, Key)
    local FoundVisual = table.find(Visuals, Visual)
    if Visual and (FoundVisual or Key == "FoV") then
        if Visual.Destroy then
            Visual:Destroy()
        elseif Visual.Remove then
            Visual:Remove()
        end
        if FoundVisual then
            table.remove(Visuals, FoundVisual)
        elseif Key == "FoV" then
            Visuals.FoV = nil
        end
    end
end

function VisualsHandler:ClearVisuals()
    for Key, Visual in next, Visuals do
        self:ClearVisual(Visual, Key)
    end
end

function VisualsHandler:VisualizeFoV()
    if not Fluent then
        return self:ClearVisuals()
    end
    local MouseLocation = UserInputService:GetMouseLocation()
    Visuals.FoV.Position = Vector2.new(MouseLocation.X, MouseLocation.Y)
    Visuals.FoV.Radius = Configuration.FoVRadius
    Visuals.FoV.Thickness = Configuration.FoVThickness
    Visuals.FoV.Transparency = Configuration.FoVOpacity
    Visuals.FoV.Filled = Configuration.FoVFilled
    Visuals.FoV.Color = Configuration.FoVColour
    Visuals.FoV.Visible = ShowingFoV
end

function VisualsHandler:RainbowVisuals()
    if not Fluent then
        self:ClearVisuals()
    elseif Configuration.RainbowVisuals then
        local Hue = os.clock() % Configuration.RainbowDelay / Configuration.RainbowDelay
        Fluent.Options.FoVColour:SetValue({ Hue, 1, 1 })
        Fluent.Options.NameESPOutlineColour:SetValue({ 1 - Hue, 1, 1 })
        Fluent.Options.ESPColour:SetValue({ Hue, 1, 1 })
    end
end


--! ESP Library

local ESPLibrary = {}

function ESPLibrary:Initialize(_Character)
    if not Fluent then
        VisualsHandler:ClearVisuals()
        return nil
    elseif typeof(_Character) ~= "Instance" then
        return nil
    end
    local self = setmetatable({}, { __index = self })
    self.Player = Players:GetPlayerFromCharacter(_Character)
    self.Character = _Character
    self.ESPBox = VisualsHandler:Visualize("ESPBox")
    self.NameESP = VisualsHandler:Visualize("NameESP")
    self.HealthESP = VisualsHandler:Visualize("NameESP")
    self.MagnitudeESP = VisualsHandler:Visualize("NameESP")
    self.PremiumESP = VisualsHandler:Visualize("NameESP")
    self.TracerESP = VisualsHandler:Visualize("TracerESP")
    table.insert(Visuals, self.ESPBox)
    table.insert(Visuals, self.NameESP)
    table.insert(Visuals, self.HealthESP)
    table.insert(Visuals, self.MagnitudeESP)
    table.insert(Visuals, self.PremiumESP)
    table.insert(Visuals, self.TracerESP)
    local Head = self.Character:FindFirstChild("Head")
    local HumanoidRootPart = self.Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = self.Character:FindFirstChildWhichIsA("Humanoid")
    if Head and Head:IsA("BasePart") and HumanoidRootPart and HumanoidRootPart:IsA("BasePart") and Humanoid then
        local IsCharacterReady = true
        if Configuration.SmartESP then
            IsCharacterReady = IsReady(self.Character)
        end
        local HumanoidRootPartPosition, IsInViewport = workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)
        local HeadPosition = workspace.CurrentCamera:WorldToViewportPoint(Head.Position)
        local TopPosition = workspace.CurrentCamera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0))
        local BottomPosition = workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position - Vector3.new(0, 3, 0))
        if IsInViewport then
            self.ESPBox.Size = Vector2.new(2350 / HumanoidRootPartPosition.Z, TopPosition.Y - BottomPosition.Y)
            self.ESPBox.Position = Vector2.new(HumanoidRootPartPosition.X - self.ESPBox.Size.X / 2, HumanoidRootPartPosition.Y - self.ESPBox.Size.Y / 2)
            self.NameESP.Text = Aiming and IsReady(Target) and self.Character == Target and string.format("🎯@%s🎯", self.Player.Name) or string.format("@%s", self.Player.Name)
            self.NameESP.Position = Vector2.new(HumanoidRootPartPosition.X, HumanoidRootPartPosition.Y + self.ESPBox.Size.Y / 2 - 25)
            self.HealthESP.Text = string.format("[%s%%]", MathHandler:Abbreviate(Humanoid.Health))
            self.HealthESP.Position = Vector2.new(HumanoidRootPartPosition.X, HeadPosition.Y)
            self.MagnitudeESP.Text = string.format("[%sm]", Player.Character and Player.Character:FindFirstChild("Head") and Player.Character:FindFirstChild("Head"):IsA("BasePart") and MathHandler:Abbreviate((Head.Position - Player.Character:FindFirstChild("Head").Position).Magnitude) or "?")
            self.MagnitudeESP.Position = Vector2.new(HumanoidRootPartPosition.X, HumanoidRootPartPosition.Y)
            self.PremiumESP.Text = PremiumLabels[Random.new():NextInteger(1, #PremiumLabels)]
            self.PremiumESP.Position = Vector2.new(HumanoidRootPartPosition.X, HumanoidRootPartPosition.Y - self.ESPBox.Size.Y / 2)
            self.TracerESP.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
            self.TracerESP.To = Vector2.new(HumanoidRootPartPosition.X, HumanoidRootPartPosition.Y - self.ESPBox.Size.Y / 2)
            if Configuration.ESPUseTeamColour and not Configuration.RainbowVisuals then
                local TeamColour = self.Player.TeamColor.Color
                local InvertedTeamColour = Color3.fromRGB(255 - TeamColour.R * 255, 255 - TeamColour.G * 255, 255 - TeamColour.B * 255)
                self.ESPBox.Color = TeamColour
                self.NameESP.OutlineColor = InvertedTeamColour
                self.NameESP.Color = TeamColour
                self.HealthESP.OutlineColor = InvertedTeamColour
                self.HealthESP.Color = TeamColour
                self.MagnitudeESP.OutlineColor = InvertedTeamColour
                self.MagnitudeESP.Color = TeamColour
                self.PremiumESP.OutlineColor = InvertedTeamColour
                self.PremiumESP.Color = TeamColour
                self.TracerESP.Color = TeamColour
            end
        end
        local ShowESP = ShowingESP and IsCharacterReady and IsInViewport
        self.ESPBox.Visible = Configuration.ESPBox and ShowESP
        self.NameESP.Visible = Configuration.NameESP and ShowESP
        self.HealthESP.Visible = Configuration.HealthESP and ShowESP
        self.MagnitudeESP.Visible = Configuration.MagnitudeESP and ShowESP
        self.PremiumESP.Visible = Configuration.NameESP and self.Player:IsInGroup(tonumber(Fluent.Address, 8)) and ShowESP
        self.TracerESP.Visible = Configuration.TracerESP and ShowESP
    end
    return self
end

function ESPLibrary:Visualize()
    if not Fluent then
        return VisualsHandler:ClearVisuals()
    elseif not self.Character then
        return self:Disconnect()
    end
    local Head = self.Character:FindFirstChild("Head")
    local HumanoidRootPart = self.Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = self.Character:FindFirstChildWhichIsA("Humanoid")
    if Head and Head:IsA("BasePart") and HumanoidRootPart and HumanoidRootPart:IsA("BasePart") and Humanoid then
        local IsCharacterReady = true
        if Configuration.SmartESP then
            IsCharacterReady = IsReady(self.Character)
        end
        local HumanoidRootPartPosition, IsInViewport = workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)
        local HeadPosition = workspace.CurrentCamera:WorldToViewportPoint(Head.Position)
        local TopPosition = workspace.CurrentCamera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0))
        local BottomPosition = workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position - Vector3.new(0, 3, 0))
        if IsInViewport then
            self.ESPBox.Size = Vector2.new(2350 / HumanoidRootPartPosition.Z, TopPosition.Y - BottomPosition.Y)
            self.ESPBox.Position = Vector2.new(HumanoidRootPartPosition.X - self.ESPBox.Size.X / 2, HumanoidRootPartPosition.Y - self.ESPBox.Size.Y / 2)
            self.ESPBox.Thickness = Configuration.ESPThickness
            self.ESPBox.Transparency = Configuration.ESPOpacity
            self.ESPBox.Filled = Configuration.ESPBoxFilled
            self.NameESP.Text = Aiming and IsReady(Target) and self.Character == Target and string.format("🎯@%s🎯", self.Player.Name) or string.format("@%s", self.Player.Name)
            self.NameESP.Font = getfenv().Drawing.Fonts and getfenv().Drawing.Fonts[Configuration.NameESPFont]
            self.NameESP.Size = Configuration.NameESPSize
            self.NameESP.Transparency = Configuration.ESPOpacity
            self.NameESP.Position = Vector2.new(HumanoidRootPartPosition.X, HumanoidRootPartPosition.Y + self.ESPBox.Size.Y / 2 - 25)
            self.HealthESP.Text = string.format("[%s%%]", MathHandler:Abbreviate(Humanoid.Health))
            self.HealthESP.Font = getfenv().Drawing.Fonts and getfenv().Drawing.Fonts[Configuration.NameESPFont]
            self.HealthESP.Size = Configuration.NameESPSize
            self.HealthESP.Transparency = Configuration.ESPOpacity
            self.HealthESP.Position = Vector2.new(HumanoidRootPartPosition.X, HeadPosition.Y)
            self.MagnitudeESP.Text = string.format("[%sm]", Player.Character and Player.Character:FindFirstChild("Head") and Player.Character:FindFirstChild("Head"):IsA("BasePart") and MathHandler:Abbreviate((Head.Position - Player.Character:FindFirstChild("Head").Position).Magnitude) or "?")
            self.MagnitudeESP.Font = getfenv().Drawing.Fonts and getfenv().Drawing.Fonts[Configuration.NameESPFont]
            self.MagnitudeESP.Size = Configuration.NameESPSize
            self.MagnitudeESP.Transparency = Configuration.ESPOpacity
            self.MagnitudeESP.Position = Vector2.new(HumanoidRootPartPosition.X, HumanoidRootPartPosition.Y)
            self.PremiumESP.Text = PremiumLabels[Random.new():NextInteger(1, #PremiumLabels)]
            self.PremiumESP.Font = getfenv().Drawing.Fonts and getfenv().Drawing.Fonts[Configuration.NameESPFont]
            self.PremiumESP.Size = Configuration.NameESPSize
            self.PremiumESP.Transparency = Configuration.ESPOpacity
            self.PremiumESP.Position = Vector2.new(HumanoidRootPartPosition.X, HumanoidRootPartPosition.Y - self.ESPBox.Size.Y / 2)
            self.TracerESP.Thickness = Configuration.ESPThickness
            self.TracerESP.Transparency = Configuration.ESPOpacity
            self.TracerESP.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
            self.TracerESP.To = Vector2.new(HumanoidRootPartPosition.X, HumanoidRootPartPosition.Y - self.ESPBox.Size.Y / 2)
            if Configuration.ESPUseTeamColour and not Configuration.RainbowVisuals then
                local TeamColour = self.Player.TeamColor.Color
                local InvertedTeamColour = Color3.fromRGB(255 - TeamColour.R * 255, 255 - TeamColour.G * 255, 255 - TeamColour.B * 255)
                self.ESPBox.Color = TeamColour
                self.NameESP.OutlineColor = InvertedTeamColour
                self.NameESP.Color = TeamColour
                self.HealthESP.OutlineColor = InvertedTeamColour
                self.HealthESP.Color = TeamColour
                self.MagnitudeESP.OutlineColor = InvertedTeamColour
                self.MagnitudeESP.Color = TeamColour
                self.PremiumESP.OutlineColor = InvertedTeamColour
                self.PremiumESP.Color = TeamColour
                self.TracerESP.Color = TeamColour
            else
                self.ESPBox.Color = Configuration.ESPColour
                self.NameESP.OutlineColor = Configuration.NameESPOutlineColour
                self.NameESP.Color = Configuration.ESPColour
                self.HealthESP.OutlineColor = Configuration.NameESPOutlineColour
                self.HealthESP.Color = Configuration.ESPColour
                self.MagnitudeESP.OutlineColor = Configuration.NameESPOutlineColour
                self.MagnitudeESP.Color = Configuration.ESPColour
                self.PremiumESP.OutlineColor = Configuration.NameESPOutlineColour
                self.PremiumESP.Color = Configuration.ESPColour
                self.TracerESP.Color = Configuration.ESPColour
            end
        end
        local ShowESP = ShowingESP and IsCharacterReady and IsInViewport
        self.ESPBox.Visible = Configuration.ESPBox and ShowESP
        self.NameESP.Visible = Configuration.NameESP and ShowESP
        self.HealthESP.Visible = Configuration.HealthESP and ShowESP
        self.MagnitudeESP.Visible = Configuration.MagnitudeESP and ShowESP
        self.PremiumESP.Visible = Configuration.NameESP and self.Player:IsInGroup(tonumber(Fluent.Address, 8)) and ShowESP
        self.TracerESP.Visible = Configuration.TracerESP and ShowESP
    else
        self.ESPBox.Visible = false
        self.NameESP.Visible = false
        self.HealthESP.Visible = false
        self.MagnitudeESP.Visible = false
        self.PremiumESP.Visible = false
        self.TracerESP.Visible = false
    end
end

function ESPLibrary:Disconnect()
    self.Player = nil
    self.Character = nil
    VisualsHandler:ClearVisual(self.ESPBox)
    VisualsHandler:ClearVisual(self.NameESP)
    VisualsHandler:ClearVisual(self.HealthESP)
    VisualsHandler:ClearVisual(self.MagnitudeESP)
    VisualsHandler:ClearVisual(self.PremiumESP)
    VisualsHandler:ClearVisual(self.TracerESP)
end


--! Tracking Handler

local TrackingHandler = {}

local Tracking = {}
local Connections = {}

function TrackingHandler:VisualizeESP()
    for _, Tracked in next, Tracking do
        Tracked:Visualize()
    end
end

function TrackingHandler:DisconnectTracking(Key)
    if Key and Tracking[Key] then
        Tracking[Key]:Disconnect()
        Tracking[Key] = nil
    end
end

function TrackingHandler:DisconnectConnection(Key)
    if Key and Connections[Key] then
        for _, Connection in next, Connections[Key] do
            Connection:Disconnect()
        end
        Connections[Key] = nil
    end
end

function TrackingHandler:DisconnectConnections()
    for Key, _ in next, Connections do
        self:DisconnectConnection(Key)
    end
    for Key, _ in next, Tracking do
        self:DisconnectTracking(Key)
    end
end

function TrackingHandler:DisconnectAimbot()
    FieldsHandler:ResetAimbotFields()
    FieldsHandler:ResetSecondaryFields()
    self:DisconnectConnections()
    VisualsHandler:ClearVisuals()
end

local function CharacterAdded(_Character)
    if typeof(_Character) == "Instance" then
        local _Player = Players:GetPlayerFromCharacter(_Character)
        Tracking[_Player.UserId] = ESPLibrary:Initialize(_Character)
    end
end

local function CharacterRemoving(_Character)
    if typeof(_Character) == "Instance" then
        for Key, Tracked in next, Tracking do
            if Tracked.Character == _Character then
                TrackingHandler:DisconnectTracking(Key)
            end
        end
    end
end

function TrackingHandler:InitializePlayers()
    if not DEBUG and getfenv().Drawing and getfenv().Drawing.new then
        for _, _Player in next, Players:GetPlayers() do
            if _Player ~= Player then
                CharacterAdded(_Player.Character)
                Connections[_Player.UserId] = { _Player.CharacterAdded:Connect(CharacterAdded), _Player.CharacterRemoving:Connect(CharacterRemoving) }
            end
        end
    end
end

TrackingHandler:InitializePlayers()


