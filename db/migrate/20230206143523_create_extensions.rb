# frozen_string_literal: true

class CreateExtensions < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'hstore'
    enable_extension 'citext'
    enable_extension 'unaccent'
    enable_extension 'uuid-ossp'
  end
end
