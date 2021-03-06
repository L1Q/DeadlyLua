--<<forum. d.l.>>
--after launch reborn xD. soon. http://i.imgur.com/HhNsWlP.png
require("libs.Res")
require("libs.ScriptConfig")
require("libs.Utils")

config = ScriptConfig.new()
config:SetParameter("manaBar", true)
config:SetParameter("overlaySpell", true)
config:SetParameter("overlayItem", true)
config:SetParameter("topPanel", true)
config:SetParameter("glypPanel", true)
config:SetParameter("ShowRune", true)
config:SetParameter("ShowCourier", true)
config:SetParameter("ShowIfVisible", true)
config:SetParameter("Ally", true)
config:Load()

local manaBar = config.manaBar
local overlaySpell = config.overlaySpell
local overlayItem = config.overlayItem
local topPanel = config.topPanel
local glypPanel = config.glypPanel
local ShowRune = config.ShowRune
local ShowCourier = config.ShowCourier
local ShowIfVisible = config.ShowIfVisible
local Ally = config.Ally

local item = {} local hero = {} local spell = {} local panel = {} local mana = {} local cours = {} local eff = {} local mod = {} local rune = {} local itemtab = {} local play = false local count = nil

print(math.floor(client.screenRatio*100))

--Config.
--If u have some problem with positioning u can add screen ration(64 line) and create config for yourself.
if math.floor(client.screenRatio*100) == 177 then
testX = 1600
testY = 900
tpanelHeroSize = 55
tpanelHeroDown = 25.714
tpanelHeroSS = 20
tmanaSize = 83
tmanaX = 42
tmanaY = 18
tglyphX = 1.0158
tglyphY = 1.03448
txxB = 2.535
txxG = 3.485
elseif math.floor(client.screenRatio*100) == 166 then
testX = 1280
testY = 768
tpanelHeroSize = 47.1
tpanelHeroDown = 25.714
tpanelHeroSS = 18
tmanaSize = 70
tmanaX = 36
tmanaY = 15
tglyphX = 1.0180
tglyphY = 1.03448
txxB = 2.59
txxG = 3.66
elseif math.floor(client.screenRatio*100) == 160 then
testX = 1280
testY = 800
tpanelHeroSize = 48.5
tpanelHeroDown = 25.714
tpanelHeroSS = 20
tmanaSize = 74
tmanaX = 38
tmanaY = 16
tglyphX = 1.0180
tglyphY = 1.03448
txxB = 2.579
txxG = 3.74
elseif math.floor(client.screenRatio*100) == 133 then
testX = 1024
testY = 768
tpanelHeroSize = 47
tpanelHeroDown = 25.714
tpanelHeroSS = 18
tmanaSize = 72
tmanaX = 37
tmanaY = 14
tglyphX = 1.021
tglyphY = 1.03448
txxB = 2.78
txxG = 4.63
elseif math.floor(client.screenRatio*100) == 125 then
testX = 1280
testY = 1024
tpanelHeroSize = 58
tpanelHeroDown = 25.714
tpanelHeroSS = 23
tmanaSize = 97
tmanaX = 48
tmanaY = 21
tglyphX = 1.021
tglyphY = 1.03448
txxB = 2.747
txxG = 4.54
else
testX = 1600
testY = 900
tpanelHeroSize = 55
tpanelHeroDown = 25.714
tpanelHeroSS = 20
tmanaSize = 83
tmanaX = 42
tmanaY = 18
tglyphX = 1.0158
tglyphY = 1.03448
txxB = 2.535
txxG = 3.485
end

local rate = client.screenSize.x/testX
local con = rate
if rate < 1 then rate = 1 end
--top panel coordinate
local x_ = tpanelHeroSize*(con)
local y_ = client.screenSize.y/tpanelHeroDown
local ss = tpanelHeroSS*(con)

--manabar coordinate
local manaSizeW = con*tmanaSize
local manaX = con*tmanaX
local manaY = client.screenSize.y/testY*tmanaY

--rune
rune[-2272] = drawMgr:CreateRect(0,0,20*rate,20*rate,0x000000ff) rune[-2272].visible = false
rune[3008] = drawMgr:CreateRect(0,0,20*rate,20*rate,0x000000ff) rune[3008].visible = false

