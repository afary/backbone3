# COLLECTIONS

class Tasks extends Backbone.Collection
  model: app.Task
  url: '/api/tasks'
  initialize: (options) ->
    @bind 'destroy', @willDestroyTask, @
  comparator: (task) ->
    task.get('createdAt')
  completedTasks: ->
    tasks = @filter (task) ->
      task.isCompleted()
    _.sortBy tasks, (task) ->
      task.get('completedAt')
  incompleteTasks: ->
    @reject (task) ->
      task.isCompleted()
  duration: ->
    durationSeconds = 0
    for duration in @pluck('duration')
      if duration > 0
        durationSeconds += duration
    durationSeconds
  tagReports: ->
    tagReports =
      other:
        name:'other'
        duration:0
    for task in @completedTasks()
      if task.isCompleted() and task.get('duration')
        if tag = task.get('tag')
          if tagReports[tag]
            tagReports[tag].duration += task.get('duration')
          else
            tagReports[tag] = { name:tag, duration:task.get('duration') }
        else
          tagReports.other.duration += task.get('duration')
    if tagReports.other.duration == 0
      delete tagReports.other
    _.sortBy tagReports, (tagReport) ->
      -tagReport.duration
  willDestroyTask: (task) ->
    @registerUndo task.toJSON()
  registerUndo: (attributes) ->
    # Queue a model's attributes to be saved.
    @undoAttributes = attributes
    if @undoAttributes.id
      delete @undoAttributes.id
    if @undoAttributes.createdAt
      delete @undoAttributes.createdAt
  resetUndo: ->
    @undoAttributes = null
  applyUndo: ->
    @create @undoAttributes
    @resetUndo()
  undoItem: ->
    # Returns the attributes of the item queued for undo.
    @undoAttributes

@app = window.app ? {}
@app.Tasks = new Tasks

