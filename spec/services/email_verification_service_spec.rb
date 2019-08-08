# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailVerificationService do
  let(:list_mxs) do
    [{ address: 'ASPMX.L.GOOGLE.COM', priority: 1 },
     { address: 'ALT1.ASPMX.L.GOOGLE.COM', priority: 5 },
     { address: 'ALT2.ASPMX.L.GOOGLE.COM', priority: 5 },
     { address: 'ALT3.ASPMX.L.GOOGLE.COM', priority: 10 },
     { address: 'ALT4.ASPMX.L.GOOGLE.COM', priority: 10 }]
  end

  subject { described_class.new(address, list_mxs).call }

  context 'existent email' do
    let(:address) { 'admin@ralabs.org' }

    it 'return true' do
      expect(subject).to be true
    end
  end

  context 'unexistent email' do
    let(:address) { 'not_admin@ralabs.org' }

    it 'return false' do
      expect(subject).to be false
    end
  end

  context 'no email' do
    let(:address) { '' }
    let(:list_mxs) { [] }

    it 'return nil' do
      expect(subject).to be nil
    end
  end
end
