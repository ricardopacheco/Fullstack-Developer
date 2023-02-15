# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.citext :fullname, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :token, null: true, index: { unique: true }
      t.string :encrypted_password, null: false, default: ""
      t.jsonb :avatar_image_data, default: {}
      t.integer :role, default: 0, null: false

      t.timestamps
    end

    add_index :users, %I[email role]
  end
end
