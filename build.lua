-- build.lua
-- Rode este arquivo com Lua no terminal se quiser juntar os arquivos em um script único.
-- Comando exemplo: lua build.lua

local ordem = {
    "services.lua",
    "save.lua",
    "config.lua",
    "ui.lua",
    "functions.lua",
    "checks.lua",
    "visuals.lua",
    "main.lua"
}

local saida = {}

for _, arquivo in ipairs(ordem) do
    local f = assert(io.open(arquivo, "r"))
    table.insert(saida, "\n\n--// ===== " .. arquivo .. " ===== //\n\n")
    table.insert(saida, f:read("*a"))
    f:close()
end

local out = assert(io.open("OpenAimbot.bundle.lua", "w"))
out:write(table.concat(saida))
out:close()

print("Arquivo gerado: OpenAimbot.bundle.lua")
