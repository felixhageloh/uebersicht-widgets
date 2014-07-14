#Enter your Wunderlist User Email
email: 'email'

#Enter your Wunderlist User Password
password: 'password'

#Show names of lists 
showListsNames: true, # true / false

#Show lists by names
#Example: ['Inbox', 'Products', 'Starred']
showLists: [] #show all by default

# Set the refresh frequency (milliseconds).
refreshFrequency: 1000 * 60	#1 minute

style: """
  top: 190px
  right: 0px
  color: #fff
  background: rgba(0,0,0,0.2)
  font-family: Roboto
  font-size: 10pt
  width: 270px

  .lists,.tasks
	  margin: 0
	  padding: 0
  
  .list,.task
      list-style: none

  .list-info
	  background: rgba(0,0,0,0.2)
	  position: relative
	  font-weight: bold

  .list-name
	  padding: 5px 10px
	  margin: 0 40px 0 0
	  overflow: hidden
	  text-overflow: ellipsis
	  position: relative
	  white-space: nowrap
	  opacity: 0.85

  .tasks-length
	  position: absolute
	  top: 0px
	  right: 5px
	  opacity: 0.85
	  padding: 5px 5px
	  
  .task
	  margin: 0 10px
	  padding: 5px 0 5px 20px
	  white-space: nowrap
	  overflow: hidden
	  text-overflow: ellipsis
	  position: relative
	  opacity: 0.85

  .task::after
	  content: ""
	  position: absolute
	  width: 10px
	  height: 10px
	  background: rgba(0,0,0,0.3) 
	  -webkit-border-radius: 20px
	  left: 0
	  top: 8px

   .error
	  padding: 5px
	  background: rgba(0,0,0,0.3) 
"""

render: (_) -> """
	<div class='to-do-wrap'></div>
"""

api: "http://api.wunderlist.com"

command: ""

token: null

getToken: () ->
	df = new $.Deferred
	
	if @token == null
		$.ajax
			type: "POST"
			url: @api + "/login"
			data:
				email: @email
				password: @password
			error: (jqXHR) =>
				err = 'No internet connection'
				if jqXHR && jqXHR.responseJSON
					err = jqXHR.responseJSON.errors.message
				console.log err
				df.reject err
			success: (data) =>
				if data.token
					@token = data.token
					df.resolve @token
				else
					err = 'token is empty'
					console.log err
					df.reject err
	else
		df.resolve @token
		
	return df.promise()

showError: (err) ->
	if @content
		@content.html '<div class="error">' + err + '</div>'
_fetch: (name) ->
	df = new $.Deferred
	
	$.ajax
		url: @api + "/me/" + name
		headers:
			'Authorization': @token
		error: (jqXHR) =>	
			err = 'No internet connection'
			if jqXHR && jqXHR.responseJSON
				err = jqXHR.responseJSON.errors.message
			console.log err	
			df.reject err
		success: (data) =>
			@[name] = data || []
			df.resolve data
			
	return df.promise()

fetchLists: () ->
	return @_fetch 'lists'

fetchTasks: () ->
	return @_fetch 'tasks'

update: (output, domEl) ->
	if !@content
		@content = $(domEl).find('.to-do-wrap')
		
	@getToken()
	.then @fetchLists.bind this
	.then @fetchTasks.bind this
	.then @buildTree.bind this
	.then @_render.bind this
	
_sort: (arr) ->
	arr.sort (a, b) ->
		if a.position < b.position
			return -1
		else
			return 1
	return arr

buildTree: () ->
	tree = {}
	lists = [{
			title: 'Inbox',
			id: 'inbox'
		},{
			title: 'Assigned to Me',
			id: 'assigned_to_me'
		},{	
			title: 'Starred',
			id: 'starred'
		}]
	lists = lists.concat @_sort(@lists)
	tasks = @_sort @tasks
	
	lists.forEach (l) =>
		tasksArr = []
		tasks.forEach (t) ->
			if (t.completed_at == null && (l.id == t.list_id || (l.id == 'starred' && t.starred) || (l.id == 'assigned_to_me' && t.assignee_id != null)))
				tasksArr.push t.title
		tree[l.title] = tasksArr

	@tree = tree		
	
_render: () ->
	str = '<ul class="lists">'
	listNameTpl = ''
	tree = if @showLists.length then @showLists else Object.keys(@tree)
	tree.forEach (listName) =>
		tasks = @tree[listName]
		n = tasks.length
		if n
			if @showListsNames
				listNameTpl = '<div class="list-info">' +
								'<div class="list-name">' + listName + '</div>' +
								'<div class="tasks-length">' + n + '</div>' +
							'</div>'
			str +=  '<li class="list">' + 
						listNameTpl +
						'<ul class="tasks">' + 
							'<li class="task">' + tasks.join('</li><li class="task">') + '</li>' +
						'</ul>' +
				   	'</li>'
	str += '</ul>'
	@content.html str