RocketChat.models.Publishs = new class extends RocketChat.models._Base
	constructor: ->
		@_initModel 'publishs'

		@tryEnsureIndex { 'resName': 1 }, { sparse: 1 }
		@tryEnsureIndex { 'resType': 1 }
		@tryEnsureIndex { 'skill': 1 }



  # FIND ONE
	findOneById: (_id, options) ->
		return @findOne _id, options

	findOneByUsername: (resName, options) ->
		query =
			resName: resName

		return @findOne query, options

  findByQuery: (query, options) ->

	  return @find query, options



	setResUrl: (_id, resUrl) ->
		update =
			$set: resUrl: resUrl

		return @update _id, update


  # REMOVE
  removeById: (_id) ->
    query =
      _id: _id

    return @remove query


  savePublishById: (_id, data) ->
    setData = {}
    unsetData = {}

    if data.name?
      if not _.isEmpty(s.trim(data.name))
        setData.name = s.trim(data.name)
      else
        unsetData.name = 1

    if data.email?
      if not _.isEmpty(s.trim(data.email))
        setData.emails = [
          address: s.trim(data.email)
        ]
      else
        unsetData.name = 1

    if data.phone?
      if not _.isEmpty(s.trim(data.phone))
        setData.phone = [
          phoneNumber: s.trim(data.phone)
        ]
      else
        unsetData.phone = 1

    update = {}

    if not _.isEmpty setData
      update.$set = setData

    if not _.isEmpty unsetData
      update.$unset = unsetData

    return @update { _id: _id }, update
