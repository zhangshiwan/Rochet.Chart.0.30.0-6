#Meteor.methods
#	findPublishs: (filter, limit) ->
#		unless Meteor.userId()
#			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'saveUserProfile' }
#
#		user = RocketChat.models.Users.findOneById Meteor.userId()
#
#
#		fields =
#			resName: 1
#			resDesc: 1
#			resUrl: 1
#			resType: 1
#			skill: 1
#			createTime: 1
#			userId: 1
#
#
#
#		filter = s.trim filter
#
#		if not filter and limit is 1
#			return @ready()
#
#		options =
#			fields: fields
#			limit: limit
#			sort: { createTime: 1 }
#
#
#	 return Publishs.find {}, options
#
