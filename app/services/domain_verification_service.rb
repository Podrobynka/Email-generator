# frozen_string_literal: true

require 'net/smtp'
require 'dnsruby'

class DomainVerificationService
  def initialize(domain)
    @domain = domain
  end

  def call
    return [] unless domain

    res = Dnsruby::DNS.new
    mxs = []
    res.each_resource(domain, 'MX') do |rr|
      mxs << { priority: rr.preference, address: rr.exchange.to_s }
    end
    mxs.sort_by { |mx| mx[:priority] }
  rescue Dnsruby::NXDomain
    []
  end

  private

  attr_reader :domain
end
