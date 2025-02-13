# frozen_string_literal: true

# This class provides methods for register new profile users and create your
# passwords
class RegistrationsController < ApplicationController
  layout 'guest'

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

  def create_password
    @presenter = presenter_class.new(
      view_context, form_object: password_form.new(token: params[:token])
    )
  end

  def update_password
    form = password_form.new(create_password_params)

    if form.submit
      @user = User.find(form.user.id)
      sign_in(@user, scope: :user)
      redirect_to profile_root_path, notice: t('.success')
    else
      @presenter = presenter_class.new(view_context, form_object: form)
      render :create_password
    end
  end

  private

  def presenter_class
    GuestContextPresenter
  end

  def registration_form
    GuestContext::RegistrationForm
  end

  def password_form
    GuestContext::CreatePasswordForm
  end

  def create_password_params
    params.require(:user).permit(:token, :password, :password_confirmation)
  end

  def registration_params
    params.require(:user).permit(
      :fullname, :email, :password, :password_confirmation, :avatar_image
    )
  end
end
