local BaseCell = autoImport("BaseCell")
SceneBottomHpSpCell = reusableClass("SceneBottomHpSpCell", BaseCell)
autoImport("SceneTimeDiskInfo")
autoImport("SceneStarMap")
SceneBottomHpSpCell.resId = ResourcePathHelper.UIPrefab_Cell("SceneBottomHpSpCell")
local tempVector3 = LuaVector3.Zero()
SceneBottomHpSpCell.PoolSize = 30
local TwelvePvpConfig = GameConfig.TwelvePvp.HpShow
local ColorRed = LuaColor.New(1, 0.4627450980392157, 0.7176470588235294, 1)
local ColorGreen = LuaColor.New(0.6627450980392157, 0.9411764705882353, 0.3058823529411765, 1)
function SceneBottomHpSpCell:Construct(asArray, args)
  self:DoConstruct(asArray, args)
end
function SceneBottomHpSpCell:DoConstruct(asArray, args)
  self._alive = true
  local gameObject = args[1]
  local creature = args[2]
  self.gameObject = gameObject
  self.transform = self.gameObject.transform
  LuaVector3.Better_Set(tempVector3, 0, 0, 0)
  self.transform.localPosition = tempVector3
  self.transform.localRotation = LuaGeometry.Const_Qua_identity
  self.canvasGroup = gameObject:GetComponent(CanvasGroup)
  self.deadSlideAnim = false
  self:initData(creature)
  if self:isPushMinion() then
    LuaVector3.Better_Set(tempVector3, 0.5, 1, 1)
  else
    LuaVector3.Better_Set(tempVector3, 1, 1, 1)
  end
  self.transform.localScale = tempVector3
  self:initHpView()
  self:initSpView()
  local buffhp, buffmaxhp = creature.data:GetBuffHpVals()
  if buffhp then
    self:SetHp(buffhp, buffmaxhp or 1)
  else
    local value = creature.data:GetHP()
    local MaxValue = creature.data.props:GetPropByName("MaxHp"):GetValue()
    self:SetHp(value, MaxValue)
  end
  value = creature.data.props:GetPropByName("Sp"):GetValue()
  MaxValue = creature.data.props:GetPropByName("MaxSp"):GetValue()
  local spTrans = creature.data.spTrans
  self:SetSp(value, MaxValue, spTrans)
  if self.mySanity and not self.ObjIsNil(self.mySanity) then
    LuaGameObject.DestroyObject(self.mySanity.gameObject)
    self.isFirstInitSanity = false
    self.mySanity = nil
    self.sanityPrefab = nil
  end
  self.scaleTween = self.gameObject:GetComponent(TweenScale)
end
function SceneBottomHpSpCell:Deconstruct(asArray)
  if not LuaGameObject.ObjectIsNull(self.gameObject) then
    if self.spSliderObj and not LuaGameObject.ObjectIsNull(self.spSliderObj) then
      LeanTween.cancel(self.spSliderObj)
    end
    Game.GOLuaPoolManager:AddToSceneUIPool(SceneBottomHpSpCell.resId, self.gameObject)
  end
  TimeTickManager.Me():ClearTick(self)
  self.canvasGroup = nil
  self.spCanvasGroup = nil
  self.sanityCanvasGroup = nil
  self.uibloodcontainer = nil
  self.bloodDetailCanvasGroup = nil
  self.uibloodslider = nil
  self.uiblood = nil
  self.bloodDetailContainer = nil
  self.bloodVolume = nil
  self.spContainer = nil
  self.spSlider = nil
  self.spSliderObj = nil
  self.gameObject = nil
  self.transform = nil
  self.hpbg = nil
  self._alive = false
  if not self:ObjIsNil(self.mySanity) then
    LuaGameObject.DestroyObject(self.mySanity.gameObject)
    self.isFirstInitSanity = false
  end
  self.sanityContainer = nil
  self.sanityPrefab = nil
  self.mySanity = nil
  self.sanityPercent = nil
  self.forebg = nil
  self.scaleTween = nil
  self.hpGrid = nil
  self.hpGridElements = nil
  self.spGrid = nil
  self.spGridElements = nil
  self.bulletsContainer = nil
  self.bulletsPrefab = nil
  self.bulletsNum = nil
  self.frenzyContainer = nil
  self.frenzyCanvasGroup = nil
  self.myFrenzySlider = nil
  self.frenzyLayer = nil
  self.timeDiskContainer = nil
  self.starMapContainer = nil
  self:RemoveTimeDisk()
  self:RemoveStarMap()
