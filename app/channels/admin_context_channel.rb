# frozen_string_literal: true

# This channel is used to broadcast messages to all admins
class AdminContextChannel < ApplicationCable::Channel
  before_subscribe :check_admin_user

  def subscribed
    stream_from 'AdminContextChannel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def check_admin_user
    reject unless current_user.admin?
  end
end
