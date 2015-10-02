Releaf.setup do |conf|
  # Default settings are commented out

  ### setup menu items and therefore available controllers
  conf.menu = [
    {
      :name => "permissions",
      :items =>   %w[releaf/permissions/users releaf/permissions/roles],
      :icon => 'user',
    },
    {
      :controller => 'releaf/i18n_database/translations',
      :icon => 'group',
    },
  ]

  # controllers that must be accessible by user, but are not visible in menu
  # should be added to this list
  conf.additional_controllers = ['releaf/permissions/profile']

  conf.components = [Releaf::I18nDatabase, Releaf::Permissions]

  conf.available_locales = ["lv", "en"]
  # conf.layout_builder = CustomLayoutBuilder
  # conf.devise_for 'releaf/admin'
end
