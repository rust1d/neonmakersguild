$(function () {
  var w = $(window).width() * .50;
  var h = $(window).height() * .75;
  
  $("#dialog").dialog({
      autoOpen: false,
      modal: true,
      width: w,
      height: h,
      buttons: {
          "Dismiss": function () {
              $(this).dialog("close");
          }
      },
  });

  $(".ui-dialog-title").css({"font-size": +16+"px"}); 
  $(".dialogify").on("click", function (e) {
      e.preventDefault();
      $("#dialog").html("");
      $("#dialog").dialog("option", "title", "Loading...").dialog("open");
      $("#dialog").load(this.href, null, function () {
          $(this).dialog("option", "title", $(this).find("h1").text());
          $(this).find("h1").remove();
      });
  });
});