@app = window.app ? {}

jQuery ->
  @app.router = new app.TimeLogRouter
  Backbone.history.start({pushState:true})
