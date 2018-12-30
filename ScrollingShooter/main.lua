debug = true

-- main player
player = { x = 200, y = 710, speed = 150, img = nil }

-- bullet
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil

bullets = {}

gunSound = nil;

-- enemy
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

enemyImg = nil

enemies = {}

score = 0
isAlive = true

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function handle_collision()
  for i, enemy in ipairs(enemies) do
	  for j, bullet in ipairs(bullets) do
		  if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
			  table.remove(bullets, j)
			  table.remove(enemies, i)
			  score = score + 1
      end
		end

	  if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) and isAlive then
		  table.remove(enemies, i)
		  isAlive = false
	  end
  end
end

function update_player(dt)
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end

  if love.keyboard.isDown('left', 'a') then
    if player.x > 0 then
      player.x = player.x - (player.speed * dt)
    end
  elseif love.keyboard.isDown('right', 'd') then
    if player.x < (love.graphics:getWidth() - player.img:getWidth()) then
      player.x = player.x + (player.speed * dt)
    end
  end
end

function update_bullets(dt)
  canShootTimer = canShootTimer - (1 * dt)
  if canShootTimer < 0 then
    canShoot= true
  end

  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y - (250 * dt)
    if bullet.y < 0 then
      table.remove(bullets, i)
    end
  end

  if love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot then
    newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg }
    table.insert(bullets, newBullet)
    canShoot = false
    canShootTimer = canShootTimerMax
    gunSound:play()
  end
end

function spawn_enemy(dt)
  createEnemyTimer = createEnemyTimer - ( 1 * dt)
  if createEnemyTimer < 0 then
    createEnemyTimer = createEnemyTimerMax

    randomNumber = math.random(10, love.graphics:getWidth() - 10)
    newEnemy = { x = randomNumber, y = -10, img = enemyImg }

    table.insert(enemies, newEnemy)
  end
end

function update_enemies(dt)
  for i, enemy in ipairs(enemies) do
    enemy.y = enemy.y + (200 * dt)
    if enemy.y > 850 then
      table.remove(enemies, i)
    end
  end
end

function handle_game_start()
  if not isAlive and love.keyboard.isDown('r') then
    bullets = {}
    enemies = {}

    canShootTimer = canShootTimerMax
    createEnemyTimer = createEnemyTimerMax

    player.x = 50
    player.y = 710

    score = 0
    isAlive = true
  end
end

function love.load(arg)
  player.img = love.graphics.newImage('assets/plane.png')
  bulletImg = love.graphics.newImage('assets/bullet.png')
  enemyImg = love.graphics.newImage('assets/enemy.png')
  gunSound = love.audio.newSource("assets/gun-sound.wav", "static");
end

function love.update(dt)
  update_player(dt)
  update_bullets(dt)
  spawn_enemy(dt)
  update_enemies(dt)
  handle_collision()

  handle_game_start()
end

function draw_player(dt)
  love.graphics.draw(player.img, player.x, player.y)
end

function draw_bullets(dt)
  for i, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
  end
end

function draw_enemies(dt)
  for i, enemy in ipairs(enemies) do
    love.graphics.draw(enemy.img, enemy.x, enemy.y)
  end
end

function love.draw(dt)
  if isAlive then
    draw_player(dt)
    draw_bullets(dt)
    draw_enemies(dt)

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("SCORE: " .. tostring(score), 400, 10)
  else
    love.graphics.print("Press 'R' to restart", love.graphics:getWidth() / 2 - 50, love.graphics:getHeight()/2 - 10)
  end
end
