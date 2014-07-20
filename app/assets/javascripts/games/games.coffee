# http://paulirish.com/2011/requestanimationframe-for-smart-animating
# shim layer with setTimeout fallback
window.requestAnimFrame = (->
  window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) ->
    window.setTimeout callback, 1000 / 60
    return
)()

# namespace our game
POP =

  # set up some initial values
  WIDTH: 320
  HEIGHT: 480
  scale: 1

  # the position of the canvas in relation to the screen
  offset:
    top: 0
    left: 0

  entities: []

  # the amount of game ticks until we spawn a bubble
  nextBubble: 100

  # track player progress
  score:
    taps: 0
    hit: 0
    escaped: 0
    accuracy: 0


  # we'll set the rest of these in the init function
  RATIO: null
  currentWidth: null
  currentHeight: null
  canvas: null
  ctx: null
  init: ->

    # the proportion of width to height
    POP.RATIO = POP.WIDTH / POP.HEIGHT

    # these will change when the screen is resized
    POP.currentWidth = POP.WIDTH
    POP.currentHeight = POP.HEIGHT

    # this is our canvas element
    POP.canvas = document.getElementsByTagName("canvas")[0]

    # setting this is important, otherwise the browser will default to
    # 320 x 200
    POP.canvas.width = POP.WIDTH
    POP.canvas.height = POP.HEIGHT

    # the canvas context enables us to interact with the canvas api
    POP.ctx = POP.canvas.getContext("2d")

    # we need to sniff out Android and iOS
    # so that we can hide the address bar in our resize function
    POP.ua = navigator.userAgent
    POP.android = (if POP.ua.indexOf("Android") > -1 then true else false)
    POP.ios = (if (POP.ua.indexOf("iPhone") > -1 or POP.ua.indexOf("iPad") > -1) then true else false)

    # set up wave effect; basically, a series of overlapping circles across the
    # top of screen
    POP.wave =
      x: -25 # x coordinate of first circle
      y: -40 # y coordinate of first circle
      r: 50 # circle radius
      time: 0 # we'll use this in calculating the sine wave
      offset: 0 # this will be the sine wave offset


    # calculate how many circles we need to cover the screen's width
    POP.wave.total = Math.ceil(POP.WIDTH / POP.wave.r) + 1

    # listen for clicks
    window.addEventListener "click", ((e) ->
      e.preventDefault()
      POP.Input.set e
      return
    ), false

    # listen for touches
    window.addEventListener "touchstart", ((e) ->
      e.preventDefault()

      # the event object has any array named touches; we just want the
      # first touch
      POP.Input.set e.touches[0]
      return
    ), false
    window.addEventListener "touchmove", ((e) ->

      # we're not interested in this, but prevent default behaviour so the
      # screen doesn't scroll or zoom
      e.preventDefault()
      return
    ), false
    window.addEventListener "touched", ((e) ->

      # as above
      e.preventDefault()
      return
    ), false

    # we're ready to resize
    POP.resize()

    # it will then repeat continuously
    POP.loop()
    return

  resize: ->
    POP.currentHeight = window.innerHeight

    # resize the width in propotion to the new height
    POP.currentWidth = POP.currentHeight * POP.RATIO

    # this will create some extra space on the page, allowing us to
    # scroll past the address bar, thus hiding it
    document.body.style.height = (window.innerHeight + 50) + "px"  if POP.android or POP.ios

    # set the new canvas style width and height
    # note: our canvas is still 320 x 480, but we're essentially scaling
    # it with CSS
    POP.canvas.style.width = POP.currentWidth + "px"
    POP.canvas.style.height = POP.currentHeight + "px"
    POP.scale = POP.currentWidth / POP.WIDTH
    POP.offset.top = POP.canvas.offsetTop
    POP.offset.left = POP.canvas.offsetLeft

    # we use a timeout here because some mobile browser don't fire if
    # there is not a short delay
    window.setTimeout (->
      window.scrollTo 0, 1
      return
    ), 1
    return


  # this is where all entities will be moved and checked for collisions, etc
  update: ->
    i = undefined

    # only need to check for a collision if the user tapped on this game tick
    checkCollision = false

    # decrease our nextBubble counter
    POP.nextBubble -= 1

    # if the counter is less than zero
    if POP.nextBubble < 0

      # put a new instance of bubble into our entities array
      POP.entities.push new POP.Bubble()

      # reset the counter with a random value
      POP.nextBubble = (Math.random() * 100) + 100

    # spawn a new instance of Touch if the user has tapped the screen
    if POP.Input.tapped

      # keep track of taps; needed to calculate accuracy
      POP.score.taps += 1

      # add a new touch
      POP.entities.push new POP.Touch(POP.Input.x, POP.Input.y)

      # set tapped back to false to avoid spawning a new touch in the
      # next cycle
      POP.Input.tapped = false
      checkCollision = true

    # cycle through all entities and update as necessary
    i = 0
    while i < POP.entities.length
      POP.entities[i].update()
      if POP.entities[i].type is "bubble" and checkCollision
        hit = POP.collides(POP.entities[i],
          x: POP.Input.x
          y: POP.Input.y
          r: 7
        )
        if hit

          # spawn an explosion
          n = 0

          while n < 5

            # random opacity to spice it up a bit
            POP.entities.push new POP.Particle(POP.entities[i].x, POP.entities[i].y, 2, "rgba(255,255,255," + Math.random() * 1 + ")")
            n += 1
          POP.score.hit += 1
        POP.entities[i].remove = hit

      # delete from array if remove property flag is set to true
      POP.entities.splice i, 1  if POP.entities[i].remove
      i += 1

    # update wave offset, feel free to play with these values for either
    # slower or faster waves
    POP.wave.time = new Date().getTime() * 0.002
    POP.wave.offset = Math.sin(POP.wave.time * 0.8) * 5

    # calculate accuracy
    POP.score.accuracy = (POP.score.hit / POP.score.taps) * 100
    POP.score.accuracy = (if isNaN(POP.score.accuracy) then 0 else ~~(POP.score.accuracy)) # a handy way to round floats
    return


  # this is where we draw all the entities
  render: ->
    i = undefined
    POP.Draw.rect 0, 0, POP.WIDTH, POP.HEIGHT, "#036"

    # display snazzy wave effect
    i = 0
    while i < POP.wave.total
      POP.Draw.circle POP.wave.x + POP.wave.offset + (i * POP.wave.r), POP.wave.y, POP.wave.r, "#fff"
      i++

    # cycle through all entities and render to canvas
    i = 0
    while i < POP.entities.length
      POP.entities[i].render()
      i += 1

    # display scores
    POP.Draw.text "Hit: " + POP.score.hit, 20, 30, 14, "#fff"
    POP.Draw.text "Escaped: " + POP.score.escaped, 20, 50, 14, "#fff"
    POP.Draw.text "Accuracy: " + POP.score.accuracy, 20, 70, 14, "#fff"
    return


  # the actual loop requests the animation frame, then proceeds to update and
  # render
  loop: ->
    requestAnimFrame POP.loop
    POP.update()
    POP.render()
    return