--font
local F10 = drawMgr:CreateFont("F10","Arial",10*rate,600*rate)
local F11 = drawMgr:CreateFont("F11","Arial",11*rate,600*rate)
local F13 = drawMgr:CreateFont("F13","Arial",13*rate,600*rate)
local hp = drawMgr:CreateFont("F14","Arial",14*rate,600*rate)

--gliph coordinate
local glyph = drawMgr:CreateText(client.screenSize.x/tglyphX,client.screenSize.y/tglyphY,0xFFFFFF70,"",F13)
glyph.visible = false

function Tick(tick)

	if client.console or not SleepCheck() then return end

	Sleep(200)

	local me = entityList:GetMyHero()

	if not me then return end
	
	if ShowRune then
		Rune()
	end
	
	local cours = entityList:GetEntities({type=LuaEntity.TYPE_COURIER})
	local enemies = entityList:GetEntities({type=LuaEntity.TYPE_HERO})
	local player = entityList:GetEntities({classId=CDOTA_PlayerResource})[1]
	
	if ShowIfVisible then
		VisibleByEnemy(me,enemies,cours)
	end

	if ShowCourier then
		Courier(me.team,cours)
	end
	
	for i = 1, #enemies do
		local v = enemies[i]
		if not v.illusion then
			local hand = v.handle
			if (Ally and hand ~= me.handle) or v.team ~= me.team then
				local offset = v.healthbarOffset

				if offset == -1 then return end
				
				if not hero[hand] then hero[hand] = {}
					hero[hand].manar1 = drawMgr:CreateRect(-manaX-1,-manaY,manaSizeW+2,6,0x010102ff,true) hero[hand].manar1.visible = false hero[hand].manar1.entity = v hero[hand].manar1.entityPosition = Vector(0,0,offset)
					hero[hand].manar2 = drawMgr:CreateRect(-manaX,-manaY+1,0,4,0x5279FFff) hero[hand].manar2.visible = false hero[hand].manar2.entity = v hero[hand].manar2.entityPosition = Vector(0,0,offset)
					hero[hand].manar3 = drawMgr:CreateRect(0,-manaY+1,0,4,0x00175Fff) hero[hand].manar3.visible = false hero[hand].manar3.entity = v hero[hand].manar3.entityPosition = Vector(0,0,offset)
				end
				
				local see = v.alive and v.visible

				--ManaBar
				if manaBar then
				
					if not hero[hand].mana then hero[hand].mana = {} end
				
					for d= 1, v.maxMana/250 do
						if not hero[hand].mana[d] then
							hero[hand].mana[d] = drawMgr:CreateRect(0,-manaY+1,2,5,0x0D145390,true) hero[hand].mana[d].visible = false hero[hand].mana[d].entity = v hero[hand].mana[d].entityPosition = Vector(0,0,v.healthbarOffset)
						end
						if see then
							hero[hand].mana[d].x = -manaX+manaSizeW/v.maxMana*250*d 
							hero[hand].mana[d].visible = true 
						elseif hero[hand].mana[d].visible then
							hero[hand].mana[d].visible = false
						end
					end

					if see then
						local manaPercent = v.mana/v.maxMana
						local printMe = string.format("%i",math.floor(v.mana))
						hero[hand].manar1.visible = true
						hero[hand].manar2.visible = true hero[hand].manar2.w = manaSizeW*manaPercent
						hero[hand].manar3.visible = true hero[hand].manar3.x = -manaX+manaSizeW*manaPercent hero[hand].manar3.w = manaSizeW*(1-manaPercent)
					elseif hero[hand].manar1.visible then
						hero[hand].manar1.visible = false
						hero[hand].manar2.visible = false
						hero[hand].manar3.visible = false
					end
					
				end							
				--Spell
				if overlaySpell then
					--StructureSpells
					local jpg = nil					
					if v.classId == CDOTA_Unit_Hero_DoomBringer or v.classId == CDOTA_Unit_Hero_Rubick or v.classId == CDOTA_Unit_Hero_Invoker then
						jpg = true
					end
					local spells = v.abilities
					local realSpells = {}
					for i,v in ipairs(spells) do
						if not v.hidden and v.abilityType ~= LuaEntityAbility.TYPE_ATTRIBUTES then
							realSpells[#realSpells + 1] = v
						end
					end
					if not hero[hand].spell then 
						hero[hand].spell = {}
						for a = 1,8 do
							spell[a] = {} 
							hero[hand].spell[a] = {}
							hero[hand].spell[a].bg = drawMgr:CreateRect(a*19*rate-54*rate,81*rate,17*rate,14*rate,0x00000095) hero[hand].spell[a].bg.visible = false hero[hand].spell[a].bg.entity = v hero[hand].spell[a].bg.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].nl = drawMgr:CreateRect(a*19*rate-55*rate,80*rate,19*rate,16*rate,0xCE131399,true) hero[hand].spell[a].nl.visible = false hero[hand].spell[a].nl.entity = v hero[hand].spell[a].nl.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].lvl1 = drawMgr:CreateRect(a*19*rate-52*rate,80*rate+12*rate,2*rate,2*rate,0xFFFF00FF) hero[hand].spell[a].lvl1.visible = false hero[hand].spell[a].lvl1.entity = v hero[hand].spell[a].lvl1.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].lvl2 = drawMgr:CreateRect(a*19*rate-49*rate,80*rate+12*rate,2*rate,2*rate,0xFFFF00FF) hero[hand].spell[a].lvl2.visible = false hero[hand].spell[a].lvl2.entity = v hero[hand].spell[a].lvl2.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].lvl3 = drawMgr:CreateRect(a*19*rate-46*rate,80*rate+12*rate,2*rate,2*rate,0xFFFF00FF) hero[hand].spell[a].lvl3.visible = false hero[hand].spell[a].lvl3.entity = v hero[hand].spell[a].lvl3.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].lvl4 = drawMgr:CreateRect(a*19*rate-43*rate,80*rate+12*rate,2*rate,2*rate,0xFFFF00FF) hero[hand].spell[a].lvl4.visible = false hero[hand].spell[a].lvl4.entity = v hero[hand].spell[a].lvl4.entityPosition = Vector(0,0,offset)
							hero[hand].spell[a].textT = drawMgr:CreateText(0,80*rate,0xFFFFFFAA,"",F13) hero[hand].spell[a].textT.visible = false hero[hand].spell[a].textT.entity = v hero[hand].spell[a].textT.entityPosition = Vector(0,0,offset)
						end
					end
					----------------
					for a,Spell in ipairs(realSpells) do
						if see then
							hero[hand].spell[a].bg.visible = true
							if jpg and (a==4 or a==5) then
								hero[hand].spell[a].bg.textureId = drawMgr:GetTextureId("NyanUI/spellicons/"..Spell.name)
							end							
							if Spell.state == LuaEntityAbility.STATE_NOTLEARNED then
								hero[hand].spell[a].nl.visible = true hero[hand].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_nolearn")
								hero[hand].spell[a].textT.visible = false								
							elseif Spell.state == LuaEntityAbility.STATE_READY then
								--if not Spell.abilityPhase then
									hero[hand].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_ready")
								--else
								--	hero[hand].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_phase")
								--end
								hero[hand].spell[a].nl.visible = true 
								hero[hand].spell[a].textT.visible = false								
							elseif Spell.cd > 0 then
								local cooldown = math.ceil(Spell.cd)
								local shift1 = 1
								if cooldown > 99 then cooldown = "99" elseif cooldown < 10 then shift1 = 3 end
								hero[hand].spell[a].nl.visible = true hero[hand].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_cooldown")
								hero[hand].spell[a].textT.visible = true hero[hand].spell[a].textT.x = a*19*rate-53*rate+shift1*rate hero[hand].spell[a].textT.text = ""..cooldown hero[hand].spell[a].textT.color = 0xFFFFFFff
							elseif Spell.state == LuaEntityAbility.STATE_NOMANA then
								local ManaCost = math.floor(math.ceil(Spell.manacost) - v.mana)
								local shift2 = 1
								if ManaCost > 99 then ManaCost = "99" elseif ManaCost < 10 then shift2 = 3 end
								hero[hand].spell[a].nl.visible = true hero[hand].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_nomana")
								hero[hand].spell[a].textT.visible = true hero[hand].spell[a].textT.x = a*19*rate-53*rate+shift2*rate hero[hand].spell[a].textT.text = ""..ManaCost hero[hand].spell[a].textT.color = 0xBBA9EEff
							elseif Spell.state == 17 then
								hero[hand].spell[a].nl.visible = true hero[hand].spell[a].nl.textureId = drawMgr:GetTextureId("NyanUI/other/spell_passive")
								hero[hand].spell[a].textT.visible = false							
							elseif hero[hand].spell[a].nl.visible then
								hero[hand].spell[a].nl.visible = false
								hero[hand].spell[a].textT.visible = false
							end

							if Spell.level == 1 then
								hero[hand].spell[a].lvl1.visible = true
							elseif Spell.level == 2 then
								hero[hand].spell[a].lvl1.visible = true
								hero[hand].spell[a].lvl2.visible = true
							elseif Spell.level == 3 then
								hero[hand].spell[a].lvl1.visible = true
								hero[hand].spell[a].lvl2.visible = true
								hero[hand].spell[a].lvl3.visible = true
							elseif Spell.level >= 4 then
								hero[hand].spell[a].lvl1.visible = true
								hero[hand].spell[a].lvl2.visible = true
								hero[hand].spell[a].lvl3.visible = true
								hero[hand].spell[a].lvl4.visible = true
							elseif hero[hand].spell[a].lvl1.visible then
								hero[hand].spell[a].lvl1.visible = false
								hero[hand].spell[a].lvl2.visible = false
								hero[hand].spell[a].lvl3.visible = false
								hero[hand].spell[a].lvl4.visible = false
							end
							
						elseif hero[hand].spell[a].bg.visible then
							hero[hand].spell[a].bg.visible = false
							hero[hand].spell[a].nl.visible = false
							hero[hand].spell[a].lvl1.visible = false
							hero[hand].spell[a].lvl2.visible = false
							hero[hand].spell[a].lvl3.visible = false
							hero[hand].spell[a].lvl4.visible = false
							hero[hand].spell[a].textT.visible = false
						end
					end
				end
				
				--Items
				if overlayItem then
					
					if not hero[hand].item then 
						hero[hand].item = {}
						for c = 1, 6 do
							item[c] = {}
							hero[hand].item[c] = {}
							hero[hand].item[c].gem = drawMgr:CreateRect(0,-manaY+7,18*rate,16*rate,0x7CFC0099) hero[hand].item[c].gem.visible = false hero[hand].item[c].gem.entity = v hero[hand].item[c].gem.entityPosition = Vector(0,0,offset)
							hero[hand].item[c].dust = drawMgr:CreateRect(0,-manaY+6,18*rate,16*rate,0x7CFC0099) hero[hand].item[c].dust.visible = false hero[hand].item[c].dust.entity = v hero[hand].item[c].dust.entityPosition = Vector(0,0,offset)
							hero[hand].item[c].sentryImg = drawMgr:CreateRect(0,-manaY+7,16*rate,14*rate,0x7CFC0099) hero[hand].item[c].sentryImg.visible = false hero[hand].item[c].sentryImg.entity = v hero[hand].item[c].sentryImg.entityPosition = Vector(0,0,offset)
							hero[hand].item[c].sentryTxt = drawMgr:CreateText(0,-manaY+10,0xffffffFF,"",F11) hero[hand].item[c].sentryTxt.visible = false hero[hand].item[c].sentryTxt.entity = v hero[hand].item[c].sentryTxt.entityPosition = Vector(0,0,offset)					
							hero[hand].item[c].sphereImg = drawMgr:CreateRect(0,-manaY+7,16*rate,14*rate,0x7CFC0099) hero[hand].item[c].sphereImg.visible = false hero[hand].item[c].sphereImg.entity = v hero[hand].item[c].sphereImg.entityPosition = Vector(0,0,offset)
							hero[hand].item[c].sphereTxt = drawMgr:CreateText(0,-manaY+7,0xffffffFF,"",F13) hero[hand].item[c].sphereTxt.visible = false hero[hand].item[c].sphereTxt.entity = v hero[hand].item[c].sphereTxt.entityPosition = Vector(0,0,offset)						
						end
					end
				
					itemtab[v.classId] = 0

					for c = 1, 6 do

						local Items = v:GetItem(c)

						if see and Items ~= nil then
							
							if Items.name == "item_gem" then
								itemtab[v.classId] = itemtab[v.classId]  + 20*rate
								hero[hand].item[c].gem.visible = true hero[hand].item[c].gem.x = itemtab[v.classId]-manaX-18*rate hero[hand].item[c].gem.textureId = drawMgr:GetTextureId("NyanUI/other/O_gem")
							elseif Items.name == "item_dust" then
								itemtab[v.classId] = itemtab[v.classId]  + 20*rate
								hero[hand].item[c].dust.visible = true hero[hand].item[c].dust.x = itemtab[v.classId]-manaX-18*rate hero[hand].item[c].dust.textureId = drawMgr:GetTextureId("NyanUI/other/O_dust")	
							elseif Items.name == "item_ward_sentry" then
								itemtab[v.classId] = itemtab[v.classId]  + 20*rate
								local charg = Items.charges
								hero[hand].item[c].sentryImg.visible = true hero[hand].item[c].sentryImg.x = itemtab[v.classId]-manaX-18*rate hero[hand].item[c].sentryImg.textureId = drawMgr:GetTextureId("NyanUI/other/O_sentry")
								hero[hand].item[c].sentryTxt.visible = true hero[hand].item[c].sentryTxt.x = itemtab[v.classId]-manaX-8*rate hero[hand].item[c].sentryTxt.text = ""..charg
							elseif Items.name == "item_sphere" then
								itemtab[v.classId] = itemtab[v.classId]  + 20*rate
								hero[hand].item[c].sphereImg.visible = true hero[hand].item[c].sphereImg.x = itemtab[v.classId]-manaX-16*rate hero[hand].item[c].sphereImg.textureId = drawMgr:GetTextureId("NyanUI/other/O_sphere")
								if Items.cd ~= 0 then
									local cdL = math.ceil(Items.cd)
									local shift4 = 0
									if cdL < 10 then shift4 = 2 end
									hero[hand].item[c].sphereTxt.visible = true hero[hand].item[c].sphereTxt.x = itemtab[v.classId]-manaX-14*rate + shift4 hero[hand].item[c].sphereTxt.text = ""..cdL
								else
									hero[hand].item[c].sphereTxt.visible = false
								end
							elseif itemtab[v.classId] ~= nil then
								hero[hand].item[c].gem.visible = false
								hero[hand].item[c].dust.visible = false
								hero[hand].item[c].sentryImg.visible = false
								hero[hand].item[c].sentryTxt.visible = false
								hero[hand].item[c].sphereTxt.visible = false
								hero[hand].item[c].sphereImg.visible = false
							end

						elseif itemtab[v.classId] ~= nil then
							hero[hand].item[c].gem.visible = false
							hero[hand].item[c].dust.visible = false
							hero[hand].item[c].sentryImg.visible = false
							hero[hand].item[c].sentryTxt.visible = false
							hero[hand].item[c].sphereTxt.visible = false
							hero[hand].item[c].sphereImg.visible = false						
						end

					end
				end
				
			end
		
		--ulti panel
			if topPanel then
			
				local xx = GetXX(v.team)
				local color = Color(v.team,me.team)
				local handId = GetID(v.playerId,count,v.team)
				
				if not panel[handId] then panel[handId] = {}
					panel[handId].hpINB = drawMgr:CreateRect(0,y_,x_-1,8*rate,0x000000D0) panel[handId].hpINB.visible = false
					panel[handId].hpIN = drawMgr:CreateRect(0,y_,0,8*rate,color) panel[handId].hpIN.visible = false				
					panel[handId].hpB = drawMgr:CreateRect(0,y_,x_-1,8*rate,0x000000ff,true) panel[handId].hpB.visible = false
					
					panel[handId].ulti = drawMgr:CreateRect(0,y_-9,14*rate,15*rate,0x0EC14A80) panel[handId].ulti.visible = false		
					panel[handId].ultiCDT = drawMgr:CreateText(0,y_-9,0xFFFFFF99,"",F13) panel[handId].ultiCDT.visible = false	
					panel[handId].lh = drawMgr:CreateText(xx-20+x_*handId,y_-30*con,-1,"",F10)
				end			
				
				local lasthits = player:GetLasthits(handId)
				local denies = player:GetDenies(handId)
				panel[handId].lh.text = " "..lasthits.." / "..denies
				
				for d = 4,8 do
					local ult = v:GetAbility(d)
					if ult ~= nil then
						if ult.abilityType == 1 then						
							panel[handId].ulti.x = xx+x_*(handId+0.01)
							if ult.cd > 0 then
								local cooldownUlti = math.ceil(ult.cd)
								local shift = -1 
								if cooldownUlti > 99 then cooldownUlti = "99" elseif cooldownUlti < 10 then shift = 3 end							
								panel[handId].ulti.visible = true 
								panel[handId].ulti.textureId = drawMgr:GetTextureId("NyanUI/other/ulti_cooldown")
								panel[handId].ultiCDT.visible = true panel[handId].ultiCDT.x = xx+x_*handId + shift panel[handId].ultiCDT.text = ""..cooldownUlti
							elseif ult.state == LuaEntityAbility.STATE_READY or ult.state == 17 then
								panel[handId].ulti.visible = true 
								panel[handId].ulti.textureId = drawMgr:GetTextureId("NyanUI/other/ulti_ready")
								panel[handId].ultiCDT.visible = false						
							elseif ult.state == LuaEntityAbility.STATE_NOMANA then								
								panel[handId].ulti.textureId = drawMgr:GetTextureId("NyanUI/other/ulti_nomana")
								panel[handId].ultiCDT.visible = false						
							end
						end
					end
				end
				if v.respawnTime < 1 then
					local health = string.format("%i",math.floor(v.health))
					local healthPercent = v.health/v.maxHealth
					local manaPercent = v.mana/v.maxMana
					panel[handId].hpINB.visible = true panel[handId].hpINB.x = xx-ss+x_*handId
					panel[handId].hpIN.visible = true panel[handId].hpIN.x = xx-ss+x_*handId panel[handId].hpIN.w = (x_-2)*healthPercent
					panel[handId].hpB.visible = true panel[handId].hpB.x = xx-ss+x_*handId
				elseif panel[handId].hpINB.visible then
					panel[handId].hpINB.visible = false
					panel[handId].hpIN.visible = false
					panel[handId].hpB.visible = false
				end
			end
		end
	end
	--gliph cooldown
	local team = 5 - me.team
	local Time = client:GetGlyphCooldown(team)
	local sms = nil
	if Time == 0 then sms = "Ry" else sms = Time end
	glyph.visible = true glyph.text = ""..sms

