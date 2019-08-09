# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailGenerationService do
  let(:params) do
    { first_name: 'Petro', last_name: 'Ivanov', company_name: 'Ralabs' }
  end
  let(:available_emails) do
    ['petro@ralabs.com', 'petro@ralabs.org', 'petro@ralabs.net',
     'petro@ralabs.co', 'ivanov@ralabs.com', 'ivanov@ralabs.org',
     'ivanov@ralabs.net', 'ivanov@ralabs.co', 'petro.ivanov@ralabs.com',
     'petro.ivanov@ralabs.org', 'petro.ivanov@ralabs.net',
     'petro.ivanov@ralabs.co', 'petro_ivanov@ralabs.com',
     'petro_ivanov@ralabs.org', 'petro_ivanov@ralabs.net',
     'petro_ivanov@ralabs.co', 'p.ivanov@ralabs.com', 'p.ivanov@ralabs.org',
     'p.ivanov@ralabs.net', 'p.ivanov@ralabs.co', 'p_ivanov@ralabs.com',
     'p_ivanov@ralabs.org', 'p_ivanov@ralabs.net', 'p_ivanov@ralabs.co',
     'petro.i@ralabs.com', 'petro.i@ralabs.org', 'petro.i@ralabs.net',
     'petro.i@ralabs.co', 'petro_i@ralabs.com', 'petro_i@ralabs.org',
     'petro_i@ralabs.net', 'petro_i@ralabs.co']
  end

  subject { described_class.new(params).call }

  it { expect(subject).to match_array(available_emails) }
end
