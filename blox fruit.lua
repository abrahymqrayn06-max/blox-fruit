local WebhookURL = "https://discord.com/api/webhooks/1554143117282902088/yoawXy-551Q6bXIpiX4tx0Ukm7Mh5m_X0ODo1MSVKGjz0Gtf72dfe5Yg0gpWhM2KvaFI"
local HttpService = game:GetService("HttpService")
local JobId = game.JobId
local PlaceId = game.PlaceId

local foundFruits = {}
pcall(function()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
            table.insert(foundFruits, v.Name)
        end
    end
end)

local fruitsInMapText = #foundFruits > 0 and table.concat(foundFruits, ", ") or "لا توجد فواكه مرسبنة حالياً"

local data = {
    ["content"] = "@everyone 🚨 **تقرير سيرفر بلوكس فريتس الجديد!**",
    ["embeds"] = {{
        ["title"] = "🍍 معلومات السيرفر والفواكه",
        ["color"] = 16753920,
        ["fields"] = {
            {
                ["name"] = "🗺️ الفواكه المرسبنة:",
                ["value"] = "```" .. fruitsInMapText .. "```",
                ["inline"] = false
            },
            {
                ["name"] = "🌐 كود السيرفر (JobId):",
                ["value"] = "```" .. JobId .. "```",
                ["inline"] = false
            },
            {
                ["name"] = "⚙️ أمر الدخول السريع:",
                ["value"] = "```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance(" .. PlaceId .. ", '" .. JobId .. "')\n```",
                ["inline"] = false
            }
        }
    }}
}

local req = (syn and syn.request) or request or http_request
if req then
    req({
        Url = WebhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(data)
    })
    print("تم الإرسال!")
end
