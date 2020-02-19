# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvParser, type: :service do
  let(:folder_path) { 'lib/assets' }
  let(:file_name) { 'test-candidate-csv.csv' }
  let(:csv_files) { CsvParser.csv_files(folder_path) }
  let(:csv_file) { csv_files.find { |file| file.include?(file_name) } }

  it 'gets CSV files from specific directory' do
    expect(csv_files.map { |file| file.include?(file_name) }.first).to eq(true)
  end

  it 'gets processed urls from CSV file' do
    urls_list = ['https://apptopia.com/apps/google_play/com.netease.l10',
                 'https://apptopia.com/apps/google_play/com.us.danmemo',
                 'https://apptopia.com/apps/google_play/com.gameone.tlbb',
                 'https://apptopia.com/apps/google_play/com.netease.clxhw',
                 'https://apptopia.com/apps/google_play/and.onemt.war.en',
                 'https://apptopia.com/apps/google_play/com.kabam.doamobile',
                 'https://apptopia.com/apps/google_play/com.etermax.preguntados.pro']
    urls = CsvParser.get_processed_urls(csv_file)
    urls_list.map.with_index do |url, i|
      expect(url == urls[i]).to eq(true)
    end
  end
end
