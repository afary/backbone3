# MODELS

class Task extends Backbone.Model
  defaults:
    tag: ''
  initialize: (attributes, options) ->
    if !attributes.createdAt
      @attributes.createdAt = (new Date).getTime()
    if tag = @extractTag(attributes.title)
      @attributes.tag = tag
    else
      @attributes.tag = null
  extractTag: (text) ->
    if @attributes.title
      matches = @attributes.title.match /\s#(\w+)/
      if matches?.length
        return matches[1]
    ''
  markComplete: ->
    completedAt = (new Date).getTime()
    @set completedAt:completedAt, duration:60
  markIncomplete: ->
    @set completedAt:null, duration:0
  isCompleted: ->
    @attributes.completedAt
  validate: (attributes) ->
    mergedAttributes = _.extend(_.clone(@attributes), attributes)
    if !mergedAttributes.title or mergedAttributes.title.trim() == ''
      return "Task title must not be blank"

@app = window.app ? {}
@app.Task = Task








