$(document).ready(function() {
  $('form.new_micropost textarea').keyup(function () {
    var left = 140 - $(this).val().length,
        counter = $('form.new_micropost .counter');
    if (left < 0) {
      counter.addClass('bad');
      counter.removeClass('quiet');
    } else {
      counter.addClass('quiet');
      counter.removeClass('bad');
    }
    counter.text(left);
  });
});