end

function Rune()
	local runes = entityList:GetEntities({classId=CDOTA_Item_Rune})
	if #runes == last and math.floor(client.gameTime % 120) ~= 0 then return end last = #runes 
	rune[-2272].visible,rune[3008].visible = false,false
	for i,v in ipairs(runes) do
		local runeType = v.runeType
		local filename = ""
		local pos = v.position.x
		if runeType == 0 then
				filename = "doubledamage"
		elseif runeType == 1 then
				filename = "haste"
		elseif runeType == 2 then
				filename = "illusion"
		elseif runeType == 3 then
				filename = "invis"
		elseif runeType == 4 then
				filename = "regen"
		elseif runeType == 5 then
				filename = "bounty"
		end
		local runeMinimap = MapToMinimap(pos,v.position.y)
		rune[pos].visible = true
		rune[pos].x = runeMinimap.x-20/2
		rune[pos].y = runeMinimap.y-20/2
		rune[pos].textureId = drawMgr:GetTextureId("NyanUI/minirunes/translucent/"..filename.."_t75")
	end	
end

function Courier(teams,tab)
	for i,v in ipairs(tab) do	
		if v.team ~= teams then
			local hand = v.handle
			if not cours[hand] then
				cours[hand] = drawMgr:CreateRect(0,0,12*rate,12*rate,0x000000FF) cours[hand].visible = false
			end
		
			if v.visible and v.alive then
				cours[hand].visible = true
				local courMinimap = MapToMinimap(v.position.x,v.position.y)
				cours[hand].x,cours[hand].y = courMinimap.x-10,courMinimap.y-6
				local flying = v:GetProperty("CDOTA_Unit_Courier","m_bFlyingCourier")
				if flying then
					cours[hand].textureId = drawMgr:GetTextureId("NyanUI/other/courier_flying")
					cours[hand].size = Vector2D(25*rate,12*rate)
				else
					cours[hand].textureId = drawMgr:GetTextureId("NyanUI/other/courier")		
				end
			elseif cours[hand].visible then
				cours[hand].visible = false
			end
			
		end		
	end  
