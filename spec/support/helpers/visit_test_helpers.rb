module VisitTestHelpers
  def click_topbar_link(menu:, title:, icon:)
    within '.topbar' do
      expect(page).not_to have_link title
      click_link menu
      expect(page).to have_selector icon
      click_link title
    end
  end

  def navigate_via_topbar(menu:, title:, icon:)
    visit '/home'

    click_topbar_link(menu: menu, title: title, icon: icon)

    expect(page).to have_header(title, icon)
  end
end

RSpec.configuration.include VisitTestHelpers, type: :feature