end
function SceneBottomHpSpCell:Exit()
  TableUtility.TableClear(tempTable)
end
function SceneBottomHpSpCell:initData(creature)
  self.creatureType = creature:GetCreatureType()
  self.camp = creature.data:GetCamp()
  self.detailedType = creature.data.detailedType
  self.ismyself = self.creatureType == Creature_Type.Me
  self.isFirstSpInit = true
  self.isFirstHpInit = true
  self.isBeHi = false
  self.bosstype = creature:GetBossType()
  self.staticID = creature.data.staticData and creature.data.staticData.id
  self.creature = creature
end
function SceneBottomHpSpCell:initHpView()
  self.uibloodcontainer = self:FindGO("BloodContainer")
  self.uibloodslider = self:FindGO("BloodSlider"):GetComponent(Slider)
  self.uiblood = self:FindGO("Blood"):GetComponent(Image)
  self:initCreateBg()
  self:initDecorate()
  self:initHpValueLabel()
  self:InitHpGrid()
  self:InitCamp()
end
function SceneBottomHpSpCell:initHpValueLabel()
  self.bloodDetailContainer = self:FindGO("BloodDetailContainer")
  if not self.bloodDetailCanvasGroup then
    self.bloodDetailCanvasGroup = self.bloodDetailContainer:GetComponent(CanvasGroup)
  end
  if Game.MapManager:IsPVEMode() and self:isMvpOrMini() or GvgProxy.Instance:IsFireState() and self:isPlayer() then
    self.bloodVolume = self:FindComponent("BloodVolume", Text)
    self.bloodVolume.text = ""
    self:SetActive(self.bloodDetailCanvasGroup, true)
  else
    self:SetActive(self.bloodDetailCanvasGroup, false)
    self.bloodVolume = nil
  end
end
function SceneBottomHpSpCell:initSpView()
  local spContainer = self:FindGO("SpContainer")
  if not self.spCanvasGroup then
    self.spCanvasGroup = spContainer:GetComponent(CanvasGroup)
  end
  if self.ismyself then
    self:SetActive(self.spCanvasGroup, true)
    self.spContainer = spContainer
    local spSlider = self:FindGO("SpSlider"):GetComponent(Slider)
    self.spSlider = spSlider
    self.spSliderObj = spSlider.gameObject
  else
    self:SetActive(self.spCanvasGroup, false)
  end
end
function SceneBottomHpSpCell:SetActive(canvasGroup, visible, isRoot)
  if not canvasGroup then
    return
  end
  canvasGroup.alpha = visible and 1 or 0
end
function SceneBottomHpSpCell:setHpSpVisible(visible, isSelect)
  local objNull = self:ObjIsNil(self.gameObject)
  if objNull then
    return
  end
  if self.deadSlideAnim then
    return
  end
  self:SetActive(self.canvasGroup, visible, true)
  if isSelect and self.creature == Game.Myself:GetLockTarget() then
    self.scaleTween:ResetToBeginning()
    self.scaleTween:PlayForward()
  end
end
function SceneBottomHpSpCell:SetHpLabel(hp)
  if self.bloodVolume then
    if hp == 0 then
      hp = "" or hp
    end
    self.bloodVolume.text = hp
  end
