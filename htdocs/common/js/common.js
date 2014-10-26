window.console = window.console || {
	log: function() {}
};
var Ha = window.Ha || {};
Ha.notify = {
	toggleSpeed: 200,
	easing: 'swing',
	delay: 2000,
	color: 'rgba(255, 238, 150, 1)',
	textColor: '#111',
	handlerNotification: null,
	visibleNotification: false,
	timeout: 2,
	can_display_message: true,
	show: function (message, type, notification_color){
		var self = this;
		type = typeof(type) != 'undefined' ? type : 'normal';
		notification_color = typeof(notification_color) != 'undefined' ? notification_color : 'info';

		if(notification_color == 'success') {
			self.color = '#5EB95E';
			self.textColor = '#fff';
		}
		else if(notification_color == 'error') {
			self.color = '#F2DEDE';
			self.textColor = '#B94A48';
		}
		else {
			self.color = 'rgba(255, 238, 150, 1)';
			self.textColor = '#111';
		}
		$('.ajax-notification-bar').show();
		$('.ajax-notification-bar').append('<p>'+message+'</p>');
		$('.ajax-notification-bar').css('background-color', self.color);
		$('.ajax-notification-bar p').css('color', self.textColor);
		$('.ajax-notification-bar p').last().delay(self.toggleSpeed/2).animate({
			opacity: 1,
			paddingLeft: '+=20'
		}, self.toggleSpeed/2, self.easing);

		$('.ajax-notification-bar p').last().slideDown(self.toggleSpeed, self.easing, function() {
			if(type == 'normal') {
				if(!self.visibleNotification) {
					clearTimeout(self.timeout);
					self.timeout = setTimeout(Ha.notify.hideNotification, self.delay);
				}
				self.visibleNotification = true;
			}
			else if(type == 'error') {
				clearTimeout(self.timeout);
			}
			self.show_notification_close_button();
		});

		$('.ajax-notification-bar').unbind('click');
		$('.ajax-notification-bar').click(function() {
			self.hide_notification_close_button();
			$('.ajax-notification-bar p').slideUp(self.toggleSpeed, self.easing, function() {
				$(this).remove();
				$('.ajax-notification-bar').hide();
			});
			self.visibleNotification = false;
		});
	},
	show_notification_close_button: function() {
		$('.ajax-notification-bar .close').show();
		$('.ajax-notification-bar .close').animate({
			opacity: 0.2
		}, Ha.notify.toggleSpeed, Ha.notify.easing);
	},
	hide_notification_close_button: function() {
		$('.ajax-notification-bar .close').animate({
			opacity: 0
		}, Ha.notify.toggleSpeed/3, Ha.notify.easing, function() {
			$('.ajax-notification-bar .close').hide();
		});
	},
    hideNotification: function() {
		if(Ha.notify.visibleNotification === true) {
			if($('.ajax-notification-bar p').length == 1) {
				Ha.notify.hide_notification_close_button();
			}
			$('.ajax-notification-bar p').first().animate({
				opacity: 0
			}, Ha.notify.toggleSpeed/2, Ha.notify.easing);
			$('.ajax-notification-bar p').first().slideUp(Ha.notify.toggleSpeed, Ha.notify.easing, function() {
				$('.ajax-notification-bar p').first().remove();
				if($('.ajax-notification-bar p').length === 0) {
					Ha.notify.visibleNotification = false;
					clearTimeout(Ha.notify.timeout);
					$('.ajax-notification-bar').hide();
				}
				else {
					clearTimeout(this.timeout);
					this.timeout = setTimeout(Ha.notify.hideNotification, this.delay/2);
				}
			});
		}
	}
};

