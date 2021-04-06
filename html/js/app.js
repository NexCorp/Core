(() => {

	NEX = {};

	NEX.CreateNotification = function(data) {
		var $notification = $(document.createElement('div'));
		$notification.addClass('notification').addClass(data.type);

		var text = "Alerta General"
	
		if (data.title !== null && data.title !== undefined){
			text = data.title
		}else{
			if (data.type === "success") {
				text = "¡Éxito!"
			} else if (data.type === "inform" || data.type === "info") {
				text = "Información:"
			} else {
				text = "¡Whoops!"
			}
		}
		
		$notification.html('\
		<h3 class="notifheader">' + text + '</h3>\
		<hr style="position: relative; margin-top: -3%;">\
		<p style="margin-top: 3%; font-size: 13px;">' + data.text + '</p>');
		$notification.fadeIn();
		if (data.style !== undefined) {
			Object.keys(data.style).forEach(function(css) {
				$notification.css(css, data.style[css])
			});
		}
	
	
		return $notification;
	}

	NEX.ShowNotif = function(data) {
		if (data.persist === undefined) {
			var $notification = NEX.CreateNotification(data);
			$('.notif-container').append($notification);
			setTimeout(function() {
				$.when($notification.fadeOut()).done(function() {
					$notification.remove()
				});
			}, data.length != null ? (data.length + 1000) : 2500);
		} else {
			if (data.persist.toUpperCase() == 'START') {
				if (persistentNotifs[data.id] === undefined) {
					var $notification = NEX.CreateNotification(data);
					$('.notif-container').append($notification);
					persistentNotifs[data.id] = $notification;
				} else {
					let $notification = $(persistentNotifs[data.id])
					$notification.addClass('notification').addClass(data.type);
					$notification.html(data.text);
	
					if (data.style !== undefined) {
						Object.keys(data.style).forEach(function(css) {
							$notification.css(css, data.style[css])
						});
					}
				}
			} else if (data.persist.toUpperCase() == 'END') {
				let $notification = $(persistentNotifs[data.id]);
				$.when($notification.fadeOut()).done(function() {
					$notification.remove();
					delete persistentNotifs[data.id];
				});
			}
		}
	}

	NEX.HUDElements = [];

	NEX.setHUDDisplay = function (opacity) {
		$('#hud').css('opacity', opacity);
	};

	NEX.insertHUDElement = function (name, index, priority, html, data) {
		NEX.HUDElements.push({
			name: name,
			index: index,
			priority: priority,
			html: html,
			data: data
		});

		NEX.HUDElements.sort((a, b) => {
			return a.index - b.index || b.priority - a.priority;
		});
	};

	NEX.updateHUDElement = function (name, data) {
		for (let i = 0; i < NEX.HUDElements.length; i++) {
			if (NEX.HUDElements[i].name == name) {
				NEX.HUDElements[i].data = data;
			}
		}

		NEX.refreshHUD();
	};

	NEX.deleteHUDElement = function (name) {
		for (let i = 0; i < NEX.HUDElements.length; i++) {
			if (NEX.HUDElements[i].name == name) {
				NEX.HUDElements.splice(i, 1);
			}
		}

		NEX.refreshHUD();
	};

	NEX.refreshHUD = function () {
		$('#hud').html('');

		for (let i = 0; i < NEX.HUDElements.length; i++) {
			let html = Mustache.render(NEX.HUDElements[i].html, NEX.HUDElements[i].data);
			$('#hud').append(html);
		}
	};

	NEX.inventoryNotification = function (add, label, count) {
		let notif = '';

		if (add) {
			notif += '+';
		} else {
			notif += '-';
		}

		if (count) {
			notif += count + ' ' + label;
		} else {
			notif += ' ' + label;
		}

		let elem = $('<div class="notify">' + notif + '</div>');
		$('#inventory_notifications').append(elem);

		$(elem).delay(3000).fadeOut(1000, function () {
			elem.remove();
		});
	};

	window.onData = (data) => {
		switch (data.action) {
			case 'setHUDDisplay': {
				NEX.setHUDDisplay(data.opacity);
				break;
			}

			case 'insertHUDElement': {
				NEX.insertHUDElement(data.name, data.index, data.priority, data.html, data.data);
				break;
			}

			case 'updateHUDElement': {
				NEX.updateHUDElement(data.name, data.data);
				break;
			}

			case 'deleteHUDElement': {
				NEX.deleteHUDElement(data.name);
				break;
			}

			case 'inventoryNotification': {
				NEX.inventoryNotification(data.add, data.item, data.count);
			}
		}
	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			NEX.ShowNotif(event.data);
			onData(event.data);
		});
	};

})();
