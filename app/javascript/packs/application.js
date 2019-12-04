// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()

require('adminlte')
require("chartkick")
require("chart.js")
require("trix")
require("@rails/actiontext")
import AutoNumeric from 'autonumeric';

import "bootstrap"
import 'chosen-js'
import 'bootstrap-datepicker'


document.addEventListener("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
  $('.chosen-select').chosen();



  $('.datepicker').datepicker(
    {
      format: 'dd/mm/yyyy',
      autoclose: true
    });
    $('.datepicker-month').datepicker(
      {
        format: 'dd/mm/yyyy',
        viewMode: "months",
        minViewMode: "months"
      });
})

document.addEventListener('turbolinks:load', ready);
var ready = function () {
    return $(window).trigger('resize');
};

document.addEventListener('turbolinks:load', ready);
