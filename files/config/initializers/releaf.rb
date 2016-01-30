Releaf.application.configure do
  config.menu = [
    {
      name: "permissions",
      items:   %w[releaf/permissions/users releaf/permissions/roles],
    },
    {
      controller: 'releaf/i18n_database/translations',
    },
  ]

  config.components = [Releaf::Core, Releaf::I18nDatabase, Releaf::Permissions]
  config.available_locales = ["lv", "en"]
end
