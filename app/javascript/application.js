// Entry point for the build script in your package.json
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import './add_jquery'
import "core-js/stable";
import "regenerator-runtime/runtime";
require("turbolinks").start()
require("@rails/activestorage").start()

require("chartkick")
require("chart.js")
require("./adminlte")
import 'chosen-js'
import 'bootstrap-datepicker'
import * as bootstrap from "bootstrap"

document.addEventListener("turbolinks:load", () => {
  $('.chosen-select').chosen();
  $('.datepicker').datepicker(
    {
      autoClose: true,
      format: 'dd/mm/yyyy',
      orientation: 'bottom auto',
      todayBtn: 'linked'
    });
  $('.datepicker-month').datepicker(
    {
      format: 'dd/mm/yyyy',
      viewMode: "months",
      minViewMode: "months",
      autoClose: true,
      orientation: 'bottom auto',
      todayBtn: 'linked',
      todayHighlight: true
    });
})


document.addEventListener('turbo:load', ready);
var ready = function () {
  return $(window).trigger('resize');
};

document.addEventListener("turbo:load", function () {
  $(function () {
    $('[data-toggle="tooltip"]').tooltip();
    $('[data-toggle="popover"]').popover();
    $('[data-toggle="dropdown"]').dropdown();

  })
})