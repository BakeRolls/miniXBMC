class SockshareDesktop
	constructor: (@url) ->

	parse: (successCallback, errorCallback) ->
		@getHash =>
			@getID =>
				@getFile =>
					successCallback @video
				, -> errorCallback 'File not found.'
			, -> errorCallback 'Video id not found.'
		, -> errorCallback 'Hash not found.'

	getHash: (successCallback, errorCallback) ->
		$.ajax
			url: @url
			beforeSend: @setUserAgent
			error: errorCallback
			success: (data) =>
				data = data.match /<input type="hidden" value="([a-z0-9]+)" name="hash">/

				if data isnt null and data.length is 2
					@hash = data[1]
					successCallback()
				else errorCallback()

	getID: (successCallback, errorCallback) ->
		$.ajax
			data: 'hash=' + @hash + '&confirm=Continue+as+Free+User'
			type: 'POST'
			url: @url
			beforeSend: @setUserAgent
			error: errorCallback
			success: (data) =>
				data = data.match /playlist: '(.*)',/

				if data isnt null and data.length is 2
					@vID = data[1]
					successCallback()
				else errorCallback()

	getFile: (successCallback, errorCallback) ->
		@hoster = @url.split 'file'
		@hoster = @hoster[0]

		$.ajax
			url: @hoster + @vID
			beforeSend: @setUserAgent
			error: errorCallback
			success: (data) =>
				@video = data.querySelector('content').getAttribute('url')
				successCallback()

	setUserAgent: (xhr) ->
		xhr.setRequestHeader 'User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20100101 Firefox/7.0.1'
