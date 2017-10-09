
$(document).ready(function() {
  $('.datepicker').datepicker({
    format: "MM dd, yyyy",
    orientation: "auto bottom",
    todayHighlight: 'true',
    autoclose: 'true'
  });
});

$(document).ready(function () {
  $('.datetimepicker').datetimepicker();
    daysOfWeekDisabled: [0, 6]
});