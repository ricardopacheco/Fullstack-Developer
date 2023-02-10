# frozen_string_literal: true

module Admin
  # Controller for managing admin dashboard.
  class DashboardController < AdminController
    before_action :authenticate_user!

    def index
      @chart = AdminContext::DashboardDecorator.new(current_user)
    end
  end
end
