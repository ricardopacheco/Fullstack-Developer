# frozen_string_literal: true

# This class provides methods for register new profile users.
class RegistrationsController < ApplicationController
  def new
    @presenter = presenter_class.new(view_context, form_object: registration_form.new)
  end

  def create
    form = registration_form.new(registration_params)

    if form.submit
      @user = User.find(form.user.id)
      sign_in(@user, scope: :user)
      redirect_to profile_root_path, notice: t('.success')
    else
      @presenter = presenter_class.new(view_context, form_object: form)
      render :new
    end
  end

  private

  def presenter_class
    GuestContextPresenter
  end

  def registration_form
    GuestContext::RegistrationForm
  end

  def registration_params
    params.require(:user).permit(
      :fullname, :email, :password, :password_confirmation, :avatar_image
    )
  end
end
