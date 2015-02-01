class ApplicationController < ActionController::Base
  class PageNotFound < StandardError; end
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  protect_from_forgery with: :exception
  before_filter :set_locale
  layout "application"
  helper_method :translation_scope

  def render_404
    render file: Rails.root.join('public', '404.html'), status: 404, layout: nil
  end

  def set_locale
    I18n.locale = params[:locale]
  end

  def redirect_to_locale_root
    # if no matching root found for any of client locales
    # use first root
    target_root = select_root_by_client_locale || available_roots.first
    raise PageNotFound, "No locale roots found" if target_root.blank?

    redirect_to target_root.url
  end

  def translation_scope
    "public." + self.class.name.gsub("Controller", "").underscore
  end

  private

  def available_roots
    @roots ||= Node.roots.where(locale: I18n.available_locales, active: true)
  end

  def select_root_by_client_locale
    roots_by_locale = {}

    available_roots.each do |root|
      roots_by_locale[ root.locale ] = root unless roots_by_locale[ root.locale ].present?
    end

    target_root = nil

    # find first client locale that has a root
    http_accept_language.user_preferred_languages.each do |locale|
      next unless roots_by_locale[locale].present?
      target_root = roots_by_locale[locale]
      break
    end

    target_root
  end
end
