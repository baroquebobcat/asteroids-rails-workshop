$(function() {
  // Ensures AJAX requests are properly formated so that Rails knows how to respond to them.
  $.ajaxSetup({
    beforeSend: function(xhr) {
      xhr.setRequestHeader("Accept", "text/javascript")
      var token = $("meta[name=csrf-token]").attr("content");
      xhr.setRequestHeader("X-CSRF-Token", token);
    }
  });
});
