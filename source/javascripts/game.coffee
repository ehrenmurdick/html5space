class Planet
  constructor: (name, x, y, radius) ->
    @container = $('<div/>')
    left = x
    top = y
    @x = x + (radius / 2)
    @y = y + (radius / 2)

    @menu =$('#prototype .planet-menu').clone()

    @container.css
      position: 'absolute'
      left: left
      top: top
      width: radius
      height: radius
      backgroundImage: "url(/images/planets/#{name}.png)"
      backgroundSize: "cover"
      cursor: 'pointer'

    @a = $("<a>#{name}</a>")
    @a.attr('href', '#')
    $('#map').append(@a)

    @a.click @scrollTo

    $('#space').append(@container)
    @container.click(@showMenu)

  scrollTo: (e) =>
    e.preventDefault()
    $('body').stop().animate
      scrollLeft: @x - ($(window).width()/2)
      scrollTop: @y - ($(window).height()/2)
    ,
      duration: 2e3
      easing: "easeInOutQuad"

  showMenu: (e) =>
    $('body').append(@menu)
    @menu.fadeToggle()
      
    
class Ship
  traverse: (start, finish) ->
    dx = finish.x - start.x
    dy = finish.y - start.y
    angle = Math.atan(dy/dx)
    angle += Math.PI/2
    angle += Math.PI if dx < 0

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

  constructor: (start, finish) ->
    @traverse(start, finish)

$ ->
  a = new Planet("planet2", 800, 100, 500)
  b = new Planet("planet1", 15000, 7000, 200)
  c = new Planet("planet3", 7000, 15000, 400)
  d = new Planet("planet4", 15000, 16000, 400)
  e = new Planet("planet4", 3000, 16000, 400)

  ship = new Ship(c, b)
  ship = new Ship(c, a)
  ship = new Ship(c, d)
  ship = new Ship(c, e)
