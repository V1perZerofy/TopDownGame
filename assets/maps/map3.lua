return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 8,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 8,
  nextobjectid = 28,
  properties = {},
  tilesets = {
    {
      name = "FullTileset",
      firstgid = 1,
      class = "",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 9,
      image = "../tiles/full tilemap.png",
      imagewidth = 288,
      imageheight = 256,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      wangsets = {},
      tilecount = 72,
      tiles = {}
    },
    {
      name = "second",
      firstgid = 73,
      class = "",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 10,
      image = "../tiles/Dungeon_Tileset.png",
      imagewidth = 320,
      imageheight = 320,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      wangsets = {},
      tilecount = 100,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 8,
      id = 2,
      name = "Floor",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 52, 44, 44, 44, 45, 53, 45, 54, 54, 44, 52, 52, 52, 45, 0,
        0, 13, 32, 23, 12, 12, 21, 21, 24, 22, 21, 32, 23, 31, 32, 0,
        43, 22, 32, 24, 12, 31, 32, 30, 22, 22, 31, 24, 30, 32, 30, 0,
        12, 33, 30, 31, 32, 23, 31, 23, 31, 30, 23, 12, 30, 31, 22, 0,
        0, 33, 32, 24, 22, 33, 31, 21, 32, 32, 22, 31, 30, 24, 32, 0,
        0, 12, 13, 24, 31, 13, 13, 24, 24, 13, 30, 21, 12, 24, 13, 0,
        0, 24, 12, 33, 32, 32, 22, 22, 32, 22, 13, 21, 30, 22, 13, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 8,
      id = 4,
      name = "Decoration",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 163, 0, 0, 163, 0, 0, 163, 0, 0, 163, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 163, 0, 0, 163, 0, 0, 163, 0, 0, 163, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 8,
      id = 3,
      name = "Walls",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        41, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 66, 40,
        50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49,
        69, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49,
        60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49,
        50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49,
        50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49,
        59, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 57, 58
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 7,
      name = "torches",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 72,
          y = 40,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["color"] = "orange",
            ["radius"] = 150
          }
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 168,
          y = 40,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["color"] = "orange",
            ["radius"] = 150
          }
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 264,
          y = 40,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["color"] = "orange",
            ["radius"] = 150
          }
        },
        {
          id = 23,
          name = "",
          type = "",
          shape = "rectangle",
          x = 72,
          y = 232,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["color"] = "orange",
            ["radius"] = 150
          }
        },
        {
          id = 24,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 40,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["color"] = "orange",
            ["radius"] = 150
          }
        },
        {
          id = 25,
          name = "",
          type = "",
          shape = "rectangle",
          x = 168,
          y = 232,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["color"] = "orange",
            ["radius"] = 150
          }
        },
        {
          id = 26,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 232,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["color"] = "orange",
            ["radius"] = 150
          }
        },
        {
          id = 27,
          name = "",
          type = "",
          shape = "rectangle",
          x = 264,
          y = 232,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["color"] = "orange",
            ["radius"] = 150
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "collision",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {
        ["collidable"] = true
      },
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 24,
          y = 16,
          width = 464,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "",
          shape = "rectangle",
          x = 24,
          y = 48,
          width = 8,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 88,
          width = 32,
          height = 24,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 112,
          width = 2,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 6,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 152,
          width = 32,
          height = 8,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 7,
          name = "",
          type = "",
          shape = "rectangle",
          x = 24,
          y = 160,
          width = 8,
          height = 96,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 248,
          width = 456,
          height = 8,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 480,
          y = 48,
          width = 8,
          height = 200,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 6,
      name = "MapChange",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 10,
          name = "",
          type = "",
          shape = "rectangle",
          x = 8,
          y = 112,
          width = 8,
          height = 40,
          rotation = 0,
          visible = true,
          properties = {
            ["key"] = false,
            ["map"] = "map1",
            ["spawn"] = "470, 130"
          }
        }
      }
    }
  }
}
