beforeEach ->
  @addMatchers
    toExistInDocument: () ->
      el = @actual
      while el = el.parentNode
        if el == document
          return true
      return false

    toBeAListOf: (expectedClass) ->
      for item in @actual
        if not (item instanceof expectedClass)
          return false
      return true

    toHaveCssClass: (classes...) ->
      for className in classes
        if not $(@actual).hasClass(className)
          return false
      return true

    toHaveChildrenWithClass: (className, count=-1) ->
      matches = $(".#{className}", @actual)

      if count == -1
        return matches.length > 0
      else
        return matches.length == count

    toBeNear: (expected, tolerance=1) ->
      return Math.abs(@actual - expected) <= tolerance
