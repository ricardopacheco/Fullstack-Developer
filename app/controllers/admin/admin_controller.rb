# frozen_string_literal: true

module Admin
  # Controller for managing admin dashboard.
  class AdminController < ApplicationController
    before_action :authenticate_user!

    layout 'admin'
  end
end
