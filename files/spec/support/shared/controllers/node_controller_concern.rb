shared_examples "a node controller" do |options={}|

  before(:all) do
    create_root_nodes do
    end
  end

  after(:all) do
    destroy_root_nodes
  end

  describe "before filters" do

    controller(described_class) do

      def index
        render text: "index"
      end

    end

    describe "#load_node" do

      it "assigns node " do
        get :index, locale: "lv", node_id: @nodes[:lv_root].id
        expect(assigns[:node]).to eq @nodes[:lv_root]
      end

      it "assigns content" do
        get :index, locale: "lv", node_id: @nodes[:lv_root].id
        expect(assigns[:content]).to eq @nodes[:lv_root].content
      end

    end
  end
end
