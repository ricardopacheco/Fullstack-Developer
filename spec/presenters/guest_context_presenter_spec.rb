# frozen_string_literal: true

require 'rails_helper'

describe GuestContextPresenter, type: :presenter do
  subject { described_class.new(view_context, form_object: form_object) }

  let(:view_context) { ActionController::Base.new.view_context }
  let(:form_object) { nil }

  before do
    allow_any_instance_of(ActionController::Base).to receive(:view_context).and_return(view_context)
    allow(view_context).to receive(:render)
  end

  describe '#render_login_form' do
    it 'renders the login form partial' do
      subject.render_login_form

      expect(view_context).to have_received(:render).with(
        partial: 'shared/guest/login/form',
        locals: { form_object: form_object }
      ).once
    end
  end

  describe '#render_register_form' do
    it 'renders the register form partial' do
      subject.render_register_form

      expect(view_context).to have_received(:render).with(
        partial: 'shared/guest/register/form',
        locals: { form_object: form_object }
      )
    end
  end
end
