# frozen_string_literal: true

class App < ApplicationRecord
  def self.import_apps(_folder_path)
    CsvParser.get_data_from_csv_urls(_folder_path) do |app_hash|
      app = App.find_by(app_hash)
      App.create(app_hash) if app.nil?
    end
  end
end
