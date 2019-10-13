
REGISTER_GOAL_UPDATE_TIME(GOAL_COMMON_ApproachTarget, 0, 0)

REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_Turn, 0, "����^�[�Q�b�g", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_Turn, 1, "���ʔ���p�x", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_Turn, 2, "�K�[�hEzState�ԍ�", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_Turn, 3, "�K�[�h�S�[���I���^�C�v", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_Turn, 4, "�K�[�h�S�[���F�������s�����琬���Ƃ��邩", 0)

REGISTER_GOAL_NO_SUB_GOAL(GOAL_COMMON_Turn, true)

function Turn_Activate(ai, goal)
	local guardEzId = goal:GetParam(2) -- guard ezStateId
	local guardEndType = goal:GetParam(3) -- what should guard goal return when it's done
	local guardSuccessOnEnd = goal:GetParam(4) -- should guard goal return success when its life expires
	GuardGoalSubFunc_Activate(ai, life_time, guardEzId) -- activate the guard "goal"
end

function Turn_Update(ai, goal)

	local turnTarget = goal:GetParam(0) -- target to face
	ai:RequestEmergencyQuickTurn()
	ai:TurnTo(turnTarget)
	
	if Turn_IsLookToTarget(ai, goal) then -- facing the target
		return GOAL_RESULT_Success
	end
	
	local guardEzId = goal:GetParam(2) -- guard ezStateId
	local guardEndType = goal:GetParam(3) -- what should guard goal return when it's done
	local guardSuccessOnEnd = goal:GetParam(4) -- should guard goal return success when its life expires
	
	return GuardGoalSubFunc_Update(ai, goal, guardEzId, guardEndType, guardSuccessOnEnd) -- update the guard "goal"
	
end

function Turn_Terminate(ai, goal)
	-- empty
end

function Turn_Interupt(ai, goal)
	local guardEzId = goal:GetParam(2) -- guard ezStateId
	local guardEndType = goal:GetParam(3) -- what should guard goal return when it's done
	return GuardGoalSubFunc_Interrupt(ai, goal, guardEzId, guardEndType) -- let the guard "goal" handle interrupts that it wants to
end

function Turn_IsLookToTarget(ai, goal)

	local angle = goal:GetParam(1) -- angle to judge whether we're facing it
	if angle <= 0 then
		angle = 15
	end
	
	return ai:IsLookToTarget( angle )
	
end


