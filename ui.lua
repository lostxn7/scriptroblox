--[[
    Arquivo separado automaticamente a partir do seu código original.
    Observação: esses arquivos foram separados para organização no VS Code.
    Para gerar o script final único, use o build.lua deste pacote ou copie na ordem indicada no README.
]]

--! UI Initializer

do
    local Window = Fluent:CreateWindow({
        Title = string.format("%s <b><i>%s</i></b>", string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"), #Status > 0 and Status or "🔥FREE🔥"),
        SubTitle = "By @ttwiz_z",
        TabWidth = UISettings.TabWidth,
        Size = UDim2.fromOffset(table.unpack(UISettings.Size)),
        Theme = UISettings.Theme,
        Acrylic = UISettings.Acrylic,
        MinimizeKey = UISettings.MinimizeKey
    })

    local Tabs = { Aimbot = Window:AddTab({ Title = "Aimbot", Icon = "crosshair" }) }

    Window:SelectTab(1)

    Tabs.Aimbot:AddParagraph({
        Title = string.format("%s 🔥FREE🔥", string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")),
        Content = "✨Universal Aim Assist Framework✨\nhttps://github.com/ttwizz/Open-Aimbot"
    })

    local AimbotSection = Tabs.Aimbot:AddSection("Aimbot")

    local AimbotToggle = AimbotSection:AddToggle("Aimbot", { Title = "Aimbot", Description = "Toggles the Aimbot", Default = Configuration.Aimbot })
    AimbotToggle:OnChanged(function(Value)
        Configuration.Aimbot = Value
        if not IsComputer then
            Aiming = Value
        end
    end)

    if IsComputer then
        local OnePressAimingModeToggle = AimbotSection:AddToggle("OnePressAimingMode", { Title = "One-Press Mode", Description = "Uses the One-Press Mode instead of the Holding Mode", Default = Configuration.OnePressAimingMode })
        OnePressAimingModeToggle:OnChanged(function(Value)
            Configuration.OnePressAimingMode = Value
        end)

        local AimKeybind = AimbotSection:AddKeybind("AimKey", {
            Title = "Aim Key",
            Description = "Changes the Aim Key",
            Default = Configuration.AimKey,
            ChangedCallback = function(Value)
                Configuration.AimKey = Value
            end
        })
        Configuration.AimKey = AimKeybind.Value ~= "RMB" and Enum.KeyCode[AimKeybind.Value] or Enum.UserInputType.MouseButton2
    end

    local AimModeDropdown = AimbotSection:AddDropdown("AimMode", {
        Title = "Aim Mode",
        Description = "Changes the Aim Mode",
        Values = { "Camera" },
        Default = Configuration.AimMode,
        Callback = function(Value)
            Configuration.AimMode = Value
        end
    })
    if getfenv().mousemoverel and IsComputer then
        table.insert(AimModeDropdown.Values, "Mouse")
        AimModeDropdown:BuildDropdownList()
    else
        ShowWarning = true
    end
    if getfenv().hookmetamethod and getfenv().newcclosure and getfenv().checkcaller and getfenv().getnamecallmethod then
        table.insert(AimModeDropdown.Values, "Silent")
        AimModeDropdown:BuildDropdownList()

        local SilentAimMethodsDropdown = AimbotSection:AddDropdown("SilentAimMethods", {
            Title = "Silent Aim Methods",
            Description = "Sets the Silent Aim Methods",
            Values = { "Mouse.Hit / Mouse.Target", "GetMouseLocation", "Raycast", "FindPartOnRay", "FindPartOnRayWithIgnoreList", "FindPartOnRayWithWhitelist" },
            Multi = true,
            Default = Configuration.SilentAimMethods
        })
        SilentAimMethodsDropdown:OnChanged(function(Value)
            Configuration.SilentAimMethods = {}
            for Key, _ in next, Value do
                if typeof(Key) == "string" then
                    table.insert(Configuration.SilentAimMethods, Key)
                end
            end
        end)

        AimbotSection:AddSlider("SilentAimChance", {
            Title = "Silent Aim Chance",
            Description = "Changes the Hit Chance for Silent Aim",
            Default = Configuration.SilentAimChance,
            Min = 1,
            Max = 100,
            Rounding = 1,
            Callback = function(Value)
                Configuration.SilentAimChance = Value
            end
        })
    else
        ShowWarning = true
    end

    local OffAimbotAfterKillToggle = AimbotSection:AddToggle("OffAimbotAfterKill", { Title = "Off After Kill", Description = "Disables the Aiming Mode after killing a Target", Default = Configuration.OffAimbotAfterKill })
    OffAimbotAfterKillToggle:OnChanged(function(Value)
        Configuration.OffAimbotAfterKill = Value
    end)

    local AimPartDropdown = AimbotSection:AddDropdown("AimPart", {
        Title = "Aim Part",
        Description = "Changes the Aim Part",
        Values = Configuration.AimPartDropdownValues,
        Default = Configuration.AimPart,
        Callback = function(Value)
            Configuration.AimPart = Value
        end
    })

    local RandomAimPartToggle = AimbotSection:AddToggle("RandomAimPart", { Title = "Random Aim Part", Description = "Selects every second a Random Aim Part from Dropdown", Default = Configuration.RandomAimPart })
    RandomAimPartToggle:OnChanged(function(Value)
        Configuration.RandomAimPart = Value
    end)

    AimbotSection:AddInput("AddAimPart", {
        Title = "Add Aim Part",
        Description = "After typing, press Enter",
        Finished = true,
        Placeholder = "Part Name",
        Callback = function(Value)
            if #Value > 0 and not table.find(Configuration.AimPartDropdownValues, Value) then
                table.insert(Configuration.AimPartDropdownValues, Value)
                AimPartDropdown:SetValue(Value)
            end
        end
    })

    AimbotSection:AddInput("RemoveAimPart", {
        Title = "Remove Aim Part",
        Description = "After typing, press Enter",
        Finished = true,
        Placeholder = "Part Name",
        Callback = function(Value)
            if #Value > 0 and table.find(Configuration.AimPartDropdownValues, Value) then
                if Configuration.AimPart == Value then
                    AimPartDropdown:SetValue(nil)
                end
                table.remove(Configuration.AimPartDropdownValues, table.find(Configuration.AimPartDropdownValues, Value))
                AimPartDropdown:SetValues(Configuration.AimPartDropdownValues)
            end
        end
    })

    AimbotSection:AddButton({
        Title = "Clear All Items",
        Description = "Removes All Elements",
        Callback = function()
            local Items = #Configuration.AimPartDropdownValues
            AimPartDropdown:SetValue(nil)
            Configuration.AimPartDropdownValues = {}
            AimPartDropdown:SetValues(Configuration.AimPartDropdownValues)
            Window:Dialog({
                Title = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"),
                Content = Items == 0 and "Nothing has been cleared!" or Items == 1 and "1 Item has been cleared!" or string.format("%s Items have been cleared!", Items),
                Buttons = {
                    {
                        Title = "Confirm"
                    }
                }
            })
        end
    })

    local AimOffsetSection = Tabs.Aimbot:AddSection("Aim Offset")

    local UseOffsetToggle = AimOffsetSection:AddToggle("UseOffset", { Title = "Use Offset", Description = "Toggles the Offset", Default = Configuration.UseOffset })
    UseOffsetToggle:OnChanged(function(Value)
        Configuration.UseOffset = Value
    end)

    AimOffsetSection:AddDropdown("OffsetType", {
        Title = "Offset Type",
        Description = "Changes the Offset Type",
        Values = { "Static", "Dynamic", "Static & Dynamic" },
        Default = Configuration.OffsetType,
        Callback = function(Value)
            Configuration.OffsetType = Value
        end
    })

    AimOffsetSection:AddSlider("StaticOffsetIncrement", {
        Title = "Static Offset Increment",
        Description = "Changes the Static Offset Increment",
        Default = Configuration.StaticOffsetIncrement,
        Min = 1,
        Max = 50,
        Rounding = 1,
        Callback = function(Value)
            Configuration.StaticOffsetIncrement = Value
        end
    })

    AimOffsetSection:AddSlider("DynamicOffsetIncrement", {
        Title = "Dynamic Offset Increment",
        Description = "Changes the Dynamic Offset Increment",
        Default = Configuration.DynamicOffsetIncrement,
        Min = 1,
        Max = 50,
        Rounding = 1,
        Callback = function(Value)
            Configuration.DynamicOffsetIncrement = Value
        end
    })

    local AutoOffsetToggle = AimOffsetSection:AddToggle("AutoOffset", { Title = "Auto Offset", Description = "Toggles the Auto Offset", Default = Configuration.AutoOffset })
    AutoOffsetToggle:OnChanged(function(Value)
        Configuration.AutoOffset = Value
    end)

    AimOffsetSection:AddSlider("MaxAutoOffset", {
        Title = "Max Auto Offset",
        Description = "Changes the Max Auto Offset",
        Default = Configuration.MaxAutoOffset,
        Min = 1,
        Max = 50,
        Rounding = 1,
        Callback = function(Value)
            Configuration.MaxAutoOffset = Value
        end
    })

    local SensitivityNoiseSection = Tabs.Aimbot:AddSection("Sensitivity & Noise")

    local UseSensitivityToggle = SensitivityNoiseSection:AddToggle("UseSensitivity", { Title = "Use Sensitivity", Description = "Toggles the Sensitivity", Default = Configuration.UseSensitivity })
    UseSensitivityToggle:OnChanged(function(Value)
        Configuration.UseSensitivity = Value
    end)

    SensitivityNoiseSection:AddSlider("Sensitivity", {
        Title = "Sensitivity",
        Description = "Smoothes out the Mouse / Camera Movements when Aiming",
        Default = Configuration.Sensitivity,
        Min = 1,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            Configuration.Sensitivity = Value
        end
    })

    local UseNoiseToggle = SensitivityNoiseSection:AddToggle("UseNoise", { Title = "Use Noise", Description = "Toggles the Camera Shaking when Aiming", Default = Configuration.UseNoise })
    UseNoiseToggle:OnChanged(function(Value)
        Configuration.UseNoise = Value
    end)

    SensitivityNoiseSection:AddSlider("NoiseFrequency", {
        Title = "Noise Frequency",
        Description = "Changes the Noise Frequency",
        Default = Configuration.NoiseFrequency,
        Min = 1,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            Configuration.NoiseFrequency = Value
        end
    })

    Tabs.Bots = Window:AddTab({ Title = "Bots", Icon = "bot" })

    Tabs.Bots:AddParagraph({
        Title = string.format("%s 🔥FREE🔥", string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")),
        Content = "✨Universal Aim Assist Framework✨\nhttps://github.com/ttwizz/Open-Aimbot"
    })

    local SpinBotSection = Tabs.Bots:AddSection("SpinBot")

    SpinBotSection:AddParagraph({
        Title = "NOTE",
        Content = "SpinBot does not function normally in RenderStepped Rendering Mode. Set a different Rendering Mode value than RenderStepped to solve this problem."
    })

    local SpinBotToggle = SpinBotSection:AddToggle("SpinBot", { Title = "SpinBot", Description = "Toggles the SpinBot", Default = Configuration.SpinBot })
    SpinBotToggle:OnChanged(function(Value)
        Configuration.SpinBot = Value
        if not IsComputer then
            Spinning = Value
        end
    end)

    if IsComputer then
        local OnePressSpinningModeToggle = SpinBotSection:AddToggle("OnePressSpinningMode", { Title = "One-Press Mode", Description = "Uses the One-Press Mode instead of the Holding Mode", Default = Configuration.OnePressSpinningMode })
        OnePressSpinningModeToggle:OnChanged(function(Value)
            Configuration.OnePressSpinningMode = Value
        end)

        local SpinKeybind = SpinBotSection:AddKeybind("SpinKey", {
            Title = "Spin Key",
            Description = "Changes the Spin Key",
            Default = Configuration.SpinKey,
            ChangedCallback = function(Value)
                Configuration.SpinKey = Value
            end
        })
        Configuration.SpinKey = SpinKeybind.Value ~= "RMB" and Enum.KeyCode[SpinKeybind.Value] or Enum.UserInputType.MouseButton2
    end

    SpinBotSection:AddSlider("SpinBotVelocity", {
        Title = "SpinBot Velocity",
        Description = "Changes the SpinBot Velocity",
        Default = Configuration.SpinBotVelocity,
        Min = 1,
        Max = 50,
        Rounding = 1,
        Callback = function(Value)
            Configuration.SpinBotVelocity = Value
        end
    })

    local SpinPartDropdown = SpinBotSection:AddDropdown("SpinPart", {
        Title = "Spin Part",
        Description = "Changes the Spin Part",
        Values = Configuration.SpinPartDropdownValues,
        Default = Configuration.SpinPart,
        Callback = function(Value)
            Configuration.SpinPart = Value
        end
    })

    local RandomSpinPartToggle = SpinBotSection:AddToggle("RandomSpinPart", { Title = "Random Spin Part", Description = "Selects every second a Random Spin Part from Dropdown", Default = Configuration.RandomSpinPart })
    RandomSpinPartToggle:OnChanged(function(Value)
        Configuration.RandomSpinPart = Value
    end)

    SpinBotSection:AddInput("AddSpinPart", {
        Title = "Add Spin Part",
        Description = "After typing, press Enter",
        Finished = true,
        Placeholder = "Part Name",
        Callback = function(Value)
            if #Value > 0 and not table.find(Configuration.SpinPartDropdownValues, Value) then
                table.insert(Configuration.SpinPartDropdownValues, Value)
                SpinPartDropdown:SetValue(Value)
            end
        end
    })

    SpinBotSection:AddInput("RemoveSpinPart", {
        Title = "Remove Spin Part",
        Description = "After typing, press Enter",
        Finished = true,
        Placeholder = "Part Name",
        Callback = function(Value)
            if #Value > 0 and table.find(Configuration.SpinPartDropdownValues, Value) then
                if Configuration.SpinPart == Value then
                    SpinPartDropdown:SetValue(nil)
                end
                table.remove(Configuration.SpinPartDropdownValues, table.find(Configuration.SpinPartDropdownValues, Value))
                SpinPartDropdown:SetValues(Configuration.SpinPartDropdownValues)
            end
        end
    })

    SpinBotSection:AddButton({
        Title = "Clear All Items",
        Description = "Removes All Elements",
        Callback = function()
            local Items = #Configuration.SpinPartDropdownValues
            SpinPartDropdown:SetValue(nil)
            Configuration.SpinPartDropdownValues = {}
            SpinPartDropdown:SetValues(Configuration.SpinPartDropdownValues)
            Window:Dialog({
                Title = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"),
                Content = Items == 0 and "Nothing has been cleared!" or Items == 1 and "1 Item has been cleared!" or string.format("%s Items have been cleared!", Items),
                Buttons = {
                    {
                        Title = "Confirm"
                    }
                }
            })
        end
    })

    if getfenv().mouse1click and IsComputer then
        local TriggerBotSection = Tabs.Bots:AddSection("TriggerBot")

        local TriggerBotToggle = TriggerBotSection:AddToggle("TriggerBot", { Title = "TriggerBot", Description = "Toggles the TriggerBot", Default = Configuration.TriggerBot })
        TriggerBotToggle:OnChanged(function(Value)
            Configuration.TriggerBot = Value
        end)

        local OnePressTriggeringModeToggle = TriggerBotSection:AddToggle("OnePressTriggeringMode", { Title = "One-Press Mode", Description = "Uses the One-Press Mode instead of the Holding Mode", Default = Configuration.OnePressTriggeringMode })
        OnePressTriggeringModeToggle:OnChanged(function(Value)
            Configuration.OnePressTriggeringMode = Value
        end)

        local SmartTriggerBotToggle = TriggerBotSection:AddToggle("SmartTriggerBot", { Title = "Smart TriggerBot", Description = "Uses the TriggerBot only when Aiming", Default = Configuration.SmartTriggerBot })
        SmartTriggerBotToggle:OnChanged(function(Value)
            Configuration.SmartTriggerBot = Value
        end)

        local TriggerKeybind = TriggerBotSection:AddKeybind("TriggerKey", {
            Title = "Trigger Key",
            Description = "Changes the Trigger Key",
            Default = Configuration.TriggerKey,
            ChangedCallback = function(Value)
                Configuration.TriggerKey = Value
            end
        })
        Configuration.TriggerKey = TriggerKeybind.Value ~= "RMB" and Enum.KeyCode[TriggerKeybind.Value] or Enum.UserInputType.MouseButton2

        TriggerBotSection:AddSlider("TriggerBotChance", {
            Title = "TriggerBot Chance",
            Description = "Changes the Hit Chance for TriggerBot",
            Default = Configuration.TriggerBotChance,
            Min = 1,
            Max = 100,
            Rounding = 1,
            Callback = function(Value)
                Configuration.TriggerBotChance = Value
            end
        })
    else
        ShowWarning = true
    end

    Tabs.Checks = Window:AddTab({ Title = "Checks", Icon = "list-checks" })

    Tabs.Checks:AddParagraph({
        Title = string.format("%s 🔥FREE🔥", string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")),
        Content = "✨Universal Aim Assist Framework✨\nhttps://github.com/ttwizz/Open-Aimbot"
    })

    local SimpleChecksSection = Tabs.Checks:AddSection("Simple Checks")

    local AliveCheckToggle = SimpleChecksSection:AddToggle("AliveCheck", { Title = "Alive Check", Description = "Toggles the Alive Check", Default = Configuration.AliveCheck })
    AliveCheckToggle:OnChanged(function(Value)
        Configuration.AliveCheck = Value
    end)

    local GodCheckToggle = SimpleChecksSection:AddToggle("GodCheck", { Title = "God Check", Description = "Toggles the God Check", Default = Configuration.GodCheck })
    GodCheckToggle:OnChanged(function(Value)
        Configuration.GodCheck = Value
    end)

    local TeamCheckToggle = SimpleChecksSection:AddToggle("TeamCheck", { Title = "Team Check", Description = "Toggles the Team Check", Default = Configuration.TeamCheck })
    TeamCheckToggle:OnChanged(function(Value)
        Configuration.TeamCheck = Value
    end)

    local FriendCheckToggle = SimpleChecksSection:AddToggle("FriendCheck", { Title = "Friend Check", Description = "Toggles the Friend Check", Default = Configuration.FriendCheck })
    FriendCheckToggle:OnChanged(function(Value)
        Configuration.FriendCheck = Value
    end)

    local FollowCheckToggle = SimpleChecksSection:AddToggle("FollowCheck", { Title = "Follow Check", Description = "Toggles the Follow Check", Default = Configuration.FollowCheck })
    FollowCheckToggle:OnChanged(function(Value)
        Configuration.FollowCheck = Value
    end)

    local VerifiedBadgeCheckToggle = SimpleChecksSection:AddToggle("VerifiedBadgeCheck", { Title = "Verified Badge Check", Description = "Toggles the Verified Badge Check", Default = Configuration.VerifiedBadgeCheck })
    VerifiedBadgeCheckToggle:OnChanged(function(Value)
        Configuration.VerifiedBadgeCheck = Value
    end)

    local WallCheckToggle = SimpleChecksSection:AddToggle("WallCheck", { Title = "Wall Check", Description = "Toggles the Wall Check", Default = Configuration.WallCheck })
    WallCheckToggle:OnChanged(function(Value)
        Configuration.WallCheck = Value
    end)

    local WaterCheckToggle = SimpleChecksSection:AddToggle("WaterCheck", { Title = "Water Check", Description = "Toggles the Water Check if Wall Check is enabled", Default = Configuration.WaterCheck })
    WaterCheckToggle:OnChanged(function(Value)
        Configuration.WaterCheck = Value
    end)

    local AdvancedChecksSection = Tabs.Checks:AddSection("Advanced Checks")

    local FoVCheckToggle = AdvancedChecksSection:AddToggle("FoVCheck", { Title = "FoV Check", Description = "Toggles the FoV Check", Default = Configuration.FoVCheck })
    FoVCheckToggle:OnChanged(function(Value)
        Configuration.FoVCheck = Value
    end)

    AdvancedChecksSection:AddSlider("FoVRadius", {
        Title = "FoV Radius",
        Description = "Changes the FoV Radius",
        Default = Configuration.FoVRadius,
        Min = 10,
        Max = 1000,
        Rounding = 1,
        Callback = function(Value)
            Configuration.FoVRadius = Value
        end
    })

    local MagnitudeCheckToggle = AdvancedChecksSection:AddToggle("MagnitudeCheck", { Title = "Magnitude Check", Description = "Toggles the Magnitude Check", Default = Configuration.MagnitudeCheck })
    MagnitudeCheckToggle:OnChanged(function(Value)
        Configuration.MagnitudeCheck = Value
    end)

    AdvancedChecksSection:AddSlider("TriggerMagnitude", {
        Title = "Trigger Magnitude",
        Description = "Distance between the Native and the Target Character",
        Default = Configuration.TriggerMagnitude,
        Min = 10,
        Max = 1000,
        Rounding = 1,
        Callback = function(Value)
            Configuration.TriggerMagnitude = Value
        end
    })

    local TransparencyCheckToggle = AdvancedChecksSection:AddToggle("TransparencyCheck", { Title = "Transparency Check", Description = "Toggles the Transparency Check", Default = Configuration.TransparencyCheck })
    TransparencyCheckToggle:OnChanged(function(Value)
        Configuration.TransparencyCheck = Value
    end)

    AdvancedChecksSection:AddSlider("IgnoredTransparency", {
        Title = "Ignored Transparency",
        Description = "Target is ignored if its Transparency is > than / = to the set one",
        Default = Configuration.IgnoredTransparency,
        Min = 0.1,
        Max = 1,
        Rounding = 1,
        Callback = function(Value)
            Configuration.IgnoredTransparency = Value
        end
    })

    local WhitelistedGroupCheckToggle = AdvancedChecksSection:AddToggle("WhitelistedGroupCheck", { Title = "Whitelisted Group Check", Description = "Toggles the Whitelisted Group Check", Default = Configuration.WhitelistedGroupCheck })
    WhitelistedGroupCheckToggle:OnChanged(function(Value)
        Configuration.WhitelistedGroupCheck = Value
    end)

    AdvancedChecksSection:AddInput("WhitelistedGroup", {
        Title = "Whitelisted Group",
        Description = "After typing, press Enter",
        Default = Configuration.WhitelistedGroup,
        Numeric = true,
        Finished = true,
        Placeholder = "Group Id",
        Callback = function(Value)
            Configuration.WhitelistedGroup = #tostring(Value) > 0 and tonumber(Value) or 0
        end
    })

    local BlacklistedGroupCheckToggle = AdvancedChecksSection:AddToggle("BlacklistedGroupCheck", { Title = "Blacklisted Group Check", Description = "Toggles the Blacklisted Group Check", Default = Configuration.BlacklistedGroupCheck })
    BlacklistedGroupCheckToggle:OnChanged(function(Value)
        Configuration.BlacklistedGroupCheck = Value
    end)

    AdvancedChecksSection:AddInput("BlacklistedGroup", {
        Title = "Blacklisted Group",
        Description = "After typing, press Enter",
        Default = Configuration.BlacklistedGroup,
        Numeric = true,
        Finished = true,
        Placeholder = "Group Id",
        Callback = function(Value)
            Configuration.BlacklistedGroup = #tostring(Value) > 0 and tonumber(Value) or 0
        end
    })

    local ExpertChecksSection = Tabs.Checks:AddSection("Expert Checks")

    local IgnoredPlayersCheckToggle = ExpertChecksSection:AddToggle("IgnoredPlayersCheck", { Title = "Ignored Players Check", Description = "Toggles the Ignored Players Check", Default = Configuration.IgnoredPlayersCheck })
    IgnoredPlayersCheckToggle:OnChanged(function(Value)
        Configuration.IgnoredPlayersCheck = Value
    end)

    local IgnoredPlayersDropdown = ExpertChecksSection:AddDropdown("IgnoredPlayers", {
        Title = "Ignored Players",
        Description = "Sets the Ignored Players",
        Values = Configuration.IgnoredPlayersDropdownValues,
        Multi = true,
        Default = Configuration.IgnoredPlayers
    })
    IgnoredPlayersDropdown:OnChanged(function(Value)
        Configuration.IgnoredPlayers = {}
        for Key, _ in next, Value do
            if typeof(Key) == "string" then
                table.insert(Configuration.IgnoredPlayers, Key)
            end
        end
    end)

    ExpertChecksSection:AddInput("AddIgnoredPlayer", {
        Title = "Add Ignored Player",
        Description = "After typing, press Enter",
        Finished = true,
        Placeholder = "Player Name",
        Callback = function(Value)
            Value = #GetPlayerName(Value) > 0 and GetPlayerName(Value) or pcall(Players.GetUserIdFromNameAsync, Players, Value) and pcall(Players.GetNameFromUserIdAsync, Players, Players:GetUserIdFromNameAsync(Value)) and Players:GetNameFromUserIdAsync(Players:GetUserIdFromNameAsync(Value)) or string.sub(Value, 1, 1) == "@" and (#GetPlayerName(string.sub(Value, 2)) > 0 and GetPlayerName(string.sub(Value, 2)) or pcall(Players.GetUserIdFromNameAsync, Players, string.sub(Value, 2)) and pcall(Players.GetNameFromUserIdAsync, Players, Players:GetUserIdFromNameAsync(string.sub(Value, 2))) and Players:GetNameFromUserIdAsync(Players:GetUserIdFromNameAsync(string.sub(Value, 2)))) or string.sub(Value, 1, 1) == "#" and pcall(Players.GetNameFromUserIdAsync, Players, tonumber(string.sub(Value, 2))) and Players:GetNameFromUserIdAsync(tonumber(string.sub(Value, 2))) or ""
            if #Value > 0 and not table.find(Configuration.IgnoredPlayersDropdownValues, Value) then
                table.insert(Configuration.IgnoredPlayersDropdownValues, Value)
                if not table.find(Configuration.IgnoredPlayers, Value) then
                    IgnoredPlayersDropdown.Value[Value] = true
                    table.insert(Configuration.IgnoredPlayers, Value)
                end
                IgnoredPlayersDropdown:BuildDropdownList()
            end
        end
    })

    ExpertChecksSection:AddInput("RemoveIgnoredPlayer", {
        Title = "Remove Ignored Player",
        Description = "After typing, press Enter",
        Finished = true,
        Placeholder = "Player Name",
        Callback = function(Value)
            Value = #GetPlayerName(Value) > 0 and GetPlayerName(Value) or pcall(Players.GetUserIdFromNameAsync, Players, Value) and pcall(Players.GetNameFromUserIdAsync, Players, Players:GetUserIdFromNameAsync(Value)) and Players:GetNameFromUserIdAsync(Players:GetUserIdFromNameAsync(Value)) or string.sub(Value, 1, 1) == "@" and (#GetPlayerName(string.sub(Value, 2)) > 0 and GetPlayerName(string.sub(Value, 2)) or pcall(Players.GetUserIdFromNameAsync, Players, string.sub(Value, 2)) and pcall(Players.GetNameFromUserIdAsync, Players, Players:GetUserIdFromNameAsync(string.sub(Value, 2))) and Players:GetNameFromUserIdAsync(Players:GetUserIdFromNameAsync(string.sub(Value, 2)))) or string.sub(Value, 1, 1) == "#" and pcall(Players.GetNameFromUserIdAsync, Players, tonumber(string.sub(Value, 2))) and Players:GetNameFromUserIdAsync(tonumber(string.sub(Value, 2))) or ""
            if #Value > 0 and table.find(Configuration.IgnoredPlayersDropdownValues, Value) then
                if table.find(Configuration.IgnoredPlayers, Value) then
                    IgnoredPlayersDropdown.Value[Value] = nil
                    table.remove(Configuration.IgnoredPlayers, table.find(Configuration.IgnoredPlayers, Value))
                    IgnoredPlayersDropdown:Display()
                end
                table.remove(Configuration.IgnoredPlayersDropdownValues, table.find(Configuration.IgnoredPlayersDropdownValues, Value))
                IgnoredPlayersDropdown:SetValues(Configuration.IgnoredPlayersDropdownValues)
            end
        end
    })

    ExpertChecksSection:AddButton({
        Title = "Deselect All Items",
        Description = "Deselects All Elements",
        Callback = function()
            local Items = #Configuration.IgnoredPlayers
            IgnoredPlayersDropdown:SetValue({})
            Window:Dialog({
                Title = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"),
                Content = Items == 0 and "Nothing has been deselected!" or Items == 1 and "1 Item has been deselected!" or string.format("%s Items have been deselected!", Items),
                Buttons = {
                    {
                        Title = "Confirm"
                    }
                }
            })
        end
    })

    ExpertChecksSection:AddButton({
        Title = "Clear Unselected Items",
        Description = "Removes Unselected Players",
        Callback = function()
            local Cache = {}
            local Items = 0
            for _, Value in next, Configuration.IgnoredPlayersDropdownValues do
                if table.find(Configuration.IgnoredPlayers, Value) then
                    table.insert(Cache, Value)
                else
                    Items = Items + 1
                end
            end
            Configuration.IgnoredPlayersDropdownValues = Cache
            IgnoredPlayersDropdown:SetValues(Configuration.IgnoredPlayersDropdownValues)
            Window:Dialog({
                Title = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"),
                Content = Items == 0 and "Nothing has been cleared!" or Items == 1 and "1 Item has been cleared!" or string.format("%s Items have been cleared!", Items),
                Buttons = {
                    {
                        Title = "Confirm"
                    }
                }
            })
        end
    })

    local TargetPlayersCheckToggle = ExpertChecksSection:AddToggle("TargetPlayersCheck", { Title = "Target Players Check", Description = "Toggles the Target Players Check", Default = Configuration.TargetPlayersCheck })
    TargetPlayersCheckToggle:OnChanged(function(Value)
        Configuration.TargetPlayersCheck = Value
    end)

    local TargetPlayersDropdown = ExpertChecksSection:AddDropdown("TargetPlayers", {
        Title = "Target Players",
        Description = "Sets the Target Players",
        Values = Configuration.TargetPlayersDropdownValues,
        Multi = true,
        Default = Configuration.TargetPlayers
    })
    TargetPlayersDropdown:OnChanged(function(Value)
        Configuration.TargetPlayers = {}
        for Key, _ in next, Value do
            if typeof(Key) == "string" then
                table.insert(Configuration.TargetPlayers, Key)
            end
        end
    end)

    ExpertChecksSection:AddInput("AddTargetPlayer", {
        Title = "Add Target Player",
        Description = "After typing, press Enter",
        Finished = true,
        Placeholder = "Player Name",
        Callback = function(Value)
            Value = #GetPlayerName(Value) > 0 and GetPlayerName(Value) or pcall(Players.GetUserIdFromNameAsync, Players, Value) and pcall(Players.GetNameFromUserIdAsync, Players, Players:GetUserIdFromNameAsync(Value)) and Players:GetNameFromUserIdAsync(Players:GetUserIdFromNameAsync(Value)) or string.sub(Value, 1, 1) == "@" and (#GetPlayerName(string.sub(Value, 2)) > 0 and GetPlayerName(string.sub(Value, 2)) or pcall(Players.GetUserIdFromNameAsync, Players, string.sub(Value, 2)) and pcall(Players.GetNameFromUserIdAsync, Players, Players:GetUserIdFromNameAsync(string.sub(Value, 2))) and Players:GetNameFromUserIdAsync(Players:GetUserIdFromNameAsync(string.sub(Value, 2)))) or string.sub(Value, 1, 1) == "#" and pcall(Players.GetNameFromUserIdAsync, Players, tonumber(string.sub(Value, 2))) and Players:GetNameFromUserIdAsync(tonumber(string.sub(Value, 2))) or ""
            if #Value > 0 and not table.find(Configuration.TargetPlayersDropdownValues, Value) then
                table.insert(Configuration.TargetPlayersDropdownValues, Value)
                if not table.find(Configuration.TargetPlayers, Value) then
                    TargetPlayersDropdown.Value[Value] = true
                    table.insert(Configuration.TargetPlayers, Value)
                end
                TargetPlayersDropdown:BuildDropdownList()
            end
        end
    })

    ExpertChecksSection:AddInput("RemoveTargetPlayer", {
        Title = "Remove Target Player",
        Description = "After typing, press Enter",
        Finished = true,
        Placeholder = "Player Name",
        Callback = function(Value)
            Value = #GetPlayerName(Value) > 0 and GetPlayerName(Value) or pcall(Players.GetUserIdFromNameAsync, Players, Value) and pcall(Players.GetNameFromUserIdAsync, Players, Players:GetUserIdFromNameAsync(Value)) and Players:GetNameFromUserIdAsync(Players:GetUserIdFromNameAsync(Value)) or string.sub(Value, 1, 1) == "@" and (#GetPlayerName(string.sub(Value, 2)) > 0 and GetPlayerName(string.sub(Value, 2)) or pcall(Players.GetUserIdFromNameAsync, Players, string.sub(Value, 2)) and pcall(Players.GetNameFromUserIdAsync, Players, Players:GetUserIdFromNameAsync(string.sub(Value, 2))) and Players:GetNameFromUserIdAsync(Players:GetUserIdFromNameAsync(string.sub(Value, 2)))) or string.sub(Value, 1, 1) == "#" and pcall(Players.GetNameFromUserIdAsync, Players, tonumber(string.sub(Value, 2))) and Players:GetNameFromUserIdAsync(tonumber(string.sub(Value, 2))) or ""
            if #Value > 0 and table.find(Configuration.TargetPlayersDropdownValues, Value) then
                if table.find(Configuration.TargetPlayers, Value) then
                    TargetPlayersDropdown.Value[Value] = nil
                    table.remove(Configuration.TargetPlayers, table.find(Configuration.TargetPlayers, Value))
                    TargetPlayersDropdown:Display()
                end
                table.remove(Configuration.TargetPlayersDropdownValues, table.find(Configuration.TargetPlayersDropdownValues, Value))
                TargetPlayersDropdown:SetValues(Configuration.TargetPlayersDropdownValues)
            end
        end
    })

    ExpertChecksSection:AddButton({
        Title = "Deselect All Items",
        Description = "Deselects All Elements",
        Callback = function()
            local Items = #Configuration.TargetPlayers
            TargetPlayersDropdown:SetValue({})
            Window:Dialog({
                Title = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"),
                Content = Items == 0 and "Nothing has been deselected!" or Items == 1 and "1 Item has been deselected!" or string.format("%s Items have been deselected!", Items),
                Buttons = {
                    {
                        Title = "Confirm"
                    }
                }
            })
        end
    })

    ExpertChecksSection:AddButton({
        Title = "Clear Unselected Items",
        Description = "Removes Unselected Players",
        Callback = function()
            local Cache = {}
            local Items = 0
            for _, Value in next, Configuration.TargetPlayersDropdownValues do
                if table.find(Configuration.TargetPlayers, Value) then
                    table.insert(Cache, Value)
                else
                    Items = Items + 1
                end
            end
            Configuration.TargetPlayersDropdownValues = Cache
            TargetPlayersDropdown:SetValues(Configuration.TargetPlayersDropdownValues)
            Window:Dialog({
                Title = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"),
                Content = Items == 0 and "Nothing has been cleared!" or Items == 1 and "1 Item has been cleared!" or string.format("%s Items have been cleared!", Items),
                Buttons = {
                    {
                        Title = "Confirm"
                    }
                }
            })
        end
    })

    local PremiumChecksSection = Tabs.Checks:AddSection("Premium Checks")

    local PremiumCheckToggle = PremiumChecksSection:AddToggle("PremiumCheck", { Title = "Premium Check", Description = "Toggles the Premium Check", Default = Configuration.PremiumCheck })
    PremiumCheckToggle:OnChanged(function(Value)
        Configuration.PremiumCheck = Value
    end)

    PremiumChecksSection:AddParagraph({
        Title = string.format("%s 💫PREMIUM💫", string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")),
        Content = "✨Upgrade to unlock all Options✨\nContact @ttwiz_z via Discord to buy"
    })

    if DEBUG or getfenv().Drawing and getfenv().Drawing.new then
        Tabs.Visuals = Window:AddTab({ Title = "Visuals", Icon = "box" })

        Tabs.Visuals:AddParagraph({
            Title = string.format("%s 🔥FREE🔥", string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")),
            Content = "✨Universal Aim Assist Framework✨\nhttps://github.com/ttwizz/Open-Aimbot"
        })

        local FoVSection = Tabs.Visuals:AddSection("FoV")

        local FoVToggle = FoVSection:AddToggle("FoV", { Title = "FoV", Description = "Graphically Displays the FoV Radius", Default = Configuration.FoV })
        FoVToggle:OnChanged(function(Value)
            Configuration.FoV = Value
            if not IsComputer then
                ShowingFoV = Value
            end
        end)

        if IsComputer then
            local FoVKeybind = FoVSection:AddKeybind("FoVKey", {
                Title = "FoV Key",
                Description = "Changes the FoV Key",
                Default = Configuration.FoVKey,
                ChangedCallback = function(Value)
                    Configuration.FoVKey = Value
                end
            })
            Configuration.FoVKey = FoVKeybind.Value ~= "RMB" and Enum.KeyCode[FoVKeybind.Value] or Enum.UserInputType.MouseButton2
        end

        FoVSection:AddSlider("FoVThickness", {
            Title = "FoV Thickness",
            Description = "Changes the FoV Thickness",
            Default = Configuration.FoVThickness,
            Min = 1,
            Max = 10,
            Rounding = 1,
            Callback = function(Value)
                Configuration.FoVThickness = Value
            end
        })

        FoVSection:AddSlider("FoVOpacity", {
            Title = "FoV Opacity",
            Description = "Changes the FoV Opacity",
            Default = Configuration.FoVOpacity,
            Min = 0.1,
            Max = 1,
            Rounding = 1,
            Callback = function(Value)
                Configuration.FoVOpacity = Value
            end
        })

        local FoVFilledToggle = FoVSection:AddToggle("FoVFilled", { Title = "FoV Filled", Description = "Makes the FoV Filled", Default = Configuration.FoVFilled })
        FoVFilledToggle:OnChanged(function(Value)
            Configuration.FoVFilled = Value
        end)

        FoVSection:AddColorpicker("FoVColour", {
            Title = "FoV Colour",
            Description = "Changes the FoV Colour",
            Default = Configuration.FoVColour,
            Callback = function(Value)
                Configuration.FoVColour = Value
            end
        })

        local ESPSection = Tabs.Visuals:AddSection("ESP")

        local SmartESPToggle = ESPSection:AddToggle("SmartESP", { Title = "Smart ESP", Description = "Does not ESP the Whitelisted Players", Default = Configuration.SmartESP })
        SmartESPToggle:OnChanged(function(Value)
            Configuration.SmartESP = Value
        end)

        if IsComputer then
            local ESPKeybind = ESPSection:AddKeybind("ESPKey", {
                Title = "ESP Key",
                Description = "Changes the ESP Key",
                Default = Configuration.ESPKey,
                ChangedCallback = function(Value)
                    Configuration.ESPKey = Value
                end
            })
            Configuration.ESPKey = ESPKeybind.Value ~= "RMB" and Enum.KeyCode[ESPKeybind.Value] or Enum.UserInputType.MouseButton2
        end

        local ESPBoxToggle = ESPSection:AddToggle("ESPBox", { Title = "ESP Box", Description = "Creates the ESP Box around the Players", Default = Configuration.ESPBox })
        ESPBoxToggle:OnChanged(function(Value)
            Configuration.ESPBox = Value
            if not IsComputer then
                if Value then
                    ShowingESP = true
                elseif not Configuration.ESPBox and not Configuration.NameESP and not Configuration.HealthESP and not Configuration.MagnitudeESP and not Configuration.TracerESP then
                    ShowingESP = false
                end
            end
        end)

        local ESPBoxFilledToggle = ESPSection:AddToggle("ESPBoxFilled", { Title = "ESP Box Filled", Description = "Makes the ESP Box Filled", Default = Configuration.ESPBoxFilled })
        ESPBoxFilledToggle:OnChanged(function(Value)
            Configuration.ESPBoxFilled = Value
        end)

        local NameESPToggle = ESPSection:AddToggle("NameESP", { Title = "Name ESP", Description = "Creates the Name ESP above the Players", Default = Configuration.NameESP })
        NameESPToggle:OnChanged(function(Value)
            Configuration.NameESP = Value
            if not IsComputer then
                if Value then
                    ShowingESP = true
                elseif not Configuration.ESPBox and not Configuration.NameESP and not Configuration.HealthESP and not Configuration.MagnitudeESP and not Configuration.TracerESP then
                    ShowingESP = false
                end
            end
        end)

        ESPSection:AddDropdown("NameESPFont", {
            Title = "Name ESP Font",
            Description = "Changes the Name ESP Font",
            Values = { "UI", "System", "Plex", "Monospace" },
            Default = Configuration.NameESPFont,
            Callback = function(Value)
                Configuration.NameESPFont = Value
            end
        })

        ESPSection:AddSlider("NameESPSize", {
            Title = "Name ESP Size",
            Description = "Changes the Name ESP Size",
            Default = Configuration.NameESPSize,
            Min = 8,
            Max = 28,
            Rounding = 1,
            Callback = function(Value)
                Configuration.NameESPSize = Value
            end
        })

        ESPSection:AddColorpicker("NameESPOutlineColour", {
            Title = "Name ESP Outline",
            Description = "Changes the Name ESP Outline Colour",
            Default = Configuration.NameESPOutlineColour,
            Callback = function(Value)
                Configuration.NameESPOutlineColour = Value
            end
        })

        local HealthESPToggle = ESPSection:AddToggle("HealthESP", { Title = "Health ESP", Description = "Creates the Health ESP in the ESP Box", Default = Configuration.HealthESP })
        HealthESPToggle:OnChanged(function(Value)
            Configuration.HealthESP = Value
            if not IsComputer then
                if Value then
                    ShowingESP = true
                elseif not Configuration.ESPBox and not Configuration.NameESP and not Configuration.HealthESP and not Configuration.MagnitudeESP and not Configuration.TracerESP then
                    ShowingESP = false
                end
            end
        end)

        local MagnitudeESPToggle = ESPSection:AddToggle("MagnitudeESP", { Title = "Magnitude ESP", Description = "Creates the Magnitude ESP in the ESP Box", Default = Configuration.MagnitudeESP })
        MagnitudeESPToggle:OnChanged(function(Value)
            Configuration.MagnitudeESP = Value
            if not IsComputer then
                if Value then
                    ShowingESP = true
                elseif not Configuration.ESPBox and not Configuration.NameESP and not Configuration.HealthESP and not Configuration.MagnitudeESP and not Configuration.TracerESP then
                    ShowingESP = false
                end
            end
        end)

        local TracerESPToggle = ESPSection:AddToggle("TracerESP", { Title = "Tracer ESP", Description = "Creates the Tracer ESP in the direction of the Players", Default = Configuration.TracerESP })
        TracerESPToggle:OnChanged(function(Value)
            Configuration.TracerESP = Value
            if not IsComputer then
                if Value then
                    ShowingESP = true
                elseif not Configuration.ESPBox and not Configuration.NameESP and not Configuration.HealthESP and not Configuration.MagnitudeESP and not Configuration.TracerESP then
                    ShowingESP = false
                end
            end
        end)

        ESPSection:AddSlider("ESPThickness", {
            Title = "ESP Thickness",
            Description = "Changes the ESP Thickness",
            Default = Configuration.ESPThickness,
            Min = 1,
            Max = 10,
            Rounding = 1,
            Callback = function(Value)
                Configuration.ESPThickness = Value
            end
        })

        ESPSection:AddSlider("ESPOpacity", {
            Title = "ESP Opacity",
            Description = "Changes the ESP Opacity",
            Default = Configuration.ESPOpacity,
            Min = 0.1,
            Max = 1,
            Rounding = 1,
            Callback = function(Value)
                Configuration.ESPOpacity = Value
            end
        })

        ESPSection:AddColorpicker("ESPColour", {
            Title = "ESP Colour",
            Description = "Changes the ESP Colour",
            Default = Configuration.ESPColour,
            Callback = function(Value)
                Configuration.ESPColour = Value
            end
        })

        local ESPUseTeamColourToggle = ESPSection:AddToggle("ESPUseTeamColour", { Title = "Use Team Colour", Description = "Makes the ESP Colour match the Target Player Team", Default = Configuration.ESPUseTeamColour })
        ESPUseTeamColourToggle:OnChanged(function(Value)
            Configuration.ESPUseTeamColour = Value
        end)

        local VisualsSection = Tabs.Visuals:AddSection("Visuals")

        local RainbowVisualsToggle = VisualsSection:AddToggle("RainbowVisuals", { Title = "Rainbow Visuals", Description = "Makes the Visuals Rainbow", Default = Configuration.RainbowVisuals })
        RainbowVisualsToggle:OnChanged(function(Value)
            Configuration.RainbowVisuals = Value
        end)

        VisualsSection:AddSlider("RainbowDelay", {
            Title = "Rainbow Delay",
            Description = "Changes the Rainbow Delay",
            Default = Configuration.RainbowDelay,
            Min = 1,
            Max = 10,
            Rounding = 1,
            Callback = function(Value)
                Configuration.RainbowDelay = Value
            end
        })
    else
        ShowWarning = true
    end

    Tabs.Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })

    Tabs.Settings:AddParagraph({
        Title = string.format("%s 🔥FREE🔥", string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")),
        Content = "✨Universal Aim Assist Framework✨\nhttps://github.com/ttwizz/Open-Aimbot"
    })

    local UISection = Tabs.Settings:AddSection("UI")

    UISection:AddDropdown("Theme", {
        Title = "Theme",
        Description = "Changes the UI Theme",
        Values = Fluent.Themes,
        Default = Fluent.Theme,
        Callback = function(Value)
            Fluent:SetTheme(Value)
            UISettings.Theme = Value
            InterfaceManager:ExportSettings()
        end
    })

    if Fluent.UseAcrylic then
        UISection:AddToggle("Acrylic", {
            Title = "Acrylic",
            Description = "Blurred Background requires Graphic Quality >= 8",
            Default = Fluent.Acrylic,
            Callback = function(Value)
                if not Value or not UISettings.ShowWarnings then
                    Fluent:ToggleAcrylic(Value)
                elseif UISettings.ShowWarnings then
                    Window:Dialog({
                        Title = "Warning",
                        Content = "This Option can be detected! Activate it anyway?",
                        Buttons = {
                            {
                                Title = "Confirm",
                                Callback = function()
                                    Fluent:ToggleAcrylic(Value)
                                end
                            },
                            {
                                Title = "Cancel",
                                Callback = function()
                                    Fluent.Options.Acrylic:SetValue(false)
                                end
                            }
                        }
                    })
                end
            end
        })
    end

    UISection:AddToggle("Transparency", {
        Title = "Transparency",
        Description = "Makes the UI Transparent",
        Default = UISettings.Transparency,
        Callback = function(Value)
            Fluent:ToggleTransparency(Value)
            UISettings.Transparency = Value
            InterfaceManager:ExportSettings()
        end
    })

    if IsComputer then
        UISection:AddKeybind("MinimizeKey", {
            Title = "Minimize Key",
            Description = "Changes the Minimize Key",
            Default = Fluent.MinimizeKey,
            ChangedCallback = function()
                UISettings.MinimizeKey = Fluent.Options.MinimizeKey.Value
                InterfaceManager:ExportSettings()
            end
        })
        Fluent.MinimizeKeybind = Fluent.Options.MinimizeKey
    end

    local NotificationsWarningsSection = Tabs.Settings:AddSection("Notifications & Warnings")

    local NotificationsToggle = NotificationsWarningsSection:AddToggle("ShowNotifications", { Title = "Show Notifications", Description = "Toggles the Notifications Show", Default = UISettings.ShowNotifications })
    NotificationsToggle:OnChanged(function(Value)
        Fluent.ShowNotifications = Value
        UISettings.ShowNotifications = Value
        InterfaceManager:ExportSettings()
    end)

    local WarningsToggle = NotificationsWarningsSection:AddToggle("ShowWarnings", { Title = "Show Warnings", Description = "Toggles the Security Warnings Show", Default = UISettings.ShowWarnings })
    WarningsToggle:OnChanged(function(Value)
        UISettings.ShowWarnings = Value
        InterfaceManager:ExportSettings()
    end)

    local PerformanceSection = Tabs.Settings:AddSection("Performance")

    PerformanceSection:AddParagraph({
        Title = "NOTE",
        Content = "Heartbeat fires every frame, after the physics simulation has completed. RenderStepped fires every frame, prior to the frame being rendered. Stepped fires every frame, prior to the physics simulation."
    })

    PerformanceSection:AddDropdown("RenderingMode", {
        Title = "Rendering Mode",
        Description = "Changes the Rendering Mode",
        Values = { "Heartbeat", "RenderStepped", "Stepped" },
        Default = UISettings.RenderingMode,
        Callback = function(Value)
            UISettings.RenderingMode = Value
            InterfaceManager:ExportSettings()
            Window:Dialog({
                Title = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"),
                Content = "Changes will take effect after the Restart!",
                Buttons = {
                    {
                        Title = "Confirm"
                    }
                }
            })
        end
    })

    if getfenv().isfile and getfenv().readfile and getfenv().writefile and getfenv().delfile then
        local ConfigurationManager = Tabs.Settings:AddSection("Configuration Manager")

        local AutoImportToggle = ConfigurationManager:AddToggle("AutoImport", { Title = "Auto Import", Description = "Toggles the Auto Import", Default = UISettings.AutoImport })
        AutoImportToggle:OnChanged(function(Value)
            UISettings.AutoImport = Value
            InterfaceManager:ExportSettings()
        end)

        ConfigurationManager:AddParagraph({
            Title = string.format("Manager for %s", game.Name),
            Content = string.format("Universe ID is %s", game.GameId)
        })

        ConfigurationManager:AddButton({
            Title = "Import Configuration File",
            Description = "Loads the Game Configuration File",
            Callback = function()
                xpcall(function()
                    if getfenv().isfile(string.format("%s.ttwizz", game.GameId)) and getfenv().readfile(string.format("%s.ttwizz", game.GameId)) then
                        local ImportedConfiguration = HttpService:JSONDecode(getfenv().readfile(string.format("%s.ttwizz", game.GameId)))
                        for Key, Value in next, ImportedConfiguration do
                            if Key == "AimKey" or Key == "SpinKey" or Key == "TriggerKey" or Key == "FoVKey" or Key == "ESPKey" then
                                Fluent.Options[Key]:SetValue(Value)
                                Configuration[Key] = Value ~= "RMB" and Enum.KeyCode[Value] or Enum.UserInputType.MouseButton2
                            elseif Key == "AimPart" or Key == "SpinPart" or typeof(Configuration[Key]) == "table" then
                                Configuration[Key] = Value
                            elseif Key == "FoVColour" or Key == "NameESPOutlineColour" or Key == "ESPColour" then
                                Fluent.Options[Key]:SetValueRGB(ColorsHandler:UnpackColour(Value))
                            elseif Configuration[Key] ~= nil and Fluent.Options[Key] then
                                Fluent.Options[Key]:SetValue(Value)
                            end
                        end
                        for Key, Option in next, Fluent.Options do
                            if Option.Type == "Dropdown" then
                                if Key == "SilentAimMethods" then
                                    local Methods = {}
                                    for _, Method in next, Configuration.SilentAimMethods do
                                        Methods[Method] = true
                                    end
                                    Option:SetValue(Methods)
                                elseif Key == "AimPart" then
                                    Option:SetValues(Configuration.AimPartDropdownValues)
                                    Option:SetValue(Configuration.AimPart)
                                elseif Key == "SpinPart" then
                                    Option:SetValues(Configuration.SpinPartDropdownValues)
                                    Option:SetValue(Configuration.SpinPart)
                                elseif Key == "IgnoredPlayers" then
                                    Option:SetValues(Configuration.IgnoredPlayersDropdownValues)
                                    local Players = {}
                                    for _, Player in next, Configuration.IgnoredPlayers do
                                        Players[Player] = true
                                    end
                                    Option:SetValue(Players)
                                elseif Key == "TargetPlayers" then
                                    Option:SetValues(Configuration.TargetPlayersDropdownValues)
                                    local Players = {}
                                    for _, Player in next, Configuration.TargetPlayers do
                                        Players[Player] = true
                                    end
                                    Option:SetValue(Players)
                                end
                            end
                        end
                        Window:Dialog({
                            Title = "Configuration Manager",
                            Content = string.format("Configuration File %s.ttwizz has been successfully loaded!", game.GameId),
                            Buttons = {
                                {
                                    Title = "Confirm"
                                }
                            }
                        })
                    else
                        Window:Dialog({
                            Title = "Configuration Manager",
                            Content = string.format("Configuration File %s.ttwizz could not be found!", game.GameId),
                            Buttons = {
                                {
                                    Title = "Confirm"
                                }
                            }
                        })
                    end
                end, function()
                    Window:Dialog({
                        Title = "Configuration Manager",
                        Content = string.format("An Error occurred when loading the Configuration File %s.ttwizz", game.GameId),
                        Buttons = {
                            {
                                Title = "Confirm"
                            }
                        }
                    })
                end)
            end
        })

        ConfigurationManager:AddButton({
            Title = "Export Configuration File",
            Description = "Overwrites the Game Configuration File",
            Callback = function()
                xpcall(function()
                    local ExportedConfiguration = { __LAST_UPDATED__ = os.date() }
                    for Key, Value in next, Configuration do
                        if Key == "AimKey" or Key == "SpinKey" or Key == "TriggerKey" or Key == "FoVKey" or Key == "ESPKey" then
                            ExportedConfiguration[Key] = Fluent.Options[Key].Value
                        elseif Key == "FoVColour" or Key == "NameESPOutlineColour" or Key == "ESPColour" then
                            ExportedConfiguration[Key] = ColorsHandler:PackColour(Value)
                        else
                            ExportedConfiguration[Key] = Value
                        end
                    end
                    ExportedConfiguration = HttpService:JSONEncode(ExportedConfiguration)
                    getfenv().writefile(string.format("%s.ttwizz", game.GameId), ExportedConfiguration)
                    Window:Dialog({
                        Title = "Configuration Manager",
                        Content = string.format("Configuration File %s.ttwizz has been successfully overwritten!", game.GameId),
                        Buttons = {
                            {
                                Title = "Confirm"
                            }
                        }
                    })
                end, function()
                    Window:Dialog({
                        Title = "Configuration Manager",
                        Content = string.format("An Error occurred when overwriting the Configuration File %s.ttwizz", game.GameId),
                        Buttons = {
                            {
                                Title = "Confirm"
                            }
                        }
                    })
                end)
            end
        })

        ConfigurationManager:AddButton({
            Title = "Delete Configuration File",
            Description = "Removes the Game Configuration File",
            Callback = function()
                if getfenv().isfile(string.format("%s.ttwizz", game.GameId)) then
                    getfenv().delfile(string.format("%s.ttwizz", game.GameId))
                    Window:Dialog({
                        Title = "Configuration Manager",
                        Content = string.format("Configuration File %s.ttwizz has been successfully removed!", game.GameId),
                        Buttons = {
                            {
                                Title = "Confirm"
                            }
                        }
                    })
                else
                    Window:Dialog({
                        Title = "Configuration Manager",
                        Content = string.format("Configuration File %s.ttwizz could not be found!", game.GameId),
                        Buttons = {
                            {
                                Title = "Confirm"
                            }
                        }
                    })
                end
            end
        })
    else
        ShowWarning = true
    end

    local DiscordWikiSection = Tabs.Settings:AddSection("Discord & Wiki")

    if getfenv().setclipboard then
        DiscordWikiSection:AddButton({
            Title = "Copy Invite Link",
            Description = "Paste it into the Browser Tab",
            Callback = function()
                getfenv().setclipboard("https://twix.cyou/pix")
                Window:Dialog({
                    Title = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"),
                    Content = "Invite Link has been copied to the Clipboard!",
                    Buttons = {
                        {
                            Title = "Confirm"
                        }
                    }
                })
            end
        })

        DiscordWikiSection:AddButton({
            Title = "Copy Wiki Link",
            Description = "Paste it into the Browser Tab",
            Callback = function()
                getfenv().setclipboard("https://moderka.org/Open-Aimbot")
                Window:Dialog({
                    Title = string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot"),
                    Content = "Wiki Link has been copied to the Clipboard!",
                    Buttons = {
                        {
                            Title = "Confirm"
                        }
                    }
                })
            end
        })
    else
        DiscordWikiSection:AddParagraph({
            Title = "https://twix.cyou/pix",
            Content = "Paste it into the Browser Tab"
        })

        DiscordWikiSection:AddParagraph({
            Title = "https://moderka.org/Open-Aimbot",
            Content = "Paste it into the Browser Tab"
        })
    end

    if UISettings.ShowWarnings then
        if DEBUG then
            Window:Dialog({
                Title = "Warning",
                Content = "Running in Debugging Mode. Some Features may not work properly.",
                Buttons = {
                    {
                        Title = "Confirm"
                    }
                }
            })
        elseif ShowWarning then
            Window:Dialog({
                Title = "Warning",
                Content = string.format("Your Software does not support all the Features of %s 🔥FREE🔥!", string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")),
                Buttons = {
                    {
                        Title = "Confirm"
                    }
                }
            })
        else
            Window:Dialog({
                Title = string.format("%s 💫PREMIUM💫", string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")),
                Content = "✨Upgrade to unlock all Options✨ – Contact @ttwiz_z via Discord to buy",
                Buttons = {
                    {
                        Title = "Confirm"
                    }
                }
            })
        end
    end
end


