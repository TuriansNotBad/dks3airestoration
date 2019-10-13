---
-- @module CommonFuncs

---
-- Leftover from demon souls, shouldn't work as expected in DS3. Issues NPC_ATK_ChangeWep_L1 if left hand weapon isn't WEP_Primary for npcs.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
function CommonNPC_ChangeWepL1(ai, goal)
	local wepIndex = ai:GetEquipWeaponIndex(ARM_L)
	if WEP_Primary ~= wepIndex then
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, NPC_ATK_ChangeWep_L1, TARGET_NONE, DIST_None)
	end
end

---
-- Leftover from demon souls, shouldn't work as expected in DS3. Issues NPC_ATK_ChangeWep_R1 if right hand weapon isn't WEP_Primary for npcs.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
function CommonNPC_ChangeWepR1(ai, goal)
	local wepIndex = ai:GetEquipWeaponIndex(ARM_R)
	if WEP_Primary ~= wepIndex then
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, NPC_ATK_ChangeWep_R1, TARGET_NONE, DIST_None)
	end
end

---
-- Leftover from demon souls, shouldn't work as expected in DS3. Issues NPC_ATK_ChangeWep_L2 if left hand weapon isn't WEP_Secondary for npcs.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
function CommonNPC_ChangeWepL2(ai, goal)
	local wepIndex = ai:GetEquipWeaponIndex(ARM_L)
	if WEP_Secondary ~= wepIndex then
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, NPC_ATK_ChangeWep_L2, TARGET_NONE, DIST_None)
	end
end

---
-- Leftover from demon souls, shouldn't work as expected in DS3. Issues NPC_ATK_ChangeWep_R2 if right hand weapon isn't WEP_Secondary for npcs.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
function CommonNPC_ChangeWepR2(ai, goal)
	local wepIndex = ai:GetEquipWeaponIndex(ARM_R)
	if WEP_Secondary ~= wepIndex then
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, NPC_ATK_ChangeWep_R2, TARGET_NONE, DIST_None)
	end
end

---
-- Leftover from demon souls, shouldn't work as expected in DS3. Issues NPC_ATK_SwitchWep if not in both hand mode for npcs.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
function CommonNPC_SwitchBothHandMode(ai, goal)
	if not ai:IsBothHandMode(TARGET_SELF) then
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, NPC_ATK_SwitchWep, TARGET_NONE, DIST_None)
	end
end

---
-- Leftover from demon souls, shouldn't work as expected in DS3. Issues NPC_ATK_SwitchWep in both hand mode for npcs.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
function CommonNPC_SwitchOneHandMode(ai, goal)
	if ai:IsBothHandMode(TARGET_SELF) then
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, NPC_ATK_SwitchWep, TARGET_NONE, DIST_None)
	end
end

---
-- ApproachTarget wrapper for TARGET_ENE_0 for NPCs.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number range Range in which to stop.
-- @tparam number alwaysWalkDist Will always walk past this distance.
-- @tparam number walkDist Will rng whether to run or walk at this distance.
-- @tparam number runChance Odds of running instead of walking when past walkDist.
-- @tparam number guardChance Odds of performing the guard action (always 4 == NPC_ATK_L1).
-- @tparam number walkLife ApproachTarget goal life if we ended up walking (default = 3)
-- @tparam number runLife  ApproachTarget goal life if we ended up running (default = 8)
function NPC_Approach_Act_Flex(ai, goal, range, alwaysWalkDist, walkDist, runChance, guardChance, walkLife, runLife)

	if walkLife == nil then
		walkLife = 3 -- approach target life if we're walking
	end
	
	if runLife == nil then
		runLife = 8 -- approach target life if we're running
	end
	
	local targetDist = ai:GetDist(TARGET_ENE_0)
	local fateRun = ai:GetRandam_Int(1, 100) -- rng if we shud run
	local bWalk = true
	
	if targetDist >= walkDist then
		bWalk = false -- target is too far to walk
	elseif alwaysWalkDist <= targetDist and fateRun <= runChance then
		bWalk = false -- if we're farther than alwaysWalkDist and rng decides that we should run - Run
	end
	
	local guardEzId = -1
	local fateGuard = ai:GetRandam_Int(1, 100) -- rng if we shud guard
	if fateGuard <= guardChance then
		guardEzId = 4 -- NPC_ATK_L1
	end
	
	if bWalk == true then
		life = walkLife -- if we're walking set life to appropriate value
	else
		life = runLife
	end
	
	-- check if we're not within range already
	if range <= targetDist then
		if bWalk == true then
			range = range + ai:GetStringIndexedNumber("AddDistWalk") -- adjust range for walking
		else
			range = range + ai:GetStringIndexedNumber("AddDistRun") -- adjust range for running
		end
		-- gogo
		goal:AddSubGoal(GOAL_COMMON_ApproachTarget, life, TARGET_ENE_0, range, TARGET_SELF, bWalk, guardEzId)
	end
	
end

---
-- Switch to one handed for npcs, shouldn't work as intended in ds3.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
function NPC_KATATE_Switch(ai, goal)
	if ai:IsBothHandMode(TARGET_SELF) then
		goal:AddSubGoal(GOAL_COMMON_NonspinningComboAttack, 10, NPC_ATK_SwitchWep, TARGET_ENE_0, DIST_None, 0)
	end
end

---
-- Switch to two handed for npcs, shouldn't work as intended in ds3.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
function NPC_RYOUTE_Switch(ai, goal)
	if not ai:IsBothHandMode(TARGET_SELF) then
		goal:AddSubGoal(GOAL_COMMON_NonspinningComboAttack, 10, NPC_ATK_SwitchWep, TARGET_ENE_0, DIST_None, 0)
	end
end

---
-- Step escape if damaged within range and counterattack, shouldn't work as intended in ds3. Left from demon souls. Uses npcs action ids. Expects INTERUPT_Damaged.
--Can be used to escape combos.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number combRunDist combo escape distance.
-- @tparam number combRunPer probability to escape combo.
-- @tparam number combRunCountPer probability to fight back after the escape.
-- @tparam number countAct counterattack id.
-- @tparam number bkStepPer backstep probability.
-- @tparam number leftStepPer left step probability.
-- @tparam number rightStepPer right step probability.
-- @return Returns true if performed the step based on interrupt (INTERUPT_Damaged).
function Damaged_StepCount_NPCPlayer(ai, goal, combRunDist, combRunPer, combRunCountPer, countAct, bkStepPer, leftStepPer, rightStepPer)

	--argument description--
	--combRunDist			--combo escape distance
	--combRunPer			--probability to escape combo
	--combRunCountPer		--probability to fight back after the escape
	--countAct				--counterattack id
	--bkStepPer				--backstep probability
	--leftStepPer			--left step probability
	--rightStepPer			--right step probability

	local targetDist = ai:GetDist(TARGET_ENE_0);			--get distance to target
	local fate = ai:GetRandam_Int(1,100)					--rng if we should escape
	local fate2 = ai:GetRandam_Int(1,100)					--rng which step we should take
	local fate3 = ai:GetRandam_Int(1,100)					--rng if we should attack

	--do a step if we were damaged within distance
	--counterattack after stepping
	if ai:IsInterupt( INTERUPT_Damaged ) then
		if targetDist < combRunDist then
			if fate <= combRunPer then
				goal:ClearSubGoal();
				--escape
				if fate2 <= bkStepPer then
					goal:AddSubGoal( GOAL_COMMON_Attack, 10.0, NPC_ATK_StepB, TARGET_ENE_0, DIST_None, 0);
				elseif fate2 <= (bkStepPer + leftStepPer ) then
					goal:AddSubGoal( GOAL_COMMON_Attack, 10.0, NPC_ATK_StepL, TARGET_ENE_0, DIST_None, 0);
				else
					goal:AddSubGoal( GOAL_COMMON_Attack, 10.0, NPC_ATK_StepR, TARGET_ENE_0, DIST_None, 0);
				end	
				
				if fate3 <= combRunCountPer then
					goal:AddSubGoal( GOAL_COMMON_ComboAttack, 10.0, countAct, TARGET_ENE_0, DIST_Middle, 0);
				end
				return true;
			end
		end
	end
	
end

---
-- Step escape if enemy attacks within range, shouldn't work as intended in ds3. Left from demon souls. Uses NPC action ids. Expects INTERUPT_FindAttack.
--Can be used to escape combos.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superStepDist responding distance.
-- @tparam number superStepPer response chance.
-- @tparam number bkStepPer backstep probability.
-- @tparam number leftStepPer left step probability.
-- @tparam number rightStepPer right step probability.
-- @return Returns true if performed the step based on interrupt (INTERUPT_FindAttack).
function FindAttack_Step_NPCPlayer(ai, goal, superStepDist, superStepPer, bkStepPer, leftStepPer, rightStepPer)

	--argument description--
	--superStepDist			--responding distance
	--superStepPer			--response chance	
	--bkStepPer				--backstep probability
	--leftStepPer			--left step probability
	--rightStepPer			--right step probability

	local targetDist = ai:GetDist(TARGET_ENE_0);			--get distance to target
	local fate = ai:GetRandam_Int(1,100)					--rng should we step
	local fate2 = ai:GetRandam_Int(1,100)					--rng which step should we take

	--do a step if enemy attacks within a certain range
	if ai:IsInterupt( INTERUPT_FindAttack ) then
		if targetDist <= superStepDist then
			if fate <= superStepPer then
				--escape
				if fate2 <= bkStepPer then
					goal:AddSubGoal( GOAL_COMMON_Attack, 10.0, NPC_ATK_StepB, TARGET_ENE_0, DIST_None, 0);
				elseif fate2 <= (bkStepPer + leftStepPer ) then
					goal:AddSubGoal( GOAL_COMMON_Attack, 10.0, NPC_ATK_StepL, TARGET_ENE_0, DIST_None, 0);
				else
					goal:AddSubGoal( GOAL_COMMON_Attack, 10.0, NPC_ATK_StepR, TARGET_ENE_0, DIST_None, 0);
				end
				return true;
			end
		end
	end