end
function SceneBottomHpSpCell:SetHp(hp, maxhp)
  if self:ObjIsNil(self.uibloodcontainer) then
    return
  end
  if maxhp == 0 then
    LogUtility.Warning("Trying to set maxhp = 0!!")
    return
  end
  self:tweenHpSlider(hp, maxhp)
  local isLowBlood
  if hp / maxhp <= 0.2 and hp ~= 0 then
    isLowBlood = true
  else
    isLowBlood = false
  end
  if self.ismyself and isLowBlood then
    if not LowBloodBlinkView.Instance then
      LowBloodBlinkView.ShowLowBloodBlink()
    end
  elseif self.ismyself and not isLowBlood and LowBloodBlinkView.Instance then
    LowBloodBlinkView.closeBloodBlink()
  end
  self:SetHpLabel(hp)
end
function SceneBottomHpSpCell:SetSp(sp, maxSp, spTrans)
  if self.ismyself then
    if self:ObjIsNil(self.spContainer) then
      return
    end
    if maxSp == 0 then
      maxSp = 99999999999 or maxSp
    end
    local curbuff = 1
    if spTrans then
      sp = maxSp
    end
    local curSp = self.spSlider.value * maxSp
    if self.spContainer.activeSelf and not self.isFirstSpInit then
      LeanTween.sliderUGUI(self.spSlider, curSp / maxSp, sp / maxSp, math.abs((sp - curSp) / maxSp) * 0.5)
    else
      self.spSlider.value = sp / maxSp
      self.isFirstSpInit = false
    end
  end
end
function SceneBottomHpSpCell:tweenHpSlider(hp, maxhp)
  local objNull = self:ObjIsNil(self.uibloodcontainer)
  if objNull then
    return
  end
  if self.uibloodcontainer.activeSelf then
    local curHp = self.uibloodslider.value * maxhp
    if not self.isFirstHpInit then
      TimeTickManager.Me():ClearTick(self)
      local time = math.abs((hp - curHp) / maxhp) * 500
      if time < 33 then
        self:setHpValueAndColor(hp / maxhp, hp)
      else
        TimeTickManager.Me():CreateTickFromTo(0, curHp, hp, time, function(owner, deltaTime, curValue)
          self:setHpValueAndColor(curValue / maxhp, hp)
        end, self)
      end
    else
      self:setHpValueAndColor(hp / maxhp, hp)
      self.isFirstHpInit = false
    end
  else
    local value = hp == 0 and 0 or hp / maxhp
    self:setHpValueAndColor(value, hp)
  end
end
function SceneBottomHpSpCell:setHpValueAndColor(value, finalHp)
  self.uibloodslider.value = value
  if value <= 0 and finalHp == 0 then
    self.deadSlideAnim = false
    self:setHpSpVisible(false)
    return
  end
  if self.uibloodslider.value <= 0.2 and self.uibloodslider.value > 0 then
    if self.camp == RoleDefines_Camp.ENEMY then
      if Game.MapManager:IsPvPMode_TeamTwelve() and self:isMvpOrMini() then
        if "com_bg_mp3" ~= self.hpbg then
          SpriteManager.SetUISprite("sceneuicom", "com_bg_mp3", self.uiblood)
          self.hpbg = "com_bg_mp3"
        end
      elseif "com_bg_hp_3s" ~= self.hpbg then
        SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_3s", self.uiblood)
        self.hpbg = "com_bg_hp_3s"
      end
    elseif "com_bg_hp_2s" ~= self.hpbg then
      SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_2s", self.uiblood)
      self.hpbg = "com_bg_hp_2s"
    end
  elseif self.camp == RoleDefines_Camp.ENEMY then
    if Game.MapManager:IsPvPMode_TeamTwelve() and self:isMvpOrMini() then
      if "com_bg_mp2" ~= self.hpbg then
        SpriteManager.SetUISprite("sceneuicom", "com_bg_mp2", self.uiblood)
        self.hpbg = "com_bg_mp2"
      end
    elseif "com_bg_hp_4s" ~= self.hpbg then
      SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_4s", self.uiblood)
      self.hpbg = "com_bg_hp_4s"
    end
  elseif "com_bg_hp_s" ~= self.hpbg then
    SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_s", self.uiblood)
    self.hpbg = "com_bg_hp_s"
  end
