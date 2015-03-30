require 'rails_helper'

feature "Text pages", js: true do
  background do
    create_root_nodes
    auth_as_user
  end

  scenario "Create and view public text page" do
    visit edit_releaf_content_node_path(Node.roots.find_by(locale: "lv"))
    open_toolbox("Add child")
    click_link "Text page"

    create_resource do
      fill_in 'Name', with: "About us"
      fill_in_richtext "Text", with: "<strong>some</strong> text about us."
    end

    find(".node-fields .link a").click
    expect(current_path).to eq("/lv/about-us")
    expect(page).to have_content("some text about us.")
  end
end
