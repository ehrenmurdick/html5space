class window.Menu
  constructor: (obj, name) ->
    @object = obj
    @id = window.game.guid()
    @menu =$("#prototype .#{name}").clone()
    @template = @menu.html()
    $('body').append(@menu)
    @name = name


  showMenu: (e) =>
    output = Mustache.render(@template, @object)
    ship = this
    object = @object
    @menu.html(output)

    @menu.find(".next").each ->
      $(this).click (e) ->
        e.preventDefault()
        $this = $(this)
        next = $this.data("next")
        id = $this.data("id")
        obj = object[$this.data("collection")][id]
        menu = new Menu(obj, next)
        window.game.pushMenu(menu)

    @menu.find(".action").each ->
      $(this).click (e) ->
        e.preventDefault()
        $this = $(this)
        action = $this.data("action")
        argument = $this.data("argument")
        object[action](argument)

    @menu.find(".close").click(-> window.game.popMenu())
    @menu.fadeIn()


  hideMenu: (e) =>
    @menu.fadeOut()
