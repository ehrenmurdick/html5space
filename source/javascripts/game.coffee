class Game
  guid: ->
    (((1+Math.random())*0x10000)|0).toString(16).substring(1)

  constructor: ->
    window.game = this
    @menus = []
    @planets = {}
    planets = [
      new Planet("planet2", 800, 100, 500),
      new Planet("planet1", 15000, 7000, 200),
      new Planet("planet3", 7000, 15000, 400),
      new Planet("planet4", 15000, 16000, 400),
      new Planet("planet4", 3000, 16000, 400)
    ]
    planets[2].addShip(new Ship("Hood"))

    for p in planets
      @addPlanet(p)


  addPlanet: (planet) ->
    @planets[planet.id] = planet

  pushMenu: (menu) ->
    if @currentMenu()
      if menu == @currentMenu()
        return
      @currentMenu().hideMenu()
    @menus.push(menu)
    menu.showMenu()

  currentMenu: ->
    @menus[@menus.length - 1]

  popMenu: ->
    menu = @menus.pop()
    if menu
      menu.hideMenu()

    menu = @currentMenu()
    if menu
      menu.showMenu()
    

class Planet
  constructor: (name, x, y, radius) ->
    @id = window.game.guid()
    @x = x
    @y = y
    @radius = radius
    @name = name
    @showPlanet()
    @ships = {}
    @buildMenu()

  hangar: ->
    v for k,v of @ships

  addShip: (ship) ->
    ship.planet = this
    @ships[ship.id] = ship

  removeShip: (ship) ->
    delete @ships[ship.id]

  showPlanet: ->
    @container = $('<div/>')
    @left = @x
    @top = @y
    @x = @left + (@radius / 2)
    @y = @top + (@radius / 2)


    @container.css
      position: 'absolute'
      left: @left
      top: @top
      width: @radius
      height: @radius
      backgroundImage: "url(/images/planets/#{@name}.png)"
      backgroundSize: "cover"
      cursor: 'pointer'

    @a = $("<a>#{@name}</a>")
    @a.attr('href', '#')
    $('#map').append(@a)

    @a.click @scrollTo

    $('#space').append(@container)
    planet = this
    @container.click ->
      window.game.pushMenu(planet)

  buildMenu: ->
    @menu =$('#prototype .planet-menu').clone()
    @template = @menu.html()
    $('body').append(@menu)

  scrollTo: (e) =>
    window.game.popMenu()
    e.preventDefault()
    $('body').stop().animate
      scrollLeft: @x - ($(window).width()/2)
      scrollTop: @y - ($(window).height()/2)
    ,
      duration: 2e3
      easing: "easeInOutQuad"

  showMenu: (e) =>
    output = Mustache.render(@template, this)
    ships = @ships
    @menu.html(output)
    @menu.find(".close").click( ->
      window.game.popMenu()
    )
    @menu.fadeIn()
    @menu.find('.ship').each ->
      $(this).click ->
        $this = $(this)
        id = $this.data('id')
        ship = ships[id]
        window.game.pushMenu(ship)

  hideMenu: (e) =>
    @menu.fadeOut()
      
    
class Ship
  constructor: (name) ->
    @id = window.game.guid()
    @menu =$('#prototype .ship-menu').clone()
    @template = @menu.html()
    $('body').append(@menu)
    @name = name

  traverse: (finish) ->
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


  showMenu: (e) =>
    output = Mustache.render(@template, this)
    ship = this
    @menu.html(output)
    @menu.find(".close").click(-> window.game.popMenu())
    @menu.find(".destinations a").each ->
      $(this).click (e) ->
        e.preventDefault()
        $this = $(this)
        planet = window.game.planets[$this.data('id')]
        ship.traverse(planet)
        window.game.popMenu()
    @menu.fadeIn()

  destinations: ->
    v for k,v of window.game.planets

  hideMenu: (e) =>
    @menu.fadeOut()

$ ->
  new Game()
