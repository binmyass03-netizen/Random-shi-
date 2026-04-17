-- OPTIMIZED + UPDATED WEBHOOK (LOW LAG VERSION)

local HttpService = game:GetService("HttpService")

local WEBHOOK = "https://discord.com/api/webhooks/1494489555490046073/QC9DzTBs1RhLEZWskHthgjiqoxxkLfabydTmoyH4Odx3CAdGHRIMxZNNmhPd0iSSH9BL"

local MIN_VALUE = 10000
local sentCache = {}

-- detect executor request
local httpRequest = (syn and syn.request) or (http and http.request) or request

local function getServerLink()
    return "https://www.roblox.com/games/"..game.PlaceId.."?jobId="..game.JobId
end

local function sendWebhook(animal)
    local data = {
        embeds = {{
            title = "🔥 High Value Animal",
            description = "**"..animal.name.."**",
            color = 65280,
            fields = {
                {name="💎 Value", value=animal.genText, inline=true},
                {name="⭐ Rarity", value=animal.rarity, inline=true},
                {name="👤 Owner", value=animal.owner, inline=true},
                {name="🌐 Server", value="[Join]("..getServerLink()..")", inline=false}
            }
        }}
    }

    local json = HttpService:JSONEncode(data)

    if httpRequest then
        task.spawn(function()
            pcall(function()
                httpRequest({
                    Url = WEBHOOK,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = json
                })
            end)
        end)
    end
end

-- PERFORMANCE LOOP (LESS LAG)
task.spawn(function()
    while true do
        task.wait(0.5) -- slower loop = less lag

        for _, animal in pairs(allAnimalsCache or {}) do
            if animal.genValue >= MIN_VALUE then
                local id = animal.uid

                if not sentCache[id] then
                    sentCache[id] = true
                    sendWebhook(animal)
                end
            end
        end
    end
end)

print("Optimized webhook loaded")
