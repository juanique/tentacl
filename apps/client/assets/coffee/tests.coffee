describe "Tentacl", ->
  describe "class", ->
    it "should be available globally", ->
      expect(Tentacl).toBeDefined()

    it "should be instantiated globally", ->
      expect(tentacl).toBeInstanceOf(Tentacl)