Ha.common = {
	ajax: function(url, dataType, queryData, type, maskEid, callback, force){
		var self = {
			maskEid: maskEid || 'container',
			url:  url || '',
			dataType:  dataType || 'json',
			queryData:  queryData || '',
			type: type || 'get'
		};
		Ha.mask.show(self.maskEid);
		$.ajax({
			dataType: self.dataType,
			url: self.url,
			data: self.queryData,
			type: self.type,
			success: function(data){
				if (typeof(force) == 'undefined') {
					Ha.common.show(data);
				}
				if (typeof(callback) == 'function') {
					callback(data);
				}
			},
			complete: function(){
				Ha.mask.clear(Ha.common.maskEid);
			},
			error: function(e){
				
			}
		});
	},
	show: function(data) {
		var alertclassname = '';
		switch (data.status){
			case 0: alertclassname = 'success'; break;
			case 1: alertclassname = 'error'; break;
		}
		Ha.notify.show(data.msg, '', alertclassname);
	},
	loadImg: function(ele, extra) {
		var def = {
			left: 0,
			right: 0,
			top: 100,
			bottom: 100
		};
		def = $.extend(true, def, extra);
		var div = document.createElement('div');
		div.style.height = '24px';
		div.style.width = '24px';
		if ($('#' + ele).width() > 24) {
			div.style.marginLeft = ($('#' + ele).width() / 2 - 12) + 'px';
		}
		if ($('#' + ele).height() > 24) {
			div.style.marginTop = ($('#' + ele).height() / 2 - 12) + 'px';
		}
		def.bottom > 0 && (div.style.marginBottom = def.bottom + 'px');
		def.top > 0 && (div.style.marginTop = def.top + 'px');
		div.innerHTML = '<i class="i_loading"></i>';
		$('#' + ele).html(div);
	},
	showItemTips: function(tipsContent, offsetElement, extra) {
		var TIPS_TIMEOUT = {};
		var TIPS_SHOW_TIMEOUT = {};
		var index = 1;
		return function() {
			tipsId = (extra && typeof(extra['id']) != 'undefined') ? extra['id'] : ('f_win_tips' + index++);
			tipsTop = (extra && typeof(extra['top']) != 'undefined') ? extra['top'] : -20;
			tipsLeft = (extra && typeof(extra['left']) != 'undefined') ? extra['left'] : -67;
			autoClose = (extra && typeof(extra['autoClose']) != 'undefined') ? extra['autoClose'] : true;
			if (TIPS_TIMEOUT[tipsId]) {
				clearTimeout(TIPS_TIMEOUT[tipsId]);
			}
			pos = $(offsetElement).offset();
			cla = (extra && typeof(extra['cla']) != 'undefined') ? extra['cla'] : 'i_orderu';
			tipsQ = '<div id="' + tipsId + '" class="tips"> <i class="' + cla + '"></i> ' + ' <p>' + tipsContent + '</p>' + ' </div>';
			if (!$('#' + tipsId)[0]) {
				$(tipsQ).appendTo('body');
			}
			tipsTop = -27;
			tipsLeft = -12;
			tipsStyle = {
				'top': (pos.top - $('#' + tipsId).height() + tipsTop) + 'px',
				'left': (pos.left + tipsLeft) + 'px',
				'display': 'none'
			};
			tipsTop = 8;
			tipsLeft = -12;
			tipsStyle = {
				'top': (pos.top + $(offsetElement).height() + tipsTop) + 'px',
				'left': (pos.left + tipsLeft) + 'px',
				'display': 'none'
			};
			tipsTop = -10;
			tipsLeft = 10;
			tipsStyle1 = {
				'top': (pos.top + tipsTop) + 'px',
				'left': (pos.left + $(offsetElement).width() + tipsLeft) + 'px',
				'display': 'none'
			};
			tipsTop = -10;
			tipsLeft = -30;
			tipsStyle1 = {
				'top': (pos.top + tipsTop) + 'px',
				'left': (pos.left - $('#' + tipsId).width() + tipsLeft) + 'px',
				'display': 'none'
			};
			$('#' + tipsId).css(tipsStyle);
			$('#' + tipsId).mouseover(function() {
				clearTimeout(TIPS_TIMEOUT[tipsId]);
			});
			$('#' + tipsId).mouseout(function() {
				clearTimeout(TIPS_TIMEOUT[tipsId]);
				TIPS_TIMEOUT[tipsId] = setTimeout(function() {
					$('#' + tipsId).fadeOut();
				}, 200);
			});
			$(offsetElement).mouseout(function() {
				if (TIPS_SHOW_TIMEOUT[tipsId]) {
					clearTimeout(TIPS_SHOW_TIMEOUT[tipsId]);
				}
				if (TIPS_TIMEOUT[tipsId]) {
					clearTimeout(TIPS_TIMEOUT[tipsId]);
				}
				var id = $(this).attr('id');
				TIPS_TIMEOUT[tipsId] = setTimeout(function() {
					$('#' + tipsId).fadeOut();
				}, 200);
			});
			$('div.tips').fadeOut();
			TIPS_SHOW_TIMEOUT[tipsId] = setTimeout(function() {
				$('#' + tipsId).fadeIn();
			}, 300);
		}();
	}
};


Ha.mask = {
	prefix: 'mask',
	show: function(id, extra) {
		var that = this;
		var style = function() {
			if ($('#' + id).length > 0) {
				return {
					width: $('#' + id).width(),
					height: $('#' + id).height(),
					offset: $('#' + id).offset(),
					padding: $('#' + id).css('padding')
				};
			}
			return null;
		}();
		if (style) {
			$('<div id="' + that.prefix + id + '"><i class="i_loading"></i>&nbsp;数据加载中...</div>').css({
				height: style.height + 'px',
				left: style.offset.left + 'px',
				position: 'absolute',
				padding: style.padding,
				'padding-top': '80px',
				top: style.offset.top + 'px',
				'text-align': 'center',
				width: style.width + 'px',
				background: '#FFF',
				'opacity': 0.4,
				'z-index': 50
			}).appendTo('body');
		}
	},
	clear: function(id) {
		if (id && $('#' + this.prefix + id).length > 0) {
			$('#' + this.prefix + id).remove();
		} else {
			$('div[id^="' + this.prefix + '"]').each(function() {
				$(this).remove();
			});
		}
	}
};


$(function(){
  $('table .dropdown-menu').on('click', 'a', function(e){
    e.preventDefault();
    $(this).parent().parent().parent().parent().find('input').val($(this).text());
  });
});