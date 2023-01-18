PpLua = {m_Cameras = nil, inited = false}
function PpLua.DepthSupport()
  if not SystemInfo.IsFormatSupported(48, 0) then
    return false
  end
  if not SystemInfo.IsFormatSupported(48, 4) then
    return false
  end
  return true
end
function PpLua.BloomSupport()
  if not SystemInfo.IsFormatSupported(49, 0) then
    return false
  end
  if not SystemInfo.IsFormatSupported(49, 4) then
    return false
  end
  return true
end
function PpLua:Init(cameras)
  self.inited = true
  self.m_Cameras = cameras
end
function PpLua:SetEffect(name)
  local isDOF = name:lower():find("depth")
  if isDOF then
    if not PpLua.DepthSupport() then
      self.inited = false
      return false
    end
  elseif (name:lower():find("bloom") or name:lower():find("boom")) and not PpLua.BloomSupport() then
    self.inited = false
    return false
  end
  if isDOF then
    PostprocessManager.Instance:SetMSAA(1)
  else
    FunctionPerformanceSetting.Me():ApplyAntiRateSetting()
  end
  self.inited = true
  PostprocessManager.Instance:SetEffect(name)
  return true
end
function PpLua:Destory()
  if not self.inited then
    return
  end
  self.inited = false
  if PostprocessManager.Instance then
    PostprocessManager.Instance:ClearEffect(self.m_Cameras[1], true)
  end
  self.m_Cameras = nil
end
function PpLua:SetEnable(enable)
end
function PpLua:Refresh()
end
function PpLua:Clear()
  self:Destory()
end
function PpLua.DestroyAll()
  PostprocessManager.Instance:ClearAllEffect()
end
