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

