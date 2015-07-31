require 'rails_helper'

RSpec.feature 'List sites' do
  let(:go_to_url) { '/sites' }

  include_examples 'authenticated page'

  it_behaves_like 'logged in user' do
    scenario 'visiting the page' do
      expect(page).to_not have_link 'localhost', href: 'http://localhost'
    end
  end

  it_behaves_like 'logged in site user' do
    scenario 'visiting the page' do
      expect(page).to have_link 'localhost', href: 'http://localhost'
    end

    include_examples 'page with topbar link', 'Sites', 'list'
  end

  it_behaves_like 'logged in admin' do
    scenario 'visiting the page' do
      expect(page).to have_link 'localhost', href: 'http://localhost'
    end
  end
end
