$(function () {
  if (!mapUsers || !mapUsers.length) {
    $('#member-map').html(
      "<div class='d-flex align-items-center justify-content-center h-100 text-muted'>" +
        "<div class='text-center'><i class='fa-solid fa-map-location-dot fa-3x mb-3'></i>" +
        "<div>No members with location data yet.</div></div></div>"
    );
    return;
  }

  var map = L.map('member-map').setView([39.8, -98.5], 4);

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    maxZoom: 18
  }).addTo(map);

  var markers = L.markerClusterGroup();

  mapUsers.forEach(function (u) {
    var popup =
      "<div class='text-center' style='min-width:120px'>" +
        "<img src='" + u.img + "' " +
          "onerror=\"this.src='" + u.placeholder + "'\" " +
          "class='rounded-circle mb-2' width='64' height='64' />" +
        "<div class='fw-semibold'>" +
          "<a href='" + u.link + "' class='text-decoration-none'>" + u.user + "</a>" +
        "</div>" +
        (u.name ? "<div class='small text-muted'>" + u.name + "</div>" : "") +
        (u.location ? "<div class='small text-muted'>" + u.location + "</div>" : "") +
      "</div>";

    var marker = L.marker([u.lat, u.lng]).bindPopup(popup);
    markers.addLayer(marker);
  });

  map.addLayer(markers);
  map.fitBounds(markers.getBounds().pad(0.1));
});
