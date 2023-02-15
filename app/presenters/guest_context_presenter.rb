# frozen_string_literal: true

# This class is responsible for rendering the view logic for guest context.
class GuestContextPresenter < ApplicationPresenter
  def initialize(view_context, options = {})
    super(view_context, nil, options)
    @form_object = options[:form_object]
  end

  def render_login_form
    render_partial_path(
      partial: 'shared/guest/login/form',
      locals: { form_object: @form_object }
    )
  end

  def render_register_form
    render_partial_path(
      partial: 'shared/guest/register/form',
      locals: { form_object: @form_object }
    )
  end

  def render_create_password_form
    render_partial_path(
      partial: 'shared/guest/create_password/form',
      locals: { form_object: @form_object }
    )
  end
end
