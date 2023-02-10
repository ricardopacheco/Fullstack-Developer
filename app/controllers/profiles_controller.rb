# frozen_string_literal: true

# This class provides methods for user manage your profile.
class ProfilesController < ApplicationController
  before_action :authenticate_user!

  layout 'profile'

  def show; end

  def edit
    attributes = current_user.attributes.slice('fullname', 'email')

    @presenter = presenter_class.new(
      view_context, current_user, form_object: profile_fields_form.new(attributes)
    )
  end

  def update
    form = profile_fields_form.new(profile_fields_params)

    if form.submit(current_user.id)
      redirect_to profile_root_path, notice: t('.success')
    else
      @presenter = presenter_class.new(view_context, current_user, form_object: form)

      render :edit
    end
  end

  def destroy
    result = ProfileContext::DeleteProfileOperation.call(current_user.id)

    if result.success?
      redirect_to root_path, notice: t('.success')
    else
      redirect_to profile_root_path, alert: t('.error')
    end
  end

  def change_password
    @presenter = presenter_class.new(view_context, current_user, form_object: update_password_form.new)
  end

  def update_password
    form = update_password_form.new(update_password_params)

    if form.submit(current_user.id)
      redirect_to profile_root_path, notice: t('.success')
    else
      @presenter = presenter_class.new(view_context, current_user, form_object: form)

      render :change_password
    end
  end

  private

  def presenter_class
    ProfileContextPresenter
  end

  def update_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def update_password_form
    ProfileContext::UpdatePasswordForm
  end

  def profile_fields_params
    params.require(:user).permit(:fullname, :email, :avatar_image)
  end

  def profile_fields_form
    ProfileContext::UpdateFieldsForm
  end
end
