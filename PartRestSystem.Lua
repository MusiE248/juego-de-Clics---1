---- Este es un Script " PartRestSystem" y va dentro de "ServerScriptService "------

local Players = game:GetService("Players")

local partConfig = {
	ParteRoja = 1.5,
	ParteNegra = 3,
	ParteAzulOscuro = 2.5
}


local partFolder = workspace:WaitForChild("PartRest")

local touchingPlayers = {}

local function startDraining(player, partName)
	local key = player.UserId .. "_" .. partName
	if touchingPlayers[key] then return end

	touchingPlayers[key] = true

	local stats = player:FindFirstChild("leaderstats")
	if not stats then return end

	local velocidad = stats:FindFirstChild("Velocidad")
	if not velocidad then return end

	local amount = partConfig[partName] or 1 

	-- Repetir mientras siga tocando
	while touchingPlayers[key] and player.Parent do
		if velocidad.Value > 0 then
			velocidad.Value = math.max(velocidad.Value - amount, 0)
		end

		if velocidad.Value <= 0 then
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid.Health = 0
			end
			touchingPlayers[key] = nil
			break
		end

		wait(1)
	end
end

local function stopDraining(player, partName)
	local key = player.UserId .. "_" .. partName
	touchingPlayers[key] = nil
end

for _, part in pairs(partFolder:GetChildren()) do
	if part:IsA("BasePart") then
		local partName = part.Name

		part.Touched:Connect(function(hit)
			local character = hit:FindFirstAncestorOfClass("Model")
			local player = Players:GetPlayerFromCharacter(character)
			if player then
				startDraining(player, partName)
			end
		end)

		part.TouchEnded:Connect(function(hit)
			local character = hit:FindFirstAncestorOfClass("Model")
			local player = Players:GetPlayerFromCharacter(character)
			if player then
				stopDraining(player, partName)
			end
		end)
	end
end

partFolder.ChildAdded:Connect(function(part)
	if not part:IsA("BasePart") then return end
	local partName = part.Name

	part.Touched:Connect(function(hit)
		local character = hit:FindFirstAncestorOfClass("Model")
		local player = Players:GetPlayerFromCharacter(character)
		if player then
			startDraining(player, partName)
		end
	end)

	part.TouchEnded:Connect(function(hit)
		local character = hit:FindFirstAncestorOfClass("Model")
		local player = Players:GetPlayerFromCharacter(character)
		if player then
			stopDraining(player, partName)
		end
	end)
end)
