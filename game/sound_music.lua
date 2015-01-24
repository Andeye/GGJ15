SoundMusic = {
  sounds = {},
  currPanicIndex = 1,
  currAwkwardIndex = 1,
  isPlayMusic = false
}

local MUSIC_VOLUME = 0.2

function SoundMusic:load()
  self.sounds[1] = {}
  
  self.sounds[1][1] = love.audio.newSource("assets/sounds/music/bossanova-test-1.mp3", "static")
  self.sounds[1][2] = love.audio.newSource("assets/sounds/music/bossanova-test-2.mp3", "static")
  self.sounds[1][3] = love.audio.newSource("assets/sounds/music/bossanova-test-3.mp3", "static")
  self.sounds[1][4] = love.audio.newSource("assets/sounds/music/bossanova-test-4.mp3", "static")
  
  for i = 1, #self.sounds do
    for j = 1, #self.sounds[i] do
      self.sounds[i][j]:setVolume(MUSIC_VOLUME)
    end
  end
end


--function SoundMusic:play(key)
--  if self.sounds[key] then
--    self.sounds[key]:play()
--  end
--end


local function getIndex(value, maxValue, arrayLen)
  local index = math.floor(value / maxValue * arrayLen) + 1
  if index > arrayLen then
    index = arrayLen
  end
  return index
end

local function getIndices(self, roomPanic, roomAwkwardness)
  local panicIndex = getIndex(roomPanic, 100, #self.sounds)
  local awkwardIndex = getIndex(roomAwkwardness, 100, #self.sounds[1])

  return panicIndex, awkwardIndex
end


function SoundMusic:update(dt, roomPanic, roomAwkwardness)
  
  local panicIndex, awkwardIndex = getIndices(self, roomPanic, roomAwkwardness)
  if panicIndex ~= self.currPanicIndex or awkwardIndex ~= self.currAwkwardIndex 
    and self.sounds[self.currPanicIndex][self.currAwkwardIndex]:isLooping()
  then
    self.sounds[self.currPanicIndex][self.currAwkwardIndex]:setLooping(false)
  end
  
  dbg:msg("panicIndex", panicIndex)
  dbg:msg("awkwardIndex", awkwardIndex)
  
  if self.isPlayMusic and not self.sounds[self.currPanicIndex][self.currAwkwardIndex]:isPlaying() then
    self.currPanicIndex, self.currAwkwardIndex = panicIndex, awkwardIndex
    self.sounds[self.currPanicIndex][self.currAwkwardIndex]:play()
    self.sounds[self.currPanicIndex][self.currAwkwardIndex]:setLooping(true)
  end
  
end


---
-- value should be in the interval [0, 1]
function SoundMusic:setVolume(value)
    self.sounds[self.currPanicIndex][self.currAwkwardIndex]:setVolume(value)
end


return SoundMusic
