# frozen_string_literal: true

# This class is responsible for rendering the view logic for profile context.
class ProfileContextPresenter < ApplicationPresenter
  def initialize(view_context, current_user, options = {})
    super(view_context, current_user, options)
    @form_object = options[:form_object]
  end

  def render_profile_update_fields_form
    render_partial_path(
      partial: 'shared/profile/update_fields_form',
      locals: { form_object: @form_object }
    )
  end

  def render_profile_change_password_form
    render_partial_path(
      partial: 'shared/profile/change_password_form',
      locals: { form_object: @form_object }
    )
  end
end
