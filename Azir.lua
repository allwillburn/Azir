local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Azir" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Azir/master/Azir.lua', SCRIPT_PATH .. 'Azir.lua', function() PrintChat('<font color = "#00FFFF"> Azir Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Azir/master/Azir.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0
 
local AzirMenu = Menu("Azir", "Azir")

AzirMenu:SubMenu("Combo", "Combo")

AzirMenu.Combo:Boolean("Q", "Use Q in combo", true)
AzirMenu.Combo:Boolean("W", "Use W in combo", true)
AzirMenu.Combo:Boolean("E", "Use E in combo", true)
AzirMenu.Combo:Boolean("R", "Use R in combo", true)
AzirMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
AzirMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
AzirMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
AzirMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
AzirMenu.Combo:Boolean("RHydra", "Use RHydra", true)
AzirMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
AzirMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
AzirMenu.Combo:Boolean("Randuins", "Use Randuins", true)


AzirMenu:SubMenu("AutoMode", "AutoMode")
AzirMenu.AutoMode:Boolean("Level", "Auto level spells", false)
AzirMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
AzirMenu.AutoMode:Boolean("Q", "Auto Q", false)
AzirMenu.AutoMode:Boolean("W", "Auto W", false)
AzirMenu.AutoMode:Boolean("E", "Auto E", false)
AzirMenu.AutoMode:Boolean("R", "Auto R", false)

AzirMenu:SubMenu("LaneClear", "LaneClear")
AzirMenu.LaneClear:Boolean("Q", "Use Q", true)
AzirMenu.LaneClear:Boolean("W", "Use W", true)
AzirMenu.LaneClear:Boolean("E", "Use E", true)
AzirMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
AzirMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

AzirMenu:SubMenu("Harass", "Harass")
AzirMenu.Harass:Boolean("Q", "Use Q", true)
AzirMenu.Harass:Boolean("W", "Use W", true)

AzirMenu:SubMenu("KillSteal", "KillSteal")
AzirMenu.KillSteal:Boolean("Q", "KS w Q", true)
AzirMenu.KillSteal:Boolean("E", "KS w E", true)

AzirMenu:SubMenu("AutoIgnite", "AutoIgnite")
AzirMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

AzirMenu:SubMenu("Drawings", "Drawings")
AzirMenu.Drawings:Boolean("DW", "Draw W Range", true)

AzirMenu:SubMenu("SkinChanger", "SkinChanger")
AzirMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
AzirMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if AzirMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
          
           if AzirMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 800) then
				CastTargetSpell(target, _W)
            end 
                    
            if AzirMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 875) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
            end          
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
    
             if AzirMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 800) then
			CastTargetSpell(target, _W)
	    end
      
            if AzirMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if AzirMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if AzirMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if AzirMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if AzirMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 1100) then
			 CastSpell(_E)
	    end

            if AzirMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 875) then
		     if target ~= nil then 
                         CastTargetSpell(target, _Q)
                     end
            end

            if AzirMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if AzirMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if AzirMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	   
	    
	    
            if AzirMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 250) and (EnemiesAround(myHeroPos(), 250) >= AzirMenu.Combo.RX:Value()) then
			CastTargetSpell(target, _R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 875) and AzirMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastTargetSpell(target, _Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 187) and AzirMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSpell(_E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if AzirMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 875) then
	        	CastTargetSpell(closeminion, _Q)
                end

                if AzirMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 800) then
	        	CastTargetSpell(closeminion, _W)
	        end

                if AzirMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 187) then
	        	CastSpell(_E)
	        end

                if AzirMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if AzirMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if AzirMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 875) then
		      CastTargetSpell(target, _Q)
          end
        end 
        if AzirMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 800) then
	  	      CastTargetSpell(target, _W)
          end
        end
        if AzirMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 1100) then
		      CastSpell(_E)
	  end
        end
        if AzirMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 250) then
		      CastTargetSpell(target, _R)
	  end
        end
                
	--AUTO GHOST
	if AzirMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if AzirMenu.Drawings.DW:Value() then
		DrawCircle(GetOrigin(myHero), 800, 0, 200, GoS.Red)
	end

end)




local function SkinChanger()
	if AzirMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Azir</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





