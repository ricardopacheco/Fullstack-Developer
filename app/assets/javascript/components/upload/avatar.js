import $ from 'jquery'
window.jQuery = $;
window.$ = $;

$(document).on("change", "form.with-avatar-upload input[id=user_avatar_image]", function() {
  let form = $(this).closest("form");
  let submitBtn = $(this).closest("form").find("input[type=submit]");
  let progressContainer = $(this).closest("form").find("#progress-bar");
  let progressBar = progressContainer.find(".progress-bar");
  let file = this.files[0];
  let fileFormData = new FormData();
  fileFormData.append("file", file);

  $.ajax({
    url: '/images/upload',
    type: 'POST',
    data: fileFormData,
    processData: false,
    contentType: false,
    xhr: function() {
      let xhr = new window.XMLHttpRequest();
      xhr.upload.addEventListener("progress", function(e) {
        if (e.lengthComputable) {
          let percentComplete = Math.round(e.loaded / e.total * 100);
          progressBar.width(percentComplete + '%');
          progressBar.text(percentComplete + '%');
        }
      }, false);
      return xhr;
    },
    beforeSend: function() {
      submitBtn.attr("disabled", true);
      progressContainer.show();
      progressBar.width(0 + '%');
    },
    success: (data) => {
      form.find("input#user_avatar_image_hidden").val(JSON.stringify(data));
      progressBar.width(0 + '%');
      progressContainer.hide();
      submitBtn.attr("disabled", false);
    }
  });
});
