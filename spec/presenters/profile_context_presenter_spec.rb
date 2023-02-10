# frozen_string_literal: true

require 'rails_helper'

describe ProfileContextPresenter, type: :presenter do
  subject { described_class.new(view_context, form_object: form_object) }

  let(:view_context) { ActionController::Base.new.view_context }
  let(:form_object) { nil }

  before do
    allow_any_instance_of(ActionController::Base).to receive(:view_context).and_return(view_context)
    allow(view_context).to receive(:render)
  end

  describe '#render_profile_update_fields_form' do
    it 'renders the update fields form partial' do
      subject.render_profile_update_fields_form

      expect(view_context).to have_received(:render).with(
        partial: 'shared/profile/update_fields_form',
        locals: { form_object: form_object }
      ).once
    end
  end

  describe '#render_profile_change_password_form' do
    it 'renders the change password form partial' do
      subject.render_profile_change_password_form

      expect(view_context).to have_received(:render).with(
        partial: 'shared/profile/change_password_form',
        locals: { form_object: form_object }
      )
    end
  end
end
