Table_PlotQuest_26 = {
  [1] = {
    id = 1,
    Type = "play_effect_ui",
    Params = {path = "BtoW"}
  },
  [2] = {
    id = 2,
    Type = "wait_time",
    Params = {time = 1000}
  },
  [3] = {
    id = 3,
    Type = "startfilter",
    Params = {
      fliter = {22}
    }
  },
  [4] = {
    id = 4,
    Type = "play_camera_anim",
    Params = {name = "Camera7", time = 10}
  },
  [5] = {
    id = 5,
    Type = "wait_time",
    Params = {time = 3000}
  },
  [6] = {
    id = 6,
    Type = "scene_action",
    Params = {uniqueid = 802198, id = 502}
  },
  [7] = {
    id = 7,
    Type = "wait_time",
    Params = {time = 5000}
  },
  [8] = {
    id = 8,
    Type = "reset_camera",
    Params = _EmptyTable
  },
  [9] = {
    id = 9,
    Type = "endfilter",
    Params = {
      fliter = {22}
    }
  }
}
Table_PlotQuest_26_fields = {
  "id",
  "Type",
  "Params"
}
return Table_PlotQuest_26
