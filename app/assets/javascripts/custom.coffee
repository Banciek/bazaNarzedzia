
$(document).on "ready, page:change", -> 
	$('[data-toggle="tooltip"]').tooltip()
	$('#accept_cookies_button').click ->
		Cookies.set('cookies_ok', 'true', { expires: 365*20 })
		$('#accept_cookies').fadeOut()


$(document).on "page:change",->
	$('#flash').slideDown('slow')
	setTimeout ( ->
		$('#flash').slideUp('slow') 
	), 3500
	
