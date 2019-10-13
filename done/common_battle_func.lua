---
-- @module CommonFuncs

local MaxActs = 99

---
-- Inits all table params to their default values for 99 acts. For each, actOddsTbl is set to 0, actTbl is set to nil, paramTbl to empty table.
-- @tparam table actOddsTbl Probability table for all your acts.
-- @tparam table actTbl Table of all action functions.
-- @tparam table paramTbl Table of all your action param tables.
function Common_Clear_Param(actOddsTbl, actTbl, paramTbl)
	local someVar = 1
	for i = 1, MaxActs do
		actOddsTbl[i] = 0
		actTbl[i] = nil
		paramTbl[i] = {}
	end
end

---
-- Chooses an action based on its probability and calls it with provided paramTbl for it. Also handles calling the actAfter if your act returns a nonzero probability
--for it. Some of the default acts might not work as they reference global variables which might have been just a typo/copypaste mistake. Almost all of the
--default acts do the same Approach_and_Attack_Act bar the very first few (starting with 12th they're all the same).
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam table actOddsTbl Probability table for all your acts.
-- @tparam table actTbl Table of all action functions.
-- @tparam function actAfter Function to perform after the action (your act should return the probability of executing this). If this is nil will use the 
--HumanCommon_ActAfter_AdjustSpace (default might not work seeing as it references some global variable which may or may not be initialized, idk).
-- @tparam table paramTbl Table of all your action param tables.
function Common_Battle_Activate(ai, goal, actOddsTbl, actTbl, actAfter, paramTbl)

	local allActs = {}		--table of all 99 acts, uses actTbl entries if those exist, otherwise from defaultActs
	local allActOddsTbl = {}--just a copy of all 99 act odds
	local oddsSum = 0		--sum of all act odds for rng later
	
	--init table of default acts
	local defaultActs = {
		function()
			return defAct01(ai, goal, paramTbl[1])
		end,
		function()
			return defAct02(ai, goal, paramTbl[2])
		end,
		function()
			return defAct03(ai, goal, paramTbl[3])
		end,
		function()
			return defAct04(ai, goal, paramTbl[4])
		end,
		function()
			return defAct05(ai, goal, paramTbl[5])
		end,
		function()
			return defAct06(ai, goal, paramTbl[6])
		end,
		function()
			return defAct07(ai, goal, paramTbl[7])
		end,
		function()
			return defAct08(ai, goal, paramTbl[8])
		end,
		function()
			return defAct09(ai, goal, paramTbl[9])
		end,
		function()
			return defAct10(ai, goal, paramTbl[10])
		end,
		function()
			return defAct11(ai, goal, paramTbl[11])
		end,
		function()
			return defAct12(ai, goal, paramTbl[12])
		end,
		function()
			return defAct13(ai, goal, paramTbl[13])
		end,
		function()
			return defAct14(ai, goal, paramTbl[14])
		end,
		function()
			return defAct15(ai, goal, paramTbl[15])
		end,
		function()
			return defAct16(ai, goal, paramTbl[16])
		end,
		function()
			return defAct17(ai, goal, paramTbl[17])
		end,
		function()
			return defAct18(ai, goal, paramTbl[18])
		end,
		function()
			return defAct19(ai, goal, paramTbl[19])
		end,
		function()
			return defAct20(ai, goal, paramTbl[20])
		end,
		function()
			return defAct21(ai, goal, paramTbl[21])
		end,
		function()
			return defAct22(ai, goal, paramTbl[22])
		end,
		function()
			return defAct23(ai, goal, paramTbl[23])
		end,
		function()
			return defAct24(ai, goal, paramTbl[24])
		end,
		function()
			return defAct25(ai, goal, paramTbl[25])
		end,
		function()
			return defAct26(ai, goal, paramTbl[26])
		end,
		function()
			return defAct27(ai, goal, paramTbl[27])
		end,
		function()
			return defAct28(ai, goal, paramTbl[28])
		end,
		function()
			return defAct29(ai, goal, paramTbl[29])
		end,
		function()
			return defAct30(ai, goal, paramTbl[30])
		end,
		function()
			return defAct31(ai, goal, paramTbl[31])
		end,
		function()
			return defAct32(ai, goal, paramTbl[32])
		end,
		function()
			return defAct33(ai, goal, paramTbl[33])
		end,
		function()
			return defAct34(ai, goal, paramTbl[34])
		end,
		function()
			return defAct35(ai, goal, paramTbl[35])
		end,
		function()
			return defAct36(ai, goal, paramTbl[36])
		end,
		function()
			return defAct37(ai, goal, paramTbl[37])
		end,
		function()
			return defAct38(ai, goal, paramTbl[38])
		end,
		function()
			return defAct39(ai, goal, paramTbl[39])
		end,
		function()
			return defAct40(ai, goal, paramTbl[40])
		end,
		function()
			return defAct41(ai, goal, paramTbl[41])
		end,
		function()
			return defAct42(ai, goal, paramTbl[42])
		end,
		function()
			return defAct43(ai, goal, paramTbl[43])
		end,
		function()
			return defAct44(ai, goal, paramTbl[44])
		end,
		function()
			return defAct45(ai, goal, paramTbl[45])
		end,
		function()
			return defAct46(ai, goal, paramTbl[46])
		end,
		function()
			return defAct47(ai, goal, paramTbl[47])
		end,
		function()
			return defAct48(ai, goal, paramTbl[48])
		end,
		function()
			return defAct49(ai, goal, paramTbl[49])
		end,
		function()
			return defAct50(ai, goal, paramTbl[50])
		end,
		function()
			return defAct51(ai, goal, paramTbl[51])
		end,
		function()
			return defAct52(ai, goal, paramTbl[52])
		end,
		function()
			return defAct53(ai, goal, paramTbl[53])
		end,
		function()
			return defAct54(ai, goal, paramTbl[54])
		end,
		function()
			return defAct55(ai, goal, paramTbl[55])
		end,
		function()
			return defAct56(ai, goal, paramTbl[56])
		end,
		function()
			return defAct57(ai, goal, paramTbl[57])
		end,
		function()
			return defAct58(ai, goal, paramTbl[58])
		end,
		function()
			return defAct59(ai, goal, paramTbl[59])
		end,
		function()
			return defAct60(ai, goal, paramTbl[60])
		end,
		function()
			return defAct61(ai, goal, paramTbl[61])
		end,
		function()
			return defAct62(ai, goal, paramTbl[62])
		end,
		function()
			return defAct63(ai, goal, paramTbl[63])
		end,
		function()
			return defAct64(ai, goal, paramTbl[64])
		end,
		function()
			return defAct65(ai, goal, paramTbl[65])
		end,
		function()
			return defAct66(ai, goal, paramTbl[66])
		end,
		function()
			return defAct67(ai, goal, paramTbl[67])
		end,
		function()
			return defAct68(ai, goal, paramTbl[68])
		end,
		function()
			return defAct69(ai, goal, paramTbl[69])
		end,
		function()
			return defAct70(ai, goal, paramTbl[70])
		end,
		function()
			return defAct71(ai, goal, paramTbl[71])
		end,
		function()
			return defAct72(ai, goal, paramTbl[72])
		end,
		function()
			return defAct73(ai, goal, paramTbl[73])
		end,
		function()
			return defAct74(ai, goal, paramTbl[74])
		end,
		function()
			return defAct75(ai, goal, paramTbl[75])
		end,
		function()
			return defAct76(ai, goal, paramTbl[76])
		end,
		function()
			return defAct77(ai, goal, paramTbl[77])
		end,
		function()
			return defAct78(ai, goal, paramTbl[78])
		end,
		function()
			return defAct79(ai, goal, paramTbl[79])
		end,
		function()
			return defAct80(ai, goal, paramTbl[80])
		end,
		function()
			return defAct81(ai, goal, paramTbl[81])
		end,
		function()
			return defAct82(ai, goal, paramTbl[82])
		end,
		function()
			return defAct83(ai, goal, paramTbl[83])
		end,
		function()
			return defAct84(ai, goal, paramTbl[84])
		end,
		function()
			return defAct85(ai, goal, paramTbl[85])
		end,
		function()
			return defAct86(ai, goal, paramTbl[86])
		end,
		function()
			return defAct87(ai, goal, paramTbl[87])
		end,
		function()
			return defAct88(ai, goal, paramTbl[88])
		end,
		function()
			return defAct89(ai, goal, paramTbl[89])
		end,
		function()
			return defAct90(ai, goal, paramTbl[90])
		end,
		function()
			return defAct91(ai, goal, paramTbl[91])
		end,
		function()
			return defAct92(ai, goal, paramTbl[92])
		end,
		function()
			return defAct93(ai, goal, paramTbl[93])
		end,
		function()
			return defAct94(ai, goal, paramTbl[94])
		end,
		function()
			return defAct95(ai, goal, paramTbl[95])
		end,
		function()
			return defAct96(ai, goal, paramTbl[96])
		end,
		function()
			return defAct97(ai, goal, paramTbl[97])
		end,
		function()
			return defAct98(ai, goal, paramTbl[98])
		end,
		function()
			return defAct99(ai, goal, paramTbl[99])
		end
	}
	
	local someVar = 1
	
	--populate allActs table and copy actOddsTbl to allActOddsTbl and calculate sum of all odds
	for i = 1, MaxActs do
		if actTbl[i] ~= nil then
			allActs[i] = actTbl[i]
		else
			allActs[i] = defaultActs[i]
		end
		allActOddsTbl[i] = actOddsTbl[i]
		oddsSum = oddsSum + allActOddsTbl[i]
	end
	
	local realActAfter = nil	--this is the function that's going to be called after the action, either default or provided by the actAfter.
	--was provided
	if actAfter ~= nil then
		realActAfter = actAfter
	--use default
	else
		realActAfter = function()
			HumanCommon_ActAfter_AdjustSpace(ai, goal, atkAfterOddsTbl)
		end
	end
	
	local actAfterOdds = 0	--probability of performing actAfter
	local forceActIndex = ai:DbgGetForceActIdx()	--index of forced act for debug
	--if we're debugging do the debug provided act
	if forceActIndex > 0 and forceActIndex <= MaxActs then
		--call the act
		actAfterOdds = allActs[forceActIndex]()	--usually they'd return the actAfterOdds
		ai:DbgSetLastActIdx(forceActIndex)		--remember which act was last done
	--choose the act based on its probability
	else
	
		local fateOdds = ai:GetRandam_Int(1, oddsSum)--rng which act should we do
		local oddsSumSoFar = 0	--used for probability decision
		local someVar2 = 1
		
		--choose act based on its probability
		for i = 1, MaxActs do
			oddsSumSoFar = oddsSumSoFar + allActOddsTbl[i]	--keep summing odds till it's high enough to surpass rngd one
			if fateOdds <= oddsSumSoFar then
				--call the act
				actAfterOdds = allActs[i]()	--usually they'd return the actAfterOdds
				ai:DbgSetLastActIdx(i)		--remember which act was last done
				i = MaxActs					--exit loop
			end
		end
		
	end
	
	local fateActAfter = ai:GetRandam_Int(1, 100)--rng should we do actAfter
	--in case act didn't return actAfter probability
	if actAfterOdds == nil then
		actAfterOdds = 0
	end
	--do act after if we should
	if fateActAfter <= actAfterOdds then
		realActAfter()
	end
	
end

function defAct01(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct02(ai, goal, paramTbl)
	local realParamTbl = {1.5, 0, 10, 40, nil, nil, nil, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end
	return HumanCommon_Approach_and_ComboAtk(ai, goal, realParamTbl)
end

function defAct03(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3005, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct04(ai, goal, paramTbl)

	local realParamTbl = {5, 0, 3007, DIST_Middle, 3005, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end
	
	local range = realParamTbl[1]					--range at which to stop approach
	local walkDist = realParamTbl[1] + 2			--distance at which we'd walk
	local guardPer = realParamTbl[2]				--guard probability
	local attBreakId = realParamTbl[3]				--attack to use for breaking guard
	local attBreakSuccessDist = realParamTbl[4]		--breaking guard attack success distance
	local attFinisherId = realParamTbl[5]			--attack to do after we broke the guard
	local attFinisherSuccessDist = realParamTbl[6]	--attack after guard was broken success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[7], 100) -- probability of performing actAfter
	Approach_and_GuardBreak_Act(ai, goal, range, walkDist, guardPer, attBreakId, attBreakSuccessDist, attFinisherId, attFinisherSuccessDist)
	
	return actAfterOdds
	
end

function defAct05(ai, goal, paramTbl)
	local realParamTbl = {4, 6, 0, 3008, DIST_None, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end
	return HumanCommon_KeepDist_and_ThrowSomething(ai, goal, realParamTbl)
end

function defAct06(ai, goal, paramTbl)
	local realParamTbl = {3000, DIST_Far, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[3], 0) -- probability of performing actAfter
	goal:AddSubGoal(GOAL_COMMON_Attack, 10, realParamTbl[1], TARGET_ENE_0, realParamTbl[2], 0)
	return actAfterOdds
end

function defAct07(ai, goal, paramTbl)
	local realParamTbl = {1.5, 0, 3001, DIST_Middle}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end
	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)
	return 100
end

function defAct08(ai, goal, paramTbl)
	local realParamTbl = {nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[1], 0) -- probability of performing actAfter
	Watching_Parry_Chance_Act(ai, goal) -- walk around baiting a parry
	return actAfterOdds
end

function defAct09(ai, goal, paramTbl)
	local realParamTbl = {1.5, 0, 10, 40, nil, nil, nil, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end
	return HumanCommon_Approach_and_ComboAtk(ai, goal, realParamTbl)
end

function defAct10(ai, goal, paramTbl)
	local realParamTbl = {3000, 3001, 2, 4, 0}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end
	return HumanCommon_Shooting_Act(ai, goal, Tbl)
end

function defAct11(ai, goal, paramTbl)
	local realParamTbl = {3002, 3003, 2, 4, 0}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end
	return HumanCommon_Shooting_Act(ai, goal, Tbl)
end

function defAct12(ai, goal, paramTbl)
	local realParamTbl = {1.5, 0, 3001, DIST_Middle}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end
	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)
	return 100
end

function defAct13(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct14(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct15(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct16(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct17(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct18(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct19(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct20(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct21(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct22(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct23(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct24(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct25(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct26(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct27(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct28(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct29(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct30(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct31(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct32(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct33(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct34(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct35(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct36(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct37(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct38(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct39(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct40(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct41(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct42(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct43(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct44(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct45(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct46(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct47(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct48(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct49(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct50(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct51(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct52(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct53(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct54(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct55(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct56(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct57(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct58(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct59(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct60(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct61(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct62(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct63(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct64(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct65(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct66(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct67(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct68(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct69(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct70(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct71(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct72(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct73(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct74(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct75(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct76(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct77(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct78(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct79(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct80(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct81(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct82(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct83(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct84(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct85(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct86(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct87(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct88(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct89(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct90(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct91(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct92(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct93(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct94(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct95(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct96(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct97(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct98(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

function defAct99(ai, goal, paramTbl)

	local realParamTbl = {1.5, 0, 3000, DIST_Middle, nil}--default paramTbl values
	if paramTbl[1] ~= nil then
		realParamTbl = paramTbl
	end

	local range = realParamTbl[1]				--range at which to stop approach
	local walkDist = realParamTbl[1] + 2		--distance at which we'd walk
	local guardPer = realParamTbl[2]			--guard probability
	local attackId = realParamTbl[3]			--attack action id
	local attackSuccessDist = realParamTbl[4]	--attack success distance
	local actAfterOdds = GET_PARAM_IF_NIL_DEF(realParamTbl[5], 100)--actAfter probability
	--approach
	Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, attackSuccessDist)

	return actAfterOdds

end

---
-- Calls KeepDist_and_Attack_Act for given paramTbl. Moves away to a certain range and performs a noncombo attack. See usage for paramTbl entries.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam table paramTbl Param table, see usage for accepted entries.
-- @return Returns actAfter probability.
-- @usage
--local distMin = paramTbl[1]     --min dist to target
--local distMax = paramTbl[2]     --max dist to target
--local walkDist = paramTbl[2] + 2--walk if closer than this distance
--local guardPer = paramTbl[3]    --guard probability
--local attackId = paramTbl[4]    --attack action id
--local atkSuccessDist = paramTbl[5]--attack success dist
--local actAfterOdds = paramTbl[6]--actAfter probability, optional, default 0
function HumanCommon_KeepDist_and_ThrowSomething(ai, goal, paramTbl)
	local distMin = paramTbl[1]		--min dist to target
	local distMax = paramTbl[2]		--max dist to target
	local walkDist = paramTbl[2] + 2--walk if closer than this distance
	local guardPer = paramTbl[3]	--guard probability
	local attackId = paramTbl[4]	--attack action id
	local atkSuccessDist = paramTbl[5]--attack success dist
	-- move away to a certain range and perform a noncombo attack
	KeepDist_and_Attack_Act(ai, goal, distMin, distMax, walkDist, guardPer, attackId, atkSuccessDist)
	return GET_PARAM_IF_NIL_DEF(paramTbl[6], 0)
end

---
-- Calls GetWellSpace_Act for given paramTbl. Performs various actions based on paramTbl. See usage for paramTbl entries.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam table paramTbl Param table, see usage for accepted entries.
-- @usage
-- local guardPer = paramTbl[1]--guard probability
-- local act1Per = paramTbl[2] --do nothing probability
-- local act2Per = paramTbl[3] --back away and sideway probability
-- local act3Per = paramTbl[4] --back away probability
-- local act4Per = paramTbl[5] --wait probability
-- local act5Per = paramTbl[6] --backstep 701 probability
function HumanCommon_ActAfter_AdjustSpace(ai, goal, paramTbl)
	local guardPer = paramTbl[1]--guard probability
	local act1Per = paramTbl[2]	--do nothing probability
	local act2Per = paramTbl[3]	--back away and sideway probability
	local act3Per = paramTbl[4]	--back away probability
	local act4Per = paramTbl[5]	--wait probability
	local act5Per = paramTbl[6]	--backstep 701 probability
	GetWellSpace_Act(ai, goal, guardPer, act1Per, act2Per, act3Per, act4Per, act5Per)
end

---
-- Calls GetWellSpace_Act_IncludeSidestep for given paramTbl. Performs various actions based on paramTbl. See usage for paramTbl entries.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam table paramTbl Param table, see usage for accepted entries.
-- @usage
-- local guardPer = paramTbl[1]--guard probability
-- local act1Per = paramTbl[2] --do nothing probability
-- local act2Per = paramTbl[3] --back away and sideway probability
-- local act3Per = paramTbl[4] --back away probability
-- local act4Per = paramTbl[5] --wait probability
-- local act5Per = paramTbl[6] --backstep 6001 probability
-- local act6Per = paramTbl[7] --sidestep in random direction probability 6002/6003 action ids.
function HumanCommon_ActAfter_AdjustSpace_IncludeSidestep(ai, goal, paramTbl)
	local guardPer = paramTbl[1]--guard probability
	local act1Per = paramTbl[2]	--do nothing probability
	local act2Per = paramTbl[3]	--back away and sideway probability
	local act3Per = paramTbl[4]	--back away probability
	local act4Per = paramTbl[5]	--wait probability
	local act5Per = paramTbl[6]	--backstep 6001 probability
	local act6Per = paramTbl[7]	--sidestep in random direction probability 6002/6003 action ids.
	GetWellSpace_Act_IncludeSidestep(ai, goal, guardPer, act1Per, act2Per, act3Per, act4Per, act5Per, act6Per)
end

---
-- Approaches target and performs a combo of attacks. See usage for paramTbl entries. If probability fails both single and double attack combos it will do 3 attacks.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam table paramTbl Param table, see usage for accepted entries.
-- @return Returns actAfter probability (100 if not provided in paramTbl)
-- @usage
-- local range = paramTbl[1]       --range at which to stop approaching
-- local walkDist = paramTbl[1] + 2--walk if closer than this distance
-- local guardPer = paramTbl[2]    --guard probability
-- local singleAttPer = paramTbl[3]--probability to only do single attack (0-100)
-- local twoAttPer = paramTbl[4]   --probability to only do two attacks (0-100)
-- local att1Id = paramTbl[5]      --first attack id
-- local att2id = paramTbl[6]      --second attack id
-- local att3id = paramTbl[7]      --third attack id
-- local actAfterOdds = paramTbl[8]--actAfter probability. 100 if not provided.
function HumanCommon_Approach_and_ComboAtk(ai, goal, paramTbl)

	local range = paramTbl[1]		--range at which to stop approaching
	local walkDist = paramTbl[1] + 2--walk if closer than this distance
	local guardPer = paramTbl[2]	--guard probability
	Approach_Act(ai, goal, range, walkDist, guardPer)
	
	local att1Id = GET_PARAM_IF_NIL_DEF(paramTbl[5], 3000)--first atk of the combo
	local att2Id = GET_PARAM_IF_NIL_DEF(paramTbl[6], 3001)--second atk of the combo
	local att3Id = GET_PARAM_IF_NIL_DEF(paramTbl[7], 3002)--third atk of the combo
	local fate = ai:GetRandam_Int(1, 100)
	
	-- determine how many attacks to do based on their probabilities
	-- single attack
	if fate <= paramTbl[3] then
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, att1Id, TARGET_ENE_0, DIST_Middle, 0)
	-- two attacks
	elseif fate <= paramTbl[3] + paramTbl[4] then
		goal:AddSubGoal(GOAL_COMMON_ComboAttack, 10, att1Id, TARGET_ENE_0, DIST_Middle, 0)
		goal:AddSubGoal(GOAL_COMMON_ComboFinal, 10, att2Id, TARGET_ENE_0, DIST_Middle, 0)
	-- three attacks
	else
		goal:AddSubGoal(GOAL_COMMON_ComboAttack, 10, att1Id, TARGET_ENE_0, DIST_Middle, 0)
		goal:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, att2Id, TARGET_ENE_0, DIST_Middle, 0)
		goal:AddSubGoal(GOAL_COMMON_ComboFinal, 10, att3Id, TARGET_ENE_0, DIST_Middle, 0)
	end
	
	return GET_PARAM_IF_NIL_DEF(paramTbl[8], 100)
	
end

---
-- Walks around baiting parries. See usage for paramTbl entries.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam table paramTbl Param table, see usage for accepted entries.
-- @return Returns actAfter probability (100 if not provided in paramTbl)
-- @usage
--local actAfterOdds = paramTbl[1] --actAfter probability, 100 if not provided.
function HumanCommon_Watching_Parry_Chance_Act(ai, goal, paramTbl)
	Watching_Parry_Chance_Act(ai, goal)
	return GET_PARAM_IF_NIL_DEF(paramTbl[1], 100)
end

---
-- Calls Shoot_Act with given paramTbl values. See usage for paramTbl entries.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam table paramTbl Param table, see usage for accepted entries.
-- @return Returns 0 (actAfter probability).
-- @usage
--local attackId = paramTbl[1]       --first attack id
--local repeatAttackId = paramTbl[2] --all following attacks ids
--local attackMin = paramTbl[3]      --minimum times to attack. Resulting attack num will be random between min and max.
--local attackMax = paramTbl[4]      --maximum times to attack. Resulting attack num will be random between min and max.
--local actAfterType = paramTbl[5]   --what to do after attacking. 0 - nothing, 1 - walk away from the target, 2 - run away from the target.
function HumanCommon_Shooting_Act(ai, goal, paramTbl)

	local attackId = paramTbl[1]
	local repeatAttackId = paramTbl[2]
	local attackNum = ai:GetRandam_Int(paramTbl[3], paramTbl[4])
	local actAfterType = paramTbl[5]
	Shoot_Act(ai, goal, attackId, repeatAttackId, attackNum)
	
	if actAfterType == 0 then
	elseif actAfterType == 1 then
		goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 2, TARGET_ENE_0, 20, TARGET_ENE_0, true, -1)
	elseif actAfterType == 2 then
		goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 5, TARGET_ENE_0, 20, TARGET_SELF, false, -1)
	else
		ai:PrintText("��logical error, get the manager!�� ")
	end
	
	return 0
	
end

---
-- Returns passed param value if it isn't nil, defineVal otherwise.
-- @param param Param value.
-- @param defineVal Default value for the param.
-- @return Returns passed param value if it isn't nil, defineVal otherwise.
function GET_PARAM_IF_NIL_DEF(param, defineVal)
	if param ~= nil then
		return param
	end
	return defineVal
end

---
-- Creates a function wrapper that will call f with given parameters in the same order as provided when called.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam function f function to wrap.
-- @tparam table paramTbl Param table that's passed to f.
-- @return Returns a function that wraps f. This function takes no arguments, all arguments required by f are preserved through upvalues.
function REGIST_FUNC(ai, goal, f, paramTbl)
	return function()
		return f(ai, goal, paramTbl)
	end
end