end

---
-- Clears subgoal if enemy attacked within a certain distance. Expects INTERUPT_FindAttack. Useful to prevent this interrupt from leaving your goal and 
--being processed by parent goal and to just keep track of when an interrupt happens close enough.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superStepDist responding distance.
-- @tparam number superStepPer response chance.
-- @return Returns true if goal was cleared.
function FindAttack_Act(ai, goal, superStepDist, superStepPer)

	--argument description--
	--superStepDist			--responding distance
	--superStepPer			--response chance	
	
	local targetDist = ai:GetDist(TARGET_ENE_0) --get distance to enemy target
	local fate = ai:GetRandam_Int(1, 100) --rng if we should clear the goal
	
	-- enemies attacked within a certain distance
	if ai:IsInterupt(INTERUPT_FindAttack) and targetDist <= superStepDist and fate <= superStepPer then
		goal:ClearSubGoal()
		return true
	end
	return false
	
end

---
-- Step escape if enemy attacks within range. Uses 701,702,703 for step action ids. Expects INTERUPT_FindAttack. Can be used to escape combos.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superStepDist responding distance.
-- @tparam number superStepPer response chance.
-- @tparam[opt=50] number optBkStepPer backstep probability. Pass in nil to use default 50.
-- @tparam[opt=25] number optLeftStepPer left step probability. Pass in nil to use default 25.
-- @tparam[opt=25] number optRightStepPer right step probability. Pass in nil to use default 25.
-- @tparam[opt=3] number stepDist Distance the step will travel for safety judgement. Pass in nil to use default 3.
-- @return Returns true if performed the step based on interrupt (INTERUPT_FindAttack).
function FindAttack_Step(ai, goal, superStepDist, superStepPer, optBkStepPer, optLeftStepPer, optRightStepPer, stepDist)

	--argument description--
	--superStepDist			--responding distance
	--superStepPer			--response chance	
	--bkStepPer				--backstep probability
	--leftStepPer			--left step probability
	--rightStepPer			--right step probability
	--stepDist				--distance the step travels, won't do it if not enough space

	local targetDist = ai:GetDist(TARGET_ENE_0) --get distance to enemy target
	local fate1 = ai:GetRandam_Int(1, 100) --rng if we should step
	local fate2 = ai:GetRandam_Int(1, 100) --rng step direction
	local bkStepPer = GET_PARAM_IF_NIL_DEF(optBkStepPer, 50) --backstep probability
	local leftStepPer = GET_PARAM_IF_NIL_DEF(optLeftStepPer, 25) --left step probability
	local rightStepPer = GET_PARAM_IF_NIL_DEF(optRightStepPer, 25) --right step probability
	local safetyDist = GET_PARAM_IF_NIL_DEF(stepDist, 3) --distance the step travels, won't do it if not enough space
	
	--if enemy attacks within a certain range
	if ai:IsInterupt(INTERUPT_FindAttack) and targetDist <= superStepDist and fate1 <= superStepPer then
	
		goal:ClearSubGoal()
		--escape
		if fate2 <= bkStepPer then
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 701, TARGET_ENE_0, 0, AI_DIR_TYPE_B, safetyDist)
		elseif fate2 <= bkStepPer + leftStepPer then
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 702, TARGET_ENE_0, 0, AI_DIR_TYPE_L, safetyDist)
		else
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 703, TARGET_ENE_0, 0, AI_DIR_TYPE_R, safetyDist)
		end
		return true
		
	end
	
end

---
-- Guard and leave target + move sideways (always walks) if enemy attacks within a certain range. Uses 9910 for guard action id. Expects INTERUPT_FindAttack.
--Sideway move direction is random, angle is random between 30 and 45, will succeed when life expires.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superGuardDist responding distance.
-- @tparam number superGuardPer response chance.
-- @tparam[opt=40] number onlyBkPer Probability to only move backwards.
-- @tparam[opt=4] number sidewayLife Life of SidewayMove goal.
-- @tparam[opt=3] number bkDist Back off distance.
-- @return Returns true if performed the guard walk based on interrupt (INTERUPT_FindAttack).
function FindAttack_Guard(ai, goal, superGuardDist, superGuardPer, onlyBkPer, sidewayLife, bkDist)

	--argument description--
	--superGuardDist		--responding distance
	--superGuardPer			--response chance
	--onlyBkPer				--probability to only move back
	--sidewayLife			--life for sideway move goal
	--bkDist				--distance to back off for

	local targetDist = ai:GetDist(TARGET_ENE_0)					--get distance to the enemy
	local fate1 = ai:GetRandam_Int(1, 100)						--rng should we guard
	local fate2 = ai:GetRandam_Int(1, 100)						--rng should we only move back
	local l_onlyBkPer = GET_PARAM_IF_NIL_DEF(onlyBkPer, 40)		--probability to only move backwards
	local l_sidewayLife = GET_PARAM_IF_NIL_DEF(sidewayLife, 4)	--life for sideway move goal
	local l_bkDist = GET_PARAM_IF_NIL_DEF(bkDist, 3)			--back off distance
	
	--if enemy attacks within a certain range
	if ai:IsInterupt(INTERUPT_FindAttack) and targetDist <= superGuardDist and fate1 <= superGuardPer then
		goal:ClearSubGoal()
		--move and guard
		if fate2 <= l_onlyBkPer then
			goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 4, TARGET_ENE_0, l_bkDist, TARGET_ENE_0, true, 9910)
		else
			goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 4, TARGET_ENE_0, l_bkDist, TARGET_ENE_0, true, 9910)
			goal:AddSubGoal(GOAL_COMMON_SidewayMove, l_sidewayLife, TARGET_ENE_0, ai:GetRandam_Int(0, 1), ai:GetRandam_Int(30, 45), true, true, 9910)
		end
		return true
	end
	
end

---
--Will randomly choose to respond with a step or guard action. Same functionality as FindAttack_Guard and FindAttack_Step for each action. Expects INTERUPT_FindAttack.
--Uses 9910 for guard action id. Uses 701,702,703 for step action ids.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @tparam number stepPer Chance to step (will guard if not step).
-- @tparam[opt=50] number inBkStepPer backstep probability. Pass in nil to use default 50.
-- @tparam[opt=25] number inLeftStepPer left step probability. Pass in nil to use default 25.
-- @tparam[opt=25] number inRightStepPer right step probability. Pass in nil to use default 25.
-- @tparam[opt=3] number inSafetyDist Distance the step will travel for safety judgement. Pass in nil to use default 3.
-- @tparam[opt=40] number inGuardOnlyBkPer Probability to only move backwards.
-- @tparam[opt=4] number inGuardSidewayLife Life of SidewayMove goal.
-- @tparam[opt=3] number inGuardBkDist Back off distance.
-- @return Returns true if performed either of the actions based on interrupt (INTERUPT_FindAttack).
function FindAttack_Step_or_Guard(ai, goal, superDist, superPer, stepPer, inBkStepPer, inLeftStepPer,
	inRightStepPer, inSafetyDist, inGuardOnlyBkPer, inGuardSidewayLife, inGuardBkDist)
	
	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	--stepPer			--step probability (will guard if not step)
	--inBkStepPer		--backstep probability
	--inLeftStepPer		--left step probability
	--inRightStepPer	--right step probability
	--inSafetyDist		--distance the step travels, won't do it if not enough space
	--inGuardOnlyBkPer	--probability to only move back
	--inGuardSidewayLife--life for sideway move goal
	--inGuardBkDist		--distance to back off for

	local targetDist = ai:GetDist(TARGET_ENE_0)		--get distance to the enemy
	local fateSuper = ai:GetRandam_Int(1, 100)		--rng should we responsd
	local fateAct = ai:GetRandam_Int(1, 100)		--rng should we step or guard
	local fateActInternal = ai:GetRandam_Int(1, 100)--rng which step or rng if we only move backwards
	
	local bkStepPer = GET_PARAM_IF_NIL_DEF(inBkStepPer, 50)				--backstep probability
	local leftStepPer = GET_PARAM_IF_NIL_DEF(inLeftStepPer, 25)			--left step probability
	local rightStepPer = GET_PARAM_IF_NIL_DEF(inRightStepPer, 25)		--right step probability
	local safetyDist = GET_PARAM_IF_NIL_DEF(inSafetyDist, 3)			--distance the step travels, won't do it if not enough space
	local guardOnlyBkPer = GET_PARAM_IF_NIL_DEF(inGuardOnlyBkPer, 40)	--probability to only move back while guarding
	local guardSidewayLife = GET_PARAM_IF_NIL_DEF(inGuardSidewayLife, 4)--SidewayMove goal life
	local guardBkDist = GET_PARAM_IF_NIL_DEF(inGuardBkDist, 3)			--guard back away distance
	
	--if enemy attacked within certain distance
	if ai:IsInterupt(INTERUPT_FindAttack) and targetDist <= superDist and fateSuper <= superPer then
		if fateAct <= stepPer then
			goal:ClearSubGoal()
			--escape
			if fateActInternal <= bkStepPer then
				goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 701, TARGET_ENE_0, 0, AI_DIR_TYPE_B, safetyDist)
			elseif fateActInternal <= bkStepPer + leftStepPer then
				goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 702, TARGET_ENE_0, 0, AI_DIR_TYPE_L, safetyDist)
			else
				goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 703, TARGET_ENE_0, 0, AI_DIR_TYPE_R, safetyDist)
			end
			return true
		else
			goal:ClearSubGoal()
			--move and guard
			if fateActInternal <= guardOnlyBkPer then
				goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 4, TARGET_ENE_0, guardBkDist, TARGET_ENE_0, true, 9910)
			else
				goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 4, TARGET_ENE_0, guardBkDist, TARGET_ENE_0, true, 9910)
				goal:AddSubGoal(GOAL_COMMON_SidewayMove, guardSidewayLife, TARGET_ENE_0, ai:GetRandam_Int(0, 1), ai:GetRandam_Int(30, 45), true, true, 9910)
			end
			return true
		end
	end
