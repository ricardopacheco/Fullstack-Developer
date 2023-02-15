# frozen_string_literal: true

module Admin
  # Controller for admin pages
  class AdminController < ApplicationController
    before_action :authenticate_user!

    layout 'admin'
  end
end
