class window.Ship
  @distance: (start, finish) ->
    dx = finish.x - start.x
    dy = finish.y - start.y
    Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))

  @timeForDistance: (distance, acceleration) ->
    (Math.sqrt(2 * distance) / acceleration) * 2

  @flightDuration: (start, finish, acceleration) ->
    @timeForDistance(@distance(start, finish), acceleration)

  @angle: (a, b) ->
    dx = b.x - a.x
    dy = b.y - a.y
    angle = Math.atan(dy/dx)
    angle += Math.PI/2
    angle += Math.PI if dx < 0
    angle


  constructor: (name) ->
    @id = window.game.guid()
    @name = name
    @acceleration = 0.025

  patrol: (finish) ->
    finish = window.game.planets[finish]
    start = @planet
    angle = Ship.angle(start, finish)

    @planet.removeShip(this)

    time = Ship.flightDuration(start, finish, @acceleration)

    @el = $('<div/>')
    @el.css
      backgroundImage: "url(/images/ship.png)"
      position: 'absolute'
      left: start.x
      top: start.y
      width: 32
      height: 48
      zIndex: 999
      rotate: angle

    $('#space').append(@el)

    patrol = (start, finish) =>
      f =
        x: finish.x + (Math.random()*500-250)
        y: finish.y + (Math.random()*500-250)

      s =
        x: parseInt(@el.css("left"))
        y: parseInt(@el.css("top"))

      time = Ship.flightDuration(s, f, @acceleration)

      angle = Ship.angle(s, f)
      
      @el.animate
        rotate: angle
      ,
        complete: =>
          @el.animate
            left: f.x
            top: f.y
          ,
            duration: time
            easing: "easeInOutQuad"
            complete: =>
              patrol(finish, start)
              # @el.remove()
    patrol(start, finish)

  transfer: (finish) ->
    finish = window.game.planets[finish]
    start = @planet
    
    angle = Ship.angle(start, finish)

    @planet.removeShip(this)

    time = Ship.timeForDistance(start, finish, @acceleration)

    @el = $('<div/>')
    @el.css
      backgroundImage: "url(/images/ship.png)"
      position: 'absolute'
      left: start.x
      top: start.y
      width: 32
      height: 48
      zIndex: 999
      WebkitTransform: "rotate(#{angle}rad)"

    $('#space').append(@el)

    @el.animate
      left: finish.x
      top: finish.y
    ,
      duration: time
      easing: "easeInOutQuad"
      complete: =>
        finish.addShip(this)
        @el.remove()
  

  destinations: ->
    v for k,v of window.game.planets
