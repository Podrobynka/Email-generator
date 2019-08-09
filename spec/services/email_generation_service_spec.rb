# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailGenerationService do
  let(:params) do
    {
      first_name: 'Petro',
      last_name: 'Ivanov',
      company_name: 'Ralabs',
      domain_extensions: %w[.org .gov]
    }
  end
  let(:available_emails) do
    %w[petro@ralabs.org ivanov@ralabs.org petro.ivanov@ralabs.org
       petro_ivanov@ralabs.org p.ivanov@ralabs.org p_ivanov@ralabs.org
       petro.i@ralabs.org petro_i@ralabs.org]
  end

  subject { described_class.new(params).call }

  it { expect(subject).to match_array(available_emails) }
end