end

function VisibleByEnemy(me,ent,cour)
	local effectDeleted = false
	
	for i,v in ipairs(cour) do
		if v.team == me.team then
			local hand = v.handle
			local visible = v.visibleToEnemy
			if eff[hand] == nil then
				if visible then						    
					eff[hand] = Effect(v,"ambient_gizmo_model")
					eff[hand]:SetVector(1,Vector(0,0,0))
				end
			elseif not visible then
				eff[hand] = nil
				effectDeleted = true
			end
		end
	end
	
	for _,v in ipairs(ent) do 
		if v.alive and v.team == me.team then
			local OnScreen = client:ScreenPosition(v.position)
			if OnScreen then
				local hand = v.handle
				local effect = nil
				if hand == me.handle then -- comparing handles
					effect = "aura_shivas" 
				else 
					effect = "ambient_gizmo_model" 
				end
				local visible = v.visibleToEnemy
				if eff[hand] == nil then
					if visible then						    
						eff[hand] = Effect(v,effect)
						eff[hand]:SetVector(1,Vector(0,0,0))
					end
				elseif not visible then
					eff[hand] = nil
					effectDeleted = true
				end
			end
		end
	end

	if effectDeleted then -- only call it once even when 1000 effects are deleted
		collectgarbage("collect")
	end

