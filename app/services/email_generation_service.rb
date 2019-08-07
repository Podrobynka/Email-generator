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
    .com .org .net .mil .edu .gov .ca .cn .co .fr .ch .de .jp .uk .ua .us .no
  ].freeze

  def initialize(first_name: '', last_name: '', company_name: '')
    @first_name = first_name.downcase
    @last_name = last_name.downcase
    @company_name = company_name.downcase
  end

  def add_domain_exstension
    add_domain.product(DOMAIN_EXTENSIONS).map(&:join)
  end

  private

  def add_domain
    USERNAME_TEMPLATES.map do |template|
      username = template.call(first_name, last_name)
      [username, company_name].join('@')
    end
  end

  attr_reader :first_name, :last_name, :company_name
end
