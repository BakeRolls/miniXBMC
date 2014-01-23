class Streamcloud
	constructor: (@url) ->
		@data = @url.split '/'

	parse: (@callback) =>
		$.ajax
			async: false
			data: $.param
				op: 'download1'
				id: @data[3]
				# most ugly way to remove the last n chars
				fname: @data[4].substr 0, @data[4].length - 5
			type: 'POST'
			url: @url
			error: @fail
			success: (data, status, xhr) =>
				url = data.match /file: "(.*)",/

				if typeof url is 'object' and url isnt null and url.length is 2
					@callback url[1]
				else @fail()

	fail: ->
		console.log 'failed'
