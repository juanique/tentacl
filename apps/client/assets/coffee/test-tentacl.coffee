console.log "test-tentacl.coffee loaded"

describe "The test framework", ->
  it "should work", ->
    expect(true).toBe(true)


describe "toExistInDocument", ->
  it "matches when it should", ->
    div = $('<div/>').appendTo(document.body)[0]
    expect(div).toExistInDocument()
    $(div).remove()

  it "doesn't match when it shouldn't", ->
    div = $('<div/>')[0]
    expect(div).not.toExistInDocument()
    $(div).remove()

describe "toHaveCssClass", ->
  div = $('<div class="warning important"/>')[0]

  it "matches when it should", ->
    expect(div).toHaveCssClass('important')
    expect(div).toHaveCssClass('warning')
    expect(div).toHaveCssClass('warning', 'important')

  it "Doesnt match when it shouldn't", ->
    expect(div).not.toHaveCssClass('safe')
    expect(div).not.toHaveCssClass('warning', 'garbage')

describe "toBeNear", ->
  it "matches when it should", ->
    expect(5).toBeNear(6)
    expect(10).toBeNear(15, 5)

  it "doesn't match when it shouldn't", ->
    expect(5).not.toBeNear(7)
    expect(10).not.toBeNear(2, 3)


describe "toHaveChildrenWithClass", ->
  div = $('<div><div class="a"/><div class="b"/><div class="a"/></div>')[0]

  it "matches when it should", ->
    expect(div).toHaveChildrenWithClass("a")
    expect(div).toHaveChildrenWithClass("b")
    expect(div).toHaveChildrenWithClass("a", 2)

  it "Doesnt match when it shouldn't", ->
    expect(div).not.toHaveChildrenWithClass("c")
    expect(div).not.toHaveChildrenWithClass("b", 2)


describe "toBeAListOf", ->
  class Animal

  it "matches an empty list", ->
    expect([]).toBeAListOf(Animal)

  it "matches a list of expected elements", ->
    animals = [new Animal(), new Animal()]

    expect(animals).toBeAListOf(Animal)

  it "doesnt match when it should not", ->
    stuff = [new Animal(), "alalaaa"]
    expect(stuff).not.toBeAListOf(Animal)


describe "Initialization", ->
  tentacl = null

  beforeEach ->
    $('#TestArea').empty()
    $("<div id='TentaclContent'/>").appendTo('#TestArea')
    tentacl = new Tentacl()
    window.tentacl = tentacl
    console.log "reset"

  it "Tentacl should be defined", ->
    expect(tentacl).toBeDefined()

  describe "Screen", ->
    screen = null

    beforeEach ->
      screen = tentacl.screen

    it "should be defined on tentacl", ->
      expect(screen).toBeDefined()

    it "should be present in the document", ->
      expect(screen.el).toExistInDocument()

    describe "MainPane", ->
      pane = null

      beforeEach ->
        pane = screen.mainPane

      it "should be in the document", ->
        expect(pane.el).toExistInDocument()

      it "should have rendered a content pane", ->
        expect(document.body).toHaveChildrenWithClass("tentacl-content-pane", 1)

        content = $(".tentacl-content-pane")
        expect(content.height()).toBeNear($(pane.el).height())

      describe "after split", ->
        beforeEach ->
          pane.split()

        it "should have rendered another content pane", ->
          expect(document.body).toHaveChildrenWithClass("tentacl-content-pane", 2)

        describe "change content disposition", ->
          panes = null
          offset1 = null
          offset2 = null

          beforeEach ->
            console.log "setContentDisposition! 3"
            pane.setContentDisposition('HORIZONTAL')
            panes = $('.tentacl-content-pane')
            offset1 = $(panes[0]).offset()
            offset2 = $(panes[1]).offset()

          it "should have children next to each other horizontally", ->
            expect(offset2.top).toBeNear(offset1.top, .5)
            expect(offset2.left).toBeNear(offset1.left + $(panes[0]).width(), .5)

          it "should have children that use all available vertical space", ->
            console.log "here we are with " + panes.length
            expect($(panes[0]).height()).toBeNear($(pane.el).height(), .5)

          describe "and split an inside vertically and add some content", ->

            beforeEach ->
              pane.children[1].split(contentDisposition: 'VERTICAL')
              pane.children[0].children[0].setValue(Array(11).join 'testing...1, 2, 3')

            it "should all align properly", ->
              panes = $('.tentacl-content-pane')
              offset1 = $(panes[0]).offset()
              offset2 = $(panes[1]).offset()
              offset3 = $(panes[2]).offset()

              expect(offset2.top).toBeNear(offset1.top, .5)
              expect(offset2.left).toBeNear(offset1.left + $(panes[0]).width(), .5)
              expect(offset3.left).toBeNear(offset2.left, .5)
              expect(offset3.top).toBeNear(offset2.top + $(panes[1]).height(), .5)

        describe "and another split", ->

          beforeEach ->
            pane.split()

          it "should be 3 content panes on the document", ->
            expect(document.body).toHaveChildrenWithClass("tentacl-content-pane", 3)


        describe "and splitting an inside horizontally", ->
          beforeEach ->
            pane.children[1].split(contentDisposition: 'HORIZONTAL')

          it "should all align properly", ->
            panes = $('.tentacl-content-pane')
            offset1 = $(panes[0]).offset()
            offset2 = $(panes[1]).offset()
            offset3 = $(panes[2]).offset()

            expect(offset2.left).toBeNear(offset1.left, .5)
            expect(offset2.top).toBeNear(offset1.top + $(panes[0]).height(), .5)
            expect(offset3.top).toBeNear(offset2.top, .5)
            expect(offset3.left).toBeNear(offset2.left + $(panes[1]).width(), .5)


