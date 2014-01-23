class Sockshare
	constructor: (@url) ->
		# go to the mobile view
		# there are rules to parse the desktop version too, but
		# this one is more easy.
		if @url.indexOf('mobile/file') is -1
			@url = @url.replace '/file/', '/mobile/file/'

		@hoster = @url.split '/mobile/file/'
		@hoster = @hoster[0]

	parse: (successCallback, errorCallback) ->
		@getHash =>
			if @video isnt undefined
				@getFile =>
					successCallback @file
				, -> errorCallback 'File not found.'
			else @getVideo =>
				@getHash =>
					@getFile =>
						successCallback @file
					, -> errorCallback 'File not found.'
				, -> errorCallback 'Video not found.'
		, -> errorCallback 'Hash not found.'

	getHash: (successCallback, errorCallback) ->
		$.ajax
			url: @url
			error: errorCallback
			success: (data) =>
				# first check if this page was already requested
				# if yes, the hosters showing the file instantly
				video   = data.match /<a href="\/get_file\.php\?(.*)">/
				hash    = data.match /<input type="hidden" value="([a-z0-9]+)" name="hash">/
				confirm = data.match /<input name="confirm" type="submit" value="(.*)">/

				if video isnt null and video.length is 2
					@video = '/get_file.php?' + video[1]

					successCallback()
				else if hash isnt null and hash.length is 2 and confirm isnt null and confirm.length is 2
					@hash    = hash[1]
					@confirm = confirm[1]

					successCallback()
				else errorCallback()

	getVideo: (successCallback, errorCallback) ->
		$.ajax
			url: @url
			data:
				hash: @hash
				confirm: @confirm
			type: 'POST'
			error: errorCallback
			success: (data) =>
				# data is always window.location
				successCallback()

	# todo
	getFile: (successCallback, errorCallback) ->
		@file = @hoster + @video

		successCallback()

		###
		$.ajax
			url: @hoster + @video
			error: errorCallback
			success: (data) ->
				console.log data
		###
