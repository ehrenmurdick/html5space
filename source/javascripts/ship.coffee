class window.Ship
  constructor: (name) ->
    @id = window.game.guid()
    @name = name

  traverse: (finish) ->
    finish = window.game.planets[finish]
    start = @planet
    dx = finish.x - start.x
    dy = finish.y - start.y
    angle = Math.atan(dy/dx)
    angle += Math.PI/2
    angle += Math.PI if dx < 0

    @planet.removeShip(this)

    dist = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))

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
      duration: dist
      easing: "easeInOutQuad"
      complete: =>
        finish.addShip(this)
        @el.remove()

  destinations: ->
    v for k,v of window.game.planets