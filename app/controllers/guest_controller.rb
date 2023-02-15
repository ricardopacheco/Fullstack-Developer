# frozen_string_literal: true

# Class for main unauthenticated route page
class GuestController < ApplicationController
  layout 'guest'

  def index
    @presenter = GuestContextPresenter.new(view_context, form_object: GuestContext::LoginForm.new)
  end
end
