# frozen_string_literal: true

require 'net/smtp'
require 'dnsruby'

# class OutOfMailServersException < StandardError; end

class EmailVerificationService
  def initialize(address)
    @email = address
    _, @domain = address.split('@')
    @servers = DomainVerificationService.new(@domain).list_mxs
    @smtp = nil
    @user_email = 'yfgurda@gmail.com'
    _, @user_domain = @user_email.split '@'
  end

  def call
    return nil if @servers.empty?

    return nil unless connect

    verify
  end

  private

  def connect
    server = next_server
    return if server.nil?

    @smtp = Net::SMTP.start server[:address], 25, @user_domain
    true
  # rescue OutOfMailServersException
  #   false
  rescue StandardError
    retry
  end

  def next_server
    @servers.shift
  end

  def verify
    mailfrom @user_email
    rcptto(@email).tap do
      close_connection
    end
  end

  def mailfrom(address)
    ensure_250 @smtp.mailfrom(address)
  end

  def rcptto(address)
    ensure_250 @smtp.rcptto(address)
  rescue StandardError => e
    return false if e.message[/^550/]
  end

  def close_connection
    @smtp.finish if @smtp&.started?
  end

  def ensure_250(smtp_return)
    return true if smtp_return.status.to_i == 250
  end
end
