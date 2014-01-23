class Nowvideo
	constructor: (@url) ->
		if @url.indexOf('/video/') >= 0
			@url = @url.replace '/video/', '/mobile/index.php?id='

	parse: (successCallback, errorCallback) ->
		$.ajax
			url: @url
			error: errorCallback
			success: (data) ->
				file = data.match /<source src="(.*)" type="(.*)">/

				if file isnt null and file.length is 3
					@file = file[1]

					successCallback @file
				else errorCallback 'File not found'
