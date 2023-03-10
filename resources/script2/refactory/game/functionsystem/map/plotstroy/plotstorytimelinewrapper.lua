PlotStoryTimeLineWrapper = class("PlotStoryTimeLineWrapper")
local getmetatable = getmetatable
function PlotStoryTimeLineWrapper.parse(param_keys, param_values, reference_param)
  local param = {}
  if param_keys.Count == param_values.Count then
    local maxCnt = param_keys.Count - 1
    local k, v
    for m = 0, maxCnt do
      k = param_keys:getItem(m)
      v = param_values[m]
      if type(v) == "userdata" and getmetatable(v).__typename == "List`1" then
        local list2table = {}
        for i = 1, v.Count do
          local item = v:getItem(i - 1)
          if type(item) == "userdata" then
            local data = {}
            data.key = item.key
            data.value = tonumber(item.value) or item.value
            list2table[i] = data
          else
            list2table[i] = item
          end
        end
        param[k] = list2table
      else
        param[k] = v
      end
    end
  end
  local refCnt = reference_param.Count - 1
  local refParam = {}
  for m = 0, refCnt do
    TableUtility.ArrayPushBack(refParam, reference_param:getItem(m))
  end
  param._refParam = refParam
  return param
end
function PlotStoryTimeLineWrapper.ProcessCMD(pqtl_id, caster, trigger_type, action_type, param_keys, param_values, need_result, reference_param)
  redlog("PQTL_Action_CMD", pqtl_id, caster, trigger_type, action_type, param_keys, param_values)
  local pstls = Game.PlotStoryManager:Get_PQTLP(pqtl_id)
  if not pstls then
    redlog("PQTL_Action_CMD", "fail", "cant find pstls for pqtl", pqtl_id)
    return
  end
  local param = PlotStoryTimeLineWrapper.parse(param_keys, param_values, reference_param)
  if param then
    pstls:AddStep(caster, trigger_type, action_type, param, need_result)
  end
end
function PlotStoryTimeLineWrapper.ProcessPreloadCMD(pqtl_id, caster, trigger_type, action_type, param_keys, param_values, reference_param)
  local pstls = Game.PlotStoryManager:Get_PQTLP(pqtl_id)
  if not pstls then
    return
  end
  local param = PlotStoryTimeLineWrapper.parse(param_keys, param_values, reference_param)
  if param then
    pstls:ProcessPreload(caster, trigger_type, action_type, param)
  end
end
function PlotStoryTimeLineWrapper.ProcessCurveCMD(pqtl_id, caster, curvePos, targetType)
  local pstls = Game.PlotStoryManager:Get_PQTLP(pqtl_id)
  if not pstls then
    return
  end
  pstls:UpdateCurvePos(caster, curvePos, targetType)
end
function PlotStoryTimeLineWrapper.QuickFinishCMD(pqtl_id, cmds)
  local pstls = Game.PlotStoryManager:Get_PQTLP(pqtl_id)
  if not pstls then
    return
  end
end
function PlotStoryTimeLineWrapper.ResetLocalEditorGame()
end
return PlotStoryTimeLineWrapper
