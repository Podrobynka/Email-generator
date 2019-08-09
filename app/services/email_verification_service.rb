# frozen_string_literal: true

require 'net/smtp'
require 'dnsruby'

# class OutOfMailServersException < StandardError; end

class EmailVerificationService
  def initialize(address, servers)
    @email = address
    @servers = servers
    @user_email = 'yfgurda@gmail.com'
    @user_domain = @user_email.split('@').last
  end

  def call
    return if servers.empty? || !connect

    verify
  end

  private

  attr_reader :email, :servers, :user_email, :user_domain, :smtp

  def connect
    server = next_server
    return if server.nil?

    @smtp = Net::SMTP.start server[:address], 25, user_domain
    true
  rescue StandardError
    retry
  end

  def next_server
    servers.shift
  end

  def verify
    mailfrom(user_email)
    rcptto(email).tap { close_connection }
  end

  def mailfrom(address)
    ensure_250 smtp.mailfrom(address)
  end

  def rcptto(address)
    ensure_250 smtp.rcptto(address)
  rescue StandardError => e
    false if e.message[/^550/]
  end

  def close_connection
    smtp.finish if smtp&.started?
  end

  def ensure_250(smtp_return)
    true if smtp_return.status.to_i == 250
  end
end
