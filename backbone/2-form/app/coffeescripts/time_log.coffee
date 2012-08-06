@app = window.app ? {}

jQuery ->

  new app.AppView collection: app.Tasks
  app.Tasks.fetch()