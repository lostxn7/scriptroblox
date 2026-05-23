--[[
    Arquivo separado automaticamente a partir do seu código original.
    Observação: esses arquivos foram separados para organização no VS Code.
    Para gerar o script final único, use o build.lua deste pacote ou copie na ordem indicada no README.
]]

--! Notifications Handler

local function Notify(Message)
    if Fluent and typeof(Message) == "string" then
        Fluent:Notify({
            Title = string.format("%s 🔥FREE🔥", string.format(MonthlyLabels[os.date("*t").month], "Open Aimbot")),
            Content = Message,
            SubContent = "By @ttwiz_z",
            Duration = 1.5
        })
    end
end

Notify("✨Upgrade to unlock all Options✨")


--! Fields Handler

local FieldsHandler = {}

function FieldsHandler:ResetAimbotFields(SaveAiming, SaveTarget)
    Aiming = SaveAiming and Aiming or false
    Target = SaveTarget and Target or nil
    if Tween then
        Tween:Cancel()
        Tween = nil
    end
    UserInputService.MouseDeltaSensitivity = MouseSensitivity
end

function FieldsHandler:ResetSecondaryFields()
    Spinning = false
    Triggering = false
    ShowingFoV = false
    ShowingESP = false
end


--! Input Handler

do
    if IsComputer then
        local InputBegan; InputBegan = UserInputService.InputBegan:Connect(function(Input)
            if not Fluent then
                InputBegan:Disconnect()
            elseif not UserInputService:GetFocusedTextBox() then
                if Configuration.Aimbot and (Input.KeyCode == Configuration.AimKey or Input.UserInputType == Configuration.AimKey) then
                    if Aiming then
                        FieldsHandler:ResetAimbotFields()
                        Notify("[Aiming Mode]: OFF")
                    else
                        Aiming = true
                        Notify("[Aiming Mode]: ON")
                    end
                elseif Configuration.SpinBot and (Input.KeyCode == Configuration.SpinKey or Input.UserInputType == Configuration.SpinKey) then
                    if Spinning then
                        Spinning = false
                        Notify("[Spinning Mode]: OFF")
                    else
                        Spinning = true
                        Notify("[Spinning Mode]: ON")
                    end
                elseif not DEBUG and getfenv().mouse1click and Configuration.TriggerBot and (Input.KeyCode == Configuration.TriggerKey or Input.UserInputType == Configuration.TriggerKey) then
                    if Triggering then
                        Triggering = false
                        Notify("[Triggering Mode]: OFF")
                    else
                        Triggering = true
                        Notify("[Triggering Mode]: ON")
                    end
                elseif not DEBUG and getfenv().Drawing and getfenv().Drawing.new and Configuration.FoV and (Input.KeyCode == Configuration.FoVKey or Input.UserInputType == Configuration.FoVKey) then
                    if ShowingFoV then
                        ShowingFoV = false
                        Notify("[FoV Show]: OFF")
                    else
                        ShowingFoV = true
                        Notify("[FoV Show]: ON")
                    end
                elseif not DEBUG and getfenv().Drawing and getfenv().Drawing.new and (Configuration.ESPBox or Configuration.NameESP or Configuration.HealthESP or Configuration.MagnitudeESP or Configuration.TracerESP) and (Input.KeyCode == Configuration.ESPKey or Input.UserInputType == Configuration.ESPKey) then
                    if ShowingESP then
                        ShowingESP = false
                        Notify("[ESP Show]: OFF")
                    else
                        ShowingESP = true
                        Notify("[ESP Show]: ON")
                    end
                end
            end
        end)

        local InputEnded; InputEnded = UserInputService.InputEnded:Connect(function(Input)
            if not Fluent then
                InputEnded:Disconnect()
            elseif not UserInputService:GetFocusedTextBox() then
                if Aiming and not Configuration.OnePressAimingMode and (Input.KeyCode == Configuration.AimKey or Input.UserInputType == Configuration.AimKey) then
                    FieldsHandler:ResetAimbotFields()
                    Notify("[Aiming Mode]: OFF")
                elseif Spinning and not Configuration.OnePressSpinningMode and (Input.KeyCode == Configuration.SpinKey or Input.UserInputType == Configuration.SpinKey) then
                    Spinning = false
                    Notify("[Spinning Mode]: OFF")
                elseif Triggering and not Configuration.OnePressTriggeringMode and (Input.KeyCode == Configuration.TriggerKey or Input.UserInputType == Configuration.TriggerKey) then
                    Triggering = false
                    Notify("[Triggering Mode]: OFF")
                end
            end
        end)

        local WindowFocused; WindowFocused = UserInputService.WindowFocused:Connect(function()
            if not Fluent then
                WindowFocused:Disconnect()
            else
                RobloxActive = true
            end
        end)

        local WindowFocusReleased; WindowFocusReleased = UserInputService.WindowFocusReleased:Connect(function()
            if not Fluent then
                WindowFocusReleased:Disconnect()
            else
                RobloxActive = false
            end
        end)
    end
