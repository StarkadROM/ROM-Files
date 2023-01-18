LangSwitchPanel = class("LangSwitchPanel", BaseView)
LangSwitchPanel.ViewType = UIViewType.PopUpLayer
LangSwitchPanel.ThaiTitle = ZhString.LangSwitchPanel_Thai
if BranchMgr.IsSEA() then
  LangSwitchPanel.NeedLanguage = {
    [1] = {
      key = "ChineseSimplified",
      title = ZhString.LangSwitchPanel_ChineseSimplified
    },
    [2] = {
      key = "Thai",
      title = ZhString.LangSwitchPanel_Thai
    },
    [3] = {
      key = "Indonesian",
      title = ZhString.LangSwitchPanel_Indonesian
    },
    [4] = {
      key = "English",
      title = ZhString.LangSwitchPanel_English
    }
  }
elseif BranchMgr.IsNA() then
  LangSwitchPanel.NeedLanguage = {
    [1] = {
      key = "English",
      title = ZhString.LangSwitchPanel_English
    },
    [2] = {
      key = "ChineseSimplified",
      title = ZhString.LangSwitchPanel_ChineseSimplified
    },
    [3] = {
      key = "Korean",
      title = ZhString.LangSwitchPanel_Korean
    },
    [4] = {
      key = "Portuguese",
      title = ZhString.LangSwitchPanel_Portuguese
    },
    [5] = {
      key = "Spanish",
      title = ZhString.LangSwitchPanel_Spanish
    }
  }
elseif BranchMgr.IsEU() then
  LangSwitchPanel.NeedLanguage = {
    [1] = {
      key = "ChineseSimplified",
      title = ZhString.LangSwitchPanel_ChineseSimplified
    },
    [2] = {
      key = "English",
      title = ZhString.LangSwitchPanel_English
    },
    [3] = {
      key = "German",
      title = ZhString.LangSwitchPanel_German
    },
    [4] = {
      key = "Spanish",
      title = ZhString.LangSwitchPanel_Spanish
    },
    [5] = {
      key = "Russian",
      title = ZhString.LangSwitchPanel_Russian
    },
    [6] = {
      key = "Portuguese",
      title = ZhString.LangSwitchPanel_Portuguese
    }
  }
end
function LangSwitchPanel:Init()
  for _, v in pairs(LangSwitchPanel.NeedLanguage) do
    do
      local lbtn = self:FindGO(v.key, self:FindGO("Grid"))
      if lbtn then
        lbtn:SetActive(true)
        local title = self:FindGO("Title", lbtn)
        local titleLab = title:GetComponent(UILabel)
        if v.key == "Thai" then
          local thaiFont = self:FindComponent("Thai", UIFont)
          if thaiFont then
            titleLab.trueTypeFont = nil
            titleLab.bitmapFont = thaiFont
          end
        end
        titleLab.text = v.title
        self:AddClickEvent(lbtn, function(go)
          self:ReloadLanguage(v.key)
        end)
      else
      end
    end
  end
end
function LangSwitchPanel:GetCurLanguageKey(title)
  for _, v in pairs(LangSwitchPanel.NeedLanguage) do
    if v.title == title then
      return v.key
    end
  end
  return LangSwitchPanel.NeedLanguage[4].key
end
function LangSwitchPanel:GetCurLanguageConf()
  local curLang = OverSea.LangManager.Instance().CurSysLang
  for _, v in pairs(LangSwitchPanel.NeedLanguage) do
    if v.key == curLang then
      return v
    end
  end
  return LangSwitchPanel.NeedLanguage[4]
end
function LangSwitchPanel:ReloadLanguage(lang)
  PlayerPrefs.SetString("lastSetLang", lang)
  OverSea.LangManager.Instance():SetCurLang(lang)
  if FunctionSDK.Instance.CurrentType == FunctionSDK.E_SDKType.TDSG then
    local result = AppBundleConfig.GetSDKLang_TDSG()
    helplog("reload lang :" .. tostring(result))
    OverSeas_TW.OverSeasManager.GetInstance():SetSDKLang(result)
  else
    OverSeas_TW.OverSeasManager.GetInstance():SetSDKLang(AppBundleConfig.GetSDKLang())
  end
  Game.Me():BackToLogo()
end
function LangSwitchPanel:OnEnter()
  LangSwitchPanel.super.OnEnter(self)
end
function LangSwitchPanel:OnExit()
  LangSwitchPanel.super.OnExit(self)
end
