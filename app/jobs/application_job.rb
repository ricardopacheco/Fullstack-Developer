# frozen_string_literal: true

# This class is an Application Job template inherited from the ActiveJob::Base class.
# It is used to define active jobs, such as scheduled tasks, background processing,
# and integration with external services.
class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
