$( document ).on('turbolinks:load', function() {
  $('.datepicker').datepicker({
    format: "MM dd, yyyy",
    orientation: "auto bottom",
    todayHighlight: 'true',
    autoclose: 'true'
  });
});

$( document ).on('turbolinks:load', function() {
  $('.datetimepicker').datetimepicker();
    daysOfWeekDisabled: [0, 6]
});
