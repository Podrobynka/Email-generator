# frozen_string_literal: true

class EmailGenerationService
  USERNAME_TEMPLATES = [
    ->(first_name, _last_name) { first_name },
    ->(_first_name, last_name) { last_name },
    ->(first_name, last_name) { [first_name, '.', last_name].join },
    ->(first_name, last_name) { [first_name, '_', last_name].join },
    ->(first_name, last_name) { [first_name[0], '.', last_name].join },
    ->(first_name, last_name) { [first_name[0], '_', last_name].join },
    ->(first_name, last_name) { [first_name, '.', last_name[0]].join },
    ->(first_name, last_name) { [first_name, '_', last_name[0]].join }
  ].freeze

  DOMAIN_EXTENSIONS = %w[
    .com .org .net .mil .edu .gov .ca .cn .co .fr .ch .de .jp .uk .ua .us
  ].freeze

  def initialize(first_name: '', last_name: '', company_name: '')
    @first_name = first_name.downcase
    @last_name = last_name.downcase
    @company_name = company_name.downcase
  end

  def verify_email
    @available_emails = []
    create_email.each do |address|
      responce = EmailVerificationService.new(address).call
      @available_emails << address unless responce || responce.nil?
    end
    # @available_emails
  end

  def create_domain
    @available_domains = []
    domains = DOMAIN_EXTENSIONS.map { |ext| [company_name, ext].join }
    domains.each do |domain|
      unless DomainVerificationService.new(domain).list_mxs.empty?
        @available_domains << domain
      end
    end
    @available_domains
  end

  private

  attr_reader :first_name, :last_name, :company_name

  def create_email
    username.product(['@'], create_domain).map(&:join)
  end

  def username
    USERNAME_TEMPLATES.map do |template|
      template.call(first_name, last_name)
    end
  end
end
