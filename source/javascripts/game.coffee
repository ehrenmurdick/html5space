class Game
  guid: ->
    (((1+Math.random())*0x10000)|0).toString(16).substring(1)

  constructor: ->
    window.game = this
    @menus = []
    @planets = {}
    planets = [
      new Planet("planet2", 5000, 14500, 500),
      new Planet("planet3", 7000, 15000, 400),
    ]
    planets[1].addShip(new Ship("Hood"))
    planets[1].addShip(new Ship("Reliant"))

    for p in planets
      @addPlanet(p)


  addPlanet: (planet) ->
    @planets[planet.id] = planet

  clearMenu: ->
    $('.menu:visible').fadeOut()
    @menus = []

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
    
$ ->
  new Game()
