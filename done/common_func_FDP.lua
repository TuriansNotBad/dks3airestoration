---
-- @submodule CommonFuncs

---
-- A more flexible ApproachTarget wrapper for TARGET_ENE_0.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number range Range in which to stop.
-- @tparam number alwaysWalkDist Will always walk past this distance.
-- @tparam number walkDist Will rng whether to run or walk at this distance.
-- @tparam number runChance Odds of running instead of walking when past walkDist.
-- @tparam number guardChance Odds of performing the guard action (always 9910).
-- @tparam number walkLife ApproachTarget goal life if we ended up walking (default = 3)
-- @tparam number runLife  ApproachTarget goal life if we ended up running (default = 8)
function Approach_Act_Flex(ai, goal, range, alwaysWalkDist, walkDist, runChance, guardChance, walkLife, runLife)

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
	elseif targetDist >= alwaysWalkDist and fateRun <= runChance then
		bWalk = false -- if we're farther than alwaysWalkDist and rng decides that we should run - Run
	end
	
	local guardEzId = -1
	local fateGuard = ai:GetRandam_Int(1, 100) -- rng if we shud guard
	
	if fateGuard <= guardChance then
		guardEzId = 9910 -- guard if rng wills it
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
-- Checks if there is no mesh obstructing the way at the specified angle and distance. Checks in a straight line with width = hit radius originating from the
--ai's character coming at the provided angle.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object. Not used.
-- @tparam number angle Angle from the front of the target. Angle at which the line will come out from the character.
-- @tparam number dist How long is the line.
-- @return Returns true if there is enough space available.
function SpaceCheck(ai, goal, angle, dist)

	local hitRadius = ai:GetMapHitRadius(TARGET_SELF)
	-- check if there's any mesh obstructing the space
	if dist * 0.95 <= ai:GetExistMeshOnLineDistSpecifyAngleEx(TARGET_SELF, angle, dist + hitRadius, AI_SPA_DIR_TYPE_TargetF, hitRadius, 0) then
		return true
	else
		return false
	end
	
end

---
-- Checks if TARGET_ENE_0 is within range and within angle cone from the AI. Returns true for all targets such that
-- angleBase - angleRange/2 <= angle to target <= angleBase + angleRange/2 and distMin <= distance to target <= distMax. Wrapper for YSD_InsideRangeEx.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object. Not used.
-- @tparam number angleBase Base angle for the range.
-- @tparam number angleRange Angle range.
-- @tparam number distMin Lower distance range value.
-- @tparam number distMax Upper distance range value.
-- @return Returns true if target is within specified distance range and angle range.
function InsideRange(ai, goal, angleBase, angleRange, distMin, distMax)
	return YSD_InsideRangeEx(ai, goal, angleBase, angleRange, distMin, distMax)
end

---
-- Checks if TARGET_ENE_0 is within angle cone from the AI. Returns true for all targets such that
--angleBase - angleRange/2 <= angle to target <= angleBase + angleRange/2.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object. Not used.
-- @tparam number angleBase Base angle for the range.
-- @tparam number angleRange Angle range.
-- @return Returns true if target is within specified angle range.
function InsideDir(ai, goal, angleBase, angleRange)
	return YSD_InsideRangeEx(ai, goal, angleBase, angleRange, -999, 999)
end

