Meteor.publish 'fullPublishs', (filter, limit) ->
	unless @userId
		return @ready()

	fields =
		resName: 1
		resDesc: 1
		resUrl: 1
		resType: 1
		skill: 1
		createTime: 1
		userId: 1
		username: 1



	filter = s.trim filter

	if not filter and limit is 1
		return @ready()

	options =
		fields: fields
		limit: limit
		sort: { createTime: 1 }



	return RocketChat.models.Publishs.find {}, options
