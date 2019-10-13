
RegisterTableGoal(GOAL_COMMON_StepSafety, "StepSafety")
REGISTER_GOAL_NO_SUB_GOAL(GOAL_COMMON_StepSafety, true)

REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StepSafety, 0, "前ステップ優先度", 0) -- fstep priority
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StepSafety, 1, "後ステップ優先度", 0) -- bstep priority
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StepSafety, 2, "左ステップ優先度", 0) -- lstep priority
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StepSafety, 3, "右ステップ優先度", 0) -- rstep priority
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StepSafety, 4, "旋回対象", 0) -- turn target
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StepSafety, 5, "安全チェック距離", 0) -- safety check distance
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StepSafety, 6, "ステップ前旋回時間", 0) -- turn time
REGISTER_DBG_GOAL_PARAM(GOAL_COMMON_StepSafety, 7, "実行不可の時成功とみなすか", 0) -- succeed if can't step?

function Goal.Activate(self, ai, goal)

	local stepPriorityTbl = {} -- keeps track of step order based on their priority
	local stepIndexTbl = {} -- keeps track which entry in priorityTbl corresponds to which step
	local ezNumberTbl = {6000, 6001, 6002, 6003} -- step ez number ids
	local dirTbl = {AI_DIR_TYPE_F, AI_DIR_TYPE_B, AI_DIR_TYPE_L, AI_DIR_TYPE_R} -- step directions
	local angleTbl = {0, 180, -90, 90} -- step angles (as measured from the character's front)
	local stepNum = table.getn(ezNumberTbl)
	-- params
	local turnTarget = goal:GetParam(stepNum) -- target to face
	local safetyDist = goal:GetParam(stepNum + 1) -- distance step will travel, used to not jump off cliffs and such.
	local turnTime = goal:GetParam(stepNum + 2) -- turn time before step
	local successIfCant = goal:GetParam(stepNum + 3) -- if we can't backstep - should we return GOAL_RESULT_Success
	
	for i = 0, stepNum - 1 do
		-- if step at i priority greater than zero
		if goal:GetParam(i) >= 0 then
			
			local stepIndex = table.getn(stepPriorityTbl) + 1
			for j = 1, stepIndex - 1 do
				-- if already present step at j has lower priority than this one we insert before it
				-- otherwise we append it
				if stepPriorityTbl[j] < goal:GetParam(i) then
					stepIndex = j
				end
			end
			
			table.insert(stepPriorityTbl, stepIndex, goal:GetParam(i))
			table.insert(stepIndexTbl, stepIndex, i + 1)

		end
		
	end
	-- go over every step from highest priority to lowest.
	for i = 1, table.getn(stepPriorityTbl) do
	
		local stepDir = dirTbl[ stepIndexTbl[i] ] -- step direction
		local mapHitRadius = ai:GetMapHitRadius(TARGET_SELF) -- hit radius of the ai
		-- check if route is free
		if safetyDist <= ai:GetExistMeshOnLineDistEx(TARGET_SELF, stepDir, safetyDist + 3, mapHitRadius, mapHitRadius)
			and not ai:IsExistChrOnLineSpecifyAngle(TARGET_SELF, angleTbl[ stepIndexTbl[i] ], safetyDist, AI_SPA_DIR_TYPE_TargetF)
		then
			goal:SetNumber(0, 0)
			-- perform turn and step
			goal:AddSubGoal(GOAL_COMMON_SpinStep, goal:GetLife(), ezNumberTbl[ stepIndexTbl[i] ], turnTarget, turnTime, AI_DIR_TYPE_B, -1)
			return 
		end
		
	end
	
	if successIfCant == false then
		goal:SetNumber(0, 1)
	end
	
end

function Goal.Update(self, ai, goal)
	if goal:GetSubGoalNum() <= 0 then
		if goal:GetNumber(0) == 1 then
			return GOAL_RESULT_Failed
		end
		return GOAL_RESULT_Success
	end
	return GOAL_RESULT_Continue
end