end
function SceneBottomHpSpCell:isMvpOrMini()
  local detailedType = self.detailedType
  if detailedType == NpcData.NpcDetailedType.MINI or detailedType == NpcData.NpcDetailedType.MVP then
    return true
  end
  return false
end
function SceneBottomHpSpCell:isMvp()
  local detailedType = self.detailedType
  if detailedType == NpcData.NpcDetailedType.MVP then
    return true
  end
  return false
end
function SceneBottomHpSpCell:isRareElite()
  local detailedType = self.detailedType
  if detailedType == NpcData.NpcDetailedType.RareElite then
    return true
  end
  return false
end
function SceneBottomHpSpCell:isPlayer()
  if self.creatureType == Creature_Type.Player then
    return true
  end
  return false
end
function SceneBottomHpSpCell:isCopyNpc()
  if self.detailedType == NpcData.NpcDetailedType.CopyNpc then
    return true
  end
  return false
end
function SceneBottomHpSpCell:isFollowMaster()
  if self.detailedType == NpcData.NpcDetailedType.FollowMaster then
    return true
  end
  return false
end
function SceneBottomHpSpCell:IsTwelveBuildNPC()
  return self.detailedType == NpcData.NpcDetailedType.TwelveBase or self.detailedType == NpcData.NpcDetailedType.TwelveBarrack or self.detailedType == NpcData.NpcDetailedType.DefenseTower
end
function SceneBottomHpSpCell:initDecorate()
  local decoratorCanvas = self:FindGO("Decorate"):GetComponent(CanvasGroup)
  local rightBossBgGO = self:FindGO("rightBossBg")
  local rightBossBgCanvas = rightBossBgGO:GetComponent(CanvasGroup)
  local rightBossBg = rightBossBgGO:GetComponent(Image)
  local leftBossBg = self:FindGO("leftBossBg"):GetComponent(Image)
  if self:isMvpOrMini() then
    if self.detailedType == NpcData.NpcDetailedType.MINI then
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_2_3", rightBossBg)
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_2_1", leftBossBg)
    elseif self.detailedType == NpcData.NpcDetailedType.MVP then
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_1_3", rightBossBg)
      SpriteManager.SetUISprite("sceneuicom", "ui_head2_1", leftBossBg)
    end
    if self.bosstype and self.bosstype == 3 then
      SpriteManager.SetUISprite("sceneuicom", "Boss_head1", rightBossBg)
      SpriteManager.SetUISprite("sceneuicom", "ui_mvp_dead11_JM", leftBossBg)
    end
    self:SetActive(rightBossBgCanvas, true)
    self:SetActive(decoratorCanvas, true)
  elseif self:isRareElite() then
    SpriteManager.SetUISprite("sceneuicom", "ui_head2_2_3", rightBossBg)
    SpriteManager.SetUISprite("sceneuicom", "map_jingying", leftBossBg)
    self:SetActive(rightBossBgCanvas, true)
    self:SetActive(decoratorCanvas, true)
  elseif Game.MapManager:IsPvPMode_TeamTwelve() then
    if self.staticID and TwelvePvpConfig[self.staticID] then
      SpriteManager.SetUISprite("sceneuicom", "main_icon_boss", leftBossBg)
      self:SetActive(rightBossBgCanvas, false)
      self:SetActive(decoratorCanvas, true)
    elseif self:IsTwelveBuildNPC() then
      SpriteManager.SetUISprite("sceneuicom", "main_icon_build", leftBossBg)
      self:SetActive(rightBossBgCanvas, false)
      self:SetActive(decoratorCanvas, true)
    else
      self:SetActive(decoratorCanvas, false)
    end
  else
    self:SetActive(decoratorCanvas, false)
  end
