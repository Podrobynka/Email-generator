# frozen_string_literal: true

class EmailsController < ApplicationController
  def new
    @emails
  end

  def create
    @emails = EmailGenerationService.new(email_params.to_h.symbolize_keys).call

    render :new
  end

  def index
    render :new
  end

  private

  def email_params
    params.permit(:first_name, :last_name, :company_name)
  end
end
