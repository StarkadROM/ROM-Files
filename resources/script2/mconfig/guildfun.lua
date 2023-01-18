GuildFun = {}
function GuildFun.calcGuildPrayCon(prayid, praylv)
  local cfg = Table_Guild_Faith[prayid]
  if cfg == nil then
    return 0
  end
  if praylv <= 10 then
    return math.floor(34)
  elseif praylv <= 20 and praylv > 10 then
    return math.floor(36)
  elseif praylv <= 30 and praylv > 20 then
    return math.floor(42)
  elseif praylv <= 40 and praylv > 30 then
    return math.floor(80)
  elseif praylv <= 50 and praylv > 40 then
    return math.floor(152)
  elseif praylv <= 60 and praylv > 50 then
    return math.floor(284)
  elseif praylv <= 70 and praylv > 60 then
    return math.floor(450)
  elseif praylv <= 80 and praylv > 70 then
    return math.floor(588)
  elseif praylv <= 150 and praylv > 80 then
    return math.floor(728)
  else
    return math.floor(1000)
  end
end
function GuildFun.calcGuildPrayMon(prayid, praylv)
  local cfg = Table_Guild_Faith[prayid]
  if cfg == nil then
    return 0
  end
  local a1 = praylv % 10
  local b1 = GameConfig.GuildPray.Remainder[a1]
  local a2 = math.floor(praylv / 10)
  local b2 = GameConfig.GuildPray.Quotient[a2]
  local result = GameConfig.GuildPray.BaseCost * b1 * b2
  result = result - result % 10
  return result