end

---
-- Clears subgoal if took damage from an enemey within a certain distance. Expects INTERUPT_Damaged. Useful to prevent this interrupt from leaving your goal and 
--being processed by parent goal and to just keep track of when an interrupt happens close enough.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @return Returns true if cleared the subgoal based on interrupt (INTERUPT_FindAttack).
function Damaged_Act(ai, goal, superDist, superPer)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance

	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng if we should respond
	
	--if we got damaged by an enemy within certain distance
	if ai:IsInterupt(INTERUPT_Damaged) and targetDist < superDist and fate <= superPer then
		goal:ClearSubGoal()
		return true
	end
	return false
	
end

---
-- Guard and leave target + move sideways (always walks) if we took damage within a certain range. Uses 9910 for guard action id. Expects INTERUPT_Damaged.
--Sideway move direction is random, angle is random between 30 and 45, will succeed when life expires.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superGuardDist responding distance.
-- @tparam number superGuardPer response chance.
-- @tparam[opt=40] number onlyBkPer Probability to only move backwards.
-- @tparam[opt=4] number sidewayLife Life of SidewayMove goal.
-- @tparam[opt=3] number bkDist Back off distance.
-- @return Returns true if performed the guard walk based on interrupt (INTERUPT_Damaged).
function Damaged_Guard(ai, goal, superGuardDist, superGuardPer, onlyBkPer, sidewayLife, bkDist)

	--argument description--
	--superGuardDist		--responding distance
	--superGuardPer			--response chance
	--onlyBkPer				--probability to only move back
	--sidewayLife			--life for sideway move goal
	--bkDist				--distance to back off for
	
	local targetDist = ai:GetDist(TARGET_ENE_0)					--get distance to the enemy
	local fate1 = ai:GetRandam_Int(1, 100)						--rng should we respond
	local fate2 = ai:GetRandam_Int(1, 100)						--rng should we only move backwards when guarding
	local lOnlyBkPer = GET_PARAM_IF_NIL_DEF(onlyBkPer, 40)		--probability to only move backwards when guarding
	local lSidewayLife = GET_PARAM_IF_NIL_DEF(sidewayLife, 4)	--SidewayMove goal life
	local lBkDist = GET_PARAM_IF_NIL_DEF(bkDist, 3)				--backoff distance when guarding
	
	--if damaged within distance
	if ai:IsInterupt(INTERUPT_Damaged) and targetDist <= superGuardDist and fate1 <= superGuardPer then
		goal:ClearSubGoal()
		--move and guard
		if fate2 <= lOnlyBkPer then
			goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 4, TARGET_ENE_0, lBkDist, TARGET_ENE_0, true, 9910)
		else
			goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 4, TARGET_ENE_0, lBkDist, TARGET_ENE_0, true, 9910)
			goal:AddSubGoal(GOAL_COMMON_SidewayMove, lSidewayLife, TARGET_ENE_0, ai:GetRandam_Int(0, 1), ai:GetRandam_Int(30, 45), true, true, 9910)
		end
		return true
	end
	
end

---
-- Step escape if we took damage within range. Uses 701,702,703 for step action ids. Expects INTERUPT_Damaged. Can be used to escape combos.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superStepDist responding distance.
-- @tparam number superStepPer response chance.
-- @tparam[opt=50] number bkStepPer backstep probability. Pass in nil to use default 50.
-- @tparam[opt=25] number leftStepPer left step probability. Pass in nil to use default 25.
-- @tparam[opt=25] number rightStepPer right step probability. Pass in nil to use default 25.
-- @tparam[opt=3] number safetyDist Distance the step will travel for safety judgement. Pass in nil to use default 3.
-- @return Returns true if performed the step based on interrupt (INTERUPT_Damaged).
function Damaged_Step(ai, goal, superStepDist, superStepPer, bkStepPer, leftStepPer, rightStepPer, safetyDist)

	--argument description--
	--superStepDist			--responding distance
	--superStepPer			--response chance	
	--bkStepPer				--backstep probability
	--leftStepPer			--left step probability
	--rightStepPer			--right step probability
	--safetyDist				--distance the step travels, won't do it if not enough space

	local targetDist = ai:GetDist(TARGET_ENE_0)
	local fate1 = ai:GetRandam_Int(1, 100)
	local fate2 = ai:GetRandam_Int(1, 100)
	local lBkStepPer = GET_PARAM_IF_NIL_DEF(bkStepPer, 50)
	local lLeftStepPer = GET_PARAM_IF_NIL_DEF(leftStepPer, 25)
	local lRightStepPer = GET_PARAM_IF_NIL_DEF(rightStepPer, 25)
	local lSafetyDist = GET_PARAM_IF_NIL_DEF(safetyDist, 3)
	
	--if damaged within distance
	if ai:IsInterupt(INTERUPT_Damaged) and targetDist <= superStepDist and fate1 <= superStepPer then
		goal:ClearSubGoal()
		--escape
		if fate2 <= lBkStepPer then
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 701, TARGET_ENE_0, 0, AI_DIR_TYPE_B, lSafetyDist)
		elseif fate2 <= lBkStepPer + lLeftStepPer then
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 702, TARGET_ENE_0, 0, AI_DIR_TYPE_L, lSafetyDist)
		else
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 703, TARGET_ENE_0, 0, AI_DIR_TYPE_R, lSafetyDist)
		end
		return true
	end
	
end

---
--Will randomly choose to respond with a step or guard action. Same functionality as Damaged_Guard and Damaged_Step for each action. Expects INTERUPT_Damaged.
--Uses 9910 for guard action id. Uses 701,702,703 for step action ids.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @tparam number stepPer Chance to step (will guard if not step).
-- @tparam[opt=50] number bkStepPer backstep probability. Pass in nil to use default 50.
-- @tparam[opt=25] number leftStepPer left step probability. Pass in nil to use default 25.
-- @tparam[opt=25] number rightStepPer right step probability. Pass in nil to use default 25.
-- @tparam[opt=3] number safetyDist Distance the step will travel for safety judgement. Pass in nil to use default 3.
-- @tparam[opt=40] number onlyBkPer Probability to only move backwards.
-- @tparam[opt=4] number sidewayLife Life of SidewayMove goal.
-- @tparam[opt=3] number bkDist Back off distance.
-- @return Returns true if performed either of the actions based on interrupt (INTERUPT_Damaged).
function Damaged_Step_or_Guard(ai, goal, superDist, superPer, stepPer, bkStepPer, leftStepPer, rightStepPer, safetyDist, onlyBkPer, sidewayLife, bkDist)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	--stepPer			--step probability (will guard if not step)
	--bkStepPer			--backstep probability
	--leftStepPer		--left step probability
	--rightStepPer		--right step probability
	--safetyDist		--distance the step travels, won't do it if not enough space
	--onlyBkPer			--probability to only move back
	--sidewayLife		--life for sideway move goal
	--bkDist			--distance to back off for

	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate1 = ai:GetRandam_Int(1, 100)		--rng should we respond
	local fate2 = ai:GetRandam_Int(1, 100)		--rng should we step (will guard if not step)
	local fate3 = ai:GetRandam_Int(1, 100)		--rng which step or should we only move backwards when guarding
	
	local lBkStepPer = GET_PARAM_IF_NIL_DEF(bkStepPer, 50)		--backstep probability
	local lLeftStepPer = GET_PARAM_IF_NIL_DEF(leftStepPer, 25)	--left step probability
	local lRightStepPer = GET_PARAM_IF_NIL_DEF(rightStepPer, 25)--right step probability
	local lSafetyDist = GET_PARAM_IF_NIL_DEF(safetyDist, 3)		--distance the step travels, won't do it if not enough space
	local lOnlyBkPer = GET_PARAM_IF_NIL_DEF(onlyBkPer, 40)		--probability to only move back while guarding
	local lSidewayLife = GET_PARAM_IF_NIL_DEF(sidewayLife, 4)	--SidewayMove goal life
	local lBkDist = GET_PARAM_IF_NIL_DEF(bkDist, 3)				--back away distance
	
	--if damaged within distance
	if ai:IsInterupt(INTERUPT_Damaged) and targetDist <= superDist and fate1 <= superPer then
		if fate2 <= stepPer then
			goal:ClearSubGoal()
			--escape
			if fate3 <= lBkStepPer then
				goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 701, TARGET_ENE_0, 0, AI_DIR_TYPE_B, lSafetyDist)
			elseif fate3 <= lBkStepPer + lLeftStepPer then
				goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 702, TARGET_ENE_0, 0, AI_DIR_TYPE_L, lSafetyDist)
			else
				goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 703, TARGET_ENE_0, 0, AI_DIR_TYPE_R, lSafetyDist)
			end
			return true
		else
			goal:ClearSubGoal()
			--move and guard
			if fate3 <= lOnlyBkPer then
				goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 4, TARGET_ENE_0, lBkDist, TARGET_ENE_0, true, 9910)
			else
				goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 4, TARGET_ENE_0, lBkDist, TARGET_ENE_0, true, 9910)
				goal:AddSubGoal(GOAL_COMMON_SidewayMove, lSidewayLife, TARGET_ENE_0, ai:GetRandam_Int(0, 1), ai:GetRandam_Int(30, 45), true, true, 9910)
			end
			return true
		end
	end
	
