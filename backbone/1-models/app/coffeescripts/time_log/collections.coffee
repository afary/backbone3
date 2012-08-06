# COLLECTIONS

class Tasks extends Backbone.Collection
  model: app.Task
  url: '/api/tasks'

@app = window.app ? {}
@app.Tasks = new Tasks
