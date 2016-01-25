require 'rails_helper'

feature "Basic layout" do
  background do
    create_root_nodes do
    end
  end

  context "when user accepted languages have no matching locale within site" do
    it "redirects to first available locale root" do
      Capybara.current_session.driver.header('Accept-Language', 'en-US;q=0.8,en;q=0.6,lt;q=0.4,et;q=0.2')
      visit "/"
      expect(current_path).to eq(@nodes[:en_root].path)
    end
  end

  context "when user accepted languages have matching locale within site" do
    it "redirects to matched locale root" do
      Capybara.current_session.driver.header('Accept-Language', 'lv,en-US;q=0.8,en;q=0.6,lt;q=0.4,et;q=0.2,lv;q=0.2')
      visit "/"
      expect(current_path).to eq(@nodes[:lv_root].path)
    end

    context "when matching locale is disabled" do
      it "redirects to first available locale root" do
        @nodes[:lv_root].update_attribute(:active, false)
        Capybara.current_session.driver.header('Accept-Language', 'lv,en-US;q=0.8,en;q=0.6,lt;q=0.4,et;q=0.2,lv;q=0.2')
        visit "/"
        expect(current_path).to eq(@nodes[:en_root].path)
      end
    end
  end
end