---
-- Checks if TARGET_ENE_0 is within range and within angle cone from the AI. Returns true for all targets such that
-- angleBase - angleRange/2 <= angle to target <= angleBase + angleRange/2 and distMin <= distance to target <= distMax.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object. Not used.
-- @tparam number angleBase Base angle for the range.
-- @tparam number angleRange Angle range.
-- @tparam number distMin Lower distance range value.
-- @tparam number distMax Upper distance range value.
-- @return Returns true if target is within specified distance range and angle range.
function YSD_InsideRangeEx(ai, goal, angleBase, angleRange, distMin, distMax)

	local targetDist = ai:GetDist(TARGET_ENE_0) -- distance to target
	
	-- check if target within specified distance range bounds
	if distMin <= targetDist and targetDist <= distMax then
	
		local targetAngle = ai:GetToTargetAngle(TARGET_ENE_0) -- angle to target
		
		local sign = 0
		if angleBase < 0 then
			sign = -1
		else
			sign = 1
		end
		-- check if current angle is within angle range from base angle
		if (angleBase + angleRange / -2 <= targetAngle and targetAngle <= angleBase + angleRange / 2)
			-- allows you to also use angleBase values such that 180 <= angleBase <= 360
			or (angleBase + angleRange / -2 <= targetAngle + 360 * sign and targetAngle + 360 * sign <= angleBase + angleRange / 2)
		then
			return true
		else
			return false
		end
		
	else
		return false
	end
	
end

---
-- Implements cooldown times on certain attacks for AI. If the time smule atkEzId was last perform is <= cooldown time returns whatever you passed for
--actOddsOnCooldown.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number atkEzId Attack ezState number.
-- @tparam number actCdTime Cooldown time.
-- @tparam number actOddsReal Actual odds for this act. Return value if we're not on cooldown.
-- @tparam number actOddsOnCooldown Alternative odds for this act. Return value if we're on cooldown.
-- @return Returns adjusted action odds - 0 if actOddsReal is 0. If enough time has passed smule last time the attack was used - returns actOddsReal.
--Otherwise returns actOddsOnCooldown.
function SetCoolTime(ai, goal, atkEzId, actCdTime, actOddsReal, actOddsOnCooldown)
	if actOddsReal <= 0 then
		return 0
	elseif ai:GetAttackPassedTime(atkEzId) <= actCdTime then
		return actOddsOnCooldown
	end
	return actOddsReal
end

---
-- Checks if there is no mesh obstructing the way at the specified angle and distance. Checks in a straight line with width = hit radius originating from the
--ai's character coming at the provided angle.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object. Not used.
-- @tparam number angle Angle from the front of the target. Angle at which the line will come out from the character.
-- @tparam number dist How long is the line.
-- @tparam number actOdds Original action odds.
-- @return Returns adjusted action odds - 0 if the space check fails, actOdds if space check succeeds.
function SpaceCheckBeforeAct(ai, goal, angle, dist, actOdds)
	if actOdds <= 0 then
		return 0
	elseif SpaceCheck(ai, goal, angle, dist) then
		return actOdds
	else
		return 0
	end
end

---
-- Counters the player spamming attacks. The more attacks the player does the greater the chance of countering with our own.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number mul Number by which we multiply the counterChance on each call.
-- @tparam number ezStateId Attack ezState number.
-- @return Returns true if it counterattacked.
function Counter_Act(ai, goal, mul, ezStateId)

	local life = 0.5
	
	if mul == nil then
		mul = 4
	end
	
	local fateAtk = ai:GetRandam_Int(1, 100)
	local counterChance = ai:GetNumber(15)
	
	if ai:IsInterupt(INTERUPT_Damaged) then
		ai:SetTimer(15, 5)
		if counterChance == 0 then
			counterChance = mul
		end
		ai:SetNumber(15, counterChance * 2)
	end
	
	if counterChance >= 100 then
		ai:SetNumber(15, 100)
	end
	
	if ai:IsInterupt(INTERUPT_Damaged) and fateAtk <= ai:GetNumber(15) and ai:GetTimer(14) <= 0 then
		ai:SetTimer(14, 3)
		ai:SetNumber(15, 0)
		goal:ClearSubGoal()
		goal:AddSubGoal(GOAL_COMMON_EndureAttack, life, ezStateId, TARGET_ENE_0, DIST_None, 0, 180, 0, 0)
		return true
	end
	
	return false
	
end