# checks if two circles overlap
POP.collides = (a, b) ->
  distance_squared = (((a.x - b.x) * (a.x - b.x)) + ((a.y - b.y) * (a.y - b.y)))
  radii_squared = (a.r + b.r) * (a.r + b.r)
  if distance_squared < radii_squared
    true
  else
    false


# abstracts various canvas operations into standalone functions
POP.Draw =
  clear: ->
    POP.ctx.clearRect 0, 0, POP.WIDTH, POP.HEIGHT
    return

  rect: (x, y, w, h, col) ->
    POP.ctx.fillStyle = col
    POP.ctx.fillRect x, y, w, h
    return

  circle: (x, y, r, col) ->
    POP.ctx.fillStyle = col
    POP.ctx.beginPath()
    POP.ctx.arc x + 5, y + 5, r, 0, Math.PI * 2, true
    POP.ctx.closePath()
    POP.ctx.fill()
    return

  text: (string, x, y, size, col) ->
    POP.ctx.font = "bold " + size + "px Monospace"
    POP.ctx.fillStyle = col
    POP.ctx.fillText string, x, y
    return

POP.Input =
  x: 0
  y: 0
  tapped: false
  set: (data) ->
    @x = (data.pageX - POP.offset.left) / POP.scale
    @y = (data.pageY - POP.offset.top) / POP.scale
    @tapped = true
    return

POP.Touch = (x, y) ->
  @type = "touch" # we'll need this later
  @x = x # the x coordinate
  @y = y # the y coordinate
  @r = 5 # the radius
  @opacity = 1 # initial opacity; the dot will fade out
  @fade = 0.05 # amount by which to fade on each game tick
  @remove = false # flag for removing this entity, POP.update will take
  # care of this
  @update = ->

    # reduce the opacity accordingly
    @opacity -= @fade

    # if opacity if 0 or less, flag for removal
    @remove = (if (@opacity < 0) then true else false)
    return

  @render = ->
    POP.Draw.circle @x, @y, @r, "rgba(255,0,0," + @opacity + ")"
    return

  return

POP.Bubble = ->
  @type = "bubble"
  @r = (Math.random() * 20) + 10 # the radius of the bubble
  @speed = (Math.random() * 3) + 1
  @x = (Math.random() * (POP.WIDTH) - @r)
  @y = POP.HEIGHT + (Math.random() * 100) + 100 # make sure it starts off screen

  # the amount by which the bubble will move from side to side
  @waveSize = 5 + @r

  # we need to remember the original x position for our sine wave calculation
  @xConstant = @x
  @remove = false
  @update = ->

    # a sine wave is commonly a function of time
    time = new Date().getTime() * 0.002
    @y -= @speed

    # the x coordinate to follow a sine wave
    @x = @waveSize * Math.sin(time) + @xConstant

    # if off screen, flag for removal
    if @y < -10
      POP.score.escaped += 1 # update score
      @remove = true
    return

  @render = ->
    POP.Draw.circle @x, @y, @r, "rgba(255,255,255,1)"
    return

  return

POP.Particle = (x, y, r, col) ->
  @x = x
  @y = y
  @r = r
  @col = col

  # determines whether particle will travel to the right or left
  # 50% chance of either happening
  @dir = (if (Math.random() * 2 > 1) then 1 else -1)

  # random values so particles do not travel at the same speeds
  @vx = ~~(Math.random() * 4) * @dir
  @vy = ~~(Math.random() * 7)
  @remove = false
  @update = ->

    # update coordinates
    @x += @vx
    @y += @vy

    # increase velocity so particle accelerates off screen
    @vx *= 0.99
    @vy *= 0.99

    # adding this negative amount to the y velocity exerts an upward pull on
    # the particle, as if drawn to the surface
    @vy -= 0.25

    # off screen
    @remove = true  if @y < 0
    return

  @render = ->
    POP.Draw.circle @x, @y, @r, @col
    return

  return

window.addEventListener "load", POP.init, false
window.addEventListener "resize", POP.resize, false
