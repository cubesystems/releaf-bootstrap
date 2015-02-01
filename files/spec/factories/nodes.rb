FactoryGirl.define do
  factory :node, class: Node do
    sequence(:name) {|n| "node #{n}"}
    sequence(:slug) {|n| "node-#{n}"}
    active true
    content_type "HomePage"
  end
end