end

---
-- If enemy guard is broken within distance clears subgoal. Expects INTERUPT_GuardBreak. Useful to prevent this interrupt from leaving your goal and 
--being processed by parent goal and to just keep track of when an interrupt happens close enough.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @return Returns true if cleared the subgoal based on interrupt (INTERUPT_GuardBreak).
function GuardBreak_Act(ai, goal, superDist, superPer)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng should we respond
	
	--if target guard was broken within range
	if ai:IsInterupt(INTERUPT_GuardBreak) and targetDist <= superDist and fate <= superPer then
		goal:ClearSubGoal()
		return true
	end
	return false
	
end

---
-- If enemy guard is broken within distance - attack. Expects INTERUPT_GuardBreak.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @tparam number counterAtk Attack id.
-- @return Returns true if performed the attack based on interrupt (INTERUPT_GuardBreak).
function GuardBreak_Attack(ai, goal, superDist, superPer, counterAtk)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	--counterAtk		--counter attack id
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng should we respond
	
	--if target guard was broken within range
	if ai:IsInterupt(INTERUPT_GuardBreak) and targetDist <= superDist and fate <= superPer then
		-- counter attack
		goal:ClearSubGoal()
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, counterAtk, TARGET_ENE_0, DIST_Middle, 0)
		return true
	end
	return false
	
end

---
-- If enemy missed a swing within distance clears subgoal. Expects INTERUPT_MissSwing. Useful to prevent this interrupt from leaving your goal and 
--being processed by parent goal and to just keep track of when an interrupt happens close enough. Same as MissSwing_Act.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @return Returns true if cleared the subgoal based on interrupt (INTERUPT_MissSwing).
function MissSwing_Int(ai, goal, superDist, superPer)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng should we respond
	
	--if target missed a swing within distance
	if ai:IsInterupt(INTERUPT_MissSwing) and targetDist <= superDist and fate <= superPer then
		goal:ClearSubGoal()
		return true
	end
	return false
	
end

---
-- If enemy missed a swing within distance - attack. Expects INTERUPT_GuardBreak.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @tparam number counterAtk Attack id.
-- @return Returns true if performed the attack based on interrupt (INTERUPT_GuardBreak).
function MissSwing_Attack(ai, goal, superDist, superPer, counterAtk)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	--counterAtk		--counter attack id
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng should we respond
	
	--if target missed a swing within distance
	if ai:IsInterupt(INTERUPT_MissSwing) and targetDist <= superDist and fate <= superPer then
		-- counter attack
		goal:ClearSubGoal()
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, counterAtk, TARGET_ENE_0, DIST_Middle, 0)
		return true
	end
	return false
	
end

---
-- If enemy used an item within distance clears subgoal. Expects INTERUPT_UseItem. Useful to prevent this interrupt from leaving your goal and 
--being processed by parent goal and to just keep track of when an interrupt happens close enough.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @return Returns true if cleared the subgoal based on interrupt (INTERUPT_UseItem).
function UseItem_Act(ai, goal, superDist, superPer)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng should we respond
	
	-- if enemy used an item within distance
	if ai:IsInterupt(INTERUPT_UseItem) and targetDist <= superDist and fate <= superPer then
		goal:ClearSubGoal()
		return true
	end
	
	return false
	
end

---
-- If enemy shot a projectile within distance clears subgoal. Expects INTERUPT_Shoot. Useful to prevent this interrupt from leaving your goal and 
--being processed by parent goal and to just keep track of when an interrupt happens close enough.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @return Returns true if cleared the subgoal based on interrupt (INTERUPT_Shoot).
function Shoot_1kind(ai, goal, superDist, superPer)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng should we respond
	
	local bkStepPer = GET_PARAM_IF_NIL_DEF(bkStepPer, 50)
	local leftStepPer = GET_PARAM_IF_NIL_DEF(leftStepPer, 25)
	local rightStepPer = GET_PARAM_IF_NIL_DEF(rightStepPer, 25)
	local safetyDist = GET_PARAM_IF_NIL_DEF(safetyDist, 3)
	
	-- if enemy shot a projectile within distance
	if ai:IsInterupt(INTERUPT_Shoot) and targetDist <= superDist and fate <= superPer then
		goal:ClearSubGoal()
		return true
	end
	return false
	
end

---
-- Finds index of which distance the enemy shot from and clears the subgoal. 0 if none. Simiar to FindShoot_Act but only has 2 distances. Expects INTERUPT_Shoot.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number shootActPer1 Response probability for the first distance.
-- @tparam number shootActPer2 Response probability for the second distance.
-- @tparam number shootActDist1 Response distance 1.
-- @tparam number shootActDist2 Response distance 2.
-- @return Returns 1 if target shot projectile at a distance <= shootActPer1. Returns 2 if target projectile at a distance <= shootActDist2.
--Returns 0 if outside the distance or rng decided not to respond.
function Shoot_2dist(ai, goal, shootActPer1, shootActPer2, shootActDist1, shootActDist2)

	--argument description--
	--shootActPer1	--response probability for the first distance
	--shootActPer2	--response probability for the second distance
	--shootActDist1	--response distance 1
	--shootActDist2	--response distance 2

	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate1 = ai:GetRandam_Int(1, 100)		--rng should we respond (shootActDist1)
	local fate2 = ai:GetRandam_Int(1, 100)		--rng should we respond (shootActDist2)
	
	--if enemy shot a projectile
	if ai:IsInterupt(INTERUPT_Shoot) then
		
		--if target within shootActDist1 and rng blessed us return 1
		if targetDist <= shootActPer1 and fate1 <= shootActDist1 then
			goal:ClearSubGoal()
			return 1
		--if target within shootActPer2 and rng blessed us return 2
		elseif targetDist <= shootActPer2 and fate1 <= shootActDist2 then
			goal:ClearSubGoal()
			return 2
		--if none return 0
		else
			return 0
		end
		
	end
	return 0 --if none return 0
	
end

---
-- Step escape if we missed a swing. Uses 701,702,703 for step action ids. Expects INTERUPT_MissSwingSelf.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superStepPer response chance.
-- @tparam[opt=50] number bkStepPer backstep probability. Pass in nil to use default 50.
-- @tparam[opt=25] number leftStepPer left step probability. Pass in nil to use default 25.
-- @tparam[opt=25] number rightStepPer right step probability. Pass in nil to use default 25.
-- @tparam[opt=3] number safetyDist Distance the step will travel for safety judgement. Pass in nil to use default 3.
-- @return Returns true if performed the step based on interrupt (INTERUPT_MissSwingSelf).
function MissSwingSelf_Step(ai, goal, superStepPer, bkStepPer, leftStepPer, rightStepPer, safetyDist)

	--argument description--
	--superStepPer			--response chance	
	--bkStepPer				--backstep probability
	--leftStepPer			--left step probability
	--rightStepPer			--right step probability
	--safetyDist			--distance the step travels, won't do it if not enough space

	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate1 = ai:GetRandam_Int(1, 100)		--rng if we should respond
	local fate2 = ai:GetRandam_Int(1, 100)		--rng which step
	
	local lBkStepPer = GET_PARAM_IF_NIL_DEF(bkStepPer, 50)		--backstep probability
	local lLeftStepPer = GET_PARAM_IF_NIL_DEF(leftStepPer, 25)	--left step probability
	local lRightStepPer = GET_PARAM_IF_NIL_DEF(rightStepPer, 25)--right step probability
	local lSafetyDist = GET_PARAM_IF_NIL_DEF(safetyDist, 3)		--distance the step travels, won't do it if not enough space
	
	--if i missed a swing
	if ai:IsInterupt(INTERUPT_MissSwingSelf) and fate1 <= superStepPer then
		goal:ClearSubGoal()
		--escape
		if fate2 <= lBkStepPer then
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 701, TARGET_ENE_0, 0, AI_DIR_TYPE_B, lSafetyDist)
		elseif fate2 <= lBkStepPer + lLeftStepPer then
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 702, TARGET_ENE_0, 0, AI_DIR_TYPE_L, lSafetyDist)
		else
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 703, TARGET_ENE_0, 0, AI_DIR_TYPE_R, lSafetyDist)
		end
		return true
	end
	
end

