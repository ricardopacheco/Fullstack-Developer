# frozen_string_literal: true

require 'rails_helper'

describe AdminContext::UserPresenter, type: :presenter do
  subject { described_class.new(view_context, form_object: form_object) }

  let(:view_context) { ActionController::Base.new.view_context }
  let(:form_object) { nil }

  before do
    allow_any_instance_of(ActionController::Base).to receive(:view_context).and_return(view_context)
    allow(view_context).to receive(:render)
  end

  describe '#render_new_user_form' do
    it 'renders the login form partial' do
      subject.render_new_user_form

      expect(view_context).to have_received(:render).with(
        partial: 'shared/admin/users/new_form',
        locals: { form_object: form_object }
      ).once
    end
  end

  describe '#render_edit_user_form' do
    it 'renders the register form partial' do
      subject.render_edit_user_form

      expect(view_context).to have_received(:render).with(
        partial: 'shared/admin/users/edit_form',
        locals: { form_object: form_object }
      )
    end
  end
end
