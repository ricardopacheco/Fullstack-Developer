# frozen_string_literal: true

# This class is an Application Job template inherited from the ActiveJob::Base class.
# It is used to define active jobs, such as scheduled tasks, background processing,
# and integration with external services.
class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  protected

  def build_message_data(event, user)
    {
      event: event,
      payload: {
        user: user.slice(:id, :fullname),
        html: render_admin_html_user_row(user)
      }
    }
  end

  def build_import_data(event, users)
    {
      event: event,
      payload: {
        total: users.size,
        html: users.each { |user| render_admin_html_user_row(user) }
      }
    }
  end

  def build_delete_data(event, user_id)
    {
      event: event,
      payload: {
        user_id: user_id
      }
    }
  end

  private

  def render_admin_html_user_row(user)
    user = AdminContext::UserDecorator.new(user, nil)

    ApplicationController.render(
      partial: 'shared/admin/users/row',
      locals: { user: user }
    )
  end
end