---
-- Checks for INTERUPT_BackstabRisk and tries to counter it with steps or an attack (TARGET_ENE_0).
--nonAttackActType can be of 3 values. 1 - will do a forward step. 2 - randomly chooses left or right step. 3 - randomly chooses
--left/right/forward step. Probably used from the Interrupt function of your goal/logic.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number nonAttackActType What to do if we roll RNG to not attack.
-- @tparam number ezStateId Attack ezState number.
-- @tparam number ezActChance Chance to perform the attack.
-- @return Returns false.
function ReactBackstab_Act(ai, goal, nonAttackActType, ezStateId, ezActChance)

	local fateCounter = ai:GetRandam_Int(1, 100) -- decides if we'll perform the counter attack
	local fateStep = ai:GetRandam_Int(1, 100) -- decides which step to do if multiple are possible
	local life = 3 -- goal life
	local stepF = 6000 -- forward step
	local stepL = 6002 -- left step
	local stepR = 6003 -- right step
	if ezStateId == nil then
		ezActChance = 0
	end
	
	if ai:IsInterupt(INTERUPT_BackstabRisk) then
		
		if fateCounter <= ezActChance then
			-- rng decided we should attack
			goal:ClearSubGoal()
			goal:AddSubGoal(GOAL_COMMON_StabCounterAttack, life, ezStateId, TARGET_ENE_0, DIST_None, 0, 180, 0, 0)
		elseif nonAttackActType == 1 then
			-- just a front step away from the enemy
			goal:ClearSubGoal()
			goal:AddSubGoal(GOAL_COMMON_SpinStep, life, stepF, TARGET_SELF, 0, AI_DIR_TYPE_F, 0)
		elseif nonAttackActType == 2 then
			-- random left or right step
			goal:ClearSubGoal()
			if fateStep <= 50 then
				goal:AddSubGoal(GOAL_COMMON_SpinStep, life, stepL, TARGET_SELF, 0, AI_DIR_TYPE_L, 0)
			else
				goal:AddSubGoal(GOAL_COMMON_SpinStep, life, stepR, TARGET_SELF, 0, AI_DIR_TYPE_R, 0)
			end
		elseif nonAttackActType == 3 then
			-- random front/left/right step
			goal:ClearSubGoal()
			if fateStep <= 33 then
				goal:AddSubGoal(GOAL_COMMON_SpinStep, life, stepF, TARGET_SELF, 0, AI_DIR_TYPE_F, 0)
			elseif fateStep <= 66 then
				goal:AddSubGoal(GOAL_COMMON_SpinStep, life, stepL, TARGET_SELF, 0, AI_DIR_TYPE_L, 0)
			else
				goal:AddSubGoal(GOAL_COMMON_SpinStep, life, stepR, TARGET_SELF, 0, AI_DIR_TYPE_R, 0)
			end
		end
		
	end
	return false
	
end

---
-- Initializes several common string indexed numbers to their default values.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object. Not used.
function Init_Pseudo_Global(ai, goal)
	ai:SetStringIndexedNumber("Dist_SideStep", 5)
	ai:SetStringIndexedNumber("Dist_BackStep", 5)
	ai:SetStringIndexedNumber("AddDistWalk", 0)
	ai:SetStringIndexedNumber("AddDistRun", 0)
	Init_AfterAttackAct(ai, goal)
end

