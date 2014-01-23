class Streamcloud
	constructor: (@url) ->
		@data = @url.split '/'

	parse: (successCallback, errorCallback) =>
		$.ajax
			data: $.param
				op: 'download1'
				id: @data[3]
				# most ugly way to remove the last n chars
				fname: @data[4].substr 0, @data[4].length - 5
			type: 'POST'
			url: @url
			error: errorCallback
			success: (data, status, xhr) =>
				url = data.match /file: "(.*)",/

				if typeof url is 'object' and url isnt null and url.length is 2
					@file = url[1]

					successCallback @file
				else errorCallback 'File not found.'
