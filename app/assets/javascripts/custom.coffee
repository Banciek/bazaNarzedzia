#function for flash animation
flash = ->
	$('#flash').slideDown('slow')
	setTimeout ( ->
		$('#flash').slideUp('slow') 
	), 2500

#function to serialize arrays for cookies
cookiefy = (array) ->
	temp = array.join()
	return temp

#make array from cookie: ',' sliced
arrayfy = (string) ->
	n = 0
	temp = []
	t = ""
	for i in [0..(string.length)]
		if string[i] == ',' || i == string.length
			temp.push(t)
			t = ""
		else
			t = t+string[i]
	return temp

#removing correct value from array when folding
folded = (array, id) ->
	for i in [0..(array.length-1)]
		array.splice(i,1) if array[i] == id
	return array

#function for checking and expanding correct employee
#replaced by rails companies/expanded
expand = ->
	if (document.cookie.indexOf('expanded') > -1 )
		temp = arrayfy(Cookies.get('expanded'))
		k = $('.expandable')
		for n in [0..k.length-1]
			for i in [0..(temp.length-1)]
				t = '.expandable:eq('+n+')'
				if $(t).attr("data-collapse-id") == temp[i]
					$(t).collapse('show')
			
	#alert('ok')



$(document).on "ready, page:change, page:update", -> 
	#check and expand correct employee
	#expand()

	#turn on bs tooltip handling
	$('[data-toggle="tooltip"]').tooltip()
	$('[data-toggle="tooltip"]').on "click, mouseleave", ->
		$('[data-toggle="tooltip"]').tooltip('hide')

	#cookies acceptance
	$('#accept_cookies_button').click ->
		Cookies.set('cookies_ok', 'true', { expires: 365*20 })
		$('#accept_cookies').fadeOut()

	#handling drag and drop tools part pulpit elements	
	$('#tools-part .tool').draggable
		cursorAt: {left: 0, top: 0}
		revert: "invalid"
		helper: ->
			$(this).find('td:nth-child(2)').clone().addClass('cloned col-sm-6')
		start: ->
			$(this).addClass('active')
			tool_id = $(this).attr("data-tool-id")

			$('#employees-part .card').droppable
				tolerance: 'pointer'
				disabled: false
				activeClass: 'dropHere'
				hoverClass: 'dropHover'
				drop: ->
					card_id = $(this).attr("data-card-id")
					employee_id = $(this).closest('li').attr("id")
					$.ajax
						type: "PUT"
						url: '/tool_assign'
						dataType: 'script'
						data: {tool_id: tool_id, tools_card_id: card_id, employee_id: employee_id}


			$('#employees-part #employee-tool').droppable
				tolerance: 'pointer'
				disabled: false
				activeClass: 'dropHereTable'
				hoverClass: 'dropHoverTable'
				drop: ->
					employee_id = $(this).closest('li').attr("id")
					$.ajax
						type: "PUT"
						url: '/tool_assign'
						dataType: 'script'
						data: {tool_id: tool_id, employee_id: employee_id}

		stop: ->
			$(this).removeClass('active')
			$('#employees-part .card').droppable
				disabled: true
			$('#employees-part #employee-tool').droppable
				disabled: true
				

	#handling drag and drop employees part pulpit elements
	$('#employees-part .tool').draggable({ 
		cursorAt: {left: 0, top: 0}
		revert: "invalid"
		helper: ->
			$(this).find('td:nth-child(2)').clone().addClass('cloned col-sm-6').css('text-align', 'center')
		start: ->
			$(this).addClass('active')
			tool_id = $(this).attr("data-tool-id")
			#alert(tool_id)
			$(this).closest('.row').find('.card').droppable({
				tolerance: 'pointer'
				disabled: false
				activeClass: 'dropHere'
				hoverClass: 'dropHover'
				drop: ->
					card_id = $(this).attr("data-card-id")
					#alert(card_id)
					$.ajax
						type: "PUT"
						url: '/tool_assign'
						dataType: 'script'
						data: {tool_id: tool_id, tools_card_id: card_id}

			})	
		stop: -> 
			$(this).removeClass('active')
			$(this).closest('.row').find('.card').droppable({
				disabled: true
			})
		})

	#pulpit employee menu: folding and expanding
	$('#fold').click (event) ->
		event.preventDefault();
		$('.expandable').collapse('hide')

	$('#expand').click (event) ->
		event.preventDefault();
		$('.expandable').collapse('show')


	#pulpit detailed or not detailed
	$('.expandable').on "show.bs.collapse", -> 
		id = $(this).attr("data-collapse-id")
		temp = arrayfy(Cookies.get('expanded')) if (document.cookie.indexOf('expanded') > -1 )
		temp = [] if (document.cookie.indexOf('expanded') == -1 )
		temp.push(id)
		Cookies.remove('expanded')
		Cookies.set('expanded', cookiefy(temp), { expires: 365*20 })
			
		
	$('.expandable').on "hide.bs.collapse", ->
		if (document.cookie.indexOf('expanded') > -1 )
			id = $(this).attr("data-collapse-id")
			temp = arrayfy(Cookies.get('expanded'))
			folding = folded(temp, id)
			if folding.length == 0
				Cookies.remove('expanded')
			else
				Cookies.remove('expanded')
				Cookies.set('expanded', cookiefy(folding), { expires: 365*20 })
		
	#pulpit- handling withdraw tool from user and tools card
	$('a.withdraw').click (event) ->
		event.preventDefault()
		id = $(this).closest('.tool').attr("data-tool-id")
		$.ajax
			type: "PUT"
			url: '/tool_withdraw'
			dataType: "script"
			data: {tool_id: id}	

	$('.tool a.pick').click (event) ->
		event.preventDefault()
		id = $(this).closest('.tool').attr("data-tool-id")
		$.ajax
			type: "PUT"
			url: '/tool_pick'
			dataType: "script"
			data: {tool_id: id}

	#picking tool from card on tools_cards show
	$('.tool a.pick-on-show').click (event) ->
		#event.preventDefault()
		id = $(this).closest('.tool').attr("data-tool-id")
		#alert(id)
		$.ajax
			type: "PUT"
			url: '/tool_pick_on_show'
			dataType: "html"
			data: {tool_id: id}

	#pulpit - which tool bealongs to which card
	$('.card').mouseenter ->
		card_id = $(this).attr("data-card-id")
		$('.tool[data-card-id="'+card_id+'"]').addClass('dropHereTable')
	$('.card').mouseleave ->
		card_id = $(this).attr("data-card-id")
		$('.tool[data-card-id="'+card_id+'"]').removeClass('dropHereTable')
	$('.tool').mouseenter ->
		card_id = $(this).attr("data-card-id")
		$('.card[data-card-id="'+card_id+'"]').addClass('dropHere')
	$('.tool').mouseleave ->
		card_id = $(this).attr("data-card-id")
		$('.card[data-card-id="'+card_id+'"]').removeClass('dropHere')	
		#alert(card_id)


	#redirecting to tools card show page, shocky but its easier way than make whole card link_to
	$('.card').click (e) ->
		if !$(e.target).hasClass('glyphicon')
			card_id = $(this).attr("data-card-id")
			window.location.href = '/tools_cards/'+card_id

$(document).on "ready", ->
	flash()

