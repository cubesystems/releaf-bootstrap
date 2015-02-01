require 'rails_helper'

describe ApplicationController do
  describe "#translation_scope" do
    it "returns normalized class name" do
      expect(subject.translation_scope).to eq("public.application")
      expect(HomePagesController.new.translation_scope).to eq("public.home_pages")
    end
  end

  describe "404" do
    it "rescues from ActionController::RoutingError" do
      allow(subject).to receive(:redirect_to_locale_root).and_raise(ActionController::RoutingError.new("x"))
      get :redirect_to_locale_root
      expect(response.status).to eq(404)
    end

    it "rescues from ActiveRecord::RecordNotFound" do
      allow(subject).to receive(:redirect_to_locale_root).and_raise(ActiveRecord::RecordNotFound)
      get :redirect_to_locale_root
      expect(response.status).to eq(404)
    end

    it "renders 404 error page" do
      allow(subject).to receive(:redirect_to_locale_root).and_raise(ActiveRecord::RecordNotFound)
      get :redirect_to_locale_root
      expect(response.status).to render_template(file: "#{Rails.root}/public/404.html")
    end

    it "renders without any layout" do
      allow(subject).to receive(:redirect_to_locale_root).and_raise(ActiveRecord::RecordNotFound)
      get :redirect_to_locale_root
      expect(response.status).to render_template(layout: nil)
    end
  end
end