end
function SceneBottomHpSpCell:InitHpGrid()
  local hpGrid = self:FindGO("hpGrid")
  if not hpGrid then
    return
  end
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    hpGrid:SetActive(false)
    return
  end
  if self.ismyself or self:isPlayer() or self:isMvpOrMini() or self.staticID and TwelvePvpConfig[self.staticID] then
    hpGrid:SetActive(true)
    return
  else
    hpGrid:SetActive(false)
    return
  end
end
function SceneBottomHpSpCell:InitCamp()
  local Camp = self:FindGO("Camp")
  if not Camp then
    return
  end
  local campBg = self:FindGO("campBg"):GetComponent(Image)
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    Camp:SetActive(false)
    return
  end
  if self.ismyself or self:isPlayer() then
    SpriteManager.SetUISprite("sceneuicom", "com_mask", campBg)
    if self.camp == RoleDefines_Camp.ENEMY then
      campBg.color = ColorRed
    else
      campBg.color = ColorGreen
    end
    Camp:SetActive(true)
  else
    Camp:SetActive(false)
  end
end
function SceneBottomHpSpCell:setCamp(camp)
  self.camp = camp
  self:initCreateBg()
end
function SceneBottomHpSpCell:initCreateBg()
  local camp = self.camp
  if camp == RoleDefines_Camp.ENEMY then
    if "com_bg_hp_4s" ~= self.hpbg then
      SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_4s", self.uiblood)
      self.hpbg = "com_bg_hp_4s"
    end
  elseif "com_bg_hp_s" ~= self.hpbg then
    SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_s", self.uiblood)
    self.hpbg = "com_bg_hp_s"
  end
end
function SceneBottomHpSpCell:Alive()
  return self._alive
end
function SceneBottomHpSpCell:InitSanity()
  self.sanityContainer = self:FindGO("SanityContainer")
  if not self.sanityContainer or self:ObjIsNil(self.sanityContainer) then
    return
  end
  if not self.sanityCanvasGroup then
    self.sanityCanvasGroup = self.sanityContainer:GetComponent(CanvasGroup)
  end
  self.sanityPrefab = self:LoadPreferb("part/SanityBarPart", self.sanityContainer)
  self.mySanity = self:FindGO("MySanity", self.sanityPrefab):GetComponent(Slider)
  self.sanityPercent = self:FindGO("sanityPercent", self.sanityPrefab):GetComponent(Text)
  self.forebg = self:FindGO("Sanity", self.mySanity.gameObject):GetComponent(Image)
  self.isFirstInitSanity = true
end
function SceneBottomHpSpCell:UpdateSanity(value)
  if not self.isFirstInitSanity and self:ObjIsNil(self.mySanity) then
    self:InitSanity()
    local guildData = Game.Myself.data:GetGuildData()
    self:UpdateSanityPostion(guildData ~= nil)
  end
  if self:ObjIsNil(self.mySanity) then
    return
  end
  if not value or value == 0 then
    self:SetActive(self.sanityCanvasGroup, false)
    return
  else
    self:SetActive(self.sanityCanvasGroup, true)
  end
  if not (value < 1) or not value then
    value = 1
  end
  if value > 0.4 then
    SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_2s", self.forebg)
  else
    SpriteManager.SetUISprite("sceneuicom", "com_bg_kl", self.forebg)
  end
  self.mySanity.value = value
  self.sanityPercent.text = string.format("%d%%", value * 100)
end
function SceneBottomHpSpCell:UpdateSanityPostion(needReposition)
  if self:ObjIsNil(self.mySanity) then
    return
  end
  if not self.spContainer or not self.spContainer.activeSelf then
    self.sanityContainer.transform.localPosition = LuaGeometry.GetTempVector3(0, -44, 0)
  elseif not self.hasFrenzy then
    self.sanityContainer.transform.localPosition = LuaGeometry.GetTempVector3(0, needReposition and -74 or -52, 0)
  else
    self.sanityContainer.transform.localPosition = LuaGeometry.GetTempVector3(0, needReposition and -84 or -62, 0)
  end
