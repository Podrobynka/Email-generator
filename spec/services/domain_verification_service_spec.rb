# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DomainVerificationService do
  subject { described_class.new(domain).call }

  context 'existent domain' do
    let(:domain) { 'ralabs.org' }
    let(:array) do
      [{ address: 'ASPMX.L.GOOGLE.COM', priority: 1 },
       { address: 'ALT1.ASPMX.L.GOOGLE.COM', priority: 5 },
       { address: 'ALT2.ASPMX.L.GOOGLE.COM', priority: 5 },
       { address: 'ALT3.ASPMX.L.GOOGLE.COM', priority: 10 },
       { address: 'ALT4.ASPMX.L.GOOGLE.COM', priority: 10 }]
    end

    it 'return array of domain and mxs' do
      expect(subject).to match_array(array)
    end
  end

  context 'unexistent domain' do
    let(:domain) { 'ralabs.gov' }

    it 'return blank array' do
      expect(subject).to be_empty
    end
  end

  context 'no domain' do
    let(:domain) { nil }

    it 'return blank array' do
      expect(subject).to be_empty
    end
  end
end