---
-- Step escape if we got rebound by opponent's guard. Uses 701,702,703 for step action ids. Expects INTERUPT_ReboundByOpponentGuard.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superStepPer response chance.
-- @tparam[opt=50] number bkStepPer backstep probability. Pass in nil to use default 50.
-- @tparam[opt=25] number leftStepPer left step probability. Pass in nil to use default 25.
-- @tparam[opt=25] number rightStepPer right step probability. Pass in nil to use default 25.
-- @tparam[opt=3] number safetyDist Distance the step will travel for safety judgement. Pass in nil to use default 3.
-- @return Returns true if performed the step based on interrupt (INTERUPT_ReboundByOpponentGuard).
function RebByOpGuard_Step(ai, goal, superStepPer, bkStepPer, leftStepPer, rightStepPer, safetyDist)

	--argument description--
	--superStepPer			--response chance	
	--bkStepPer				--backstep probability
	--leftStepPer			--left step probability
	--rightStepPer			--right step probability
	--safetyDist			--distance the step travels, won't do it if not enough space
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate1 = ai:GetRandam_Int(1, 100)		--rng if we should respond
	local fate2 = ai:GetRandam_Int(1, 100)		--rng which step
	
	local lBkStepPer = GET_PARAM_IF_NIL_DEF(bkStepPer, 50)		--backstep probability
	local lLeftStepPer = GET_PARAM_IF_NIL_DEF(leftStepPer, 25)	--left step probability
	local lRightStepPer = GET_PARAM_IF_NIL_DEF(rightStepPer, 25)--right step probability
	local lRightStepPer = GET_PARAM_IF_NIL_DEF(safetyDist, 3)		--distance the step travels, won't do it if not enough space
	
	--if i was repelled by an opponent's guard
	if ai:IsInterupt(INTERUPT_ReboundByOpponentGuard) and fate1 <= superStepPer then
		goal:ClearSubGoal()
		--escape
		if fate2 <= lBkStepPer then
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 701, TARGET_ENE_0, 0, AI_DIR_TYPE_B, lRightStepPer)
		elseif fate2 <= lBkStepPer + lLeftStepPer then
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 702, TARGET_ENE_0, 0, AI_DIR_TYPE_L, lRightStepPer)
		else
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 703, TARGET_ENE_0, 0, AI_DIR_TYPE_R, lRightStepPer)
		end
		return true
	end
	
end

---
-- If successfully guarded an enemy attack within distance clears subgoal. Expects INTERUPT_SuccessGuard. Useful to prevent this interrupt from leaving your goal and 
--being processed by parent goal and to just keep track of when an interrupt happens.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @return Returns true if cleared the subgoal based on interrupt (INTERUPT_SuccessGuard).
function SuccessGuard_Act(ai, goal, superDist, superPer)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate1 = ai:GetRandam_Int(1, 100)		--rng if we should respond
	local fate2 = ai:GetRandam_Int(1, 100)
	
	if ai:IsInterupt(INTERUPT_SuccessGuard) and targetDist <= superDist and fate1 <= superPer then
		goal:ClearSubGoal()
		return true
	end
	return false
	
end

---
-- If successfully guarded an enemy attack within distance - counter attack. Expects INTERUPT_SuccessGuard.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @tparam number counterAtk counter attack id.
-- @return Returns true if counter attacked based on interrupt (INTERUPT_SuccessGuard).
function SuccessGuard_Attack(ai, goal, superDist, superPer, counterAtk)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate1 = ai:GetRandam_Int(1, 100)		--rng if we should respond
	
	if ai:IsInterupt(INTERUPT_SuccessGuard) and targetDist <= superDist and fate1 <= superPer then
		--counter attack
		goal:ClearSubGoal()
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, counterAtk, TARGET_ENE_0, DIST_Middle, 0)
		return true
	end
	return false
	
end

---
-- Clears subgoal if took damage from an enemey outside a certain distance. Expects INTERUPT_Damaged. Useful to prevent this interrupt from leaving your goal and 
--being processed by parent goal and to just keep track of when an interrupt happens far enough.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number farResDist won't respond if enemy closer than this distance.
-- @tparam number farResPer response chance.
-- @return Returns true if cleared the subgoal based on interrupt (INTERUPT_Damaged).
function FarDamaged_Act(ai, goal, farResDist, farResPer)

	--argument description--
	--farResDist		--responding distance
	--farResPer			--response chance
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng if we should respond
	
	--if we were damage outside certain distance
	if ai:IsInterupt(INTERUPT_Damaged) and targetDist >= farResDist  and fate <= farResPer then
		goal:ClearSubGoal()
		return true
	end
	return false
	
end

---
-- If opponent missed a swing within distance clears subgoal. Expects INTERUPT_MissSwing. Useful to prevent this interrupt from leaving your goal and 
--being processed by parent goal and to just keep track of when an interrupt happens close enough. Same as MissSwing_Int.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @return Returns true if cleared the subgoal based on interrupt (INTERUPT_MissSwing).
function MissSwing_Act(ai, goal, superDist, superPer)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng if we should respond
	
	--if opponent missed a swing within certain distance
	if ai:IsInterupt(INTERUPT_MissSwing) and targetDist <= superDist and fate <= superPer then
		goal:ClearSubGoal()
		return true
	end
	return false
	
end

---
-- If opponent's guard broke within a certain distance clears subgoal. Expects INTERUPT_GuardBreak. Useful to prevent this interrupt from leaving your goal and 
--being processed by parent goal and to just keep track of when an interrupt happens close enough.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @return Returns true if cleared the subgoal based on interrupt (INTERUPT_GuardBreak).
function FindGuardBreak_Act(ai, goal, superDist, superPer)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng if we should respond
	
	--if opponent's guard broke within a certain distance
	if ai:IsInterupt(INTERUPT_GuardBreak) and targetDist <= superDist and fate <= superPer then
		goal:ClearSubGoal()
		return true
	end
	return false
	
end

---
-- If opponent stopped guarding within a certain distance clears subgoal. Expects INTERUPT_GuardFinish. Useful to prevent this interrupt from leaving your goal and 
--being processed by parent goal and to just keep track of when an interrupt happens close enough.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number superDist responding distance.
-- @tparam number superPer response chance.
-- @return Returns true if cleared the subgoal based on interrupt (INTERUPT_GuardFinish).
FindGuardFinish_Act = function(ai, goal, superDist, superPer)

	--argument description--
	--superDist			--responding distance
	--superPer			--response chance
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng if we should respond
	
	--if opponent stopped guarding within a certain distance
	if ai:IsInterupt(INTERUPT_GuardFinish) and targetDist <= superDist and fate <= superPer then
		goal:ClearSubGoal()
		return true
	end
	return false
	
end

---
-- Finds index of which distance the enemy shot from and clears the subgoal. 0 if none. Simiar to Shoot_2dist but has 3 distances. Expects INTERUPT_Shoot.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number shootActPer1 Response probability for the first distance.
-- @tparam number shootActPer2 Response probability for the second distance.
-- @tparam number shootActPer3 Response probability for the third distance.
-- @tparam number shootActDist1 Response distance 1.
-- @tparam number shootActDist2 Response distance 2.
-- @tparam number shootActDist3 Response distance 3.
-- @return Returns 1 if target shot projectile at a distance <= shootActPer1. Returns 2 if target projectile at a distance <= shootActDist2.
--Returns 3 if target shot projectile at a distance <= shootActPer3. Returns 0 if outside the distance or rng decided not to respond.
function FindShoot_Act(ai, goal, shootActPer1, shootActPer2, shootActPer3, shootActDist1, shootActDist2, shootActDist3)

	--argument description--
	--shootActPer1	--response probability for the first distance
	--shootActPer2	--response probability for the second distance
	--shootActPer3	--response probability for the third distance
	--shootActDist1	--response distance 1
	--shootActDist2	--response distance 2
	--shootActDist1	--response distance 3
	
	local targetDist = ai:GetDist(TARGET_ENE_0)	--get distance to the enemy
	local fate = ai:GetRandam_Int(1, 100)		--rng if we should respond
	
	if ai:IsInterupt(INTERUPT_Shoot) then
		--if target within shootActDist1 and rng blessed us return 1
		if targetDist <= shootActDist1 and fate <= shootActPer1 then
			goal:ClearSubGoal()
			return 1
		--if target within shootActDist2 and rng blessed us return 2
		elseif targetDist <= shootActDist2 and fate <= shootActPer2 then
			goal:ClearSubGoal()
			return 2
		--if target within shootActDist3 and rng blessed us return 3
		elseif targetDist <= shootActDist3 and fate <= shootActPer3 then
			goal:ClearSubGoal()
			return 3
		else
		--if none return 0
			goal:ClearSubGoal()
			return 0
		end
	end
	return 0 --if none return 0
	
end

---
-- Basic wrapper for ApproachTarget, allows to set walking distance and guard chance (action is always 9910).
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number range Range at which to stop walking towards the target.
-- @tparam boolean walkDist Distance at which we'll walk instead of running.
-- @tparam number guardPer Guard chance.
function BusyApproach_Act(ai, goal, range, walkDist, guardPer)

	local guardId = -1						--guard action id
	local fate = ai:GetRandam_Int(1, 100)	--rng if we should guard
	
	--if rng has us guard set the proper id
	if fate <= guardPer then
		guardId = 9910
	end
	
	local targetDist = ai:GetDist(TARGET_ENE_0) --get distance to the enemy
	
	if targetDist >= walkDist  then
		--run
		goal:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, TARGET_ENE_0, range, TARGET_SELF, false, guardId)
	else
		--walk
		goal:AddSubGoal(GOAL_COMMON_ApproachTarget, 2, TARGET_ENE_0, range, TARGET_SELF, true, guardId)
	end
	
end

---
-- Directs AI to approach the target and perform a noncombo attack. Attack goal used is GOAL_COMMON_AttackTunableSpin.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number range Range at which to stop walking towards the target.
-- @tparam boolean walkDist Distance at which we'll walk instead of running.
-- @tparam number guardPer Guard chance.
-- @tparam number attackId Attack action id.
-- @tparam number atkSuccessDist If target ever farther than this distance - we've failed.
-- @tparam[opt=1.5] number turnTime Time it'll spend turning before attacking.
-- @tparam[opt=20] number frontJgAngle Angle used to decide if there's a need to turn. If target is out of this angle will attempt to turn.
function Approach_and_Attack_Act(ai, goal, range, walkDist, guardPer, attackId, atkSuccessDist, turnTime, frontJgAngle)

	local targetDist = ai:GetDist(TARGET_ENE_0) --get distance to the enemy
	local bWalk = true --walk?
	if walkDist <= targetDist then
		-- target too far, run
		bWalk = false
	end
	
	local guardId = -1 --guard action id
	local fate = ai:GetRandam_Int(1, 100) --rng should we guard
	if fate <= guardPer then
		--rng told us to guard, put in a proper action id
		guardId = 9910
	end
	
	local lTurnTime = GET_PARAM_IF_NIL_DEF(turnTime, 1.5)		--time it'll spend turning before attacking
	local lFrontJgAngle = GET_PARAM_IF_NIL_DEF(frontJgAngle, 20)--angle used to decide if there's a need to turn
	
	-- walk and attack
	goal:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, TARGET_ENE_0, range, TARGET_SELF, bWalk, guardId)
	goal:AddSubGoal(GOAL_COMMON_AttackTunableSpin, 10, attackId, TARGET_ENE_0, atkSuccessDist, lTurnTime, lFrontJgAngle)
	
