# frozen_string_literal: true

require 'rails_helper'

feature 'Generating emails' do
  scenario 'Visiting root page' do
    visit '/'

    fill_in 'First name', with: 'Petro'
    fill_in 'Last name', with: 'Ivanov'
    fill_in 'Company', with: 'Ralabs'
    click_button 'Generate emails'

    available_emails_section = find('#available_emails')

    expect(available_emails_section).to have_content 'petro@ralabs.org'
    expect(available_emails_section).to have_content '31'
  end

  scenario 'Visiting index page' do
    visit '/emails'

    expect(page).to have_content 'Email generator'
  end
end
