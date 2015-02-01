class TextPagesController < ApplicationController
  include NodeController
  def show
    @node = ::Node.find(params[:node_id])
    @text = @node.content
  end
end
