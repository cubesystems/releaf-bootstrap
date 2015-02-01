class Node < ActiveRecord::Base
  include Releaf::Content::Node
  validates_with Releaf::Content::Node::RootValidator, allow: [HomePage]

  def locale_selection_enabled?
    root?
  end
end
