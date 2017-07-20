Meteor.methods
	savePublish: (publish) ->
		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'saveUserProfile' }

		user = RocketChat.models.Users.findOneById Meteor.userId()


		publish.userId = Meteor.userId()
		publish.createTime = new Date
		publish.username = user.username

		RocketChat.models.Publishs.insertOrUpsert publish

		return true
