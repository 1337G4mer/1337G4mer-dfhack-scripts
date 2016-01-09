gui = require 'gui'
gs = require 'gui.script'

--[[
	Author : 1337G4mer on bay12 and reddit
	Version : 0.3
	Description : A small utility to gather all quest/sites offered by your conversation partner.
	
	Config:
	sleepFrames: Number of frames to skip set low if you want fast processing
	slower runs faster but sometimes bugs out. Setting number lower than 10 created
	issues for me. Defaulted to 20.
	
	Usage:
	To run the script as "gatherQuests.lua" in your hack/scripts directory.
	from command propmt type gatherQuests to run it.
	Alternatively you can bind to one of your keys with the following command
	keybinding add Ctrl-Q@dungeonmode gatherQuests
	Before you run it though find a creature who has lot of sites to give.
	If the creature doesn't offer any [detailed description] you may run into infinite loop.
	In that case kill script as described below.
	
	Troubleshooting:
	When script fails or stops because of not able to find the correct menu option.
	Just re run the script and it will pick up where it left.
	
	Although this is better than macro because you can switch your screen to your favourite youtube video
	and the script still keeps going unlike macro, however, since it progress in game time, if you are stuck in infinite
	loop your adventurer can possibly starve to death :D (not happened in testing yet, but possible)
	
	You can kill/stop the script any time by typing cmd in dfhack console.-> kill-lua gatherQuests
	Note: You may have to do this sometime as there are some conversation options which run in infinite loop.
]]--
sleepFrames = 20
--Global Variables--
breakNow = 'N'
troublesExist = 'N'
armiesExist = 'N'
beastsExist = 'N'
banditsExist='N'
criminalsExist = 'N'
verminsExist = 'N'
fightingExist = 'N'
ruffiansExist = 'N'
directionsExist = 'N'
invalidMenuOptions = 'N'


local vs = dfhack.gui.getCurViewscreen(true)

function findAndChoose()
	invalidMenuOptions = 'N'
	local choicesPtr = df.global.ui_advmode.conversation.choices
	for i, choice in pairs(choicesPtr) do
		choiceTypeNum = choice.choice.type
		choiceTitle = choice.title[0].value
		choiceTypeStr = 'unst'
		--print('chc '..i,choiceTypeNum,choiceTitle)
		if string.find(choiceTitle, 'troubles') and choiceTypeNum == 11 then
			df.global.ui_advmode.conversation.cursor_choice=i
			choiceTypeStr = 'trbl'
			troublesExist = 'Y'
			break
		elseif string.find(choiceTitle, 'beasts') and  choiceTypeNum == 75 then
			choiceTypeStr = 'bsts'
			beastsExist = 'Y'
			df.global.ui_advmode.conversation.cursor_choice=i
			break
		elseif string.find(choiceTitle, 'directions')  and  choiceTypeNum == 77 then
			choiceTypeStr = 'drcn'
			directionsExist = 'Y'
			df.global.ui_advmode.conversation.cursor_choice=i
			break
		elseif string.find(choiceTitle, 'criminals') and  choiceTypeNum == 75 then
			choiceTypeStr = 'crml'
			criminalsExist = 'Y'
			df.global.ui_advmode.conversation.cursor_choice=i
			break
		elseif string.find(choiceTitle, 'bandits') and  choiceTypeNum == 75 then
			choiceTypeStr = 'bndt'
			banditsExist='Y'
			df.global.ui_advmode.conversation.cursor_choice=i
			break			
		elseif string.find(choiceTitle, 'vermin') and  choiceTypeNum == 75 then
			choiceTypeStr = 'vrmn'
			verminsExist = 'Y'
			df.global.ui_advmode.conversation.cursor_choice=i
			break
		elseif string.find(choiceTitle, 'armies') and  choiceTypeNum == 75 then
			choiceTypeStr = 'mrch'
			ruffiansExist = 'Y'
			df.global.ui_advmode.conversation.cursor_choice=i
			break
		elseif string.find(choiceTitle, 'ruffians') and  choiceTypeNum == 75 then
			choiceTypeStr = 'rffn'
			ruffiansExist = 'Y'
			df.global.ui_advmode.conversation.cursor_choice=i
			break
		elseif string.find(choiceTitle, 'fighting') and  choiceTypeNum == 75 then
			choiceTypeStr = 'fght'
			ruffiansExist = 'Y'
			df.global.ui_advmode.conversation.cursor_choice=i
			break
		end
	end
end

gs.start(function()
	print('================== Starting Quest Gather ==================')
	i=0
	repeat
		i = i +1
		
		--reset globals.
		breakNow = 'N'
		troublesExist = 'N'
		beastsExist = 'N'
		criminalsExist = 'N'
		banditsExist='Y'
		verminsExist = 'N'
		directionsExist = 'N'
		invalidMenuOptions = 'N'
		choiceTypeNum = ''
		choiceTitle = ''
		
		gs.sleep(sleepFrames,'frames')
		gui.simulateInput(vs, 'SELECT')
		gui.simulateInput(vs, 'SELECT')
		gui.simulateInput(vs, 'SELECT')
		gs.sleep(sleepFrames,'frames')
		--vs = dfhack.gui.getCurViewscreen()
		gui.simulateInput(vs, 'A_TALK')
		gs.sleep(sleepFrames,'frames')
		gui.simulateInput(vs, 'SELECT')
		gs.sleep(sleepFrames,'frames')
		findAndChoose()
		gs.sleep(sleepFrames,'frames')
		if (choiceTypeStr ~= 'unst') then
			--print('<<>>',choiceTypeStr)
			gui.simulateInput(vs,'SELECT')
			gs.sleep(sleepFrames,'frames')
		else
			--print('>><<',choiceTypeStr)
			invalidMenuOptions = 'Y'
		end
		existsStr = troublesExist..armiesExist..beastsExist..criminalsExist..banditsExist..verminsExist..fightingExist..ruffiansExist..directionsExist
		if choiceTypeStr == 'drcn' then
			dfhack.color(10)
		else
			dfhack.color(8)
		end
		print('Lp:'..i,choiceTypeStr,existsStr,invalidMenuOptions,choiceTypeNum,choiceTitle)
		if  invalidMenuOptions =='Y' then
			print('================== Finished Quest Gather ==================')
			breakNow = 'Y'
		end
		
	until breakNow == 'Y'
end)
