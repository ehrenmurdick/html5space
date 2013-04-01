class window.Planet
  constructor: (name, x, y, radius) ->
    @id = window.game.guid()
    @x = x
    @y = y
    @radius = radius
    @name = name
    @showPlanet()
    @ships = {}

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

    menu = new Menu(this, "planet-menu")
    @container.click ->
      window.game.pushMenu(menu)

  scrollTo: (e) =>
    window.game.clearMenu()
    e.preventDefault()
    $('body').stop().animate
      scrollLeft: @x - ($(window).width()/2)
      scrollTop: @y - ($(window).height()/2)
    ,
      duration: 2e3
      easing: "easeInOutQuad"
      
