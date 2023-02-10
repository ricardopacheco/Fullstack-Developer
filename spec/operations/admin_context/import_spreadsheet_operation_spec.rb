# frozen_string_literal: true

require 'rails_helper'

describe AdminContext::ImportSpreadsheetOperation, type: :operation do
  let!(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:admin_id) { admin.id }
  let(:file) do
    fixture_file_upload(
      'import/example.xlsx',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )
  end

  describe '.call(admin_id, file, &block)' do
    let(:operation) { described_class }

    context 'when block is given' do
      context 'when operation happens with success' do
        it 'expect result success matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(admin_id, file) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_a(Integer)
          expect(matched_failure).to be_nil
        end
      end

      context 'when operation happens with failure' do
        it 'expect result matching block' do
          matched_success = nil
          matched_failure = nil

          operation.call(nil, file) do |o|
            o.success { |v| matched_success = v }
            o.failure { |f| matched_failure = f }
          end

          expect(matched_success).to be_nil
          expect(matched_failure[:base]).to eq(I18n.t('operations.base.admin_not_found'))
        end
      end
    end
  end

  describe '#call(admin_id, file)' do
    subject(:operation) { described_class.new.call(admin_id, file) }

    context 'when admin_id is not informed or not found on database' do
      let(:admin_id) { nil }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.admin_not_found'))
      end
    end

    context 'when admin_id is a non-admin user' do
      let(:admin_id) { user.id }
      let(:attributes) { {} }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to eq(I18n.t('operations.base.user_is_not_admin'))
      end
    end

    context 'when file is not informed' do
      let(:file) { nil }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to include(
          I18n.t('operations.admin_context.import_spreadsheet_operation.required')
        )
      end
    end

    context 'when file is not a spreadsheet' do
      let(:file) { fixture_file_upload('profile_photo.png', 'image/png') }

      it 'expect return failure with error message' do
        expect(operation).to be_failure
        expect(operation.failure[:base]).to include(
          I18n.t('operations.admin_context.import_spreadsheet_operation.invalid')
        )
      end
    end

    context 'when create user operation have problems' do
      let!(:invalid_admin_model_user) { build(:user, email: 'example@email.net') }
      let(:admin_model_class) { User }

      before do
        allow(admin_model_class).to receive(:new).and_call_original
        allow(admin_model_class).to receive(:new).and_return(invalid_admin_model_user)
        allow(invalid_admin_model_user).to receive(:save).and_return(false)
        allow(invalid_admin_model_user)
          .to receive(:errors)
          .and_return(
            ActiveModel::Errors.new(admin_model_class.new).tap do |e|
              e.add(:email, I18n.t('errors.messages.taken'))
            end
          )
      end

      it 'expect return failure with create user operation message errors' do
        expect(operation).to be_failure
        expect(operation.failure[:email]).to include(I18n.t('errors.messages.taken'))
      end
    end

    context 'when spreadsheet is valid' do
      it 'expect return success' do
        expect(operation).to be_success
      end

      it 'expect create users' do
        expect { operation }.to change(User, :count).from(1).to(3)
      end
    end
  end
end
