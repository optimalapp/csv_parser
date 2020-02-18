# frozen_string_literal: true

require 'csv'

module CsvParser
  def get_data
    @g_store = 'google'
    @a_store = 'apple'
    @itns = 'itunes'
    get_urls do |url|
      if url.include?(@g_store)
        yield app_hash(url, @g_store)
      elsif url.include?(@a_store) && url.include?(@itns)
        yield app_hash(url, @a_store)
      elsif url.include?('ios')
        yield app_hash(url, @a_store)
      elsif url.include?(@itns)
      end
    end
  end

  private

  def get_urls
    root_path = Rails.root.join('lib', 'assets')
    csv_files = File.path(root_path) + '/*.csv'
    Dir[csv_files].each do |file|
      cleaned = File.readlines(file).map { |r| r.split.join.gsub(',', '') }.map { |l| l.include?('https') ? l : nil }.compact
      cleaned.each { |l| yield l }
    end
  end

  def app_hash(url, store)
    index = get_index(url)
    app = {}
    app[:store_name] = store.to_s
    app[:id_in_store] = store == @a_store ? get_id(url, index).match(/\d+/) : get_id(url, index)
    app
  end

  def get_id(url, _index)
    url.split('')[_index + 1..url.split('').length].join
  end

  def get_index(url)
    url.split('').map.with_index { |d, i| d == '/' ? i : nil }.compact.last
  end
end
