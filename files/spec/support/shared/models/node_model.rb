shared_examples "a node model" do |options={}|
  it "acts as node" do
    expect(described_class.included_modules).to include ActiveRecord::Acts::Node::InstanceMethods
  end
end
