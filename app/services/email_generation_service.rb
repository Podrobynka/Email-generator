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
    .com .org .net .edu .gov .co .uk .ua .us
  ].freeze

  def initialize(
    first_name:,
    last_name:,
    company_name:,
    domain_extensions: DOMAIN_EXTENSIONS
  )
    @first_name = first_name.downcase
    @last_name = last_name.downcase
    @company_name = company_name.downcase
    @domain_extensions = domain_extensions
  end

  def call
    create_emails.map do |address|
      address[0] if EmailVerificationService.new(address[0], address[1]).call
    end.compact
  end

  private

  attr_reader :first_name, :last_name, :company_name, :domain_extensions

  def verify_domain
    available_domains = {}

    create_domains.each do |domain|
      responce = DomainVerificationService.new(domain).call
      available_domains.store(domain, responce) unless responce.empty?
    end

    available_domains
  end

  def create_domains
    domain_extensions.map { |ext| [company_name, ext].join }
  end

  def create_emails
    username.product(['@'], verify_domain.keys).map do |email_parts|
      email = email_parts.join
      domain = email_parts.last
      [email, verify_domain[domain]]
    end
  end

  def username
    USERNAME_TEMPLATES.map { |template| template.call(first_name, last_name) }
  end
end
