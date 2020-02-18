# frozen_string_literal: true

require 'csv'
module CsvParser
  def self.import_apps
    get_csv_data do |app_hash|
      App.create(app_hash)
    end
  end

  private

  def self.get_csv_data
    get_urls do |url|
      @numeric_id = url.scan(/\d+/).join
      if @numeric_id.length >= 9
        yield app_hash
      else
        yield app_hash(url)
      end
    end
  end

  def self.get_urls
    root_path = Rails.root.join('lib', 'assets')
    csv_files = File.path(root_path) + '/*.csv'
    Dir[csv_files].each do |file|
      cleaned = File.readlines(file).map { |r| r.split.join.gsub(',', '') }.map { |l| l.include?('https') ? l : nil }.compact
      cleaned.each { |l| yield l }
    end
  end

  def self.app_hash(url = nil)
    app = {}
    if url.nil?
      app[:store_name] = 'Apple Store'
      app[:id_in_store] = @numeric_id
      app
    else
      app[:store_name] = 'Google Play'
      app[:id_in_store] = get_id(url)
      app
    end
  end

  def self.get_id(_url)
    regexp = /\w+\.\w+\.\w+/
    last_match = ''
    if _url.match(regexp)
      last_match = _url.match(regexp).to_s
      regexp = /\w+\.\w+\.\w+\.\w+/
      if _url.match(regexp)
        last_match = _url.match(regexp).to_s
        regexp = /\w+\.\w+\.\w+\.\w+\.\w+/
        if _url.match(regexp)
          _url.match(regexp).to_s
        else
          last_match
        end
      else
        last_match
      end
    end
  end
end
