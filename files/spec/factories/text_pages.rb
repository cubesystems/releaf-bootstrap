FactoryGirl.define do
  factory :text_page do
    text_html "MyText"
  end

  factory :text_page_node, parent: :node do
    name "some text"
    slug "some-text"
    content_type "TextPage"
    association :content, factory: :text_page
  end
end
