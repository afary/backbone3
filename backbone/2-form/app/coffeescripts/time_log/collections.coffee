# COLLECTIONS

class Tasks extends Backbone.Collection
  model: app.Task
  url: '/api/tasks'
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

@app = window.app ? {}
@app.Tasks = new Tasks

