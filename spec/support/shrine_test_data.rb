# frozen_string_literal: true

# This module was created to help keep tests fast, avoiding expensive operations
# such as file processing and metadata extraction. With this module, we can create
# a helper method to create attached file data for us to use with our factories/fixtures.
module ShrineTestData
  module_function

  def image_data
    attacher = Shrine::Attacher.new
    attacher.set(uploaded_image)

    attacher.set_derivatives(
      large:  uploaded_image,
      medium: uploaded_image,
      small:  uploaded_image,
      thumbnail: uploaded_image
    )

    attacher.column_data
  end

  def uploaded_image
    file = File.open(Rails.root.join('spec/fixtures/profile_photo.png'), binmode: true)

    # for performance we skip metadata extraction and assign test metadata
    uploaded_file = Shrine.upload(file, :store, metadata: false)
    uploaded_file.metadata.merge!(
      "size"      => File.size(file.path),
      "width"     => 128,
      "height"    => 128,
      "mime_type" => "image/png",
      "filename"  => "profile_photo.png",
    )

    uploaded_file
  end
end
