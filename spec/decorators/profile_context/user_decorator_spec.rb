# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfileContext::UserDecorator do
  let(:user) { create(:user) }
  let(:decorator) { described_class.new(user) }

  describe '#image_tag_avatar' do
    context 'when user has no avatar' do
      it 'returns nil' do
        expect(decorator.image_tag_avatar(:small)).to be_nil
      end
    end

    context 'when user has an avatar' do
      let(:user) { create(:user, :with_upload_avatar) }

      it 'returns an image tag' do
        expect(decorator.image_tag_avatar(:small)).to include(user.avatar_image_url(:small))
      end
    end
  end

  describe '#edit_profile_link' do
    it 'returns an edit link' do
      expect(decorator.edit_profile_link).to include('profile-btn-edit')
    end
  end

  describe '#link_to_change_password' do
    it 'returns a change password link' do
      expect(decorator.link_to_change_password).to include('profile-btn-change-password')
    end
  end

  describe '#link_to_delete' do
    it 'returns a delete link' do
      expect(decorator.link_to_delete).to include('profile-btn-delete')
    end
  end
end
