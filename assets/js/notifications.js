$(function() {
  var API = '/app/services/user/Actions.cfc';
  var $toggle = $('#navNotifyToggle');
  var $dropdown = $('#navNotifyDropdown');
  var $list = $('#navNotifyList');
  var $badge = $('#notificationBadge');
  var $badgeMobile = $('#notificationBadgeMobile');
  var $badgeMenu = $('#notificationBadgeMenu');

  if (!$toggle.length) return;

  var activeTab = 'unread';

  // ─── Badge ───

  function setBadge(count) {
    [$badge, $badgeMobile, $badgeMenu].forEach(function($el) {
      if (count > 0) {
        $el.text(count > 99 ? '99+' : count).removeClass('d-none');
      } else {
        $el.addClass('d-none');
      }
    });
  }

  function updateBadgeCount(delta) {
    var count = parseInt($badge.text()) || 0;
    setBadge(count + delta);
  }

  // ─── Render ───

  function emptyMessage() {
    return activeTab === 'unread' ? 'No unread notifications' : 'No notifications yet';
  }

  function esc(str) {
    return $('<span>').text(str || '').html();
  }

  function buildItem(nt) {
    var isUnread = !nt.read;
    var kebab = '';

    if (isUnread) {
      kebab += '<li><a href="#" class="dropdown-item btn-notify-read" data-unid="' + nt.unid + '">'
            + '<i class="fa-solid fa-check me-2"></i>Mark as read</a></li>';
    }
    kebab += '<li><a href="#" class="dropdown-item btn-notify-delete text-danger" data-unid="' + nt.unid + '">'
          + '<i class="fa-solid fa-trash-can me-2"></i>Delete</a></li>';

    return '<div class="nav-notify-item' + (isUnread ? ' unread' : '') + '" data-unid="' + nt.unid + '">'
      + '<a href="' + esc(nt.link) + '" class="nav-notify-content">'
      + '<div class="nav-notify-text">' + nt.message + '</div>'
      + '<div class="nav-notify-time">' + nt.age + '</div>'
      + '</a>'
      + '<div class="dropdown flex-shrink-0">'
      + '<button class="kebab-btn" data-bs-toggle="dropdown" aria-expanded="false">'
      + '<i class="fa-solid fa-ellipsis-vertical"></i></button>'
      + '<ul class="dropdown-menu dropdown-menu-sm dropdown-menu-end">' + kebab + '</ul>'
      + '</div>'
      + '</div>';
  }

  function renderItems(items) {
    if (!items.length) {
      $list.html('<div class="text-muted small text-center py-3">' + emptyMessage() + '</div>');
      return;
    }
    var html = '';
    items.forEach(function(nt) { html += buildItem(nt); });
    $list.html(html);
  }

  // ─── Load ───

  function loadTab(tab) {
    $list.html('<div class="text-muted small text-center py-3">'
      + '<span class="spinner-border spinner-border-sm me-1"></span> Loading...</div>');
    $.getJSON(API + '?method=notifications&filter=' + tab, function(res) {
      if (res.success && res.data) {
        setBadge(res.data.count);
        renderItems(res.data.items);
      }
    });
  }

  // ─── Tabs ───

  $(document).on('click', '.nav-notify-tab', function(e) {
    e.preventDefault();
    var filter = $(this).data('filter');
    if (filter === activeTab) return;
    activeTab = filter;
    $('.nav-notify-tab').removeClass('active');
    $(this).addClass('active');
    loadTab(activeTab);
  });

  // ─── Toggle ───

  var loaded = false;

  $toggle.on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    var wasOpen = !$dropdown.hasClass('d-none');
    $dropdown.toggleClass('d-none');
    if (!wasOpen && !loaded) {
      loaded = true;
      loadTab(activeTab);
    }
  });

  $(document).on('click', function(e) {
    if (!$(e.target).closest('.nav-drop-wrap').length) {
      $dropdown.addClass('d-none');
    }
  });

  // ─── Mark All Read ───

  $('#btnMarkAllRead').on('click', function(e) {
    e.preventDefault();
    $.getJSON(API + '?method=mark_all_read', function(res) {
      if (res.success) {
        setBadge(0);
        $list.find('.nav-notify-item').removeClass('unread');
        $list.find('.btn-notify-read').closest('li').remove();
      }
    });
  });

  // ─── Per-Item Mark Read ───

  $(document).on('click', '.btn-notify-read', function(e) {
    e.preventDefault();
    var $btn = $(this);
    var unid = $btn.data('unid');
    var $item = $btn.closest('.nav-notify-item');
    $.post(API + '?method=notification_read', { unid: unid }, function(res) {
      if (res.success) {
        $item.removeClass('unread');
        $btn.closest('li').remove();
        updateBadgeCount(-1);
      }
    }, 'json');
  });

  // ─── Delete ───

  $(document).on('click', '.btn-notify-delete', function(e) {
    e.preventDefault();
    var $btn = $(this);
    var unid = $btn.data('unid');
    var $item = $btn.closest('.nav-notify-item');
    var wasUnread = $item.hasClass('unread');
    $btn.prop('disabled', true);
    $.post(API + '?method=notification_delete', { unid: unid }, function(res) {
      if (res.success) {
        $item.slideUp(200, function() {
          $(this).remove();
          if (wasUnread) updateBadgeCount(-1);
          if (!$list.find('.nav-notify-item').length) {
            $list.html('<div class="text-muted small text-center py-3">' + emptyMessage() + '</div>');
          }
        });
      } else {
        $btn.prop('disabled', false);
      }
    }, 'json');
  });
});
