autoImport("BagItemCell")
BagFashionItemCell = class("BagFashionItemCell", BagItemCell)
function BagFashionItemCell:Init()
  local bagItemCell = self:FindGO("Common_BagItemCell")
  if not bagItemCell then
    bagItemCell = self:LoadPreferb("cell/BagItemCell", self.gameObject)
    bagItemCell.name = "Common_BagItemCell"
  end
  BagFashionItemCell.super.Init(self)
  self:FindFashionObjs()
  self:AddClickEvent(bagItemCell, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.empty:GetComponent(UISprite).depth = self.grey:GetComponent(UISprite).depth - 1
end
function BagFashionItemCell:FindFashionObjs()
  self.objInUse = self:FindGO("InUse")
  self.eye = self:FindComponent("Eye", UISprite)
end
function BagFashionItemCell:SetData(data)
  self.fashionItemData = data
  local isActive = type(data) == "table" or data == BagItemEmptyType.Empty
  if self.isActive ~= isActive then
    self.isActive = isActive
    self.gameObject:SetActive(isActive)
  end
  BagFashionItemCell.super.SetData(self, data and data.isAdventureItemData and data:Clone() or data)
  if data and data.IsMountPet and data:IsMountPet() then
    IconManager:SetPetMountIcon(data, self.icon)
  elseif data and data.isAdventureItemData then
    local savedItems = data.savedItemDatas
    if #savedItems > 0 and savedItems[1]:IsMountPet() then
      IconManager:SetPetMountIcon(savedItems[1], self.icon)
    end
  end
  self:RefreshStatus()
  self:ActiveNewTag(false)
end
function BagFashionItemCell:RefreshStatus()
  self.eye.gameObject:SetActive(self.fashionItemData == BagItemEmptyType.Empty)
  if not self.fashionItemData or self.fashionItemData == BagItemEmptyType.Empty or self.fashionItemData == BagItemEmptyType.Grey then
    if self.isEquiped ~= false then
      self.objInUse:SetActive(false)
      self.isEquiped = false
    end
    if self.fashionItemData == BagItemEmptyType.Empty and self.advFashion then
      self.eye.spriteName = self.isFashionHide and "bag_icon_hide" or "bag_icon_show"
      self.eye:MakePixelPerfect()
      IconManager:SetUIIcon(ItemTabType_MainBag_Icon[ItemNormalList.TabType.FashionPage][self.advFashion], self.icon)
      self.icon:MakePixelPerfect()
      self.item:SetActive(true)
    end
    return
  end
  self.isEquiped = false
  if self.fashionItemData.isAdventureItemData then
    local savedItems = self.fashionItemData.savedItemDatas
    for i = 1, #savedItems do
      if PackageFashionPage.IsFashionItemEquiped(savedItems[i]) then
        self.isEquiped = true
        break
      end
    end
  elseif self.fashionItemData then
    self.isEquiped = PackageFashionPage.IsFashionItemEquiped(self.fashionItemData)
  end
  self.objInUse:SetActive(self.isEquiped and not self.isFashionHide)
end
function BagFashionItemCell:TrySetFashionHide(advFashion, isFashionHide)
  self.advFashion = advFashion
  self.isFashionHide = isFashionHide and true or false
end
