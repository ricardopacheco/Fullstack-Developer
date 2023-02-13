# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminContext::UserDecorator do
  let(:user) { create(:user) }
  let(:decorator) { described_class.new(user, nil) }

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

  describe '#badge_role' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }

      it 'returns an admin badge' do
        expect(decorator.badge_role).to include('bg-primary')
      end
    end

    context 'when user is not admin' do
      it 'returns a profile badge' do
        expect(decorator.badge_role).to include('bg-secondary')
      end
    end
  end

  describe '#link_to_edit' do
    it 'returns an edit link' do
      expect(decorator.link_to_edit).to include('admin-btn-edit-user')
    end
  end

  describe '#link_to_convert_profile' do
    it 'returns a convert to profile link' do
      expect(decorator.link_to_convert_profile).to include('admin-btn-convert-admin-to-profile')
    end
  end

  describe '#link_to_convert_admin' do
    it 'returns a convert to admin link' do
      expect(decorator.link_to_convert_admin).to include('admin-btn-convert-profile-in-admin')
    end
  end

  describe '#link_to_convert' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }

      it 'returns a convert to profile link' do
        expect(decorator.link_to_convert).to include('admin-btn-convert-admin-to-profile')
      end
    end

    context 'when user is not admin' do
      it 'returns a convert to admin link' do
        expect(decorator.link_to_convert).to include('admin-btn-convert-profile-in-admin')
      end
    end
  end

  describe '#link_to_delete' do
    it 'returns a delete link' do
      expect(decorator.link_to_delete).to include('admin-btn-delete-user')
    end
  end
end
