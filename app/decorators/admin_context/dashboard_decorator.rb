# frozen_string_literal: true

module AdminContext
  # This class is a great way to quickly and easily customize components for dashboard
  class DashboardDecorator
    attr_reader :current_user

    def initialize(current_user)
      @current_user = current_user
    end

    def total_users
      User.count
    end

    def render_grouped_users_by_role
      User.group(:role).count
    end
  end
end
