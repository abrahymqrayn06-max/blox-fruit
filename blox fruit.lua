-- ==========================================
local WebhookURL = "https://discord.com/api/webhooks/1554143117282902088/yoawXy-551Q6bXIpiX4tx0Ukm7Mh5m_X0ODo1MSVKGjz0Gtf72dfe5Yg0gpWhM2KvaFI"
-- ==========================================

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local JobId = game.JobId
local PlaceId = game.PlaceId

-- دالة جلب فواكه الستوك (Stock) من اللعبة
local function getBloxFruitsStock()
    local stockList = {}
    pcall(function()
        local success, result = pcall(function()
            return ReplicatedStorage.Modules.Net:Invoke("GetFruitsStock") 
        end)
        if success and result then
            for _, fruit in pairs(result) do
                table.insert(stockList, tostring(fruit))
            end
        end
    end)
    
    if #stockList == 0 then
        table.insert(stockList, "افتح نافذة بائع الفواكه لتحديث الستوك")
    end
    
    return table.concat(stockList, ", ")
end

-- فحص الفواكه المرسبنة في الماب
local foundFruits = {}
pcall(function()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Tool") and (v.Name:find("Fruit") or v:FindFirstChild("Handle")) then
            table.insert(foundFruits, v.Name)
        end
    end
end)

local fruitsInMapText = #foundFruits > 0 and table.concat(foundFruits, ", ") or "لا توجد فواكه مرسبنة حالياً في الماب"
local stockText = getBloxFruitsStock()

-- تجهيز بيانات الرسالة لإرسالها للديسكورد
local data = {
    ["content"] = "@everyone 🚨 **تقرير فواكه بلوكس فريتس الجديد!**",
    ["embeds"] = {{
        ["title"] = "🍍 معلومات السيرفر والفواكه",
        ["color"] = 16753920,
        ["fields"] = {
            {
                ["name"] = "🛒 فواكه الستوك (Stock):",
                ["value"] = "```" .. stockText .. "```",
                ["inline"] = false
            },
            {
                ["name"] = "🗺️ الفواكه المرسبنة في الماب:",
                ["value"] = "```" .. fruitsInMapText .. "```",
                ["inline"] = false
            },
            {
                ["name"] = "🌐 كود السيرفر (JobId):",
                ["value"] = "```" .. JobId .. "```",
                ["inline"] = false
            },
            {
                ["name"] = "⚙️ أمر الدخول السريع (شغله بديلتا):",
                ["value"] = "```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance(" .. PlaceId .. ", '" .. JobId .. "')\n```",
                ["inline"] = false
            }
        }
    }}
}

-- إرسال البيانات عبر الـ Webhook
local request = http_request or request or HttpPost or syn.request
if request then
    local success, err = pcall(function()
        request({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
    if success then
        print("تم إرسال التقرير إلى الديسكورد بنجاح!")
    else
        print("فشل الإرسال، تحقق من الاتصال.")
    end
else
    print("الـ Executor لا يدعم خاصية الـ Request.")
end
