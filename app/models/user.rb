# frozen_string_literal: true

# This class represents an user in the application. It provides features such as
# authentication, authorization, user profile creation and storage of information.
class User < ApplicationRecord
  devise :database_authenticatable

  include AvatarUserImageUploader::Attachment(:avatar_image)
  enum role: { profile: 0, admin: 1 }

  validates :fullname, :email, presence: true
  validates :email, uniqueness: true
end