---
-- Initializes several common string indexed numbers to their default values.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object. Not used.
function Init_AfterAttackAct(ai, goal)
	ai:SetStringIndexedNumber("DistMin_AAA", -999)
	ai:SetStringIndexedNumber("DistMax_AAA", 999)
	ai:SetStringIndexedNumber("BaseDir_AAA", AI_DIR_TYPE_F)
	ai:SetStringIndexedNumber("Angle_AAA", 360)
	ai:SetStringIndexedNumber("Odds_Guard_AAA", 0)
	ai:SetStringIndexedNumber("Odds_NoAct_AAA", 0)
	ai:SetStringIndexedNumber("Odds_BackAndSide_AAA", 0)
	ai:SetStringIndexedNumber("Odds_Back_AAA", 0)
	ai:SetStringIndexedNumber("Odds_Backstep_AAA", 0)
	ai:SetStringIndexedNumber("Odds_Sidestep_AAA", 0)
	ai:SetStringIndexedNumber("Odds_BitWait_AAA", 0)
	ai:SetStringIndexedNumber("Odds_BsAndSide_AAA", 0)
	ai:SetStringIndexedNumber("Odds_BsAndSs_AAA", 0)
	ai:SetStringIndexedNumber("DistMin_Inter_AAA", -999)
	ai:SetStringIndexedNumber("DistMax_Inter_AAA", 999)
	ai:SetStringIndexedNumber("BaseAng_Inter_AAA", 0)
	ai:SetStringIndexedNumber("Ang_Inter_AAA", 360)
	ai:SetStringIndexedNumber("BackAndSide_BackLife_AAA", 2)
	ai:SetStringIndexedNumber("BackAndSide_SideLife_AAA", ai:GetRandam_Float(2.5, 3.5))
	ai:SetStringIndexedNumber("BackLife_AAA", ai:GetRandam_Float(2, 3))
	ai:SetStringIndexedNumber("BsAndSide_SideLife_AAA", ai:GetRandam_Float(2.5, 3.5))
	ai:SetStringIndexedNumber("BackAndSide_BackDist_AAA", 1.5)
	ai:SetStringIndexedNumber("BackDist_AAA", ai:GetRandam_Float(2.5, 3.5))
	ai:SetStringIndexedNumber("BackAndSide_SideDir_AAA", ai:GetRandam_Int(45, 60))
	ai:SetStringIndexedNumber("BsAndSide_SideDir_AAA", ai:GetRandam_Int(45, 60))
end

---
-- Default update function for NoSubGoal goals. Simply checks if there are any subgoals left active for this goal and returns GOAL_RESULT_Success if there aren't.
-- Otherwise returns GOAL_RESULT_Continue.
-- @tparam table tbl Goal table. Not used.
-- @tparam userdata ai AI object. Not used.
-- @tparam userdata goal Goal object.
-- @return Returns GOAL_RESULT_Success if no subgoals remain, GOAL_RESULT_Continue otherwise.
function Update_Default_NoSubGoal(tbl, ai, goal)
	if goal:GetSubGoalNum() <= 0 then
		return GOAL_RESULT_Success
	end
	return GOAL_RESULT_Continue
end

---
-- Guard goal subfunc. Used from other goal's Activate function.
-- @tparam userdata ai AI object.
-- @tparam number life Guard action life.
-- @tparam number guardEzId Guard action ezState number. Set to negative to do nothing.
-- @usage
--function ApproachTarget_Activate(ai, goal)
--    local life = goal:GetLife() -- goal lifetime
--    local moveTarget = goal:GetParam(0) -- target type to which to move
--    local range = goal:GetParam(1) -- range at which we've arrived
--    local turnTarget = goal:GetParam(2) -- what do we face when done
--    local bWalk = goal:GetParam(3) -- walk?
--    local guardEzId = goal:GetParam(4) -- guard action ezStateId number
--    local dirType = AI_DIR_TYPE_CENTER -- move towards the center of the target
--    local unknown = 0 -- dunno what this is
--    local guardGoalEndType = goal:GetParam(5) -- what should guard goal return when it's done
--    local successOnLifeEnd = goal:GetParam(6) -- should guard goal return success when it's life expires
--    local param7 = goal:GetParam(7) -- dunno what this is
--     -- move towards that target
--    goal:AddSubGoal(GOAL_COMMON_MoveToSomewhere, life, moveTarget, dirType, range, turnTarget, bWalk, dirType, unknown, param7)
--     -- if we haven't arrived yet do the Guard action
--    local targetDist = ai:GetDist(moveTarget)
--    if range < targetDist then
--        GuardGoalSubFunc_Activate(ai, life, guardEzId)
--    end
--end
function GuardGoalSubFunc_Activate(ai, life, guardEzId)
	-- check if we were provided with a real guard action ezState Id
	if guardEzId > 0 then
		-- do block
		ai:DoEzAction(life, guardEzId)
	end
