class window.Menu
  constructor: (obj, name) ->
    @object = obj
    @name = name


  showMenu: (e) =>
    $.get "/menus/#{@name}.html", (data) =>
      @menu = $(Mustache.render(data, @object))
      $('body').append(@menu)
      @bindChildren()
      @bindActions()

      @menu.find(".close").click(-> window.game.popMenu())
      @menu.fadeIn()


  hideMenu: (e) =>
    @menu.fadeOut()

  bindActions: ->
    object = @object
    @menu.find(".action").each ->
      $(this).click (e) ->
        e.preventDefault()
        $this = $(this)
        action = $this.data("action")
        argument = $this.data("argument")
        object[action](argument)
        window.game.popMenu()


  bindChildren: ->
    object = @object
    @menu.find(".next").each ->
      $(this).click (e) ->
        e.preventDefault()
        $this = $(this)
        next = $this.data("next")
        id = $this.data("id")
        obj = object[$this.data("collection")][id]
        menu = new Menu(obj, next)
        window.game.pushMenu(menu)
