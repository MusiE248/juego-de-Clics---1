---- Este es un Script " PortalSystem" y va dentro de "ServerScriptService "------



local Players = game:GetService("Players")

-- Folders
local partFolder = workspace:WaitForChild("PartPortales")
local posFolder = workspace:WaitForChild("TPPosiciones")

local portalRequisitos = {
	ZonaPlaya = { clics = 200, velocidad = 70 },
	ZonaCiudad = { clics = 500, velocidad = 120 },
	ZonaNieve = { clics = 1000, velocidad = 200 }
}

local cooldown = {}

local function teleport(player, destinoPart)
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame = destinoPart.CFrame + Vector3.new(0, 3, 0)
	end
end

local function tryTeleport(player, portalName, desdePartPortales)
	local destinoFolder = desdePartPortales and posFolder or partFolder
	local destino = destinoFolder:FindFirstChild(portalName)

	if not destino or not destino:IsA("BasePart") then return end

	if desdePartPortales then
		local stats = player:FindFirstChild("leaderstats")
		if not stats then return end

		local clics = stats:FindFirstChild("Clics")
		local velocidad = stats:FindFirstChild("Velocidad")
		if not clics or not velocidad then return end

		local requisitos = portalRequisitos[portalName]
		if not requisitos then return end

		if clics.Value >= requisitos.clics and velocidad.Value >= requisitos.velocidad then
			teleport(player, destino)
		end
	else
		teleport(player, destino)
	end
end

local function conectarPortales(folder, desdePartPortales)
	for _, portal in pairs(folder:GetChildren()) do
		if portal:IsA("BasePart") then
			local portalName = portal.Name

			portal.Touched:Connect(function(hit)
				local character = hit:FindFirstAncestorOfClass("Model")
				local player = Players:GetPlayerFromCharacter(character)

				if player and not cooldown[player] then
					cooldown[player] = true
					tryTeleport(player, portalName, desdePartPortales)
					wait(1)
					cooldown[player] = nil
				end
			end)
		end
	end

	folder.ChildAdded:Connect(function(portal)
		if portal:IsA("BasePart") then
			local portalName = portal.Name

			portal.Touched:Connect(function(hit)
				local character = hit:FindFirstAncestorOfClass("Model")
				local player = Players:GetPlayerFromCharacter(character)

				if player and not cooldown[player] then
					cooldown[player] = true
					tryTeleport(player, portalName, desdePartPortales)
					wait(1)
					cooldown[player] = nil
				end
			end)
		end
	end)
end

conectarPortales(partFolder, true)
conectarPortales(posFolder, false) 



