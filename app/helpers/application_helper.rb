# frozen_string_literal: true

# This module contains helper methods for the application.
# It is available for use in all controllers and views.
module ApplicationHelper
  def bootstrap_class_for(flash)
    case flash.to_sym
    when :notice
      'alert-primary'
    when :success
      'alert-success'
    when :error
      'alert-danger'
    when :alert
      'alert-warning'
    else
      flash.to_s
    end
  end
end