end

---
-- Guard goal update subfunc. Used from other goal's Update function.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number guardEzId Guard action ezState number. Set to negative to do nothing.
-- @tparam number guardGoalEndType Once we've successfully blocked - what should we return. If set to GOAL_RESULT_Continue will keep going until life expires.
-- @tparam boolean successOnLifeEnd If life expires should we return GOAL_RESULT_Success? Returns GOAL_RESULT_Failed if false.
-- @return If life expires and successOnLifeEnd set to true - returns GOAL_RESULT_Success. If successfully blocked - returns guardGoalEndType.
--Returns GOAL_RESULT_Failed if took damage or life expired and not successOnLifeEnd. Else returns GOAL_RESULT_Continue.
-- @usage
--function ApproachTarget_Update(ai, goal, arg2)
--    local guardEzId = goal:GetParam(4) -- guard action ezStateId number
--    local guardGoalEndType = goal:GetParam(5) -- what should guard goal return when it's done
--    local successOnLifeEnd = goal:GetParam(6) -- should guard goal return success when it's life expires
--    -- keep going till guard goal ends
--    return GuardGoalSubFunc_Update(ai, goal, guardEzId, guardGoalEndType, successOnLifeEnd)
--end
function GuardGoalSubFunc_Update(ai, goal, guardEzId, guardGoalEndType, successOnLifeEnd)
	
	-- check if we were provided with a real guard action ezState Id
	if guardEzId > 0 then
		-- if we took damage then we've failed
		if goal:GetNumber(0) ~= 0 then
			return GOAL_RESULT_Failed
		-- if we successfully blocked and guardGoalEndType isn't set to continue - end
		elseif goal:GetNumber(1) ~= 0 then
			return guardGoalEndType
		end
	end
	
	-- if our goal has expired either fail or succeed
	if goal:GetLife() <= 0 then
		if successOnLifeEnd then
			return GOAL_RESULT_Success
		else
			return GOAL_RESULT_Failed
		end
	end
	
	return GOAL_RESULT_Continue
	
end

---
-- Guard goal interrupt subfunc. Used from other goal's Interrupt function. Listens for INTERUPT_Damaged and INTERUPT_SuccessGuard interrupts and sets off
--appropriate flags using goal.SetNumber for the GuardGoalSubFunc_Update function to process.
-- @tparam userdata ai AI object.
-- @tparam userdata goal Goal object.
-- @tparam number guardEzId Guard action ezState number. Set to negative to do nothing.
-- @tparam number guardGoalEndType Once we've successfully blocked - what should we return. GOAL_RESULT.
-- @return Returns false.
-- @usage
--function ApproachTarget_Interupt(ai, goal)
--    local guardEzId = goal:GetParam(4) -- guard action ezStateId number
--    local guardGoalEndType = goal:GetParam(5) -- what should guard goal return when it's done
--    -- check if guard goal got a relevant interrupt
--    return GuardGoalSubFunc_Interrupt(ai, goal, guardEzId, guardGoalEndType)
--end
function GuardGoalSubFunc_Interrupt(ai, goal, guardEzId, guardGoalEndType)
	-- check if we were provided with a real guard action ezState Id
	if guardEzId > 0 then
		-- if we were damaged set the flag at 0
		if ai:IsInterupt(INTERUPT_Damaged) then
			goal:SetNumber(0, 1)
		-- if we successfully blocked something then if we're not set to keep going - set the flag to end this goal
		elseif ai:IsInterupt(INTERUPT_SuccessGuard) and guardGoalEndType ~= GOAL_RESULT_Continue then
			goal:SetNumber(1, 1)
		end
	end
	return false
end
