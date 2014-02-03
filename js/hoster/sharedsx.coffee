class SharedSx
	constructor: (@url) ->

	parse: (successCallback, errorCallback) ->
		$.ajax
			url: @url
			error: errorCallback
			success: (data) ->
				file = data.match /<div class="stream-content" data-url="(.*)" data-name="(.*)" data-title="(.*)" data-poster="">/
				console.log file

				if file isnt null and file.length is 4
					@file = file[1]

					successCallback @file
				else errorCallback 'File not found'