end

---
-- Directs AI to move away to a certain distance range from the target and perform a noncombo attack. Attack goal used is GOAL_COMMON_Attack.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number distMin Min distance to the target.
-- @tparam number distMax Max distance to the target.
-- @tparam boolean walkDist Distance at which we'll walk instead of running.
-- @tparam number guardPer Guard chance.
-- @tparam number attackId Attack action id.
-- @tparam number atkSuccessDist If target ever farther than this distance - we've failed.
function KeepDist_and_Attack_Act(ai, goal, distMin, distMax, walkDist, guardPer, attackId, atkSuccessDist)

	local targetDist = ai:GetDist(TARGET_ENE_0) --get distance to the enemy
	local bWalk = true --walk?
	if walkDist <= targetDist then
		-- target too far, run
		bWalk = false
	end
	
	local guardId = -1 --guard action id
	local fate = ai:GetRandam_Int(1, 100) --rng should we guard
	if fate <= guardPer then
		--rng told us to guard, put in a proper action id
		guardId = 9910
	end
	
	-- keep distance and attack
	goal:AddSubGoal(GOAL_COMMON_KeepDist, 10, TARGET_ENE_0, distMin, distMax, TARGET_ENE_0, bWalk, guardId)
	goal:AddSubGoal(GOAL_COMMON_Attack, 10, attackId, TARGET_ENE_0, atkSuccessDist, 0)
	
end

---
-- Directs AI to approach the target and try to break its guard. After the guard is broken will perform a final finisher hit.
--Attack goal used is GOAL_COMMON_GuardBreakAttack and GOAL_COMMON_ComboFinal.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number range Range at which to stop walking towards the target.
-- @tparam boolean walkDist Distance at which we'll walk instead of running.
-- @tparam number guardPer Guard chance.
-- @tparam number atkBreakId GuardBreak attack action id.
-- @tparam number atkSuccessDist If target ever farther than this distance while guard breaking - we've failed.
-- @tparam number atkFinisherId Finisher attack action id.
-- @tparam number finisherSuccessDist If target ever farther than this distance while in the ComboFinal goal - we've failed.
function Approach_and_GuardBreak_Act(ai, goal, range, walkDist, guardPer, atkBreakId, atkSuccessDist, atkFinisherId, finisherSuccessDist)

	local targetDist = ai:GetDist(TARGET_ENE_0) -- enemy distance
	local bWalk = true -- walk?
	if walkDist <= targetDist then
		-- target too far, run
		bWalk = false
	end
	
	local guardId = -1 --guard action id
	local fate = ai:GetRandam_Int(1, 100) --rng should we guard
	if fate <= guardPer then
		--rng told us to guard, put in a proper action id
		guardId = 9910
	end
	
	-- approach and attempt to guard break and do a final hit if guard broken
	goal:AddSubGoal(GOAL_COMMON_ApproachTarget, 10, TARGET_ENE_0, range, TARGET_SELF, bWalk, guardId)
	goal:AddSubGoal(GOAL_COMMON_GuardBreakAttack, 10, atkBreakId, TARGET_ENE_0, atkSuccessDist, 0)
	goal:AddSubGoal(GOAL_COMMON_ComboFinal, 10, atkFinisherId, TARGET_ENE_0, finisherSuccessDist, 0)
	
end

---
-- Generic GetWellSpace action.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number guardPer Guard chance.
-- @tparam number act1Per Chance to do nothing.
-- @tparam number act2Per Chance to back away and sideway move.
-- @tparam number act3Per Chance to just back away.
-- @tparam number act4Per Chance to wait.
-- @tparam number act5Per Chance to backstep (action id 701).
function GetWellSpace_Act(ai, goal, guardPer, act1Per, act2Per, act3Per, act4Per, act5Per)

	local guardId = -1
	local fateGuard = ai:GetRandam_Int(1, 100)
	if fateGuard <= guardPer then
		guardId = 9910
	end
	
	local fate = ai:GetRandam_Int(1, 100)
	local right = ai:GetRandam_Int(0, 1)
	-- number of friends moving in the same direction
	local friendNum = ai:GetTeamRecordCount(COORDINATE_TYPE_SideWalk_L + right, TARGET_ENE_0, 2)
	
	-- do nothing
	if fate <= act1Per then
	-- back away and sideway move
	elseif fate <= act1Per + act2Per and friendNum < 2 then
		goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 2.5, TARGET_ENE_0, 2, TARGET_ENE_0, true, guardId)
		goal:AddSubGoal(GOAL_COMMON_SidewayMove, 3, TARGET_ENE_0, right, ai:GetRandam_Int(30, 45), true, true, guardId)
	-- back away
	elseif fate <= act1Per + act2Per + act3Per then
		goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 2.5, TARGET_ENE_0, 3, TARGET_ENE_0, true, guardId)
	-- wait
	elseif fate <= act1Per + act2Per + act3Per + act4Per then
		goal:AddSubGoal(GOAL_COMMON_Wait, ai:GetRandam_Float(0.5, 1), 0, 0, 0, 0)
	-- backstep
	else
		goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 701, TARGET_ENE_0, 0, AI_DIR_TYPE_B, 4)
	end
	
end

---
-- Generic GetWellSpace action with additional sidestep possibility.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number guardPer Guard chance.
-- @tparam number act1Per Chance to do nothing.
-- @tparam number act2Per Chance to back away and sideway move.
-- @tparam number act3Per Chance to just back away.
-- @tparam number act4Per Chance to wait.
-- @tparam number act5Per Chance to backstep (action id 6001).
-- @tparam number act6Per Chance to sidestep in random direction (action id 6002/6003).
function GetWellSpace_Act_IncludeSidestep(ai, goal, guardPer, act1Per, act2Per, act3Per, act4Per, act5Per, act6Per)

	local guardId = -1
	local fateGuard = ai:GetRandam_Int(1, 100)
	if fateGuard <= guardPer then
		guardId = 9910
	end
	
	local fate = ai:GetRandam_Int(1, 100)
	local right = ai:GetRandam_Int(0, 1)
	-- number of friends moving in the same direction
	local friendNum = ai:GetTeamRecordCount(COORDINATE_TYPE_SideWalk_L + right, TARGET_ENE_0, 2)
	
	-- do nothing
	if fate <= act1Per then
	-- back away and sideway move
	elseif fate <= act1Per + act2Per and friendNum < 2 then
		goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 2.5, TARGET_ENE_0, 2, TARGET_ENE_0, true, guardId)
		goal:AddSubGoal(GOAL_COMMON_SidewayMove, 3, TARGET_ENE_0, right, ai:GetRandam_Int(30, 45), true, true, guardId)
	-- back away
	elseif fate <= act1Per + act2Per + act3Per then
		goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 2.5, TARGET_ENE_0, 3, TARGET_ENE_0, true, guardId)
	-- wait
	elseif fate <= act1Per + act2Per + act3Per + act4Per then
		goal:AddSubGoal(GOAL_COMMON_Wait, ai:GetRandam_Float(0.5, 1), 0, 0, 0, 0)
	-- backstep
	elseif fate <= act1Per + act2Per + act3Per + act4Per + act5Per then
		goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 6001, TARGET_ENE_0, 0, AI_DIR_TYPE_B, 4)
	-- sidestep
	else
		local fateStepDir = ai:GetRandam_Int(1, 100)
		-- sidestep left
		if fateStepDir <= 50 then
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 6002, TARGET_ENE_0, 0, AI_DIR_TYPE_L, 4)
		-- sidestep right
		else
			goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 6003, TARGET_ENE_0, 0, AI_DIR_TYPE_R, 4)
		end
	end
end

---
-- Attacks the TARGET_ENE_0 specified amount of time in a row. First attack is always the attackId, rest are attackRepeatId.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number attackId First attack id.
-- @tparam number attackRepeatId Id of all consecutive attacks.
-- @tparam number attackNum How many times to attack. 5 is max.
function Shoot_Act(ai, goal, attackId, attackRepeatId, attackNum)
	if attackNum == 1 then
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, attackId, TARGET_ENE_0, DIST_None, 0)
	elseif attackNum >= 2 then
		goal:AddSubGoal(GOAL_COMMON_ComboAttack, 10, attackId, TARGET_ENE_0, DIST_None, 0)
		if attackNum >= 3 then
			goal:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, attackRepeatId, TARGET_ENE_0, DIST_None, 0)
			if attackNum >= 4 then
				goal:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, attackRepeatId, TARGET_ENE_0, DIST_None, 0)
				if attackNum >= 5 then
					goal:AddSubGoal(GOAL_COMMON_ComboRepeat, 10, attackRepeatId, TARGET_ENE_0, DIST_None, 0)
				end
			end
		end
		goal:AddSubGoal(GOAL_COMMON_ComboFinal, 10, attackRepeatId, TARGET_ENE_0, DIST_None, 0)
	end
