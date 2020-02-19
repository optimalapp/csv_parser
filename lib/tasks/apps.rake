# frozen_string_literal: true

namespace :apps do
  task import: :environment do
    App.import_apps('lib/assets')
  end
end
