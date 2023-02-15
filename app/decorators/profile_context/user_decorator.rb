# frozen_string_literal: true

module ProfileContext
  # Decorator for user objects in profile context.
  class UserDecorator < Burgundy::Item
    attributes :id, :fullname, :email

    def image_tag_avatar(crop)
      return if item.avatar_image.blank?

      h.image_tag(item.avatar_image_url(crop || :small))
    end

    def edit_profile_link
      h.link_to(
        I18n.t('views.profile.edit_profile'),
        r.edit_profile_path,
        id: 'profile-btn-edit',
        class: 'btn btn-outline-primary'
      )
    end

    def link_to_change_password
      h.link_to(
        I18n.t('views.profile.change_password'),
        r.change_password_profile_path,
        id: 'profile-btn-change-password',
        class: 'btn btn-outline-info'
      )
    end

    def link_to_delete
      h.link_to(
        I18n.t('views.profile.delete_profile'),
        r.profile_path,
        id: 'profile-btn-delete',
        class: 'btn btn-outline-danger',
        data: { confirm: 'Are you sure? This action is irreversible' }
      )
    end
  end
end