end
function GuildFun.calcGuildPrayAttr(prayid, praylv)
  local result = {}
  if praylv >= 0 and praylv <= 10 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 10 * praylv
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 0.4 * praylv
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 0.4 * praylv
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 0.2 * praylv
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 0.2 * praylv
    end
  elseif praylv >= 11 and praylv <= 20 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 100 + 18 * (praylv - 10)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 4 + 0.7 * (praylv - 10)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 4 + 0.7 * (praylv - 10)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 2 + 0.4 * (praylv - 10)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 2 + 0.4 * (praylv - 10)
    end
  elseif praylv >= 21 and praylv <= 30 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 280 + 28 * (praylv - 20)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 11 + 1.1 * (praylv - 20)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 11 + 1.1 * (praylv - 20)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 6 + 0.5 * (praylv - 20)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 6 + 0.5 * (praylv - 20)
    end
  elseif praylv >= 31 and praylv <= 40 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 560 + 38 * (praylv - 30)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 22 + 1.5 * (praylv - 30)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 22 + 1.5 * (praylv - 30)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 11 + 0.7 * (praylv - 30)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 11 + 0.7 * (praylv - 30)
    end
  elseif praylv >= 41 and praylv <= 50 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 940 + 45 * (praylv - 40)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 37 + 1.8 * (praylv - 40)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 37 + 1.8 * (praylv - 40)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 18 + 0.9 * (praylv - 40)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 18 + 0.9 * (praylv - 40)
    end
  elseif praylv >= 51 and praylv <= 60 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 1390 + 55 * (praylv - 50)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 55 + 2.2 * (praylv - 50)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 55 + 2.2 * (praylv - 50)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 27 + 1.1 * (praylv - 50)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 27 + 1.1 * (praylv - 50)
    end
  elseif praylv >= 61 and praylv <= 70 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 1940 + 63 * (praylv - 60)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 77 + 2.5 * (praylv - 60)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 77 + 2.5 * (praylv - 60)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 38 + 1.3 * (praylv - 60)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 38 + 1.3 * (praylv - 60)
    end
  elseif praylv >= 71 and praylv <= 80 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 2570 + 73 * (praylv - 70)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 102 + 2.9 * (praylv - 70)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 102 + 2.9 * (praylv - 70)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 51 + 1.5 * (praylv - 70)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 51 + 1.5 * (praylv - 70)
    end
  elseif praylv >= 81 and praylv <= 90 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 3300 + 83 * (praylv - 80)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 131 + 3.3 * (praylv - 80)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 131 + 3.3 * (praylv - 80)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 66 + 1.6 * (praylv - 80)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 66 + 1.6 * (praylv - 80)
    end
  elseif praylv >= 91 and praylv <= 100 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 4130 + 90 * (praylv - 90)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 164 + 3.6 * (praylv - 90)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 164 + 3.6 * (praylv - 90)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 82 + 1.8 * (praylv - 90)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 82 + 1.8 * (praylv - 90)
    end
  elseif praylv >= 101 and praylv <= 110 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 5030 + 100 * (praylv - 100)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 200 + 4 * (praylv - 100)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 200 + 4 * (praylv - 100)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 100 + 2 * (praylv - 100)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 100 + 2 * (praylv - 100)
    end
  elseif praylv >= 111 and praylv <= 120 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 6030 + 112 * (praylv - 110)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 240 + 4.5 * (praylv - 110)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 240 + 4.5 * (praylv - 110)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 120 + 2.2 * (praylv - 110)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 120 + 2.2 * (praylv - 110)
    end
  elseif praylv >= 121 and praylv <= 130 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 7150 + 125 * (praylv - 120)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 285 + 5 * (praylv - 120)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 285 + 5 * (praylv - 120)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 142 + 2.5 * (praylv - 120)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 142 + 2.5 * (praylv - 120)
    end
  elseif praylv >= 131 and praylv <= 140 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 8400 + 138 * (praylv - 130)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 335 + 5.5 * (praylv - 130)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 335 + 5.5 * (praylv - 130)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 167 + 2.8 * (praylv - 130)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 167 + 2.8 * (praylv - 130)
    end
  elseif praylv >= 141 and praylv <= 150 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 9780 + 150 * (praylv - 140)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 390 + 6 * (praylv - 140)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 390 + 6 * (praylv - 140)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 195 + 3 * (praylv - 140)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 195 + 3 * (praylv - 140)
    end
  elseif praylv >= 151 and praylv <= 160 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 11280 + 175 * (praylv - 150)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 450 + 7 * (praylv - 150)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 450 + 7 * (praylv - 150)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 225 + 3.5 * (praylv - 150)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 225 + 3.5 * (praylv - 150)
    end
  elseif praylv >= 161 and praylv <= 170 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 13030 + 187.5 * (praylv - 160)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 520 + 7.5 * (praylv - 160)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 520 + 7.5 * (praylv - 160)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 260 + 3.8 * (praylv - 160)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 260 + 3.8 * (praylv - 160)
    end
  elseif praylv >= 171 and praylv <= 180 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 14905 + 200 * (praylv - 170)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 595 + 8 * (praylv - 170)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 595 + 8 * (praylv - 170)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 298 + 4 * (praylv - 170)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 298 + 4 * (praylv - 170)
    end
  elseif praylv >= 181 and praylv <= 190 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 16905 + 212.5 * (praylv - 180)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 675 + 8.5 * (praylv - 180)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 675 + 8.5 * (praylv - 180)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 338 + 4.2 * (praylv - 180)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 338 + 4.2 * (praylv - 180)
    end
  elseif praylv >= 191 and praylv <= 200 then
    if prayid == 1 then
      result[CommonFun.RoleData.EATTRTYPE_MAXHP] = 19030 + 225 * (praylv - 190)
    elseif prayid == 2 then
      result[CommonFun.RoleData.EATTRTYPE_ATK] = 760 + 9 * (praylv - 190)
    elseif prayid == 3 then
      result[CommonFun.RoleData.EATTRTYPE_MATK] = 760 + 9 * (praylv - 190)
    elseif prayid == 4 then
      result[CommonFun.RoleData.EATTRTYPE_DEF] = 380 + 4.5 * (praylv - 190)
    elseif prayid == 5 then
      result[CommonFun.RoleData.EATTRTYPE_MDEF] = 380 + 4.5 * (praylv - 190)
    end
  end
  return result
end
