# frozen_string_literal: true

namespace :apps do
  task import: :environment do
    CsvParser.import_apps
  end
end
