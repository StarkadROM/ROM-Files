AutoAimMonsterData = class("AutoAimMonsterData")
function AutoAimMonsterData:ctor(data)
  self:SetData(data)
end
function AutoAimMonsterData:SetData(data)
  if data then
    self.id = data.id
    self.level = data.level
  end
end
function AutoAimMonsterData:SetId(id)
  if id then
    self.id = id
  end
end
function AutoAimMonsterData:SetLevel(level)
  if level then
    self.level = level
  end
end
function AutoAimMonsterData:GetId()
  return self.id
end
function AutoAimMonsterData:GetLevel()
  return self.level
end
function AutoAimMonsterData:SetBossType(bosstype)
  self.bosstype = bosstype
end
function AutoAimMonsterData:GetBossType()
  return self.bosstype
end
function AutoAimMonsterData:IsShow()
  return self.option ~= 1
end
