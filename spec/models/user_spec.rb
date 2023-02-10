# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'Enumerations' do
    it { is_expected.to define_enum_for(:role).with_values(profile: 0, admin: 1).backed_by_column_of_type(:integer) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:fullname) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'Unique validations' do
    subject { build(:user, email: user.email) }

    let(:user) { create(:user) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end
end
