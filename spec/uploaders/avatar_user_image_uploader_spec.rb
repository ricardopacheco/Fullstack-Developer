# frozen_string_literal: true

RSpec.describe AvatarUserImageUploader do
  let(:user) { create(:user, :with_upload_avatar) }

  describe 'Image metadata attributes' do
    let(:image) { user.avatar_image }

    it 'expect extracts metadata' do
      expect(image.mime_type).to eq('image/png')
      expect(image.extension).to eq('png')
      expect(image.size).to be_instance_of(Integer)
      expect(image.width).to be_instance_of(Integer)
      expect(image.height).to be_instance_of(Integer)
    end
  end

  describe 'Image derivatives attributes' do
    let(:derivatives) { user.avatar_image_derivatives }

    before do
      user.avatar_image_derivatives!
      user.save
      user.reload
    end

    it 'generates derivatives' do
      expect(derivatives[:large]).to  be_a(Shrine::UploadedFile)
      expect(derivatives[:medium]).to be_a(Shrine::UploadedFile)
      expect(derivatives[:small]).to  be_a(Shrine::UploadedFile)
      expect(derivatives[:thumbnail]).to be_a(Shrine::UploadedFile)
    end
  end

  describe 'Validations' do
    let(:image) { fixture_file_upload('profile_photo.png') }
    let(:user) { build(:user) }

    before do
      Shrine.storages[:cache].upload(image, 'profile_photo.png')
      user.update(avatar_image: upload)
    end

    context 'when file occours a invalidation' do
      let(:size) { File.size(image) }
      let(:upload) do
        Shrine.uploaded_file(
          'id' => 'profile_photo.png',
          'storage' => 'cache',
          'metadata' => { 'mime_type' => 'text/plain', 'size' => size }
        )
      end

      it 'expect invalidate avatar by invalid mime type' do
        expect(user).to be_invalid
        expect(user.errors[:avatar_image]).to include(
          I18n.t(
            'shrine.errors.file.mime_type_inclusion',
            list: described_class::ALLOW_MIME_TYPES
          )
        )
      end
    end
  end
end
