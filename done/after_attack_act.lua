
RegisterTableGoal(GOAL_COMMON_AfterAttackAct, "AfterAttackAct")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_COMMON_AfterAttackAct, true)

function Goal.Activate( self, ai, goal )
	
	-- distance to the enemy
	local targetDist = ai:GetDist(TARGET_ENE_0)
	-- if target is withing required distance for After Attack Act
	if targetDist >= ai:GetStringIndexedNumber("DistMin_AAA") and ai:GetStringIndexedNumber("DistMax_AAA") >= targetDist then
		-- if target is within required direction/angle from us
		if ai:IsInsideTarget(TARGET_ENE_0, ai:GetStringIndexedNumber("BaseDir_AAA"), ai:GetStringIndexedNumber("Angle_AAA")) == false then
			-- do nothing
		else
			
			-- guard ezStateId
			local guardEzId = -1
			-- if we roll RNG to guard during AAA
			if ai:GetRandam_Int(1, 100) <= ai:GetStringIndexedNumber("Odds_Guard_AAA") then
				guardEzId = 9910
			end
			
			local moveDir = ai:GetRandam_Int(0, 1)
			-- get how many friends are moving to the left within 4 meters
			local friendsLeftNum = ai:GetTeamRecordCount(COORDINATE_TYPE_SideWalk_L, TARGET_ENE_0, 4)
			-- get how many friends are moving to the right within 4 meters
			local friendsRightNum = ai:GetTeamRecordCount(COORDINATE_TYPE_SideWalk_R, TARGET_ENE_0, 4)
			-- if more friends on the left we go right, else left
			if friendsRightNum < friendsLeftNum then
				moveDir = 1
			elseif friendsLeftNum < friendsRightNum then
				moveDir = 0
			end
			
			-- total odds for AAA
			local totalOdds = ai:GetStringIndexedNumber("Odds_NoAct_AAA")
				+ ai:GetStringIndexedNumber("Odds_BackAndSide_AAA")
				+ ai:GetStringIndexedNumber("Odds_Back_AAA")
				+ ai:GetStringIndexedNumber("Odds_Backstep_AAA")
				+ ai:GetStringIndexedNumber("Odds_Sidestep_AAA")
				+ ai:GetStringIndexedNumber("Odds_BitWait_AAA")
				+ ai:GetStringIndexedNumber("Odds_BsAndSide_AAA")
				+ ai:GetStringIndexedNumber("Odds_BsAndSs_AAA")
			
			local NoActPer = 0 + ai:GetStringIndexedNumber("Odds_NoAct_AAA") -- do nothing action
			local BackAndSidePer = NoActPer + ai:GetStringIndexedNumber("Odds_BackAndSide_AAA") -- move back and move side
			local BackPer = BackAndSidePer + ai:GetStringIndexedNumber("Odds_Back_AAA") -- move back
			local BackstepPer = BackPer + ai:GetStringIndexedNumber("Odds_Backstep_AAA") -- do a backstep
			local SidestepPer = BackstepPer + ai:GetStringIndexedNumber("Odds_Sidestep_AAA") -- do a sidestep
			local BitWaitPer = SidestepPer + ai:GetStringIndexedNumber("Odds_BitWait_AAA") -- wait a bit
			local BsAndSidePer = BitWaitPer + ai:GetStringIndexedNumber("Odds_BsAndSide_AAA") -- do a backstep and move sideways
			local BsAndSsPer = BsAndSidePer + ai:GetStringIndexedNumber("Odds_BsAndSs_AAA") -- do a backstep and do a sidestep
			-- pick an action at random
			local fate = ai:GetRandam_Int(1, totalOdds)
			
			-- doing nothing
			if fate > 0 and fate <= NoActPer then
				-- do nothing
			-- moving back and moving sideways
			elseif NoActPer < fate and fate <= BackAndSidePer then
				
				-- move back but stay within range
				goal:AddSubGoal(GOAL_COMMON_LeaveTarget, ai:GetStringIndexedNumber("BackAndSide_BackLife_AAA"), TARGET_ENE_0, ai:GetStringIndexedNumber("BackAndSide_BackDist_AAA"), TARGET_ENE_0, true, guardEzId)
					:SetTargetRange(30, ai:GetStringIndexedNumber("DistMin_Inter_AAA"), ai:GetStringIndexedNumber("DistMax_Inter_AAA"))
						:SetTargetAngle(30, ai:GetStringIndexedNumber("BaseAng_Inter_AAA"), ai:GetStringIndexedNumber("Ang_Inter_AAA"))
				
				-- move sideways but stay within range
				goal:AddSubGoal(GOAL_COMMON_SidewayMove, ai:GetStringIndexedNumber("BackAndSide_SideLife_AAA"), TARGET_ENE_0, moveDir, ai:GetStringIndexedNumber("BackAndSide_SideDir_AAA"), true, true, guardEzId)
					:SetTargetRange(30, ai:GetStringIndexedNumber("DistMin_Inter_AAA"), ai:GetStringIndexedNumber("DistMax_Inter_AAA"))
						:SetTargetAngle(30, ai:GetStringIndexedNumber("BaseAng_Inter_AAA"), ai:GetStringIndexedNumber("Ang_Inter_AAA"))
				
			-- moving back
			elseif BackAndSidePer < fate and fate <= BackPer then
				
				-- move back away for set distance
				goal:AddSubGoal(GOAL_COMMON_LeaveTarget, ai:GetStringIndexedNumber("BackLife_AAA"), TARGET_ENE_0, ai:GetStringIndexedNumber("BackDist_AAA"), TARGET_ENE_0, true, guardEzId)
				
			-- do a backstep
			elseif BackPer < fate and fate <= BackstepPer then
			
				-- backstep
				goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 6001, TARGET_ENE_0, 0, AI_DIR_TYPE_B, ai:GetStringIndexedNumber("Dist_BackStep"))
				
			-- do a sidestep
			elseif BackstepPer < fate and fate <= SidestepPer then
			
				-- sidestep
				goal:AddSubGoal(GOAL_EnemyStepLR, 5, TARGET_ENE_0, ai:GetStringIndexedNumber("Dist_SideStep"))
				
			-- just wait
			elseif SidestepPer < fate and fate <= BitWaitPer then
			
				-- wait
				goal:AddSubGoal(GOAL_COMMON_Wait, ai:GetRandam_Float(0.5, 1), 0, 0, 0, 0)
				
			-- do a backstep and move sideways
			elseif BitWaitPer < fate and fate <= BsAndSidePer then
				
				-- backstep
				goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 6001, TARGET_ENE_0, 0, AI_DIR_TYPE_B, ai:GetStringIndexedNumber("Dist_BackStep"))
				
				-- sideways move but stay in range
				goal:AddSubGoal(GOAL_COMMON_SidewayMove, ai:GetStringIndexedNumber("BsAndSide_SideLife_AAA"), TARGET_ENE_0, moveDir, ai:GetStringIndexedNumber("BsAndSide_SideDir_AAA"), true, true, guardEzId)
					:SetTargetRange(30, ai:GetStringIndexedNumber("DistMin_Inter_AAA"), ai:GetStringIndexedNumber("DistMax_Inter_AAA"))
						:SetTargetAngle(30, ai:GetStringIndexedNumber("BaseAng_Inter_AAA"), ai:GetStringIndexedNumber("Ang_Inter_AAA"))
				
			-- do a backstep and do a sidestep
			elseif BsAndSidePer < fate and fate <= BsAndSsPer then
				
				-- backstep
				goal:AddSubGoal(GOAL_COMMON_SpinStep, 5, 6001, TARGET_ENE_0, 0, AI_DIR_TYPE_B, ai:GetStringIndexedNumber("Dist_BackStep"))
				
				-- sidestep
				goal:AddSubGoal(GOAL_EnemyStepLR, 5, TARGET_ENE_0, ai:GetStringIndexedNumber("Dist_SideStep"))
				
			end
			
		end
		
	end
	
end

function Goal.Update(self, ai, goal)
	if goal:GetSubGoalNum() <= 0 then
		return GOAL_RESULT_Success
	end
	if goal:GetLife() <= 0 then
		return GOAL_RESULT_Success
	end
	return GOAL_RESULT_Continue
end

function Goal.Interrupt_TargetOutOfRange(self, ai, goal, slot)
	if slot == 30 then
		goal:ClearSubGoal()
		return true
	end
	return false
end

function Goal.Interrupt_TargetOutOfAngle(self, ai, goal, slot)
	if slot == 30 then
		goal:ClearSubGoal()
		return true
	end
	return false
end
