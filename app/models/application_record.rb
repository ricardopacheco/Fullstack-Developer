# frozen_string_literal: true

# This module serves as the base class for all models in the application.
# It provides basic functionality such as database interaction and validation.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
