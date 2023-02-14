# frozen_string_literal: true

# This channel is used to broadcast messages to current user profile
class ProfileContextChannel < ApplicationCable::Channel
  before_subscribe :check_profile_user

  def subscribed
    stream_from "ProfileContextChannel-#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def check_profile_user
    reject unless current_user.profile?
  end
end
