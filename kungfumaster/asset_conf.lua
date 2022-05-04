local floor_bottom = 0.19
local level_start_duration = 0.5

local asset_conf = {
  screen_width = 800,
  screen_height = 600,
  floor_bottom = floor_bottom,
  spriteSheet = 'assets/sprites.png',
  doorSprite = 'assets/doors.png',
  levelStartDuration = level_start_duration,
  hero = {
    refFrame = {
      pixelwidth = 24,      -- reference pixel width  24 pixel = 1 unit = 1/3 width in viewport dimension
      pixelheight = 56,     -- reference pixel height 56 pixel = 1 unit = 1/12 height in viewport dimension
      height = 1 / 3.2,       -- height in viewport dimension
      width = 1 / 12,       -- width in viewport dimension
    },
    sprites = {
      standing = {
        duration = 1,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 500,
            width = 24,
            height = 56,
          },
        }
      },
      walking = {
        duration = 0.35,
        quads = {
          [1] = {
            pos_x = 72,
            pos_y = 496,
            width = 26,
            height = 60,
          },
          [2] = {
            pos_x = 106,
            pos_y = 493,
            width = 17,
            height = 63,
          },
          [2] = {
            pos_x = 131,
            pos_y = 496,
            width = 27,
            height = 60,
          },
          [3] = {
            pos_x = 166,
            pos_y = 494,
            width = 17,
            height = 62,
          },
        },
      },
      sitting = {
        duration = 1,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 691,
            width = 23,
            height = 40,
          }
        },
      },
      standJumping = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 813,
            width = 15,
            height = 56,
          },
          [2] = {
            pos_x = 39,
            pos_y = 788,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 60,
            pos_y = 784,
            width = 17,
            height = 54,
          },
          [4] = {
            pos_x = 85,
            pos_y = 782,
            width = 17,
            height = 69,
          },
          [5] = {
            pos_x = 110,
            pos_y = 813,
            width = 15,
            height = 56,
          },
        },
      },
      walkJumping = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 937,
            width = 26,
            height = 53,
          },
          [2] = {
            pos_x = 50,
            pos_y = 909,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 71,
            pos_y = 905,
            width = 17,
            height = 54,
          },
          [4] = {
            pos_x = 96,
            pos_y = 903,
            width = 17,
            height = 69,
          },
          [5] = {
            pos_x = 121,
            pos_y = 934,
            width = 15,
            height = 56,
          },
        },
      },
      standPunching = {
        duration = 0.125,
        quads = {
          [1] = {
            pos_x = 52,
            pos_y = 580,
            width = 21,
            height = 62,
          },
          [2] = {
            pos_x = 16,
            pos_y = 581,
            width = 28,
            height = 61,
            hitPoint = {
              pos_x = 39,
              pos_y = 590,
              width = 5,
              height = 6,
            },
          },
          [3] = {
            pos_x = 52,
            pos_y = 580,
            width = 21,
            height = 62,
          },
        },
      },
      standKicking = {
        duration = 0.125,
        quads = {
          [1] = {
            pos_x = 259,
            pos_y = 579,
            width = 29,
            height = 63,
          },
          [2] = {
            pos_x = 296,
            pos_y = 581,
            width = 43,
            height = 61,
            hitPoint = {
              pos_x = 332,
              pos_y = 589,
              width = 7,
              height = 6,
            },
          },
          [3] = {
            pos_x = 259,
            pos_y = 579,
            width = 29,
            height = 63,
          },
        },
      },
      sitPunching = {
        duration = 0.125,
        quads = {
          [1] = {
            pos_x = 108,
            pos_y = 683,
            width = 23,
            height = 48,
          },
          [1] = {
            pos_x = 71,
            pos_y = 683,
            width = 29,
            height = 48,
            hitPoint = {
              pos_x = 94,
              pos_y = 692,
              width = 6,
              height = 6,
            }
          },
          [3] = {
            pos_x = 108,
            pos_y = 683,
            width = 23,
            height = 48,
          },
        },
      },
      sitKicking = {
        duration = 0.125,
        quads = {
          [1] = {
            pos_x = 323,
            pos_y = 688,
            width = 31,
            height = 43,
          },
          [1] = {
            pos_x = 362,
            pos_y = 689,
            width = 49,
            height = 42,
            hitPoint = {
              pos_x = 403,
              pos_y = 724,
              width = 8,
              height = 7,
            }
          },
          [3] = {
            pos_x = 323,
            pos_y = 688,
            width = 31,
            height = 43,
          },
        },
      },
      standJumpKicking = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 363,
            pos_y = 813,
            width = 15,
            height = 56,
          },
          [2] = {
            pos_x = 386,
            pos_y = 788,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 407,
            pos_y = 784,
            width = 17,
            height = 54,
          },
          [4] = {
            pos_x = 432,
            pos_y = 772,
            width = 31,
            height = 68,
            hitPoint = {
              pos_x = 456,
              pos_y = 775,
              --width = 7,
              --height = 10,
              width = 7,
              height = 38,
            },
          },
          [5] = {
            pos_x = 432,
            pos_y = 772,
            width = 31,
            height = 68,
            hitPoint = {
              pos_x = 456,
              pos_y = 775,
              --width = 7,
              --height = 28,
              width = 7,
              height = 38,
            },
          },
          [6] = {
            pos_x = 471,
            pos_y = 782,
            width = 17,
            height = 69,
          },
          [7] = {
            pos_x = 496,
            pos_y = 813,
            width = 15,
            height = 56,
          },
        },
      },
      standJumpPunching = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 157,
            pos_y = 813,
            width = 15,
            height = 56,
          },
          [2] = {
            pos_x = 180,
            pos_y = 788,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 201,
            pos_y = 784,
            width = 17,
            height = 54,
          },
          [4] = {
            pos_x = 226,
            pos_y = 779,
            width = 28,
            height = 61,
            hitPoint = {
              pos_x = 249,
              pos_y = 788,
              width = 5,
              height = 6,
            }
          },
          [5] = {
            pos_x = 262,
            pos_y = 780,
            width = 21,
            height = 62,
          },
          [6] = {
            pos_x = 291,
            pos_y = 782,
            width = 17,
            height = 69,
          },
          [7] = {
            pos_x = 316,
            pos_y = 813,
            width = 15,
            height = 56,
          },
        },
      },
      walkJumpKicking = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 937,
            width = 26,
            height = 53,
          },
          [2] = {
            pos_x = 50,
            pos_y = 909,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 71,
            pos_y = 905,
            width = 17,
            height = 54,
            hitPoint = {
              pos_x = 84,
              pos_y = 905,
              width = 4,
              height = 37,
            }
          },
          [4] = {
            pos_x = 465,
            pos_y = 893,
            width = 31,
            height = 68,
            hitPoint = {
              pos_x = 489,
              pos_y = 896,
              width = 7,
              height = 38,
            }
          },
          [5] = {
            pos_x = 465,
            pos_y = 893,
            width = 31,
            height = 68,
            hitPoint = {
              pos_x = 489,
              pos_y = 896,
              width = 7,
              height = 38,
            }
          },
          [6] = {
            pos_x = 96,
            pos_y = 903,
            width = 17,
            height = 69,
          },
          [7] = {
            pos_x = 121,
            pos_y = 934,
            width = 15,
            height = 56,
          },
        },
      },
      walkJumpPunching = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 937,
            width = 26,
            height = 53,
          },
          [2] = {
            pos_x = 50,
            pos_y = 909,
            width = 13,
            height = 69,
          },
          [3] = {
            pos_x = 71,
            pos_y = 905,
            width = 17,
            height = 54,
          },
          [4] = {
            pos_x = 248,
            pos_y = 901,
            width = 28,
            height = 61,
            hitPoint = {
              pos_x = 271,
              pos_y = 910,
              width = 5,
              height = 6,
            }
          },
          [5] = {
            pos_x = 284,
            pos_y = 898,
            width = 21,
            height = 62,
          },
          [6] = {
            pos_x = 96,
            pos_y = 903,
            width = 17,
            height = 69,
          },
          [7] = {
            pos_x = 121,
            pos_y = 934,
            width = 15,
            height = 56,
          },
        },
      },
      gotHit = {
        duration = 0.2,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 1018,
            width = 20,
            height = 59,
          },
          [2] = {
            pos_x = 68,
            pos_y = 1015,
            width = 13,
            height = 62,
          },
        },
      },
      falling = {
        duration = 1.0,
        quads = {
          [1] = {
            pos_x = 113,
            pos_y = 1018,
            width = 31,
            height = 59,
          },
          [2] = {
            pos_x = 152,
            pos_y = 1029,
            width = 38,
            height = 48,
          },
        },
      },
      stairUp = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 222,
            pos_y = 1015,
            width = 22,
            height = 62,
          },
          [2] = {
            pos_x = 252,
            pos_y = 1016,
            width = 18,
            height = 61,
          },
          [3] = {
            pos_x = 278,
            pos_y = 1016,
            width = 21,
            height = 61,
          },
          [4] = {
            pos_x = 307,
            pos_y = 1016,
            width = 18,
            height = 61,
          },
        },
      },
    },
  },
  crazy88 = {
    refFrame = {
      pixelwidth = 20,
      pixelheight = 58,
      height = 1 / 3.2,
      width = 1 / 12,
    },
    sprites = {
      walking = {
        duration = 0.7,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 16,
            width = 20,
            height = 58,
          },
          [2] = {
            pos_x = 44,
            pos_y = 16,
            width = 11,
            height = 58,
          },
          [3] = {
            pos_x = 63,
            pos_y = 16,
            width = 21,
            height = 58,
          },
          [4] = {
            pos_x = 92,
            pos_y = 16,
            width = 11,
            height = 58,
          },
        },
      },
      approaching = {
        duration = 0.7,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 98,
            width = 20,
            height = 63,
          },
          [2] = {
            pos_x = 44,
            pos_y = 98,
            width = 11,
            height = 63,
          },
          [3] = {
            pos_x = 63,
            pos_y = 98,
            width = 21,
            height = 63,
          },
          [4] = {
            pos_x = 92,
            pos_y = 98,
            width = 11,
            height = 63,
          },
        },
      },
      holding = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 135,
            pos_y = 104,
            width = 22,
            height = 57,
          },
        },
      },
      falling = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 351,
            pos_y = 108,
            width = 37,
            height = 53,
          },
          [2] = {
            pos_x = 396,
            pos_y = 112,
            width = 41,
            height = 49,
          },
        },
      },
      hitTop = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 189,
            pos_y = 102,
            width = 23,
            height = 59,
          },
        },
      },
      hitMiddle = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 244,
            pos_y = 105,
            width = 20,
            height = 56,
          },
        },
      },
      hitBottom = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 296,
            pos_y = 101,
            width = 23,
            height = 60,
          },
        },
      },
    },
  },
  dwarf = {
    refFrame = {
      pixelwidth = 16,
      pixelheight = 43,
      height = 1 / 4.3,
      width = 1 / 12,
    },
    sprites = {
      walking = {
        duration = 0.7,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 189,
            width = 16,
            height = 43,
          },
          [2] = {
            pos_x = 40,
            pos_y = 189,
            width = 11,
            height = 43,
          },
          [3] = {
            pos_x = 59,
            pos_y = 189,
            width = 16,
            height = 43,
          },
          [4] = {
            pos_x = 83,
            pos_y = 189,
            width = 11,
            height = 43,
          },
        },
      },
      holding = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 126,
            pos_y = 192,
            width = 19,
            height = 40,
          },
        },
      },
      falling = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 177,
            pos_y = 196,
            width = 27,
            height = 36,
          },
          [2] = {
            pos_x = 212,
            pos_y = 207,
            width = 31,
            height = 25,
          },
        },
      },
      tumbling = {
        duration = 0.7,
        quads = {
          [1] = {
            pos_x = 275,
            pos_y = 192,
            width = 16,
            height = 40,
          },
          [2] = {
            pos_x = 299,
            pos_y = 185,
            width = 18,
            height = 47,
          },
          [3] = {
            pos_x = 325,
            pos_y = 201,
            width = 19,
            height = 31,
          },
          [4] = {
            pos_x = 352,
            pos_y = 204,
            width = 20,
            height = 28,
          },
          [5] = {
            pos_x = 380,
            pos_y = 201,
            width = 19,
            height = 31,
          },
          [6] = {
            pos_x = 435,
            pos_y = 192,
            width = 16,
            height = 40,
          },
        },
      },
    },
  },
  gogo = {
    refFrame = {
      pixelwidth = 22,
      pixelheight = 59,
      height = 1 / 3.2,
      width = 1 / 12,
    },
    sprites = {
      standing = {
        duration = 0.7,
        quads = {
          [1] = {
            pos_x = 139,
            pos_y = 267,
            width = 22,
            height = 59,
          },
        },
      },
      walking = {
        duration = 0.6,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 267,
            width = 21,
            height = 59,
          },
          [2] = {
            pos_x = 45,
            pos_y = 267,
            width = 12,
            height = 59,
          },
          [3] = {
            pos_x = 65,
            pos_y = 267,
            width = 22,
            height = 59,
          },
          [4] = {
            pos_x = 95,
            pos_y = 267,
            width = 12,
            height = 59,
          },
        },
      },
      throwingHigh = {
        duration = 0.25,
        quads = {
          [1] = {
            pos_x = 193,
            pos_y = 256,
            width = 16,
            height = 70,
          },
          [2] = {
            pos_x = 217,
            pos_y = 267,
            width = 27,
            height = 59,
          },
        },
      },
      throwingLow = {
        duration = 0.25,
        quads = {
          [1] = {
            pos_x = 276,
            pos_y = 275,
            width = 32,
            height = 51,
          },
          [2] = {
            pos_x = 316,
            pos_y = 275,
            width = 32,
            height = 51,
          },
        },
      },
      falling = {
        duration = 0.25,
        quads = {
          [1] = {
            pos_x = 478,
            pos_y = 274,
            width = 45,
            height = 52,
          },
          [2] = {
            pos_x = 531,
            pos_y = 278,
            width = 47,
            height = 48,
          },
        },
      },
      hit1 = {
        duration = 0.10,
        quads = {
          [1] = {
            pos_x = 380,
            pos_y = 268,
            width = 15,
            height = 58,
          },
        },
      },
      hit2 = {
        duration = 0.10,
        quads = {
          [1] = {
            pos_x = 427,
            pos_y = 267,
            width = 19,
            height = 59,
          },
        },
      },
    },
  },
  knife = {
    refFrame = {
      pixelwidth = 12,
      pixelheight = 7,
      height = 1 / 24,
      width = 1 / 24,
    },
    sprites = {
      flying = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 610,
            pos_y = 319,
            width = 12,
            height = 7,
          },
        },
      },
    },
  },
  hitMark = {
    refFrame = {
      pixelwidth = 11,
      pixelheight = 14,
      height = 1 / 13,
      width = 1 / 13,
    },
    sprites = {
      hit = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 534,
            pos_y = 455,
            width = 11,
            height = 14,
          },
        },
      },
    },
  },
  lifeSprite = {
    pos_x = 21,
    pos_y = 500,
    width = 8,
    height = 11,
  },
  doors = {
    left = {
      duration = level_start_duration,
      pos = {
        x = 0,
        y = 1,
        height = 1,
        width = 0.28125,      -- in viewport dimension. (72/1792)*7
      },
      quads = {
        [1] = {
          pos_x = 0,
          pos_y = 0,
          height = 200,
          width = 72,
        },
        [2] = {
          pos_x = 73,
          pos_y = 0,
          height = 200,
          width = 72,
        }
      }
    },
    right = {
      duration = level_start_duration,
      pos = {
        x = 6.69921875,
        y = 1,
        height = 1,
        width =0.30078125 ,      -- in viewport dimension. (77/1792)*7
      },
      quads = {
        [1] = {
          pos_x = 323,
          pos_y = 0,
          height = 200,
          width = 77,
        },
        [2] = {
          pos_x = 245,
          pos_y = 0,
          height = 200,
          width = 77,
        }
      }
    },
  },
  boss1 = {
    refFrame = {
      pixelwidth = 28,
      pixelheight = 64,
      height = 1 / 3,
      width = 1 / 11,
    },
    sprites = {
      standing = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 1201,
            width = 28,
            height = 64,
          }
        }
      },
      walking = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 1201,
            width = 28,
            height = 64,
          },
          [2] = {
            pos_x = 52,
            pos_y = 1201,
            width = 27,
            height = 64,
          },
          [3] = {
            pos_x = 87,
            pos_y = 1201,
            width = 32,
            height = 64,
          },
          [4] = {
            pos_x = 127,
            pos_y = 1201,
            width = 27,
            height = 64,
          },
        },
      },
      standAttackHigh = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 186,
            pos_y = 1188,
            width = 32,
            height = 77,
          },
          [2] = {
            pos_x = 226,
            pos_y = 1202,
            width = 26,
            height = 63,
          },
          [3] = {
            pos_x = 260,
            pos_y = 1201,
            width = 50,
            height = 64,
            hitPoint = {
              pos_x = 292,
              pos_y = 1204,
              width = 18,
              height = 15,
            },
          },
        },
      },
      standAttackMid = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 416,
            pos_y = 1201,
            width = 51,
            height = 64,
          },
          [2] = {
            pos_x = 475,
            pos_y = 1202,
            width = 26,
            height = 63,
          },
          [3] = {
            pos_x = 509,
            pos_y = 1209,
            width = 58,
            height = 56,
            hitPoint = {
              pos_x = 550,
              pos_y = 1221,
              width = 17,
              height = 12,
            },
          },
        },
      },
      sitting = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 1289,
            width = 40,
            height = 56,
          },
        },
      },
      sitAttack = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 88,
            pos_y = 1289,
            width = 40,
            height = 56,
          },
          [2] = {
            pos_x = 136,
            pos_y = 1301,
            width = 29,
            height = 44,
          },
          [3] = {
            pos_x = 173,
            pos_y = 1302,
            width = 56,
            height = 43,
            hitPoint = {
              pos_x = 213,
              pos_y = 1319,
              width = 16,
              height = 8,
            },
          },
        },
      },
      hit1 = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 16,
            pos_y = 1484,
            width = 32,
            height = 69,
          },
        }
      },
      hit2 = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 80,
            pos_y = 1478,
            width = 41,
            height = 75,
          },
        }
      },
      hit3 = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 153,
            pos_y = 1472,
            width = 38,
            height = 81,
          },
        }
      },
      hit4 = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 223,
            pos_y = 1497,
            width = 40,
            height = 56,
          },
        }
      },
      hit5 = {
        duration = 0.1,
        quads = {
          [1] = {
            pos_x = 295,
            pos_y = 1494,
            width = 43,
            height = 59,
          },
        }
      },
      falling = {
        duration = 0.5,
        quads = {
          [1] = {
            pos_x = 365,
            pos_y = 1382,
            width = 30,
            height = 66,
          },
          [2] = {
            pos_x = 403,
            pos_y = 1382,
            width = 39,
            height = 66,
          },
        },
      },
    },
  },
  level = {
    [1] = {
      background = 'assets/floor1_b.png',
      foreground = 'assets/floor1_f.png',
      start = {
        ix = 6.65,
        iy = floor_bottom,
        sx = 6.5,
        sy = floor_bottom,
      },
      forward = true,
      viewport = {
        width = 1.0,
        height = 1.0,
        x = 6.0,
        y = 1.0,
      },
      size = {
        width = 7.0,
        height = 1.0,
      },
      limit = {
        min = 0.15,
        max = 6.85,
      },
      objs = {
        [1] = {
          name = "crazy88",
          config = {
            rate = 1/2,
            max = 10,
            missRate = 0.5,
          },
        },
        [2] = {
          name = "gogo",
          config = {
            max = 1,
            delay = 4,
            missRate = 0.1,
          },
        },
      },
      boss = {
        name = "boss1",
        x = 0.715,
        y = floor_bottom,
      },
    },
    [2] = {
      background = 'assets/floor2_b.png',
      foreground = 'assets/floor2_f.png',
      start = {
        ix = 0.35,
        iy = floor_bottom,
        sx = 0.5,
        sy = floor_bottom,
      },
      door = 'left',
      forward = false,
      viewport = {
        width = 1.0,
        height = 1.0,
        x = 0.0,
        y = 1.0,
      },
      size = {
        width = 7.0,
        height = 1.0,
      },
      limit = {
        min = 0.15,
        max = 6.85,
      },
      objs = {
        [1] = {
          name = "crazy88",
          config = {
            rate = 1/2,
            max = 10,
            missRate = 0.5,
          },
        },
        [2] = {
          name = "gogo",
          config = {
            max = 1,
            delay = 4,
            missRate = 0.1,
          },
        },
      },
    },
    [3] = {
      background = 'assets/floor3_b.png',
      foreground = 'assets/floor3_f.png',
      start = {
        ix = 6.65,
        iy = floor_bottom,
        sx = 6.5,
        sy = floor_bottom,
      },
      door = 'right',
      forward = true,
      viewport = {
        width = 1.0,
        height = 1.0,
        x = 6.0,
        y = 1.0,
      },
      size = {
        width = 7.0,
        height = 1.0,
      },
      limit = {
        min = 0.15,
        max = 6.85,
      },
      objs = {
        [1] = {
          name = "crazy88",
          config = {
            rate = 1/2,
            max = 10,
            missRate = 0.5,
          },
        },
        [2] = {
          name = "gogo",
          config = {
            max = 1,
            delay = 4,
            missRate = 0.1,
          },
        },
      },
    },
    [4] = {
      background = 'assets/floor4_b.png',
      foreground = 'assets/floor4_f.png',
      start = {
        ix = 0.35,
        iy = floor_bottom,
        sx = 0.5,
        sy = floor_bottom,
      },
      door = 'left',
      forward = false,
      viewport = {
        width = 1.0,
        height = 1.0,
        x = 0.0,
        y = 1.0,
      },
      size = {
        width = 7.0,
        height = 1.0,
      },
      limit = {
        min = 0.15,
        max = 6.85,
      },
      objs = {
        [1] = {
          name = "crazy88",
          config = {
            rate = 1/2,
            max = 6,
            missRate = 0.7,
          },
        },
        [2] = {
          name = "gogo",
          config = {
            max = 1,
            delay = 4,
            missRate = 0.1,
          },
        },
      },
    },
    [5] = {
      background = 'assets/floor5_b.png',
      foreground = 'assets/floor5_f.png',
      start = {
        ix = 6.65,
        iy = floor_bottom,
        sx = 6.5,
        sy = floor_bottom,
      },
      door = 'right',
      forward = true,
      viewport = {
        width = 1.0,
        height = 1.0,
        x = 6.0,
        y = 1.0,
      },
      size = {
        width = 7.0,
        height = 1.0,
      },
      limit = {
        min = 0.15,
        max = 6.85,
      },
      objs = {
        [1] = {
          name = "crazy88",
          config = {
            rate = 1/2,
            max = 10,
            missRate = 0.5,
          },
        },
        [2] = {
          name = "gogo",
          config = {
            max = 1,
            delay = 4,
            missRate = 0.1,
          },
        },
      },
    },
  },
}

return asset_conf
