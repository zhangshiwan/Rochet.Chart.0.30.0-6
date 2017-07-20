Template.channelSettings.helpers
	canEdit: ->
		return RocketChat.authz.hasAllPermission('edit-room', @rid)
	canArchiveOrUnarchive: ->
		return RocketChat.authz.hasAtLeastOnePermission(['archive-room', 'unarchive-room'], @rid)
	editing: (field) ->
		return Template.instance().editing.get() is field
	notDirect: ->
		return ChatRoom.findOne(@rid, { fields: { t: 1 }})?.t isnt 'd'
	roomType: ->
		return ChatRoom.findOne(@rid, { fields: { t: 1 }})?.t
	channelSettings: ->
		return RocketChat.ChannelSettings.getOptions()
	roomTypeDescription: ->
		roomType = ChatRoom.findOne(@rid, { fields: { t: 1 }})?.t
		if roomType is 'c'
			return t('Channel')
		else if roomType is 'p'
			return t('Private_Group')
	roomName: ->
		return ChatRoom.findOne(@rid, { fields: { name: 1 }})?.name
	roomTopic: ->
		return ChatRoom.findOne(@rid, { fields: { topic: 1 }})?.topic
	archivationState: ->
		return ChatRoom.findOne(@rid, { fields: { archived: 1 }})?.archived
	archivationStateDescription: ->
		archivationState = ChatRoom.findOne(@rid, { fields: { archived: 1 }})?.archived
		if archivationState is true
			return t('Room_archivation_state_true')
		else
			return t('Room_archivation_state_false')

Template.channelSettings.events
	'keydown input[type=text]': (e, t) ->
		if e.keyCode is 13
			e.preventDefault()
			t.saveSetting()

	'click [data-edit]': (e, t) ->
		e.preventDefault()
		t.editing.set($(e.currentTarget).data('edit'))
		setTimeout (-> t.$('input.editing').focus().select()), 100

	'click .cancel': (e, t) ->
		e.preventDefault()
		t.editing.set()

	'click .save': (e, t) ->
		e.preventDefault()
		t.saveSetting()

Template.channelSettings.onCreated ->
	@editing = new ReactiveVar

	@validateRoomType = =>
		type = @$('input[name=roomType]:checked').val()
		if type not in ['c', 'p']
			toastr.error t('error-invalid-room-type', type)
		return true

	@validateRoomName = =>
		rid = Template.currentData()?.rid
		room = ChatRoom.findOne rid

		if not RocketChat.authz.hasAllPermission('edit-room', rid) or room.t not in ['c', 'p']
			toastr.error t('error-not-allowed')
			return false

		name = $('input[name=roomName]').val()

		try
			nameValidation = new RegExp '^' + RocketChat.settings.get('UTF8_Names_Validation') + '$'
		catch
			nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

		if not nameValidation.test name
			toastr.error t('error-invalid-room-name', { room_name: name: name })
			return false

		return true

	@validateRoomTopic = =>
		return true

	@saveSetting = =>
		switch @editing.get()
			when 'roomName'
				room = ChatRoom.findOne @data?.rid
				if $('input[name=roomName]').val() is room.name
					toastr.success TAPi18n.__ 'Room_name_changed_successfully'
				else
					if @validateRoomName()
						Meteor.call 'saveRoomSettings', @data?.rid, 'roomName', @$('input[name=roomName]').val(), (err, result) ->
							if err
								return handleError(err)
							toastr.success TAPi18n.__ 'Room_name_changed_successfully'
			when 'roomTopic'
				if @validateRoomTopic()
					Meteor.call 'saveRoomSettings', @data?.rid, 'roomTopic', @$('input[name=roomTopic]').val(), (err, result) ->
						if err
							return handleError(err)
						toastr.success TAPi18n.__ 'Room_topic_changed_successfully'
			when 'roomType'
				if @validateRoomType()
					Meteor.call 'saveRoomSettings', @data?.rid, 'roomType', @$('input[name=roomType]:checked').val(), (err, result) ->
						if err
							return handleError(err)
						toastr.success TAPi18n.__ 'Room_type_changed_successfully'
			when 'archivationState'
				if @$('input[name=archivationState]:checked').val() is 'true'
					if ChatRoom.findOne(@data.rid)?.archived isnt true
						Meteor.call 'archiveRoom', @data?.rid, (err, results) ->
							return handleError err if err
							toastr.success TAPi18n.__ 'Room_archived'
				else
					if ChatRoom.findOne(@data.rid)?.archived is true
						Meteor.call 'unarchiveRoom', @data?.rid, (err, results) ->
							return handleError err if err
							toastr.success TAPi18n.__ 'Room_unarchived'
		@editing.set()
