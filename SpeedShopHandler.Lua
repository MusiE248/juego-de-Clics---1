---- Este es un Script " SpeedShopHandler" y va dentro de "ServerScriptService "------

--- como complementraio este Script debe tener su LocalScript que es el que esta dentro del BuyButton en el Gui "SpeedShopGui
--- este scritp se encarga de que la compra se realize y aqui solo se venden "venta de desarrollador" oseano pongas ID de passes solo "venta de desarrollador" 

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local buyEvent = ReplicatedStorage:WaitForChild("BuySpeedEvent")

local speedProducts = {
	Speed150 = {
		id = 3269361295, 
		amount = 150
	},
	Speed300 = {
		id = 3269362939, 
		amount = 300
	}
}

local pendingPurchase = {}

buyEvent.OnServerEvent:Connect(function(player, productKey)
	local productData = speedProducts[productKey]
	if not productData then return end

	pendingPurchase[player.UserId] = productKey
	MarketplaceService:PromptProductPurchase(player, productData.id)
end)

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end

	local productKey = pendingPurchase[receiptInfo.PlayerId]
	local productData = speedProducts[productKey]

	if productData and productData.id == receiptInfo.ProductId then
		local stats = player:FindFirstChild("leaderstats")
		if stats then
			local speed = stats:FindFirstChild("Velocidad")
			if speed then
				speed.Value += productData.amount
			end
		end
	end

	return Enum.ProductPurchaseDecision.PurchaseGranted
end

