# frozen_string_literal: true

# This class allows for uploading of a user image file and validates the file
# type according to the defined parameters.
class AvatarUserImageUploader < Shrine
  ALLOW_MIME_TYPES = %w[image/jpg image/jpeg image/png].freeze
  ALLOW_EXTENSIONS = %w[jpg jpeg png].freeze

  Attacher.validate do
    validate_max_size GLOBAL_MAX_UPLOAD_FILE_SIZE
    validate_mime_type ALLOW_MIME_TYPES
    validate_extension ALLOW_EXTENSIONS
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      large: magick.resize_to_limit!(500, 500),
      medium: magick.resize_to_limit!(250, 250),
      small: magick.resize_to_limit!(100, 100),
      thumbnail: magick.resize_to_limit!(50, 50),
      tiny: magick.resize_to_limit!(25, 25)
    }
  end
end
