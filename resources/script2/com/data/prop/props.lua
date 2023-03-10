autoImport("Prop")
Props = class("Props", ReusableObject)
function Props:ctor(configs, createAll)
  self.hasDirtyDatas = false
  self.configs = configs
  self.mProps = {}
  self.dirtyIDs = {}
  if createAll == true then
    self:InitAllProps()
  end
end
function Props:Reset()
  self.hasDirtyDatas = false
  TableUtility.TableClear(self.dirtyIDs)
  local propVO
  for _, v in pairs(self.mProps) do
    propVO = v.propVO
    v.value = propVO ~= nil and propVO.defaultValue or 0
  end
end
function Props:ResetAllProps()
  if self.configs then
    for _, o in pairs(self.configs) do
      self:SetValueById(o.id, o.defaultValue)
    end
  end
end
function Props:InitAllProps()
  for _, o in pairs(self.configs) do
    self:InitProp(o)
  end
end
function Props:InitProp(propVO)
  local p = Prop.new(propVO)
  self.mProps[propVO.name] = p
  return p
end
function Props:GetPropByID(id)
  local conf = self.configs[id]
  local p
  if conf ~= nil then
    p = self:GetPropByName(conf.name)
    if p == nil then
      p = self:InitProp(conf)
    end
  else
    assert("--------try to get " .. id .. " propVO,but not exist!")
  end
  return p
end
function Props:GetValueByID(id)
  local p = self:GetPropByID(id)
  if p == nil then
    return 0
  end
  return p:GetValue()
end
function Props:GetPropByName(name)
  local p = self.mProps[name]
  if (p == nil or p.propVO == nil) and self.configs[name] ~= nil then
    p = self:InitProp(self.configs[name])
  end
  return p
end
function Props:GetValueByName(name)
  local p = self:GetPropByName(name)
  if p == nil then
    return 0
  end
  return p:GetValue()
end
function Props:DirtySetByID(id, value)
  local p = self:GetPropByID(id)
  local old = p:SetValue(value)
  if value ~= old then
    if self.dirtyIDs[id] == nil then
      self.dirtyIDs[id] = old or value
    end
    self.hasDirtyDatas = true
  end
  return old
end
function Props:SetValueById(id, value)
  local p = self:GetPropByID(id)
  local old = p:SetValue(value)
  return old, p
end
function Props:SetValueByName(name, value)
  local p = self:GetPropByName(name)
  local old = p:SetValue(value)
  return old, p
end