end

---
-- Approach target wrapper for TARGET_ENE_0.
-- @tparam userdate ai Ai object.
-- @tparam userdata goal Goal object.
-- @tparam number range Range in which we stop.
-- @tparam number walkDist If we're farther than this dist - run.
-- @tparam number guardPer Percent chance to guard while moving. Guard action is always 9910.
-- @tparam[opt=10] number actLife Life for the approach goal. Default 10.
function Approach_Act(ai, goal, range, walkDist, guardPer, actLife)
	
	if actLife == nil then actLife = 10 end
	
	local targetDist = ai:GetDist(TARGET_ENE_0)
	-- determine if we should walk
	local bWalk = true
	if walkDist <= targetDist then
		bWalk = false
	end
	-- determine if we should guard
	local bWalk = -1
	local guardFate = ai:GetRandam_Int(1, 100)
	if guardFate <= guardPer then
		bWalk = 9910
	end
	
	goal:AddSubGoal(GOAL_COMMON_ApproachTarget, actLife, TARGET_ENE_0, range, TARGET_SELF, bWalk, bWalk)
	
end

---
-- Approach target or leave depending on the distance. Always walks when leaving.
-- @tparam userdate ai Ai object.
-- @tparam userdata goal Goal object.
-- @tparam number leaveDist Distance at which we'll leave the target.
-- @tparam number range Range in which we stop approaching.
-- @tparam number walkDist If we're farther than this dist - run.
-- @tparam number guardPer Percent chance to guard while moving. Guard action is always 9910.
function Approach_or_Leave_Act(ai, goal, leaveDist, range, walkDist, guardPer)

	local targetDist = ai:GetDist(TARGET_ENE_0)
	-- determine if we should walk
	local bWalk = true
	if walkDist ~= -1 and walkDist <= targetDist then
		bWalk = false
	end
	-- determine if we should guard
	local guardId = -1
	local fate = ai:GetRandam_Int(1, 100)
	if fate <= guardPer then
		guardId = 9910
	end
	-- determine if we should approach
	if targetDist >= leaveDist then
		goal:AddSubGoal(GOAL_COMMON_ApproachTarget, 5, TARGET_ENE_0, range, TARGET_SELF, bWalk, guardId)
	else
		goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 5, TARGET_ENE_0, leaveDist, TARGET_ENE_0, true, guardId)
	end
	
end

---
-- Keeps at a certain distance range and moves sideways with guard action 9920. Probably just sets up bait for attacks so you can parry them.
-- @tparam userdate ai Ai object.
-- @tparam userdata goal Goal object.
function Watching_Parry_Chance_Act(ai, goal)

	FirstDist = ai:GetRandam_Float(2, 4)
	SecondDist = ai:GetRandam_Float(2, 4)
	
	goal:AddSubGoal(GOAL_COMMON_KeepDist, 5, TARGET_ENE_0, FirstDist, FirstDist + 0.5, TARGET_ENE_0, true, 9920)
	goal:AddSubGoal(GOAL_COMMON_SidewayMove, ai:GetRandam_Float(3, 5), TARGET_ENE_0, ai:GetRandam_Int(0, 1), 180, true, true, 9920)
	
	goal:AddSubGoal(GOAL_COMMON_KeepDist, 5, TARGET_ENE_0, SecondDist, SecondDist + 0.5, TARGET_ENE_0, true, 9920)
	goal:AddSubGoal(GOAL_COMMON_SidewayMove, ai:GetRandam_Float(3, 5), TARGET_ENE_0, ai:GetRandam_Int(0, 1), 180, true, true, 9920)
	
end

---
-- Parries or ripostes an opponent if conditions are met. Checks for either INTERUPT_ParryTiming or INTERUPT_SuccessParry. If INTERUPT_ParryTiming then
--will parry with action id 4000. If INTERUPT_SuccessParry will approach the target, stop for half a second, then perform the 3110 attack.
-- @tparam userdate ai Ai object.
-- @tparam userdata goal Goal object.
-- @tparam number parryDist Distance at which we respond to INTERUPT_ParryTiming.
-- @tparam number parryAngleRange Angle range from the front of the AI. Used to check if opponent is in front of us before attempting the parry.
--Won't parry if out of this angle.
-- @tparam number riposteDist Distance at which we respond to INTERUPT_SuccessParry.
-- @tparam number riposteAngleRange Angle range from the front of the AI. Used to check if opponent is in front of us before approaching the target for riposte.
--Won't riposte if out of this angle.
-- @return Returns true if responded to either of the interrupts.
function Parry_Act(ai, goal, parryDist, parryAngleRange, riposteDist, riposteAngleRange)

	local targetDist = ai:GetDist(TARGET_ENE_0)
	--if it's time to parry
	if ai:IsInterupt( INTERUPT_ParryTiming ) then
	
		if targetDist <= parryDist then --target within the parry atempt distance
			if ai:IsInsideTarget( TARGET_ENE_0, AI_DIR_TYPE_F, parryAngleRange ) then
				if not ai:IsActiveGoal( GOAL_COMMON_Parry ) then
					goal:ClearSubGoal()
					--parry
					goal:AddSubGoal( GOAL_COMMON_Parry, 1.25, 4000, TARGET_SELF, 0 )
					return true
				end
			end
		end
	--if we successfully parried an opponent
	elseif ai:IsInterupt( INTERUPT_SuccessParry ) then
	
		if targetDist <= riposteDist then --target within the riposte attempt distance
			if ai:IsInsideTarget( TARGET_ENE_0, AI_DIR_TYPE_F, riposteAngleRange ) then
				goal:ClearSubGoal()
				--approach and riposte
				goal:AddSubGoal( GOAL_COMMON_ApproachTarget, 3, TARGET_ENE_0, 1, TARGET_SELF, false, -1 )
				goal:AddSubGoal( GOAL_COMMON_Wait, ai:GetRandam_Float( 0.3, 0.6 ), TARGET_ENE_0 )
				goal:AddSubGoal( GOAL_COMMON_AttackTunableSpin, 10, 3110, TARGET_ENE_0, 3, 0, -1 )
				return true
			end
		end
		
	end
end

---
--Adds an observe area behind TARGET_ENE_0. If we enter the required range and angle behind the target will trigger INTERUPT_Inside_ObserveArea.
-- @tparam userdate ai Ai object.
-- @tparam userdata goal Goal object.
-- @tparam number areaSlot Slot for this observe area. Allows you to have multiple observe areas. You can use ai:IsInsideObserve( areaSlot ) to see
--if the particular area of interest is invaded by the target.
-- @tparam number backposDistRange Distance from behind the target in which we'll trigger the interrupt.
-- @tparam number backposAngleRange Angle range from behind the target in which we'll trigger the interrupt.
function ObserveAreaForBackstab(ai, goal, areaSlot, backposDistRange, backposAngleRange)
	ai:AddObserveArea(areaSlot, TARGET_ENE_0, TARGET_SELF, AI_DIR_TYPE_B, backposAngleRange, backposDistRange)
end

---
-- Will attempt to approach target and backstab. Expects properly set up backstabbing position through INTERUPT_Inside_ObserveArea at the specified areaSlot.
--If on cooldown - will not attempt to backstab. Attack used is 3110.
-- @tparam userdate ai Ai object.
-- @tparam userdata goal Goal object.
-- @tparam number areaSlot Slot for this observe area. Allows you to have multiple observe areas. You can use ai:IsInsideObserve( areaSlot ) to see
--if the particular area of interest is invaded by the target.
-- @tparam number bkstabRange Range within which to approach the target.
-- @tparam number cdTimerSlot Slot for the ai timer for backstab cooldown.
-- @tparam number cdTime Cooldown time for the backstab.
-- @return Returns true if responded to the interrupt.
function Backstab_Act(ai, goal, areaSlot, bkstabRange, cdTimerSlot, cdTime)

	-- if we're inside the observe area at the required slot, the cooldown has passed and we are not in a synced animation
	if ai:IsInterupt(INTERUPT_Inside_ObserveArea) and ai:IsThrowing() == false and ai:IsFinishTimer(cdTimerSlot) == true and ai:IsInsideObserve(areaSlot) then
		-- reset the cooldown timer
		ai:SetTimer(cdTimerSlot, cdTime)
		goal:ClearSubGoal()
		-- approach and backstab
		goal:AddSubGoal(GOAL_COMMON_ApproachTarget, 5, TARGET_ENE_0, bkstabRange, TARGET_SELF, false, -1)
		goal:AddSubGoal(GOAL_COMMON_Attack, 10, 3110, TARGET_ENE_0, 3, 0)
		
		return true
		
	end
	
end

