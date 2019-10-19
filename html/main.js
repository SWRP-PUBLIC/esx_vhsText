
$(function () {
	window.addEventListener('message', function (event) {
		switch (event.data.action) {
			case 'changeTime':
				$('#time').html(event.data.data)
				break;
			case 'changeJob':
				if (event.data.data == 'none') {
					$('body').css('display', 'none')
				} else {
					$('body').css('display', 'unset')
					$('#job').html(event.data.data)
				}
				break;
		}
	})
})