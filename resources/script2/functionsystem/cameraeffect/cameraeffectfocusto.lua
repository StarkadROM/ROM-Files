CameraEffectFocusTo = class("CameraEffectFocusTo", CameraEffect)
CameraEffectFocusTo.Tag = 0
function CameraEffectFocusTo:ctor(focus, viewPort, duration, listener, inverse, onRestore)
  CameraEffectFocusTo.super.ctor(self)
  self.focus = focus
  self.viewPort = viewPort
  self.duration = duration
  self.inverse = inverse
  self.onRestore = onRestore
  self.animRunning = false
  function self.finishedListener(cameraController)
    self.animRunning = false
    if nil ~= listener then
      listener(cameraController)
    end
  end
  CameraEffectFocusTo.Tag = CameraEffectFocusTo.Tag + 1
  self.tag = CameraEffectFocusTo.Tag
end
function CameraEffectFocusTo:SetFocusOffset(offset)
  self.offset = offset
end
function CameraEffectFocusTo:DoStart(cameraController)
  self.originalZoom = cameraController.zoom
  cameraController:ResetCurrentInfoByZoom(1)
  if nil ~= self.offset then
    if nil ~= self.focus then
      cameraController:FocusTo(self.focus, self.offset, self.viewPort, self.duration, self.finishedListener, self.inverse or false)
    else
      cameraController:FocusTo(self.offset, self.viewPort, self.duration, self.finishedListener, self.inverse or false)
    end
  elseif nil ~= self.focus then
    cameraController:FocusTo(self.focus, self.viewPort, self.duration, self.finishedListener, self.inverse or false)
  else
    cameraController:FocusTo(self.viewPort, self.duration, self.finishedListener, self.inverse or false)
  end
  self.animRunning = true
end
function CameraEffectFocusTo:DoEnd(cameraController)
  if self.animRunning and not self.inverse then
    redlog("CameraEffectFocusTo 清空动画.")
    cameraController:InterruptSmoothTo()
  end
  if not self.onRestore then
    cameraController:ResetCurrentInfoByZoom(self.originalZoom)
    local duration = self.immediateEnd and 0 or self.duration
    cameraController:RestoreDefault(duration, nil)
  end
end
