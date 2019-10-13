REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ApproachTarget, 0, "à⁄ìÆëŒè€", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ApproachTarget, 1, "ìûíBîªíËãóó£", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ApproachTarget, 2, "ê˘âÒëŒè€", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ApproachTarget, 3, "ï‡Ç≠?", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_ApproachTarget, 4, "ÉKÅ[ÉhEzStateî‘çÜ", 0)
REGISTER_GOAL_UPDATE_TIME(GOAL_COMMON_ApproachTarget, 0, 0)

--[[
Move target
Arrival determination distance
Turn target
walk?
Guard EzState number
]]

function ApproachTarget_Activate(ai, goal)

	local life = goal:GetLife() -- goal lifetime
	local moveTarget = goal:GetParam(0) -- target type to which to move
	local range = goal:GetParam(1) -- range at which we've arrived
	local turnTarget = goal:GetParam(2) -- what do we face when done
	local bWalk = goal:GetParam(3) -- walk?
	local guardEzId = goal:GetParam(4) -- guard action ezStateId number
	local dirType = AI_DIR_TYPE_CENTER -- move towards the center of the target
	local unknown = 0 -- dunno what this is
	local guardGoalEndType = goal:GetParam(5) -- what should guard goal return when it's done
	local successOnLifeEnd = goal:GetParam(6) -- should guard goal return success when it's life expires
	local param7 = goal:GetParam(7) -- dunno what this is
	-- move towards that target
	goal:AddSubGoal(GOAL_COMMON_MoveToSomewhere, life, moveTarget, dirType, range, turnTarget, bWalk, dirType, unknown, param7)
	
	-- if we haven't arrived yet do the Guard action
	local targetDist = ai:GetDist(moveTarget)
	if range < targetDist then
		GuardGoalSubFunc_Activate(ai, life, guardEzId)
	end
	
end

function ApproachTarget_Update(ai, goal, arg2)
	local guardEzId = goal:GetParam(4) -- guard action ezStateId number
	local guardGoalEndType = goal:GetParam(5) -- what should guard goal return when it's done
	local successOnLifeEnd = goal:GetParam(6) -- should guard goal return success when it's life expires
	-- keep going till guard goal ends
	return GuardGoalSubFunc_Update(ai, goal, guardEzId, guardGoalEndType, successOnLifeEnd)
end

function ApproachTarget_Terminate(ai, goal)
end

function ApproachTarget_Interupt(ai, goal)
	local guardEzId = goal:GetParam(4) -- guard action ezStateId number
	local guardGoalEndType = goal:GetParam(5) -- what should guard goal return when it's done
	-- check if guard goal got a relevant interrupt
	return GuardGoalSubFunc_Interrupt(ai, goal, guardEzId, guardGoalEndType)
end
