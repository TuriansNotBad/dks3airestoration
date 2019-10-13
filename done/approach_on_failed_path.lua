-- Walk towards the specified target if we had FailedPath on our way towards the TARGET_ENE_0
function ApproachOnFailedPath_Activate(ai, goal)
	-- how often should we check if path now exists
	local checkInterval = goal:GetParam(0)
	goal:SetTimer(0, checkInterval)
	
	local moveTarget = goal:GetParam(1) -- target type to which to move towards
	local range = goal:GetParam(2) -- range at which we consider to have succeeded
	local turnTarget = goal:GetParam(3) -- what do we turn towards
	local bWalk = goal:GetParam(4) -- walk?
	local guardEzId = goal:GetParam(5) -- guard ezStateId
	-- start the goal
	goal:AddSubGoal(GOAL_COMMON_ApproachTarget, -1, moveTarget, range, turnTarget, bWalk, guardEzId)
	
end

function ApproachOnFailedPath_Update(ai, goal)

	local result = GOAL_RESULT_Continue
	
	if true == goal:IsFinishTimer(0) then
		-- check if path exist
		local doesPathExist = ai:CheckDoesExistPath(TARGET_ENE_0, AI_DIR_TYPE_L, 0.5, 0)
		-- if path is found we successfully wasted a bunch of time.
		if true == doesPathExist then
			result = GOAL_RESULT_Success
		else
			-- no path exist, reset the timer and start anew
			local checkInterval = goal:GetParam(0)
			goal:SetTimer(0, checkInterval)
		end
		
	end
	
	-- if we stopped walking for whatever reason start it all over again
	if goal:GetSubGoalNum() <= 0 then
	
		local moveTarget = goal:GetParam(1) -- target type to which to move towards
		local range = goal:GetParam(2) -- range at which we consider to have succeeded
		local turnTarget = goal:GetParam(3) -- what do we turn towards
		local bWalk = goal:GetParam(4) -- walk?
		local guardEzId = goal:GetParam(5) -- guard ezStateId
		-- start the goal
		goal:AddSubGoal(GOAL_COMMON_ApproachTarget, -1, moveTarget, range, turnTarget, bWalk, guardEzId)
		
	end
	
	return result
	
end

function ApproachOnFailedPath_Terminate(ai, goal)
end

function ApproachOnFailedPath_Interupt(ai, goal)
	if ai:IsInterupt(INTERUPT_MovedEnd_OnFailedPath) then
		return true
	end
	return false
end


