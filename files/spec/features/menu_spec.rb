require 'rails_helper'

feature "Menu" do
  background do
    create_root_nodes do
      @nodes[:lv_about_us] = create( :text_page_node, parent_id: @nodes[:lv_root].id, item_position: 1,
                                    active: true, name: "about us" )
      @nodes[:lv_contacts] = create( :text_page_node, parent_id: @nodes[:lv_root].id, item_position: 2,
                                                 active: true, name: "contacts" )
      @nodes[:lv_contacts_shop] = create( :text_page_node, parent_id: @nodes[:lv_contacts].id, item_position: 1,
                                                 active: true, name: "contacts shop" )
      @nodes[:lv_about_us_old] = create( :text_page_node, parent_id: @nodes[:lv_root].id, item_position: 3,
                                                 active: false, name: "about us old" )
    end
  end

  scenario "menu ordering" do
    visit @nodes[:lv_root].path
    expect( page ).to have_css('.menu li', count: 2)
    expect( page ).to have_css('.menu li:first-child a', text: "about us")
    expect( page ).to have_css('.menu li:last-child a', text: "contacts")

    visit @nodes[:en_root].path
    expect( page ).to have_css('.menu li', count: 0)
  end

  scenario "highlight current node" do
    visit @nodes[:lv_root].path
    expect( page ).to have_no_css('.menu li.active', text: "about us")
    expect( page ).to have_no_css('.menu li.active', text: "contacts")

    click_link "contacts"
    expect( page ).to have_no_css('.menu li.active', text: "about us")
    expect( page ).to have_css('.menu li.active', text: "contacts")

    click_link "about us"
    expect( page ).to have_css('.menu li.active', text: "about us")
    expect( page ).to have_no_css('.menu li.active', text: "contacts")

    visit @nodes[:lv_contacts_shop].path
    expect( page ).to have_no_css('.menu li.active', text: "about us")
    expect( page ).to have_css('.menu li.active', text: "contacts")
  end
end
