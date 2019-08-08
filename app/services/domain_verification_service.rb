# frozen_string_literal: true

require 'net/smtp'
require 'dnsruby'

class DomainVerificationService
  def initialize(domain)
    @domain = domain
  end

  def call
    return [] unless domain

    mxs = []
    resources.each_resource(domain, 'MX') do |resource|
      mxs << { priority: resource.preference, address: resource.exchange.to_s }
    end

    mxs.sort_by { |mx| mx[:priority] }
  rescue Dnsruby::NXDomain
    []
  end

  private

  attr_reader :domain

  def resources
    Dnsruby::DNS.new
  end
end
