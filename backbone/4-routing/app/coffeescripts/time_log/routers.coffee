# ROUTERS

jQuery ->

  class TimeLogRouter extends Backbone.Router
    routes:
      '': 'redirectToToday'
      'tasks/:year/:month/:day': 'show'
    initialize: ->
      @view = new app.AppView collection: app.Tasks
      app.Tasks.bind 'change:date', @changeDate, @
    show: (year, month, day) ->
      app.Tasks.setDate year, month, day
    redirectToToday: ->
      today = new Date()
      [day, month, year] = [today.getDate(), today.getMonth() + 1, today.getFullYear()]
      Backbone.history.navigate "tasks/#{year}/#{month}/#{day}", true
    changeDate: ->
      # NOTE: Just change the URL, don't fire any actions.
      # Take /api/ off the front of the server data URL.
      Backbone.history.navigate app.Tasks.url.substring(5, 255)

  @app = window.app ? {}
  @app.TimeLogRouter = TimeLogRouter

