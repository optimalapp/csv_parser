# frozen_string_literal: true

namespace :apps do
  task import: :environment do
    App.import_apps_from('lib/assets')
  end
end
