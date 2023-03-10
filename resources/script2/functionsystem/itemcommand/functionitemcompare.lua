FunctionItemCompare = class("FunctionItemCompare")
function FunctionItemCompare.Me()
  if nil == FunctionItemCompare.me then
    FunctionItemCompare.me = FunctionItemCompare.new()
  end
  return FunctionItemCompare.me
end
function FunctionItemCompare:ctor()
end
function FunctionItemCompare:TryRemove(item)
  if item then
    if item:IsFashion() then
      if QuickUseProxy.Instance:RemoveNeverEquipedFashion(item.staticData.id, item:IsNew() == false) then
        return true
      end
    elseif item:IsEquip() then
      if item.equipInfo:CanUseByProfess(MyselfProxy.Instance:GetMyProfession()) and QuickUseProxy.Instance:RemoveBetterEquip(item) then
        return true
      end
    elseif item:IsHomeMatetial() then
      if QuickUseProxy.Instance:RemoveItemUse(item) then
        return true
      end
    else
      local useConfig = Table_UseItem[item.staticData.id]
      if useConfig and useConfig.AlertMode and useConfig.AlertMode == 1 and QuickUseProxy.Instance:RemoveItemUse(item) then
        return true
      end
    end
  end
end
function FunctionItemCompare:CompareItem(item, myselfLV)
  if item and item.staticData then
    local useConfig = Table_UseItem[item.staticData.id]
    if useConfig and useConfig.AlertMode then
      if useConfig.AlertMode == 1 then
        myselfLV = myselfLV or MyselfProxy.Instance:RoleLevel()
        local level = item.staticData.Level or 0
        if (useConfig.Alert_LimitLevel == nil or myselfLV <= useConfig.Alert_LimitLevel) and item.tempHint and myselfLV >= level and QuickUseProxy.Instance:AddItemUse(item) then
          return true
        end
      end
    elseif item:IsHomeMatetial() then
      if item.tempHint and not AdventureDataProxy.Instance:IsFurnitureUnlock(item.staticData.id, true) then
        return QuickUseProxy.Instance:AddItemUse(item)
      end
    elseif item:IsHint() then
      myselfLV = myselfLV or MyselfProxy.Instance:RoleLevel()
      local level = item.staticData.Level or 0
      if myselfLV >= level then
        if item:IsFashion() then
          if item:CanEquip() then
            if not item:IsNew() then
              if QuickUseProxy.Instance:RemoveNeverEquipedFashion(item.staticData.id, true) then
                return true
              end
            elseif QuickUseProxy.Instance:AddNeverEquipedFashion(item) then
              return true
            end
          end
        elseif item:IsEquip() then
          if self:CompareEquip(item, MyselfProxy.Instance:GetMyProfession()) then
            return true
          end
        elseif item.staticData.UseMode ~= nil then
          return QuickUseProxy.Instance:AddItemUse(item)
        end
      end
    end
    return false
  else
    errorLog("try to compare a nil item")
    return false
  end
end
function FunctionItemCompare:CompareEquip(item, profess, equipItems)
  equipItems = equipItems or BagProxy.Instance:GetRoleEquipBag().siteMap
  profess = profess or MyselfProxy.Instance:GetMyProfession()
  if item.equipInfo:CanUseByProfess(profess) then
    local sites = item.equipInfo:GetEquipSite()
    local better = false
    local site
    for i = 1, #sites do
      local equipedPart = equipItems[sites[i]]
      if item:CompareTo(equipedPart) then
        better = true
        site = sites[i]
        break
      elseif equipedPart ~= nil and equipedPart.equipInfo:CanUseByProfess(profess) == false then
        better = true
        site = sites[i]
        break
      end
    end
    if better and QuickUseProxy.Instance:AddBetterEquip(item, site) then
      return true
    end
  end
  return false
end
function FunctionItemCompare:CompareItems(items)
  self.myselfLV = MyselfProxy.Instance:RoleLevel()
  local dirty = false
  if items and type(items) == "table" then
    for i = 1, #items do
      if self:CompareItem(items[i], self.myselfLV) then
        dirty = true
      end
    end
  else
    errorLog("try to compare nil items")
    return
  end
  if dirty then
    GameFacade.Instance:sendNotification(ItemEvent.BetterEquipAdd)
  end
end
function FunctionItemCompare:SetHint(item)
  if item and item.staticData then
    local staticID = item.staticData.id
    ServiceItemProxy.Instance:CallHintNtf(staticID)
    local items = BagProxy.Instance:GetItemsByStaticID(staticID)
    if items then
      for i = 1, #items do
        items[i].isHint = false
      end
    end
  end
end
function FunctionItemCompare:TryCompare()
  local bag = BagProxy.Instance:GetMainBag()
  self:CompareItems(bag:GetItems())
end
