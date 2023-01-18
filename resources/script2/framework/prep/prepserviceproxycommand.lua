PrepServiceProxyCommand = class("PrepServiceProxyCommand", pm.SimpleCommand)
autoImport("ServiceProxy")
ServiceConnProxy = autoImport("ServiceConnProxy")
ServicePlayerProxy = autoImport("ServicePlayerProxy")
ServiceUserProxy = autoImport("ServiceUserProxy")
ServiceErrorProxy = autoImport("ServiceErrorProxy")
ServiceNpcProxy = autoImport("ServiceNpcProxy")
ServiceGMProxy = autoImport("ServiceGMProxy")
ServiceSceneProxy = autoImport("ServiceSceneProxy")
autoImport("ServiceHandlerOnLoadedProxy")
autoImport("ServiceSkillProxy")
autoImport("ServiceItemProxy")
autoImport("ServiceQuestProxy")
autoImport("ServiceNUserProxy")
autoImport("ServiceMapProxy")
autoImport("ServiceFuBenCmdProxy")
autoImport("ServiceSessionTeamProxy")
autoImport("ServiceBossCmdProxy")
autoImport("ServiceSessionMailProxy")
autoImport("ServiceSessionShopProxy")
autoImport("ServiceCarrierCmdProxy")
autoImport("ServiceGuildCmdProxy")
autoImport("ServiceWeatherProxy")
autoImport("ServiceSceneTipProxy")
autoImport("ServiceChatRoomProxy")
autoImport("ServiceInfiniteTowerProxy")
autoImport("ServiceSceneSealProxy")
autoImport("ServiceSceneInterlocutionProxy")
autoImport("ServiceSceneManualProxy")
autoImport("ServiceSessionSocialityProxy")
autoImport("ServiceUserEventProxy")
autoImport("ServiceRecordTradeProxy")
autoImport("ServiceDojoProxy")
autoImport("ServiceChatCmdProxy")
autoImport("ServiceLoginUserCmdProxy")
autoImport("ServiceErrorUserCmdProxy")
autoImport("ServiceActivityCmdProxy")
autoImport("ServiceSceneAuguryProxy")
autoImport("ServiceScenePetProxy")
autoImport("ServiceMatchCCmdProxy")
autoImport("ServiceAchieveCmdProxy")
autoImport("ServiceAuthorizeProxy")
autoImport("ServiceAstrolabeCmdProxy")
autoImport("ServiceSceneFoodProxy")
autoImport("ServicePhotoCmdProxy")
autoImport("ServiceAuctionCCmdProxy")
autoImport("ServiceTutorProxy")
autoImport("ServiceSceneBeingProxy")
autoImport("ServiceActivityEventProxy")
autoImport("ServiceWeddingCCmdProxy")
autoImport("ServicePveCardProxy")
autoImport("ServiceTeamRaidCmdProxy")
autoImport("ServiceInteractCmdProxy")
autoImport("ServicePuzzleCmdProxy")
autoImport("ServiceHomeCmdProxy")
autoImport("ServiceTeamGroupRaidProxy")
autoImport("ServiceBattlePassProxy")
autoImport("ServiceRoguelikeCmdProxy")
autoImport("ServiceTechTreeCmdProxy")
autoImport("ServiceMiniGameCmdProxy")
autoImport("ServiceUserShowProxy")
autoImport("ServiceActHitPollyProxy")
autoImport("ServiceUserAfkCmdProxy")
autoImport("ServiceNoviceNotebookProxy")
autoImport("ServiceActMiniRoCmdProxy")
autoImport("ServiceRaidCmdProxy")
autoImport("ServiceGoalCmdProxy")
autoImport("ServiceDisneyActivityProxy")
autoImport("ServiceQueueEnterCmdProxy")
autoImport("ServiceSceneManorProxy")
autoImport("ServiceFamilyCmdProxy")
autoImport("ServiceNoviceBattlePassProxy")
autoImport("ServiceSceneUser3Proxy")
autoImport("ServiceMessCCmdProxy")
autoImport("ServiceOverseasTaiwanCmdProxy")
function PrepServiceProxyCommand:execute(noti)
  GameFacade.Instance:registerProxy(ServiceHandlerOnLoadedProxy.new())
  GameFacade.Instance:registerProxy(ServiceConnProxy.new())
  GameFacade.Instance:registerProxy(ServicePlayerProxy.new())
  GameFacade.Instance:registerProxy(ServiceUserProxy.new())
  GameFacade.Instance:registerProxy(ServiceErrorProxy.new())
  GameFacade.Instance:registerProxy(ServiceNpcProxy.new())
  GameFacade.Instance:registerProxy(ServiceItemProxy.new())
  GameFacade.Instance:registerProxy(ServiceGMProxy.new())
  GameFacade.Instance:registerProxy(ServiceSkillProxy.new())
  GameFacade.Instance:registerProxy(ServiceSceneProxy.new())
  GameFacade.Instance:registerProxy(ServiceQuestProxy.new())
  GameFacade.Instance:registerProxy(ServiceNUserProxy.new())
  GameFacade.Instance:registerProxy(ServiceMapProxy.new())
  GameFacade.Instance:registerProxy(ServiceFuBenCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceSessionTeamProxy.new())
  GameFacade.Instance:registerProxy(ServiceBossCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceSessionMailProxy.new())
  GameFacade.Instance:registerProxy(ServiceSessionShopProxy.new())
  GameFacade.Instance:registerProxy(ServiceCarrierCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceWeatherProxy.new())
  GameFacade.Instance:registerProxy(ServiceSceneTipProxy.new())
  GameFacade.Instance:registerProxy(ServiceChatRoomProxy.new())
  GameFacade.Instance:registerProxy(ServiceInfiniteTowerProxy.new())
  GameFacade.Instance:registerProxy(ServiceSceneSealProxy.new())
  GameFacade.Instance:registerProxy(ServiceSceneInterlocutionProxy.new())
  GameFacade.Instance:registerProxy(ServiceSceneManualProxy.new())
  GameFacade.Instance:registerProxy(ServiceSessionSocialityProxy.new())
  GameFacade.Instance:registerProxy(ServiceUserEventProxy.new())
  GameFacade.Instance:registerProxy(ServiceRecordTradeProxy.new())
  GameFacade.Instance:registerProxy(ServiceGuildCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceDojoProxy.new())
  GameFacade.Instance:registerProxy(ServiceChatCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceLoginUserCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceErrorUserCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceActivityCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceSceneAuguryProxy.new())
  GameFacade.Instance:registerProxy(ServiceScenePetProxy.new())
  GameFacade.Instance:registerProxy(ServiceMatchCCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceAchieveCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceAuthorizeProxy.new())
  GameFacade.Instance:registerProxy(ServiceAstrolabeCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceSceneFoodProxy.new())
  GameFacade.Instance:registerProxy(ServicePhotoCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceAuctionCCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceTutorProxy.new())
  GameFacade.Instance:registerProxy(ServiceSceneBeingProxy.new())
  GameFacade.Instance:registerProxy(ServiceActivityEventProxy.new())
  GameFacade.Instance:registerProxy(ServiceWeddingCCmdProxy.new())
  GameFacade.Instance:registerProxy(ServicePveCardProxy.new())
  GameFacade.Instance:registerProxy(ServiceTeamRaidCmdProxy.new())
  GameFacade.Instance:registerProxy(ServicePuzzleCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceInteractCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceHomeCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceTeamGroupRaidProxy.new())
  GameFacade.Instance:registerProxy(ServiceBattlePassProxy.new())
  GameFacade.Instance:registerProxy(ServiceRoguelikeCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceTechTreeCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceMiniGameCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceUserShowProxy.new())
  GameFacade.Instance:registerProxy(ServiceActHitPollyProxy.new())
  GameFacade.Instance:registerProxy(ServiceOverseasTaiwanCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceUserAfkCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceGoalCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceDisneyActivityProxy.new())
  GameFacade.Instance:registerProxy(ServiceQueueEnterCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceNoviceNotebookProxy.new())
  GameFacade.Instance:registerProxy(ServiceActMiniRoCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceRaidCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceSceneManorProxy.new())
  GameFacade.Instance:registerProxy(ServiceFamilyCmdProxy.new())
  GameFacade.Instance:registerProxy(ServiceNoviceBattlePassProxy.new())
  GameFacade.Instance:registerProxy(ServiceSceneUser3Proxy.new())
  GameFacade.Instance:registerProxy(ServiceMessCCmdProxy.new())
end