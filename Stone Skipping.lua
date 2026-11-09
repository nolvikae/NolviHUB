-- Mario Hub · Stone Skipping · Script dédié
-- Charge ui.lua + le script de jeu Stone Skipping depuis nolvikae/NolviHUB

if game.GameId ~= 10765298801 then
    game:GetService("Players").LocalPlayer:Kick("Mario Hub: ce script est pour Stone Skipping uniquement")
    return
end

local StarterGui = game:GetService("StarterGui")

local function Notify(text)
    warn("[Mario Hub] " .. text)
    pcall(StarterGui.SetCore, StarterGui, "SendNotification", {
        Title = "Mario Hub",
        Text = text,
        Duration = 10,
    })
end

local function Fetch(url)
    local send = request or http_request or (syn and syn.request) or (http and http.request)
    if type(send) == "function" then
        local ok, res = pcall(send, { Url = url, Method = "GET" })
        if ok then
            if type(res) == "string" then return res end
            if type(res) == "table" then
                return res.Body or res.Content or res.Response or res.text
            end
        end
    end
    local ok2, res2 = pcall(game.HttpGet, game, url)
    if ok2 then
        if type(res2) == "string" then return res2 end
        if type(res2) == "table" then
            return res2.Body or res2.Content or res2.Response or res2.text
        end
    end
    return nil
end

local function CleanBOM(text)
    if type(text) ~= "string" then return text end
    while true do
        local b1, b2, b3 = text:byte(1, 3)
        if b1 == 0xEF and b2 == 0xBB and b3 == 0xBF then
            text = text:sub(4)
        elseif b1 and b1 < 0x20 then
            text = text:sub(2)
        else
            break
        end
    end
    return text
end

-- 1. Charge ui.lua (bibliothèque d'interface)
Notify("Chargement de l'interface...")
local uiSource = Fetch("https://raw.githubusercontent.com/nolvikae/NolviHUB/main/ui.lua")
if not uiSource then
    Notify("Echec: impossible de charger ui.lua")
    return
end
uiSource = CleanBOM(uiSource)
local uiChunk, uiErr = loadstring(uiSource)
if not uiChunk then
    Notify("Echec compilation ui.lua: " .. tostring(uiErr))
    return
end
uiChunk()

-- 2. Charge le script de jeu Stone Skipping
Notify("Chargement de Stone Skipping...")
local gameSource = Fetch("https://raw.githubusercontent.com/nolvikae/NolviHUB/main/All%20Map/old/Stone%20Skipping.lua")
if not gameSource then
    Notify("Echec: impossible de charger Stone Skipping.lua")
    return
end
gameSource = CleanBOM(gameSource)
local gameChunk, gameErr = loadstring(gameSource)
if not gameChunk then
    Notify("Echec compilation Stone Skipping: " .. tostring(gameErr))
    return
end

gameChunk()
Notify("Stone Skipping charge ! Ouvre le menu avec Left Ctrl.")
