$(document).ready ->
	if localStorage['address'] is undefined
		localStorage['address'] = ''

	$('input[name="address"]').val localStorage['address']
	$('input[name="address"]').on 'keyup', (event) ->
		$('.address input').css 'border-color', '#333'
		localStorage['address'] = $(event.target).val()
		testAddress()

	testAddress()

	$('input[name="playurl"]').on 'click', playUrl

	$('input[name="reseturl"]').on 'click', ->
		$('input[name="url"]').val ''

	$('input[name="clipboard"]').on 'click', ->
		cordova.plugins.clipboard.paste (text) =>
			$('input[name="url"]').val text
			playUrl()

	$('input[name="url"]').on 'click', ->
		this.select()

	$('input[name="toggle"]').on 'click', ->
		callAPI
			id: 1
			jsonrpc: '2.0'
			method: 'Player.PlayPause'
			params: playerid: 1
		, (data, status, xhr) ->
			$('.debug').text 'Toggled'
		, (xhr, errorType, error) ->
			$('.debug').text 'Error: ' + error

	$('input[name="volume"]').on 'change', (event) ->
		callAPI
			id: 1
			jsonrpc: '2.0'
			method: 'Application.SetVolume'
			params: volume: parseInt $(event.target).val()
		, (data, status, xhr) ->
			$('.debug').text 'Set Volume'
		, (xhr, errorType, error) ->
			$('.debug').text 'Error: ' + error

playUrl = ->
	if $('input[name="url"]').val() isnt ''
		parseVideoURL $('input[name="url"]').val(), (url) ->
			$('input[name="url"]').val url

			callAPI
				id: 1
				jsonrpc: '2.0'
				method: 'Player.Open'
				params: item: file: url
			, (data, status, xhr) ->
				$('.debug').text 'Sent video'
			, (xhr, errorType, error) ->
				$('.debug').text 'Error: ' + error
		, (error) -> $('.debug').text 'Error: ' + error

callAPI = (data, successCallback, errorCallback) ->
	if typeof data is 'object'
		data = JSON.stringify data

	$.ajax
		contentType: 'application/json'
		data: data
		type: 'POST'
		url: localStorage['address'] + 'jsonrpc'
		success: (data, status, xhr) ->
			successCallback data, status, xhr
		error: (xhr, errorType, error) ->
			errorCallback xhr, errorType, error

testAddress = ->
	callAPI
		id: 1,
		jsonrpc: '2.0'
		method: 'JSONRPC.Introspect'
		params:
			filter:
				id: 'AudioLibrary.GetAlbums'
				type: 'method'
	, ->
		$('.debug').text 'Connected'
		$('.address input').css 'border-color', 'lightgreen'
	, ->
		$('.debug').text 'Could not connect to host'
		$('.address input').css 'border-color', 'red'

parseVideoURL = (url, successCallback, errorCallback) ->
	hoster = new Primeshare url  if url.indexOf('primeshare.tv')  >= 0
	hoster = new Nowvideo url    if url.indexOf('nowvideo.ch')    >= 0
	hoster = new Streamcloud url if url.indexOf('streamcloud.eu') >= 0
	hoster = new Sockshare url   if url.indexOf('sockshare.com')  >= 0 or url.indexOf('putlocker.com') >= 0

	if typeof hoster is 'object'
		hoster.parse (url) ->
			successCallback url
		, (error) -> errorCallback error
	else if url.indexOf('http') is 0
		successCallback url
	else errorCallback 'No URL'
