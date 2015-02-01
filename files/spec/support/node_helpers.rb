module NodeHelpers
  def create_root_nodes
    destroy_root_nodes false

    @nodes = {}

    def @nodes.reload!
      self.each_pair do |key, node|
        node.reload
      end
      Rails.application.reload_routes!
    end

    def @nodes.destroy *keys
      keys.each do |key|
        next if self[key].blank?
        self[key].destroy
        self.delete key
      end
    end

    @nodes[:lv_root] = create( :home_page_node, name: "Latviešu", slug: "lv", locale: "lv", item_position: 1)
    @nodes[:en_root] = create( :home_page_node, name: "English",  slug: "en", locale: "en", item_position: 2)

    yield if block_given?

    @nodes.reload!

  end

  def destroy_root_nodes reload_routes = true

    if @nodes.present?
      @nodes[:en_root].destroy unless @nodes[:en_root].blank?
      @nodes[:lv_root].destroy unless @nodes[:lv_root].blank?
    end

    @nodes = {}

    Rails.application.reload_routes! if reload_routes

  end
end
