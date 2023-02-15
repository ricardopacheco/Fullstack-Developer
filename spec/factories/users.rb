# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@management.com" }
    fullname { Faker::Name.name }
    password { 'password' }
    password_confirmation { 'password' }

    trait :admin do
      role { :admin }
    end

    trait :with_token do
      token { SecureRandom.hex(20) }
    end

    trait :with_upload_avatar do
      avatar_image do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/profile_photo.png'),
          'image/png'
        )
      end
    end

    trait :with_avatar do
      avatar_image { ShrineTestData.image_data }
    end
  end
end
