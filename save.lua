--[[
    Arquivo separado automaticamente a partir do seu código original.
    Observação: esses arquivos foram separados para organização no VS Code.
    Para gerar o script final único, use o build.lua deste pacote ou copie na ordem indicada no README.
]]

--! Interface Manager

local UISettings = {
    TabWidth = 160,
    Size = { 580, 460 },
    Theme = "VSC Dark High Contrast",
    Acrylic = false,
    Transparency = true,
    MinimizeKey = "RightShift",
    ShowNotifications = true,
    ShowWarnings = true,
    RenderingMode = "RenderStepped",
    AutoImport = true
}

local InterfaceManager = {}

function InterfaceManager:ImportSettings()
    pcall(function()
        if not DEBUG and getfenv().isfile and getfenv().readfile and getfenv().isfile("UISettings.ttwizz") and getfenv().readfile("UISettings.ttwizz") then
            for Key, Value in next, HttpService:JSONDecode(getfenv().readfile("UISettings.ttwizz")) do
                UISettings[Key] = Value
            end
        end
    end)
end

function InterfaceManager:ExportSettings()
    pcall(function()
        if not DEBUG and getfenv().isfile and getfenv().readfile and getfenv().writefile then
            getfenv().writefile("UISettings.ttwizz", HttpService:JSONEncode(UISettings))
        end
    end)
end

InterfaceManager:ImportSettings()

UISettings.__LAST_RUN__ = os.date()
InterfaceManager:ExportSettings()


--! Colors Handler

local ColorsHandler = {}

function ColorsHandler:PackColour(Colour)
    return typeof(Colour) == "Color3" and { R = Colour.R * 255, G = Colour.G * 255, B = Colour.B * 255 } or typeof(Colour) == "table" and Colour or { R = 255, G = 255, B = 255 }
end

function ColorsHandler:UnpackColour(Colour)
    return typeof(Colour) == "table" and Color3.fromRGB(Colour.R, Colour.G, Colour.B) or typeof(Colour) == "Color3" and Colour or Color3.fromRGB(255, 255, 255)
end


--! Configuration Importer

local ImportedConfiguration = {}

pcall(function()
    if not DEBUG and getfenv().isfile and getfenv().readfile and getfenv().isfile(string.format("%s.ttwizz", game.GameId)) and getfenv().readfile(string.format("%s.ttwizz", game.GameId)) and UISettings.AutoImport then
        ImportedConfiguration = HttpService:JSONDecode(getfenv().readfile(string.format("%s.ttwizz", game.GameId)))
        for Key, Value in next, ImportedConfiguration do
            if Key == "FoVColour" or Key == "NameESPOutlineColour" or Key == "ESPColour" then
                ImportedConfiguration[Key] = ColorsHandler:UnpackColour(Value)
            end
        end
    end
end)


