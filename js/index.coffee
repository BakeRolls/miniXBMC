$(document).ready ->
	if localStorage['address'] is undefined
		localStorage['address'] = ''

	$('input[name="address"]').val localStorage['address']
	$('input[name="address"]').on 'keyup', (event) ->
		$('.address input').css 'border-color', '#333'
		localStorage['address'] = $(event.target).val()
		testAddress()

	testAddress()

	$('input[name="playurl"]').on 'click', (event) ->
		if $('input[name="url"]').val() isnt ''
			parseVideoURL $('input[name="url"]').val(), (url) ->
				callAPI
					id: 1
					jsonrpc: '2.0'
					method: 'Player.Open'
					params: item: file: url
				, ->
			, ->

	$('input[name="reseturl"]').on 'click', ->
		$('input[name="url"]').val ''

	$('input[name="url"]').on 'click', ->
		this.select()

	$('input[name="toggle"]').on 'click', ->
		callAPI
			id: 1
			jsonrpc: '2.0'
			method: 'Player.PlayPause'
			params: playerid: 1
		, (data, status, xhr) ->
			console.log 'okay'
		, (xhr, errorType, error) ->
			alert('error ' + error);

	$('input[name="volume"]').on 'change', (event) ->
		callAPI
			id: 1
			jsonrpc: '2.0'
			method: 'Application.SetVolume'
			params: volume: parseInt $(event.target).val()
		, (data, status, xhr) ->
			console.log 'okay'
		, (xhr, errorType, error) ->
			alert('error ' + error);

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
		$('.address input').css 'border-color', 'lightgreen'
	, ->
		$('.address input').css 'border-color', 'red'

parseVideoURL = (url, successCallback, errorCallback) ->
	if url.indexOf('streamcloud.eu') >= 0
		hoster = new Streamcloud url

	if url.indexOf('sockshare.com') >= 0 or url.indexOf('putlocker.com') >= 0
		hoster = new Sockshare url

	hoster.parse (url) ->
		$('.playurl input[type="text"]').val url

		callAPI
			id: 1
			jsonrpc: '2.0'
			method: 'Player.Open'
			params: item: file: url
		, (data, status, xhr) ->
			console.log 'okay'
		, (xhr, errorType, error) ->
			alert('error ' + error);
	, (error) ->
		alert error

	if url.match '$https?://'
		return successCallback url

	errorCallback()
