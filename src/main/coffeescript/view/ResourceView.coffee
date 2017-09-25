class ResourceView extends Backbone.View
  events: {
    'change .swagger-select-pager'    : 'pageChange'
  }
  initialize: (options)->
    @pageNum = options.pageNum
    @pageSize = options.pageSize
    @pageTotal = Math.ceil(@model.operationsArray.length / @pageSize)
    log @pageNum , @pageSize , @pageTotal 

  render: ->
    $(@el).html(Handlebars.templates.resource(@model))
    $('.swagger-ui-pager', @el).html(Handlebars.templates.resource_pager({pageNum: @pageNum, pageSize: @pageSize, pageTotal: @pageTotal}))

    @number = 0

    # Render each operation
    @addOperation operation for operation in @model.operationsArray
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
    @addOperation operation for operation in @model.operationsArray
    
