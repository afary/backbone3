# VIEWS

jQuery ->
  class AppView extends Backbone.View
    el: '#wrap'
    initialize: (options) ->
      @subviews = [
        new TasksView     collection: @collection
        new NewTaskView   collection: @collection
        ]
      @collection.bind 'reset', @render, @
    render: ->
      $(@el).empty()
      $(@el).append subview.render().el for subview in @subviews
      @


  class TasksView extends Backbone.View
    className: 'tasks'
    template: _.template($('#tasks-template').html())
    blankStateTemplate: _.template($('#blank-state-template').html())
    initialize: (options) ->
      @completedSubviews = [
        new CompletedTasksView collection: @collection
        ]
      @incompleteSubviews = [
        new IncompleteTasksView collection: @collection
        ]
    render: ->
      $(@el).html @template()
      $(@el).append subview.render().el for subview in @completedSubviews

      # In all cases, show IncompleteTaskView
      $(@el).append subview.render().el for subview in @incompleteSubviews

      @delegateEvents()
      @
    startTracking: ->
      @collection.createStartTask()
      $('#new-task').val('').focus()


  class CompletedTasksView extends Backbone.View
    id: 'completed-tasks'
    tagName: 'ul'
    initialize: ->
      @collection.bind 'change', @render, @
    render: ->
      $(@el).empty()
      for task in @collection.completedTasks()
        completedTaskView = new CompletedTaskView model: task
        $(@el).append completedTaskView.render().el
      @


  class CompletedTaskView extends Backbone.View
    className: 'task'
    tagName: 'li'
    template: _.template($('#completed-task-template').html())
    events:
      'click input.is-done': 'markIncomplete'
    render: ->
      $(@el).html @template(@model.toJSON())
      @
    disable: ->
      @$('input').prop 'disabled', true
    enable: ->
      @$('input').prop 'disabled', false
    markIncomplete: ->
      if @$('.is-done').prop('checked')
        @model.markComplete()
      else
        @model.markIncomplete()
      @model.save()


  class IncompleteTasksView extends Backbone.View
    id: 'tasks-to-complete'
    tagName: 'ul'
    initialize: (options) ->
      @collection.bind 'add', @render, @
      @collection.bind 'change',  @render, @
    render: ->
      $(@el).empty()
      for task in @collection.incompleteTasks()
        incompleteTaskView = new IncompleteTaskView model: task
        $(@el).append incompleteTaskView.render().el
      @


  class IncompleteTaskView extends Backbone.View
    className: 'task'
    tagName: 'li'
    template: _.template($('#incomplete-task-template').html())
    events:
      'click input.is-done': 'markComplete'
    render: ->
      $(@el).html @template(@model.toJSON())
      @
    markComplete: ->
      if @$('.is-done').prop('checked')
        @model.markComplete()
      else
        @model.markIncomplete()
      @model.save()


  class NewTaskView extends Backbone.View
    tagName: 'form'
    template: _.template($('#new-task-template').html())
    events:
      'keypress #new-task': 'saveOnEnter'
      'focusout #new-task': 'hideWarning'
    render: ->
      $(@el).html @template()
      @
    saveOnEnter: (event) ->
      if (event.keyCode is 13) # ENTER
        event.preventDefault()
        newAttributes = {title:$('#new-task').val()}
        errorCallback = {error:@flashWarning}
        if @collection.create(newAttributes, errorCallback)
          @hideWarning()
          @focus() 
    focus: ->
      $('#new-task').val('').focus()
    hideWarning: ->
      $('#warning').hide()
    flashWarning: (model, error) ->
      console.log error
      $('#warning').fadeOut(100)
      $('#warning').fadeIn(400)


  @app = window.app ? {}
  @app.AppView = AppView

