# frozen_string_literal: true

require 'csv'
module CsvParser
  def self.get_data_from_csv_urls(_folder_path)
    @folder_path = _folder_path
    length = 9
    get_processed_urls do |_url|
      @numeric_id = _url.scan(/\d+/).join
      if @numeric_id.length >= length
        yield app_hash
      else
        yield app_hash(_url)
      end
    end
  end

  def self.get_data_from_url(_url)
    length = 9
    @numeric_id = _url.scan(/\d+/).join
    if @numeric_id.length >= length
      app_hash
    else
      app_hash(_specific_url)
    end
  end

  def self.csv_files(_folder_path)
    _folder_path ||= @folder_path
    root_path = Rails.root.join(_folder_path)
    csvs = File.path(root_path) + '/*.csv'
    Dir[csvs]
  end

  def self.get_processed_urls(_specific_file = nil)
    if _specific_file.nil?
      csv_files(@folder_path).each do |_file|
        cleaned_urls(_file).each { |l| yield l }
      end
    else
      cleaned_urls(_specific_file)
    end
  end

  private

  def self.cleaned_urls(file)
    File.readlines(file).map { |r| r.split.join.gsub(',', '') }.map { |l| l.include?('https') ? l : nil }.compact
  end

  def self.app_hash(url = nil)
    app = {}
    if url.nil?
      app[:store_name] = 'iOs'
      app[:id_in_store] = @numeric_id
      app
    else
      app[:store_name] = 'Google'
      app[:id_in_store] = get_id(url)
      app
    end
  end

  def self.get_id(_url)
    regexp = /\w+\.\w+\.?\w+\.?\w+\.?\w+\.?\w+\.?\w+\.?\w+\.?\w+\.?\w+/
    _url = get_short_url(_url, get_index(_url, '/', 3))
    _url.match(regexp).to_s
  end

  def self.get_index(url, char, _nr)
    hash = {}
    url.split('').map.with_index { |d, i| d == char && hash.count < _nr ? hash[i] = d : nil }.compact.last
    hash.keys.last
  end

  def self.get_short_url(url, _index)
    url.split('')[_index + 1..url.split('').length].join
  end
end
