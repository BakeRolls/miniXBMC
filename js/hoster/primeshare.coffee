class Primeshare
	constructor: (@url) ->
		# primeshare is checking the user agent
		if @url.indexOf('mobile.primeshare.tv') is -1
			@url = @url.replace 'primeshare.tv', 'mobile.primeshare.tv'

		console.log @url

	parse: (successCallback, errorCallback) ->
		$.ajax
			url: @url
			error: errorCallback
			success: (data) ->
				file = data.match /<source src="(.*)" type='(.*)'>/

				if file isnt null and file.length is 3
					@file = file[1]

					successCallback @file
				else errorCallback 'File not found'
