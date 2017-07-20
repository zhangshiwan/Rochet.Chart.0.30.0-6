Meteor.methods
	deleteMessage: (message) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'deleteMessage' }

		originalMessage = RocketChat.models.Messages.findOneById message._id, {fields: {u: 1, rid: 1, file: 1}}
		if not originalMessage?
			throw new Meteor.Error 'error-action-not-allowed', 'Not allowed', { method: 'deleteMessage', action: 'Delete_message' }

		hasPermission = RocketChat.authz.hasPermission(Meteor.userId(), 'delete-message', originalMessage.rid)
		deleteAllowed = RocketChat.settings.get 'Message_AllowDeleting'

		deleteOwn = originalMessage?.u?._id is Meteor.userId()

		unless hasPermission or (deleteAllowed and deleteOwn)
			throw new Meteor.Error 'error-action-not-allowed', 'Not allowed', { method: 'deleteMessage', action: 'Delete_message' }

		blockDeleteInMinutes = RocketChat.settings.get 'Message_AllowDeleting_BlockDeleteInMinutes'
		if blockDeleteInMinutes? and blockDeleteInMinutes isnt 0
			msgTs = moment(originalMessage.ts) if originalMessage.ts?
			currentTsDiff = moment().diff(msgTs, 'minutes') if msgTs?
			if currentTsDiff > blockDeleteInMinutes
				throw new Meteor.Error 'error-message-deleting-blocked', 'Message deleting is blocked', { method: 'deleteMessage' }


		keepHistory = RocketChat.settings.get 'Message_KeepHistory'
		showDeletedStatus = RocketChat.settings.get 'Message_ShowDeletedStatus'

		if keepHistory
			if showDeletedStatus
				RocketChat.models.Messages.cloneAndSaveAsHistoryById originalMessage._id
			else
				RocketChat.models.Messages.setHiddenById originalMessage._id, true

			if originalMessage.file?._id?
				RocketChat.models.Uploads.update originalMessage.file._id, {$set: {_hidden: true}}

		else
			if not showDeletedStatus
				RocketChat.models.Messages.removeById originalMessage._id

			if originalMessage.file?._id?
				FileUpload.delete(originalMessage.file._id)

		if showDeletedStatus
			RocketChat.models.Messages.setAsDeletedById originalMessage._id
		else
			RocketChat.Notifications.notifyRoom originalMessage.rid, 'deleteMessage', {_id: originalMessage._id}
