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

  def initialize(params)
    @first_name = params[:first_name].downcase
    @last_name = params[:last_name].downcase
    @company_name = params[:company_name].downcase
  end

  def call
    @available_emails = []
    create_emails.each do |address|
      responce = EmailVerificationService.new(address[0], address[1]).call
      @available_emails << address[0] unless responce || responce.nil?
    end
    @available_emails
  end

  private

  attr_reader :first_name, :last_name, :company_name

  def verify_domain
    @available_domains = {}
    create_domains.each do |domain|
      responce = DomainVerificationService.new(domain).call
      @available_domains.store(domain, responce) unless responce.empty?
    end
    @available_domains
  end

  def create_domains
    DOMAIN_EXTENSIONS.map { |ext| [company_name, ext].join }
  end

  def create_emails
    @emails = []
    username.product(['@'], verify_domain.keys).map(&:join).each do |email|
      _, domain = email.split('@')
      @emails << [email, verify_domain[domain]]
    end
    @emails
  end

  def username
    USERNAME_TEMPLATES.map { |template| template.call(first_name, last_name) }
  end
end
