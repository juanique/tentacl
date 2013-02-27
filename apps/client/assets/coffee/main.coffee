$(document).ready ->
  resizeHandler = null

  window.tentacl = new Tentacl
  $(window).resize ->
    clearTimeout(resizeHandler)
    rerender = ->
      tentacl.screen.render()
    resizeHandler = setTimeout rerender, 100
  return


  window.cm = CodeMirror document.body,
    extraKeys:
      'Ctrl-W': (e) ->
        console.log "hola"
        cm.setValue(cm.getValue() + "\nCTRL-W fired")
        return false

  document.onkeydown = (e) ->
    return
    if document.activeElement == document.body
      e.preventDefault()