end


--! Math Handler

local MathHandler = {}

function MathHandler:CalculateDirection(Origin, Position, Magnitude)
    return typeof(Origin) == "Vector3" and typeof(Position) == "Vector3" and typeof(Magnitude) == "number" and (Position - Origin).Unit * Magnitude or Vector3.zero
end

function MathHandler:CalculateChance(Percentage)
    return typeof(Percentage) == "number" and math.round(math.clamp(Percentage, 1, 100)) / 100 >= math.round(Random.new():NextNumber() * 100) / 100 or false
end

function MathHandler:Abbreviate(Number)
    if typeof(Number) == "number" then
        local Abbreviations = {
            D = 10 ^ 33,
            N = 10 ^ 30,
            O = 10 ^ 27,
            Sp = 10 ^ 24,
            Sx = 10 ^ 21,
            Qn = 10 ^ 18,
            Qd = 10 ^ 15,
            T = 10 ^ 12,
            B = 10 ^ 9,
            M = 10 ^ 6,
            K = 10 ^ 3
        }
        local Selected = 0
        local Result = tostring(math.round(Number))
        for Key, Value in next, Abbreviations do
            if math.abs(Number) < 10 ^ 36 then
                if math.abs(Number) >= Value and Value > Selected then
                    Selected = Value
                    Result = string.format("%s%s", tostring(math.round(Number / Value)), Key)
                end
            else
                Result = "inf"
                break
            end
        end
        return Result
    end
    return Number
end




--[[ Continuaçao de functions.lua ]]

--! Bots Handler

local function HandleBots()
    if Spinning and Configuration.SpinPart and Player.Character and Player.Character:FindFirstChildWhichIsA("Humanoid") and Player.Character:FindFirstChild(Configuration.SpinPart) and Player.Character:FindFirstChild(Configuration.SpinPart):IsA("BasePart") then
        Player.Character:FindFirstChild(Configuration.SpinPart).CFrame = Player.Character:FindFirstChild(Configuration.SpinPart).CFrame * CFrame.fromEulerAnglesXYZ(0, math.rad(Configuration.SpinBotVelocity), 0)
    end
    if not DEBUG and getfenv().mouse1click and IsComputer and Triggering and (Configuration.SmartTriggerBot and Aiming or not Configuration.SmartTriggerBot) and Mouse.Target and IsReady(Mouse.Target:FindFirstAncestorWhichIsA("Model")) and MathHandler:CalculateChance(Configuration.TriggerBotChance) then
        getfenv().mouse1click()
    end
end


--! Random Parts Handler

local function HandleRandomParts()
    if Fluent and os.clock() - Clock >= 1 then
        if Configuration.RandomAimPart and #Configuration.AimPartDropdownValues > 0 then
            Fluent.Options.AimPart:SetValue(Configuration.AimPartDropdownValues[Random.new():NextInteger(1, #Configuration.AimPartDropdownValues)])
        end
        if Configuration.RandomSpinPart and #Configuration.SpinPartDropdownValues > 0 then
            Fluent.Options.SpinPart:SetValue(Configuration.SpinPartDropdownValues[Random.new():NextInteger(1, #Configuration.SpinPartDropdownValues)])
        end
        Clock = os.clock()
    end
end


