$(document).ready ->
  console.log "documentready!"
  jasmineEnv = jasmine.getEnv()
  jasmineEnv.updateInterval = 1000

  reporter = new jasmine.HtmlReporter()
  jasmineEnv.addReporter(reporter)
  jasmineEnv.specFilter = (spec) -> reporter.specFilter(spec)
  jasmineEnv.execute()
