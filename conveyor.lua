-- Script de convoyeur simple pour Roblox
-- Place ce script dans une part qui sera le convoyeur

local conveyorSpeed = 50 -- Vitesse du convoyeur (en studs par seconde)

while true do
	local touchingParts = workspace:FindPartBoundsInRadius(script.Parent.Position, 10)
	
	for _, part in ipairs(touchingParts) do
		local humanoidRootPart = part.Parent:FindFirstChild("HumanoidRootPart")
		
		if humanoidRootPart then
			-- Applique une vélocité pour déplacer le joueur
			humanoidRootPart.AssemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity + Vector3.new(conveyorSpeed, 0, 0)
		end
	end
	
	wait(0.1) -- Rafraîchit chaque 0.1 secondes
end
