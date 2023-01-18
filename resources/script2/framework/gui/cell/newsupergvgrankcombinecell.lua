autoImport("BaseCombineCell")
autoImport("NewGvgRankCell")
NewSuperGvgRankCombineCell = class("NewSuperGvgRankCombineCell", BaseCombineCell)
function NewSuperGvgRankCombineCell:Init()
  self:InitCells(3, "NewSuperGvgRankCell", NewGvgRankCell)
end
