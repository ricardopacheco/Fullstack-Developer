# frozen_string_literal: true

# This class is responsible for rendering the view logic associated. Is more of
# a "let's build a bridge between the model/backend and view". The presenter
# pattern has several interpretations.
class ApplicationPresenter
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(view_context, current_user, options = {})
    @view_context = view_context
    @current_user = current_user
    @options = options
  end

  def helpers
    @view_context
  end

  def render_partial_path(options = {})
    helpers.render(options)
  end
end
