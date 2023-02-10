# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#bootstrap_class_for' do
    context 'when the flash is :notice' do
      it 'returns the alert-primary class' do
        expect(bootstrap_class_for(:notice)).to eq('alert-primary')
      end
    end

    context 'when the flash is :success' do
      it 'returns the alert-success class' do
        expect(bootstrap_class_for(:success)).to eq('alert-success')
      end
    end

    context 'when the flash is :error' do
      it 'returns the alert-danger class' do
        expect(bootstrap_class_for(:error)).to eq('alert-danger')
      end
    end

    context 'when the flash is :alert' do
      it 'returns the alert-warning class' do
        expect(bootstrap_class_for(:alert)).to eq('alert-warning')
      end
    end

    context 'when the flash is unknown name' do
      it 'returns the unknown name class' do
        expect(bootstrap_class_for(:example)).to eq('example')
      end
    end
  end
end
