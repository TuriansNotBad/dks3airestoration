REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_AttackTunableSpin, 0, "EzStateID", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_AttackTunableSpin, 1, "çUåÇëŒè€", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_AttackTunableSpin, 2, "ê¨å˜ãóó£", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_AttackTunableSpin, 3, "çUåÇëOê˘âÒéûä‘", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_AttackTunableSpin, 4, "ê≥ñ îªíËäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_AttackTunableSpin, 5, "è„çUåÇäpìx", 0)
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_AttackTunableSpin, 6, "â∫çUåÇäpìx", 0)

--[[
EzStateID
Attack target
Success distance
Turn time before attack
Front judgment angle
Top attack angle
Bottom attack angle
]]

AttackTunableSpin_Activate = function(ai, goal)

	local life = goal:GetLife()
	local ezStateId = goal:GetParam(0)
	local target = goal:GetParam(1)
	local succDist = goal:GetParam(2)
	local succAngle = 180
	local turnTime = goal:GetParam(3)
	local frontJgAngle = goal:GetParam(4)
	
	if turnTime < 0 then
		turnTime = 1.5
	end
	if frontJgAngle < 0 then
		frontJgAngle = 20
	end
	
	local animCancel = false
	local arg10 = true
	local forceFail = false
	local noSpin = false
	local upAtkAngle = goal:GetParam(5)
	local downAtkAngle = goal:GetParam(6)
	
	goal:AddSubGoal( GOAL_COMMON_CommonAttack, life, ezStateId, target, succDist, succAngle, turnTime, frontJgAngle, animCancel,
		arg10, forceFail, noSpin, upAtkAngle, downAtkAngle )
	
end

AttackTunableSpin_Update = function(ai, goal)
	return GOAL_RESULT_Continue
end

AttackTunableSpin_Terminate = function(ai, goal)
end

REGISTER_GOAL_NO_INTERUPT(GOAL_COMMON_AttackTunableSpin, true)
AttackTunableSpin_Interupt = function(ai, goal)
	return false
end
