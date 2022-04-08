local asset_conf = {
  spriteSheet = love.graphics.newImage('assets/sprites.png'),
  hero = {
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
        duration = 0.5,
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
    },
  },
}

return asset_conf
