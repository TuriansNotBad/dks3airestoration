
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StabCounterAttack, 0, "EzStateID", 0) -- ez state id
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StabCounterAttack, 1, "çUåÇëŒè€", 0) -- target
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StabCounterAttack, 2, "ê¨å˜ãóó£", 0) -- success distance
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StabCounterAttack, 3, "çUåÇëOê˘âÒéûä‘", 0) -- turn time
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StabCounterAttack, 4, "ê≥ñ îªíËäpìx", 0) -- front judgement angle
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StabCounterAttack, 5, "è„çUåÇäpìx", 0) -- upper attack angle
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StabCounterAttack, 6, "â∫çUåÇäpìx", 0) -- down attack angle

function StabCounterAttack_Activate(ai, goal)

	local life = goal:GetLife()
	local ezStateId = goal:GetParam(0)
	local targetType = goal:GetParam(1)
	local successDist = goal:GetParam(2)
	local successAngle = 180
	local turnTime = goal:GetParam(3)
	local frontJgAngle = goal:GetParam(4)
	
	if ( turnTime < 0 ) then
		turnTime = 1.5
	end
	if ( frontJgAngle < 0 ) then
		frontJgAngle = 20
	end
	
	local bAnimCancel = false
	local arg10 = true
	local forceFail = false
	local noSpin = false
	local upperAtkAngle = goal:GetParam(5)
	local downAtkAngle = goal:GetParam(6)
	
	goal:AddSubGoal( GOAL_COMMON_CommonAttack, life, ezStateId, targetType, successDist,
		successAngle, turnTime, frontJgAngle, bAnimCancel, arg10, forceFail, noSpin, upperAtkAngle, downAtkAngle )
	ai:SetEnableStabCounterCancel_forGoal()
	
end

function StabCounterAttack_Update(ai, goal)
	return GOAL_RESULT_Continue
end

function StabCounterAttack_Terminate(ai, goal)
	ai:ClearEnableStabCounterCancel_forGoal()
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_StabCounterAttack, true)
function StabCounterAttack_Interupt(ai, goal)
	return false
end


