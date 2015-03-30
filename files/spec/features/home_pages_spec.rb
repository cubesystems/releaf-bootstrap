require 'rails_helper'

feature "Home pages", js: true do
  background do
    auth_as_user
  end

  scenario "Create and view public home page" do
    visit releaf_content_nodes_path
    click_link "Create new resource"
    click_link "Home page"

    create_resource do
      fill_in 'Name', with: "Lv"
      select "lv", from: "Locale"
      fill_in_richtext "Intro text", with: "<strong>We</strong> believe."
    end

    visit "/lv"
    expect(page).to have_content("We believe")
  end
end
