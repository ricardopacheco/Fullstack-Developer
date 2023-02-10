# frozen_string_literal: true

# This class provides controller actions to manage user sessions. It provides
# features such as login and logout.
class SessionsController < ApplicationController
  def create
    session = session_class.new(session_params)

    if session.submit
      user = User.find(session.user.id)
      sign_in(user, scope: :user)
      redirect_to profile_root_path, notice: t('.success')
    else
      @presenter = GuestContextPresenter.new(view_context, form_object: session)
      render 'guest/index'
    end
  end

  def destroy
    sign_out(current_user)

    redirect_to root_path, notice: t('.success')
  end

  private

  def session_class
    GuestContext::LoginForm
  end

  def session_params
    params.require(:user).permit(:email, :password)
  end
end
