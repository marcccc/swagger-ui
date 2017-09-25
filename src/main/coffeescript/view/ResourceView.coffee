class ResourceView extends Backbone.View
  events: {
    'change .swagger-select-pager' : 'pageChange',
    'keyup .query-operations-input' : 'operationsFilter'
  }
  initialize: (options)->
    @pageNum = options.pageNum
    @pageSize = options.pageSize
    @filteredOperationsArray = @model.operationsArray
    @pageTotal = Math.ceil(@model.operationsArray.length / @pageSize)

  render: ->
    $(@el).html(Handlebars.templates.resource(@model))
    @renderPager()

    @number = 0

    # Render each operation
    @addOperation operation for operation in @filteredOperationsArray
    @

  renderPager: -> 
    $('.swagger-ui-pager', @el).html(Handlebars.templates.resource_pager({pageNum: @pageNum, pageSize: @pageSize, pageTotal: @pageTotal}))
    @    

  addOperation: (operation) ->

    operation.number = @number

    # Render an operation and add it to operations li
    if @number >= ((@pageNum - 1) * @pageSize) and @number < (@pageNum * @pageSize)
      operationView = new OperationView({model: operation, tagName: 'li', className: 'endpoint'}) 
      $('.endpoints', $(@el)).append operationView.render().el

    @number++

  pageChange: (e) ->
    $('.endpoints', @el).empty()
    @number = 0
    @pageNum = $(e.target).val()
    @addOperation operation for operation in @filteredOperationsArray
    @markFilterKeyWords()
    @
    
  operationsFilter: (e) ->
    return if e.keyCode != 13
    filteredOperationsArray = []
    for operation in @model.operationsArray
      do (operation) ->
        filteredOperationsArray.push(operation) if new RegExp(e.target.value, 'i').test(operation.path)
    @filteredOperationsArray = filteredOperationsArray
    @pageNum = 1
    @pageTotal = Math.ceil(@filteredOperationsArray.length / @pageSize);
    @renderPager()
    @number = 0
    $('.endpoints', @el).empty()
    @addOperation operation for operation in @filteredOperationsArray
    @markFilterKeyWords()
    @

  markFilterKeyWords: ->
    keyWords = $('.query-operations-input', @el).val()
    if keyWords
      paths = $('.operations .heading .path a', @el)
      for path in paths
        do (path) -> 
          $(path).html($(path).html().replace(new RegExp(keyWords, 'ig'), '<b style="color:red;">$&</b>'))
    @