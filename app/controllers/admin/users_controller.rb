# frozen_string_literal: true

module Admin
  # Controller for managing users.
  class UsersController < AdminController
    before_action :authenticate_user!
    before_action :find_user, only: %i[show edit update destroy up down]

    def index
      @users = User.all
    end

    def show
      @user = User.find(params[:id])
    end

    def new
      @presenter = presenter_class.new(
        view_context, current_user, form_object: AdminContext::CreateUserForm.new
      )
    end

    def edit
      @presenter = presenter_class.new(
        view_context,
        current_user,
        form_object: AdminContext::EditUserForm.new(
          @user.attributes.slice('fullname', 'email')
        )
      )
    end

    def create
      form = AdminContext::CreateUserForm.new(user_params)

      if form.submit(current_user.id)
        redirect_to admin_user_path(form.user.id), notice: t('.success')
      else
        @presenter = presenter_class.new(view_context, current_user, form_object: form)
        render :new
      end
    end

    def update
      form = AdminContext::EditUserForm.new(user_params)

      if form.submit(current_user.id, @user.id)
        redirect_to admin_user_path(@user.id), notice: t('.success')
      else
        @presenter = presenter_class.new(view_context, current_user, form_object: form)
        render :edit
      end
    end

    def destroy
      result = AdminContext::DeleteUserOperation.call(current_user.id, @user.id)

      if result.success?
        redirect_to admin_users_path, notice: t('.success')
      else
        redirect_to edit_admin_user_path(@user.id), alert: t('.error')
      end
    end

    def up
      result = AdminContext::UserUpOperation.call(current_user.id, @user.id)

      if result.success?
        redirect_to request.referer, notice: t('.success', fullname: @user.fullname)
      else
        redirect_to edit_admin_user_path(@user.id), alert: t('.error', fullname: @user.fullname)
      end
    end

    def down
      result = AdminContext::UserDownOperation.call(current_user.id, @user.id)

      if result.success?
        redirect_to request.referer, notice: t('.success', fullname: @user.fullname)
      else
        redirect_to edit_admin_user_path(@user.id), alert: t('.error', fullname: @user.fullname)
      end
    end

    def upload
      @presenter = presenter_class.new(
        view_context,
        current_user,
        form_object: AdminContext::ImportSpreadsheetForm.new
      )
    end

    def import
      form = AdminContext::ImportSpreadsheetForm.new(import_params)

      if form.submit(current_user.id)
        redirect_to admin_users_path, notice: t('.success', total: form.counter)
      else
        @presenter = presenter_class.new(view_context, current_user, form_object: form)
        render :upload
      end
    end

    private

    def presenter_class
      AdminContext::UserPresenter
    end

    def user_params
      params.require(:user).permit(:fullname, :email, :avatar_image)
    end

    def find_user
      @user = User.find(params[:id])
    end

    def import_params
      params.require(:import).permit(:file)
    end
  end
end