end
function SceneBottomHpSpCell:ClearSanity()
  if self.mySanity and not self:ObjIsNil(self.mySanity) then
    LuaGameObject.DestroyObject(self.mySanity.gameObject)
    self.isFirstInitSanity = false
    self.mySanity = nil
  end
end
function SceneBottomHpSpCell:isPushMinion()
  local detailedType = self.detailedType
  if detailedType == NpcData.NpcDetailedType.PushMinion and self.staticID and not TwelvePvpConfig[self.staticID] then
    return true
  end
  return false
end
function SceneBottomHpSpCell:UpdateHpColor(camp)
  self.camp = camp
  if self.uibloodslider.value <= 0.2 and self.uibloodslider.value > 0 then
    if self.camp == RoleDefines_Camp.ENEMY then
      if Game.MapManager:IsPvPMode_TeamTwelve() and self:isMvpOrMini() then
        if "com_bg_mp3" ~= self.hpbg then
          SpriteManager.SetUISprite("sceneuicom", "com_bg_mp3", self.uiblood)
          self.hpbg = "com_bg_mp3"
        end
      elseif "com_bg_hp_3s" ~= self.hpbg then
        SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_3s", self.uiblood)
        self.hpbg = "com_bg_hp_3s"
      end
    elseif "com_bg_hp_2s" ~= self.hpbg then
      SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_2s", self.uiblood)
      self.hpbg = "com_bg_hp_2s"
    end
  elseif self.camp == RoleDefines_Camp.ENEMY then
    if Game.MapManager:IsPvPMode_TeamTwelve() and self:isMvpOrMini() then
      if "com_bg_mp2" ~= self.hpbg then
        SpriteManager.SetUISprite("sceneuicom", "com_bg_mp2", self.uiblood)
        self.hpbg = "com_bg_mp2"
      end
    elseif "com_bg_hp_4s" ~= self.hpbg then
      SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_4s", self.uiblood)
      self.hpbg = "com_bg_hp_4s"
    end
  elseif "com_bg_hp_s" ~= self.hpbg then
    SpriteManager.SetUISprite("sceneuicom", "com_bg_hp_s", self.uiblood)
    self.hpbg = "com_bg_hp_s"
  end
end
function SceneBottomHpSpCell:InitBullets()
  self.bulletsContainer = self:FindGO("BulletsContainer")
  if not self.bulletsContainer or self:ObjIsNil(self.bulletsContainer) then
    return
  end
  self.bulletsPrefab = self:LoadPreferb("part/BulletsPart", self.bulletsContainer)
  self.bulletsNum = self:FindGO("num", self.bulletsPrefab):GetComponent(Text)
  self.bulletsNum.text = MyselfProxy.Instance:GetCurBullets()
  local bulletbg = self:FindGO("bg", self.bulletsPrefab):GetComponent(Image)
  SpriteManager.SetUISprite("sceneui", "Games_bg_bullet", bulletbg)
  local bulleticon = self:FindGO("bullet", self.bulletsPrefab):GetComponent(Image)
  SpriteManager.SetUISprite("sceneui", "Games_icon_bullet", bulleticon)
  local bulleticon2 = self:FindGO("img", self.bulletsPrefab):GetComponent(Image)
  SpriteManager.SetUISprite("sceneui", "Games_icon_bullet2", bulleticon2)
  self.bulletsContainer.transform.localPosition = LuaGeometry.GetTempVector3(-75, -10, 0)
  self.bulletsContainer:SetActive(true)
end
function SceneBottomHpSpCell:UpdateBulletsNum(num)
  if not self.bulletsContainer then
    self:InitBullets()
  end
  self.bulletsNum.text = num
  self:ShowBullets(true)
