-- FULLY FIXED SCRIPT (Delta / Executor Compatible + Fallback)

local HttpService = game:GetService("HttpService")

local WEBHOOK = "https://discord.com/api/webhooks/1494489545406808237/7qxKp_Z3Ilgrntat3rr_n6RaioJyjBLKhYCVpqX9rwjvFyGalRAx5umN-WFJmHskyuG9"

local MIN_VALUE = 10000
local sentCache = {}

-- Detect request function (Delta / Synapse / etc.)
local httpRequest = (syn and syn.request) or (http and http.request) or request

local function getServerLink()
    return "https://www.roblox.com/games/"..game.PlaceId.."?jobId="..game.JobId
end

local function sendWebhook(animal)
    local data = {
        content = "",
        embeds = {{
            title = "🔥 High Value Animal Found!",
            description = "**"..animal.name.."**",
            color = 65280,
            fields = {
                {name="💎 Value", value=animal.genText, inline=true},
                {name="⭐ Rarity", value=animal.rarity, inline=true},
                {name="🧬 Mutation", value=animal.mutation, inline=true},
                {name="📊 Traits", value=animal.traits, inline=false},
                {name="👤 Owner", value=animal.owner, inline=true},
                {name="🌐 Server", value="[Join Server]("..getServerLink()..")", inline=false}
            }
        }}
    }

    local json = HttpService:JSONEncode(data)

    -- Try executor request first
    if httpRequest then
        pcall(function()
            httpRequest({
                Url = WEBHOOK,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = json
            })
        end)
    else
        -- fallback (server only)
        pcall(function()
            HttpService:PostAsync(
                WEBHOOK,
                json,
                Enum.HttpContentType.ApplicationJson
            )
        end)
    end
end

-- EXAMPLE INTEGRATION (put inside your loop)

--[[

if genValue >= MIN_VALUE and not sentCache[uid] then
    sentCache[uid] = true

    sendWebhook({
        name = animalInfo.DisplayName or animalName,
        rarity = rarity,
        mutation = mutation,
        traits = traits,
        genText = "$" .. tostring(genValue) .. "/s",
        owner = owner and owner.Name or "Unknown"
    })
end

]]

print("Webhook system loaded successfully")

