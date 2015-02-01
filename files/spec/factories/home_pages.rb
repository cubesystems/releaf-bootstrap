FactoryGirl.define do
  factory :home_page do
    intro_text_html "we believe"
  end

  factory :home_page_node, parent: :node do
    name "LV"
    slug "lv"
    locale "lv"
    item_position 1
    content_type "HomePage"
    association :content, factory: :home_page
  end
end
