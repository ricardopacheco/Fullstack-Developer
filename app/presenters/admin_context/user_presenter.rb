# frozen_string_literal: true

module AdminContext
  # This class is responsible for rendering the view logic for users in admin context.
  class UserPresenter < ApplicationPresenter
    def initialize(view_context, current_user, options = {})
      super(view_context, current_user, options)
      @form_object = options[:form_object]
    end

    def render_new_user_form
      render_partial_path(
        partial: 'shared/admin/users/new_form', locals: { form_object: @form_object }
      )
    end

    def render_edit_user_form
      render_partial_path(
        partial: 'shared/admin/users/edit_form', locals: { form_object: @form_object }
      )
    end

    def render_upload_spreadsheet_form
      render_partial_path(
        partial: 'shared/admin/users/upload_form', locals: { form_object: @form_object }
      )
    end
  end
end
