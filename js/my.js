var opts = {
  lines: 8, // The number of lines to draw
  length: 10, // The length of each line
  width: 4, // The line thickness
  radius: 10, // The radius of the inner circle
  corners: 1, // Corner roundness (0..1)
  rotate: 0, // The rotation offset
  direction: 1, // 1: clockwise, -1: counterclockwise
  color: '#fff', // #rgb or #rrggbb or array of colors
  speed: 2, // Rounds per second
  trail: 60, // Afterglow percentage
  shadow: false, // Whether to render a shadow
  hwaccel: false, // Whether to use hardware acceleration
  className: 'spinner', // The CSS class to assign to the spinner
  zIndex: 2e9, // The z-index (defaults to 2000000000)
  top: 'auto', // Top position relative to parent in px
  left: 'auto' // Left position relative to parent in px
};
var spinner = new Spinner(opts);


document.addEventListener('page:fetch', function() {
    $('.inner.cover').addClass('animated fadeOutDown');
    var target = document.getElementById('wrap');
    spinner.spin(target);
});

document.addEventListener('page:load', function() {
    $('.inner.cover').addClass('animated fadeInUp');
    $('.inner.cover').one('webkitAnimationEnd oanimationend msAnimationEnd animationend',
        function(e) {
            $('.inner.cover').removeClass('animated');
        });
    });
       
document.addEventListener('page:restore', function () {
    $('.inner.cover').removeClass('fadeOutDown');
    spinner.stop();
});
