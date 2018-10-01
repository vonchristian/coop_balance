$( document ).on('turbolinks:load', function() {
  $('.datepicker').datepicker({
    format: "MM dd, yyyy",
    orientation: "auto bottom",
    todayHighlight: 'true',
    autoclose: 'true'
  });
});

$( document ).on('turbolinks:load', function() {
  $('[data-toggle="tooltip"]').tooltip()
})
$( document ).on('turbolinks:load', function() {
  $('[data-toggle="popover"]').popover()
})
