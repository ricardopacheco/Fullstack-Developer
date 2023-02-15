import $ from 'jquery'
window.jQuery = $;
window.$ = $;

import 'block-ui/jquery.blockUI'

$(document).on("change", "form.with-spreadsheet-upload input[id=import_file]", function() {
  console.log('Change event triggered');
  let form = $(this).closest("form");
  let submitBtn = form.find("input[type=submit]");
  submitBtn.attr("disabled", true);

  form.block({ message: '<h4>Enviando ...</h4>' });
  form.submit();
});
