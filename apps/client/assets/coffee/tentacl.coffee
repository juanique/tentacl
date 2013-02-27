getPrecisionHeight = (el) ->
  return parseFloat(getComputedStyle(el).height)


getPrecisionWidth = (el) ->
  return parseFloat(getComputedStyle(el).width)


class TentaclView extends Backbone.View

  render: ->
    if @className
      $(@el).addClass(@className)
    return @el


class window.Tentacl

  constructor: ->
    @screen = new Screen(el: $("#TentaclContent")[0])
    @screen.render()


class window.Screen extends TentaclView

  constructor: (args={}) ->
    super(args)
    @mainPane = new LayoutPane()

  render: ->
    $(@el).empty()
    $(@mainPane.render()).appendTo(@el).addClass('tentacl-main-pane')
    @mainPane.onNodeInserted()


class window.Pane extends TentaclView
  constructor: () ->
    super(el: document.createElement('div'))

    @ownElement = @el


class window.LayoutPane extends Pane

  className: 'tentacl-layout-pane'

  constructor: (args={}) ->
    """
    @param child {ContentPane} The base child for this Pane,
        defaults to a new ContenPane
    @param contentDisposition {'VERTICAL'|'HORIZONTAL'} default 'VERTICAL'
    """
    args.child or= new ContentPane()
    args.contentDisposition or= 'VERTICAL'

    args.child.on "split", (dir) =>
      @split(contentDisposition:dir)

    super(args)

    @setContentDisposition(args.contentDisposition, render: false)
    @children = [args.child]
    @currentFocus = args.child

  toString: ->
    return "<LayoutPane panes:#{@panes.length}>"

  setContentDisposition: (contentDisposition, args={}) ->
    """Changes the content disposition of the childnodes of the pane
    it triggers a rerender if necessary unless `render: false` is given.
    @param render {boolean}
    """

    args.render = if args.render == false then false else true

    if @contentDisposition isnt contentDisposition and args.render
      @contentDisposition = contentDisposition
      @render()
    else
      @contentDisposition = contentDisposition

  focus: (args={}) ->
    """Focuses the current pane which ultimately results on the focus
    of a descendant ContentPane.
    @param pane {Pane|'NEXT'} optional pane to switch the focus to.
    """

    currentIndex = @children.indexOf(@currentFocus)

    if args.pane instanceof Pane
      @currentFocus = args.pane
    else
      switch  args.pane
        when 'NEXT'
          newIndex = (currentIndex + 1) % @children.length
          @currentFocus = @children[newIndex]
        when 'PREV'
          newIndex = (@children.length + currentIndex - 1) % @children.length
          @currentFocus = @children[newIndex]

    @currentFocus.focus()

  split: (args={}) ->
    """
    Adds a new children to the pane, spliting the view.
    @param {'VERTICAL','HORIZONTAL'} optional param to change content disposition
    @return {LayoutPane} The new child pane.
    """

    if args.contentDisposition
      @setContentDisposition(args.contentDisposition, render: false)

    newChild = new LayoutPane()

    if @children.length == 1
      oldChild = @children[0]
      oldChild.off("split")
      wrapper = new LayoutPane(child: oldChild)
      @children = [wrapper, newChild]
      @currentFocus = wrapper
    else
      @children.push newChild

    @render()

    return newChild

  render: ->
    super()
    $(@el).empty()

    inDOM = $.contains(document.documentElement, @el)

    for child in @children
      $(@el).toggleClass('tentacl-horizontal', @contentDisposition=='HORIZONTAL')
      $(@el).toggleClass('tentacl-vertical', @contentDisposition=='VERTICAL')

      $(child.render()).appendTo(@el)

      if inDOM
        @resizeChild_(child)
        child.onNodeInserted()


    return @el

  onNodeInserted: ->
    for child in @children
      @resizeChild_(child)
      child.onNodeInserted()

  resizeChild_: (child) ->
    h = getPrecisionHeight(@el)
    w = getPrecisionWidth(@el)

    if @contentDisposition == 'HORIZONTAL'
      child.el.style.height = h + 'px'
      child.el.style.width = (w / @children.length) + 'px'
    else
      child.el.style.width = w + 'px'
      child.el.style.height = (h / @children.length) + 'px'


class window.ContentPane extends Pane
  className: 'tentacl-content-pane'

  constructor: ->
    super(el: document.createElement('div'))

  toString: ->
    return "<ContentPane>"

  render: ->
    @el = super()
    $(@el).empty()

    @ta = document.createElement('textarea')
    $(@ta).appendTo(@el)

    return @el

  onNodeInserted: ->
    @cm = CodeMirror.fromTextArea @ta,
      lineNumbers: true
      lineWrapping: true
      mode: "text/x-csrc"
      keyMap: "vim"
      showCursorWhenSelecting: true

    $cm = $('.CodeMirror', @el)

    # TODO - find a way to avoid the scrollbar appearing where it shouldn't!
    $cm.find('.CodeMirror-hscrollbar').remove()
    $cm.find('.CodeMirror-vscrollbar').remove()


    @cm.on "split", (direction) =>
      @trigger("split", direction)

  setValue: (value) ->
    @cm.setValue(value)

  focus: ->
    @cm.focus()