end

function GetCount()
	local num = 0
	for i,v in ipairs(entityList:GetEntities({type=LuaEntity.TYPE_PLAYER})) do
		if v.team == LuaEntity.TEAM_RADIANT then
			num = num + 1
		end
	end
	return num
end

function GetID(id,count,team)
	if team == LuaEntity.TEAM_DIRE then
		return 5 - count + id
	else
		return id
	end
end	

function GetXX(ent)
	if ent == 2 then		
		return client.screenSize.x/txxG + 1
	elseif ent == 3 then
		return client.screenSize.x/txxB + 1
	end
end

function Color(ent,meteam)
	if ent ~= meteam then
		return 0x960018FF
	else
		return 0x008000FF
	end
end
	
function GameClose()
	sleeptick = 0
	eff = {}
	mana = {}
	spell = {}
	item = {}
	hero = {}
	panel = {}
	cours = {}
	itemtab = {}
	rune[-2272].visible,rune[3008].visible = false,false	
	glyph.visible = false
	collectgarbage("collect")
end

function Load()
	if PlayingGame() then
		play = true
		count = GetCount()
		script:RegisterEvent(EVENT_TICK,Tick)
		script:UnregisterEvent(Load)
	end
end

function GameClose()
	if play then
		script:UnregisterEvent(Tick)
		script:RegisterEvent(EVENT_TICK,Load)
		play = false
	end
	eff = {}
	mana = {}
	spell = {}
	item = {}
	hero = {}
	panel = {}
	cours = {}
	itemtab = {}
	collectgarbage("collect")
	rune[-2272].visible,rune[3008].visible = false,false	
	glyph.visible = false	
end

script:RegisterEvent(EVENT_TICK,Load)
script:RegisterEvent(EVENT_CLOSE,GameClose)