describe "Screen", ->
  screen = null

  beforeEach ->
    screen = new Screen()

  it "should have a main pane", ->
    expect(screen.mainPane).toBeDefined()

describe "Pane", ->
  pane = null

  beforeEach ->
    pane = new Pane()

describe "LayoutPane", ->
  pane = null

  beforeEach ->
    pane = new LayoutPane()

  it "should start with a child ContentPane", ->
    expect(pane.children).toHaveLength(1)
    expect(pane.children[0]).toBeInstanceOf(ContentPane)

  describe "setContentDisposition", ->

    it "should trigger render() only when necessary", ->
      spyOn(pane, 'render')

      expect(pane.contentDisposition).toBe('VERTICAL')

      pane.setContentDisposition('VERTICAL')
      pane.setContentDisposition('HORIZONTAL', render: false)
      expect(pane.render).not.toHaveBeenCalled()

      pane.setContentDisposition('VERTICAL')
      expect(pane.render).toHaveBeenCalled()

  describe "split", ->
    it "should wrap the existing content pane in a layoutPane", ->
      currentPane = pane.children[0]

      pane.split()
      expect(pane.children[0].children[0]).toBe(currentPane)

      pane.split() # Also if done twice
      expect(pane.children[0].children[0]).toBe(currentPane)

    it "shoud add a new LayoutPane as a child", ->
      pane.split()

      expect(pane.children).toHaveLength(2)
      expect(pane.children).toBeAListOf(LayoutPane)

    it "should add new LayoutPane children with each split", ->
      pane.split()
      pane.split()

      expect(pane.children).toHaveLength(3)
      expect(pane.children).toBeAListOf(LayoutPane)

    it "should trigger a rerender", ->
      spyOn(pane, 'render')

      pane.split()
      expect(pane.render).toHaveBeenCalled()

    it "accepts a param to set the content disposition", ->
      pane.split(contentDisposition: "VERTICAL")
      expect(pane.contentDisposition).toBe("VERTICAL")

      pane.split(contentDisposition: "HORIZONTAL")
      expect(pane.contentDisposition).toBe("HORIZONTAL")

  describe "focus", ->
    it "should start focused on its contentPane", ->
      expect(pane.currentFocus).toBe(pane.children[0])

    it "should forward focus calls to its current focus", ->
      spyOn(pane.currentFocus, "focus")

      pane.focus()

      expect(pane.currentFocus.focus).toHaveBeenCalled()

    describe "with more than one pne",  ->
      content1 = null
      content2 = null
      content3 = null

      beforeEach ->
        content1 = pane.children[0]
        content2 = pane.split().children[0]
        content3 = pane.split().children[0]

        spyOn(content1, 'focus')
        spyOn(content2, 'focus')
        spyOn(content3, 'focus')

      it "allows to change its current focus by specifing a new child", ->
        pane.focus()
        expect(content1.focus).toHaveBeenCalledXTimes(1)
        expect(content2.focus).not.toHaveBeenCalled()

        pane.focus(pane: content2)
        expect(content1.focus).toHaveBeenCalledXTimes(1)
        expect(content2.focus).toHaveBeenCalledXTimes(1)

        pane.focus()
        expect(content1.focus).toHaveBeenCalledXTimes(1)
        expect(content2.focus).toHaveBeenCalledXTimes(2)

      it "allows to change focus to the next/prev pane", ->
        pane.focus()
        expect(content1.focus).toHaveBeenCalledXTimes(1)
        expect(content2.focus).toHaveBeenCalledXTimes(0)
        expect(content3.focus).toHaveBeenCalledXTimes(0)

        pane.focus(pane: 'NEXT')
        expect(content1.focus).toHaveBeenCalledXTimes(1)
        expect(content2.focus).toHaveBeenCalledXTimes(1)
        expect(content3.focus).toHaveBeenCalledXTimes(0)

        pane.focus(pane: 'NEXT')
        expect(content1.focus).toHaveBeenCalledXTimes(1)
        expect(content2.focus).toHaveBeenCalledXTimes(1)
        expect(content3.focus).toHaveBeenCalledXTimes(1)

        pane.focus(pane: 'NEXT')
        expect(content1.focus).toHaveBeenCalledXTimes(2)
        expect(content2.focus).toHaveBeenCalledXTimes(1)
        expect(content3.focus).toHaveBeenCalledXTimes(1)

        pane.focus(pane: 'PREV')
        expect(content1.focus).toHaveBeenCalledXTimes(2)
        expect(content2.focus).toHaveBeenCalledXTimes(1)
        expect(content3.focus).toHaveBeenCalledXTimes(2)
