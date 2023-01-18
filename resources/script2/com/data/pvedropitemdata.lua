autoImport("ItemData")
PveDropItemData = class("PveDropItemData", ItemData)
PveDropItemData.Type = {
  E_First = 1,
  E_Normal = 2,
  E_Probability = 3
}
function PveDropItemData:SetType(t)
  self.dropType = t
end
function PveDropItemData:SetOwnPveId(ownerid)
  self.ownerid = ownerid
end
function PveDropItemData:IsPickup()
  return PveEntranceProxy.Instance:IsPickup(self.ownerid)
end
function PveDropItemData:IsFirst()
  return self.dropType == PveDropItemData.Type.E_First
end
function PveDropItemData:IsNormal()
  return self.dropType == PveDropItemData.Type.E_Normal
end
function PveDropItemData:IsProbability()
  return self.dropType == PveDropItemData.Type.E_Probability
end
