# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailVerificationService do
  let(:servers) do
    [{ address: 'ASPMX.L.GOOGLE.COM', priority: 1 },
     { address: 'ALT1.ASPMX.L.GOOGLE.COM', priority: 5 },
     { address: 'ALT2.ASPMX.L.GOOGLE.COM', priority: 5 },
     { address: 'ALT3.ASPMX.L.GOOGLE.COM', priority: 10 },
     { address: 'ALT4.ASPMX.L.GOOGLE.COM', priority: 10 }]
  end

  subject { described_class.new(address, servers).call }

  context 'existent email' do
    let(:address) { 'admin@ralabs.org' }

    it { expect(subject).to be_falsey }
  end

  context 'unexistent email' do
    let(:address) { 'not_admin@ralabs.org' }

    it { expect(subject).to be_truthy }
  end

  context 'no email' do
    let(:address) { '' }
    let(:servers) { [] }

    it { expect(subject).to be_falsey }
  end
end
