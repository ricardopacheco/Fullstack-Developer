# frozen_string_literal: true

module AdminContext
  # Decorator for user objects in admin context.
  class UserDecorator < Burgundy::Item
    attributes :id, :fullname, :email

    def initialize(user, current_admin)
      super(user)
      @current_admin = current_admin
    end

    def image_tag_avatar(crop)
      return if item.avatar_image.blank?

      h.image_tag(item.avatar_image_url(crop || :small))
    end

    def badge_role
      role_class = item.admin? ? 'primary' : 'secondary'

      h.content_tag(:span, role, class: "badge bg-#{role_class}")
    end

    def link_to_edit
      h.link_to(
        '<i class="fa-solid fa-pen-to-square"></i>'.html_safe,
        r.edit_admin_user_path(item.id),
        id: 'admin-btn-edit-user',
        class: 'btn btn-outline-primary'
      )
    end

    def link_to_convert_profile
      h.link_to(
        t('decorators.admin_context.user.convert_to_profile'),
        r.down_admin_user_path(item.id),
        method: :put,
        id: 'admin-btn-convert-admin-to-profile',
        class: 'btn btn-outline-warning'
      )
    end

    def link_to_convert_admin
      h.link_to(
        t('decorators.admin_context.user.convert_to_admin'),
        r.up_admin_user_path(item.id),
        method: :put,
        id: 'admin-btn-convert-profile-in-admin',
        class: 'btn btn-outline-info'
      )
    end

    def link_to_convert
      return link_to_convert_profile if item.admin?

      link_to_convert_admin
    end

    def link_to_delete
      h.link_to(
        '<i class="fa-solid fa-trash"></i>'.html_safe,
        r.admin_user_path(item.id),
        method: :delete,
        id: 'admin-btn-delete-user',
        class: 'btn btn-outline-danger',
        data: { confirm: 'Are you sure? This action is irreversible' }
      )
    end
  end
end
