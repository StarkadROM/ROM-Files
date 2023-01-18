local BaseCell = autoImport("BaseCell")
GFaithTypeCell = class("GFaithTypeCell", BaseCell)
function GFaithTypeCell:Init()
  self.name = self:FindComponent("NameLabel", UILabel)
  self.attriAdd = self:FindComponent("AttriAdd", UILabel)
end
function GFaithTypeCell:SetData(data)
  if data then
    local sData = data.staticData
    if OverSea.LangManager.Instance().CurSysLang == "Thai" then
      self.name.text = string.format("%s%s", ZhString.GFaithTypeCell_Pray, sData.Name)
    else
      self.name.text = string.format("%s%s", sData.Name, ZhString.GFaithTypeCell_Pray)
    end
    local _, nowValue = next(GuildFun.calcGuildPrayAttr(sData.id, data.level))
    if nowValue then
      local floorValue = math.floor(nowValue)
      if nowValue > floorValue then
        self.attriAdd.text = string.format("%s +%.1f", sData.Attr, nowValue)
      else
        self.attriAdd.text = string.format("%s +%s", sData.Attr, floorValue)
      end
    end
  end
end