end
function SceneBottomHpSpCell:ShowBullets(value)
  redlog("ShowBullets", value)
  if self.bulletsContainer and value ~= nil then
    self.bulletsContainer:SetActive(value)
  elseif value then
    self:InitBullets()
  else
    redlog("not self.bulletsContainer")
  end
end
function SceneBottomHpSpCell:InitFrenzy()
  self.frenzyContainer = self:FindGO("FrenzyContainer")
  if not self.frenzyContainer or self:ObjIsNil(self.frenzyContainer) then
    return
  end
  if not self.frenzyCanvasGroup then
    self.frenzyCanvasGroup = self.frenzyContainer:GetComponent(CanvasGroup)
  end
  local prefab = self:LoadPreferb("part/FrenzyBar", self.frenzyContainer)
  if prefab then
    self.myFrenzySlider = self:FindGO("FrenzySlider", prefab):GetComponent(Slider)
    self.frenzyLayer = self:FindGO("FrenzyLayer", prefab):GetComponent(Text)
    self.frenzyLayer.text = layer or 0
    self.myFrenzySlider.value = 0
  end
end
function SceneBottomHpSpCell:UpdateFrenzyLayer(layer, maxLayer)
  if not self.frenzyContainer then
    self:InitFrenzy()
  end
  self.frenzyLayer.text = layer or 0
  self.myFrenzySlider.value = (layer or 0) / (maxLayer ~= 0 and maxLayer or 1)
  self:ShowFrenzy(true)
end
function SceneBottomHpSpCell:ShowFrenzy(value)
  if self.frenzyContainer then
    if value and not self.frenzyContainer.activeSelf then
      self.frenzyContainer:SetActive(true)
    elseif false == value and self.frenzyContainer.activeSelf then
      self.frenzyContainer:SetActive(false)
    end
  else
    self:InitFrenzy()
  end
  self.hasFrenzy = value
end
function SceneBottomHpSpCell:InitTimeDiskInfo()
  if not self.sceneTimeDisk then
    self.timeDiskContainer = self:FindGO("TimeDiskContainer")
    if not self.timeDiskContainer or self:ObjIsNil(self.timeDiskContainer) then
      return
    end
    local info = SkillProxy.Instance:GetTimeDiskInfo()
    local args = ReusableTable.CreateArray()
    args[1] = self.timeDiskContainer
    args[2] = info and info.isSun
    args[3] = self
    self.sceneTimeDisk = SceneTimeDiskInfo.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
  end
end
function SceneBottomHpSpCell:UpdateRotation(isSun, now, curGrid)
  if not self.sceneTimeDisk then
    self:InitTimeDiskInfo()
  end
  self.sceneTimeDisk:UpdateRotation(isSun, now, curGrid)
end
function SceneBottomHpSpCell:RemoveTimeDisk()
  if self.sceneTimeDisk then
    self.sceneTimeDisk:Destroy()
    self.sceneTimeDisk = nil
  end
end
function SceneBottomHpSpCell:InitStarMap()
  if not self.sceneStarMap then
    self.starMapContainer = self:FindGO("StarMapContainer")
    if not self.starMapContainer or self:ObjIsNil(self.starMapContainer) then
      return
    end
    local info = SkillProxy.Instance:GetTimeDiskInfo()
    local args = ReusableTable.CreateArray()
    args[1] = self.starMapContainer
    self.sceneStarMap = SceneStarMap.CreateAsArray(args)
    ReusableTable.DestroyAndClearArray(args)
  end
end
function SceneBottomHpSpCell:UpdateStar(bufflayer)
  if not self.sceneStarMap then
    self:InitStarMap()
  end
  self.sceneStarMap:UpdateStar(bufflayer)
end
function SceneBottomHpSpCell:RemoveStarMap()
  if self.sceneStarMap then
    self.sceneStarMap:Destroy()
    self.sceneStarMap = nil
  end
end
