REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_Attack, 0, "EzStateID", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_Attack, 1, "çUåÇëŒè€", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_Attack, 2, "ê¨å˜ãóó£", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_Attack, 3, "è„çUåÇäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_Attack, 4, "â∫çUåÇäpìx", 0)

function Attack_Activate(ai, goal)

	local life = goal:GetLife()
	local ezActionId = goal:GetParam(0)
	local target = goal:GetParam(1)
	local successDist = goal:GetParam(2)
	local successAngle = 180
	local turnTime = 1.5
	local frongJgAngle = 20
	local animCancel = false
	local arg10 = true
	local forceFail = false
	local noSpin = false
	local upAtkAngle = goal:GetParam(3)
	local downAtkAngle = goal:GetParam(4)
	
	goal:AddSubGoal(GOAL_COMMON_CommonAttack, life, ezActionId, target, successDist, successAngle, turnTime,
		frongJgAngle, animCancel, arg10, forceFail, noSpin, upAtkAngle, downAtkAngle)
	
end

function Attack_Update(ai, goal)
	return GOAL_RESULT_Continue
end

function Attack_Terminate(ai, goal)
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_Attack, true)
function Attack_Interupt(ai, goal)
	return false
end


