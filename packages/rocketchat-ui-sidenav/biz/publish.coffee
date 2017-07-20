Template.publish.helpers
	isReady: ->
		return Template.instance().ready?.get()
	publishs: ->
		return Template.instance().publishs()
	isLoading: ->
		return 'btn-loading' unless Template.instance().ready?.get()
	hasMore: ->
		return Template.instance().limit?.get() is Template.instance().users?().length

	dateFormated: (date) ->
		return moment(date).format('YYYY-MM-DD HH:mm:ss')


Template.publish.onCreated ->
	instance = @
	@limit = new ReactiveVar 30
	@filter = new ReactiveVar ''
	@ready = new ReactiveVar true



	@autorun ->
		filter = instance.filter.get()
		limit = instance.limit.get()
		subscription = instance.subscribe 'fullPublishs', filter, limit
		instance.ready.set subscription.ready()

	@publishs = ->
		filter = _.trim instance.filter?.get()
		if filter
			filterReg = new RegExp filter, "i"
			query = { $or: [ { resName: filterReg }, { resDesc: filterReg }] }
		else
			query = {}



		return Publishs.find(query, { limit: instance.limit?.get(), sort: { createTime: -1 } }).fetch()








Template.publish.events
	'keydown #users-filter': (e) ->
		if e.which is 13
			e.stopPropagation()
			e.preventDefault()



	'click .load-more': (e, t) ->
		e.preventDefault()
		e.stopPropagation()
		t.limit.set t.limit.get() + 30