---
-- Moves around the TARGET_ENE_0 at a reasonable distance. Can be used to occupy enemies that aren't supposed to be fighting for whatever reason.
--If targetDist >= 6 will walk towards the target to a range of 4.5, >= 3 will SidewayMove, if closer will leave target. After that it will SidewayMove in a random
--direction for 3 seconds. This is called automatically if you use Common_Battle_Activate.
-- @tparam userdate ai Ai object.
-- @tparam userdata goal Goal object.
-- @tparam number guardPer Probability to guard while moving.
-- @usage
--local role = ai:GetTeamOrder(ORDER_TYPE_Role)
--if role == ROLE_TYPE_Torimaki then
--    Torimaki_Act(ai, goal, 30)
--end
function Torimaki_Act(ai, goal, guardPer)

	local guardId = -1
	-- determine if we should guard
	local fate = ai:GetRandam_Int(1, 100)
	if fate <= guardPer then
		guardId = 9910
	end
	
	local targetDist = ai:GetDist(TARGET_ENE_0)
	-- if you're far you will walk towards the target
	if targetDist >= 15 then
		goal:AddSubGoal(GOAL_COMMON_ApproachTarget, 5, TARGET_ENE_0, 4.5, TARGET_SELF, true, -1)
	-- if you're far you will walk towards the target
	elseif targetDist >= 6 then
		goal:AddSubGoal(GOAL_COMMON_ApproachTarget, 5, TARGET_ENE_0, 4.5, TARGET_SELF, true, -1)
	-- move around at a reasonable distance
	elseif targetDist >= 3 then
		goal:AddSubGoal(GOAL_COMMON_SidewayMove, 3, TARGET_ENE_0, ai:GetRandam_Int(0, 1), ai:GetRandam_Int(30, 45), true, true, guardId)
	-- move away from the target
	else
		goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 5, TARGET_ENE_0, 4, TARGET_ENE_0, true, guardId)
	end
	-- move around at a reasonable distance
	goal:AddSubGoal(GOAL_COMMON_SidewayMove, 3, TARGET_ENE_0, ai:GetRandam_Int(0, 1), ai:GetRandam_Int(30, 45), true, true, guardId)
	
end

---
-- Moves around the TARGET_ENE_0 at a reasonable distance. Can be used to occupy enemies that aren't supposed to be fighting for whatever reason.
--If targetDist >= 8 will walk towards the target to a range of 4.5, >= 4 will SidewayMove, if closer will leave target. After that it will SidewayMove in a random
--direction for 3 seconds. This is called automatically if you use Common_Battle_Activate.
-- @tparam userdate ai Ai object.
-- @tparam userdata goal Goal object.
-- @tparam number guardPer Probability to guard while moving.
-- @usage
--local role = ai:GetTeamOrder(ORDER_TYPE_Role)
--if role == ROLE_TYPE_Kankyaku then
--    Kankyaku_Act(ai, goal, 30)
--end
function Kankyaku_Act(ai, goal, guardPer)

	local guardId = -1
	-- determine if we should guard
	local fate = ai:GetRandam_Int(1, 100)
	if fate <= guardPer then
		guardId = 9910
	end
	
	local targetDist = ai:GetDist(TARGET_ENE_0)
	-- if you're far you will walk towards the target
	if targetDist >= 15 then
		goal:AddSubGoal(GOAL_COMMON_ApproachTarget, 5, TARGET_ENE_0, 6.5, TARGET_SELF, true, -1)
	-- if you're far you will walk towards the target
	elseif targetDist >= 8 then
		goal:AddSubGoal(GOAL_COMMON_ApproachTarget, 5, TARGET_ENE_0, 6.5, TARGET_SELF, true, -1)
	-- move around at a reasonable distance
	elseif targetDist >= 4 then
		goal:AddSubGoal(GOAL_COMMON_SidewayMove, 3, TARGET_ENE_0, ai:GetRandam_Int(0, 1), ai:GetRandam_Int(30, 45), true, true, guardId)
	-- move away from the target
	else
		goal:AddSubGoal(GOAL_COMMON_LeaveTarget, 5, TARGET_ENE_0, 6, TARGET_ENE_0, true, guardId)
	end
	-- move around at a reasonable distance
	goal:AddSubGoal(GOAL_COMMON_SidewayMove, 3, TARGET_ENE_0, ai:GetRandam_Int(0, 1), ai:GetRandam_Int(30, 45), true, true, guardId)
	
end

---
-- Resets all action probabilities to 0 in the actOddsTbl and resets all paramTbl entries to an empty table. Same as Common_Clear_Param but doesn't require you to
--remake the action function table.
-- @tparam table actOddsTbl Action probability table.
-- @tparam table paramTbl Param table.
function ClearTableParam(actOddsTbl, paramTbl)
	local maxParam = 50
	local someVar = 1
	for i = 1, maxParam do
		actOddsTbl[i] = 0
		paramTbl[i] = {}
	end
end

---
-- Chooses an index of an action based on its probability. Returns -1 if failed to select any, should only happen if probability sum is 0 or table is empty.
-- @tparam userdata ai AI object.
-- @tparam table oddsTbl Table of action odds.
-- @return Returns an index of an action based on it's probability. Returns -1 if failed to select any.
function SelectOddsIndex(ai, oddsTbl)

	local numOdds = table.getn(oddsTbl)
	local sumOdds = 0
	-- get sum of all the odds
	for i = 1, numOdds do
		sumOdds = sumOdds + oddsTbl[i]
	end
	
	-- get a random value for all of the odds
	local fateOdds = ai:GetRandam_Int(0, sumOdds - 1)
	for i = 1, numOdds do
	
		local oddsVal = oddsTbl[i]
		-- if we won the lottery return the index
		if fateOdds < oddsVal then
			return i
		end
		fateOdds = fateOdds - oddsVal
		
	end
	
	return -1
	
end

---
-- Chooses an action function based on its probability. Returns nil if failed to select any, should only happen if probability sum is 0 or table is empty.
-- @tparam userdata ai AI object.
-- @tparam table oddsTbl Table of action odds.
-- @tparam table actTbl Table of action functions.
-- @return Returns action function based on its probability. Returns nil if failed to select any.
function SelectFunc(ai, oddsTbl, actTbl)

	local actIndex = SelectOddsIndex(ai, oddsTbl)
	if actIndex < 1 then
		return nil
	end
	
	return actTbl[actIndex]
	
end

---
-- Selects an action from table goal based on its probability. Your goal must have action functions defined directly inside it with names Act01, Act02, ..., Act20.
-- Act20 is the max anything past that is ignored.
-- @tparam table goalTbl Table of your goal.
-- @tparam userdata ai AI object.
-- @tparam table oddsTbl Table of action odds.
-- @return Returns action function based on its probability. Returns nil if failed to select any.
function SelectGoalFunc(goalTbl, ai, oddsTbl)
	local goalActTbl = _GetGoalActFuncTable(goalTbl)
	return SelectFunc(ai, oddsTbl, goalActTbl)
end

---
-- Selects an action from table goal based on its probability and calls it. Your goal must have action functions defined directly inside it with names
--Act01, Act02, ..., Act20. Act20 is the max anything past that is ignored. After the action based on its returned GetWellspaceOdds value it will determine if it
--should do the ActAfter. Your action must return a number otherwise this will break.
-- @tparam table goalTbl Table of your goal.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam table oddsTbl Table of action odds.
-- @tparam[opt] table paramTbl Table of params.
-- @tparam number actAfterOddsTbl This is the paramTbl to use in your ActAfter function. If your goal does not define ActAfter function you must provide valid
--probability table with 6 entries to be used by GetWellSpace_Act function as this argument.
function CallAttackAndAfterFunc(goalTbl, ai, goal, oddsTbl, paramTbl, actAfterOddsTbl)
	
	-- select act index
	local index = SelectOddsIndex(ai, oddsTbl)
	local GetWellspaceOdds = 0
	
	-- if we found an index
	if index >= 1 then
		-- get goal func table
		local goalActTbl = (_GetGoalActFuncTable(goalTbl))
		-- get params if exist
		local params = nil
		if paramTbl ~= nil then
			params = paramTbl[index]
		end
		-- do the act
		GetWellspaceOdds = goalActTbl[index](goalTbl, ai, goal, params)
	end
	
	-- determine if we should do act after
	local fate = ai:GetRandam_Int(1, 100)
	if fate <= GetWellspaceOdds then
		if goalTbl.ActAfter ~= nil then
			goalTbl.ActAfter(goalTbl, ai, goal, actAfterOddsTbl)
		else
			HumanCommon_ActAfter_AdjustSpace(ai, goal, actAfterOddsTbl)
		end
	end
	
end

---
-- Gathers Act01, Act02, ..., Act20 functions from goalTbl and puts them in a table in same order.
-- @tparam table goalTbl Table of your goal.
-- @return Table of all the supported act functions.
function _GetGoalActFuncTable(goalTbl)
	local funcTbl =
	{
		goalTbl.Act01, goalTbl.Act02, goalTbl.Act03, goalTbl.Act04, goalTbl.Act05, goalTbl.Act06, goalTbl.Act07, goalTbl.Act08, goalTbl.Act09,
		goalTbl.Act10, goalTbl.Act11, goalTbl.Act12, goalTbl.Act13, goalTbl.Act14, goalTbl.Act15, goalTbl.Act16, 
		goalTbl.Act17, goalTbl.Act18, goalTbl.Act19, goalTbl.Act20
	}
	return funcTbl
end

---
-- Returns at which side of the target we are. Possible values are TARGET_ANGLE_FRONT, TARGET_ANGLE_LEFT, TARGET_ANGLE_RIGHT, TARGET_ANGLE_BACK.
-- @tparam userdate ai Ai object.
-- @tparam number target Target.
-- @return Returns at which side of the target we are.
function GetTargetAngle(ai, target)

	if ai:IsInsideTarget(target, AI_DIR_TYPE_F, 90) then
		if ai:IsInsideTarget(target, AI_DIR_TYPE_F, 90) then
			return TARGET_ANGLE_FRONT
		elseif ai:IsInsideTarget(target, AI_DIR_TYPE_L, 180) then
			return TARGET_ANGLE_LEFT
		else
			return TARGET_ANGLE_RIGHT
		end
	end
	
	if ai:IsInsideTarget(target, AI_DIR_TYPE_L, 90) then
		return TARGET_ANGLE_LEFT
	elseif ai:IsInsideTarget(target, AI_DIR_TYPE_R, 90) then
		return TARGET_ANGLE_RIGHT
	else
		return TARGET_ANGLE_BACK
	end
	
end


