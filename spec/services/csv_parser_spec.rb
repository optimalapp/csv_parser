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

  it 'gets data from urls' do
    urls_list = ['https://apptopia.com/apps/google_play/com.netease.l10',
                 'https://apptopia.com/apps/google_play/com.us.danmemo',
                 'https://apptopia.com/apps/google_play/com.gameone.tlbb',
                 'https://apptopia.com/apps/itunes_connect/1253537199',
                 'https://apptopia.com/apps/itunes_connect/1448712419',
                 'https://apptopia.com/apps/itunes_connect/1449235979',
                 'https://apptopia.com/ios/app/1448852425/intelligence',
                 'https://apptopia.com/ios/app/389801252/intelligence',
                 'https://apptopia.com/ios/app/1445450568/intelligence',
                 'https://apptopia.com/google-play/app/com.facebook.orca/intelligence',
                 'https://apptopia.com/google-play/app/com.colorup.game/intelligence',
                 'https://apptopia.com/google-play/app/com.zhiliaoapp.musically/intelligence',
                 'https://apptopia.com/google-play/app/com.pandora.android/intelligence',
                 'https://itunes.apple.com/us/app/fortnite/id1261357853?mt=8',
                 'https://itunes.apple.com/us/app/golf-clash/id1089225191?mt=8',
                 'https://play.google.com/store/apps/details?id=air.com.buffalo_studios.newflashbingo&hl=en',
                 'https://play.google.com/store/apps/details?id=com.kabam.marvelbattle&hl=en',
                 'https://play.google.com/store/apps/details?id=com.smallgiantgames.empires&hl=en']

    results = [{ store_name: 'Google', id_in_store: 'com.netease.l10' },
               { store_name: 'Google', id_in_store: 'com.us.danmemo' },
               { store_name: 'Google', id_in_store: 'com.gameone.tlbb' },
               { store_name: 'Apple', id_in_store: '1253537199' },
               { store_name: 'Apple', id_in_store: '1448712419' },
               { store_name: 'Apple', id_in_store: '1449235979' },
               { store_name: 'Apple', id_in_store: '1448852425' },
               { store_name: 'Apple', id_in_store: '389801252' },
               { store_name: 'Apple', id_in_store: '1445450568' },
               { store_name: 'Google', id_in_store: 'com.facebook.orca' },
               { store_name: 'Google', id_in_store: 'com.colorup.game' },
               { store_name: 'Google', id_in_store: 'com.zhiliaoapp.musically' },
               { store_name: 'Google', id_in_store: 'com.pandora.android' },
               { store_name: 'Apple', id_in_store: '1261357853' },
               { store_name: 'Apple', id_in_store: '1089225191' },
               { store_name: 'Google', id_in_store: 'air.com.buffalo_studios.newflashbingo' },
               { store_name: 'Google', id_in_store: 'com.kabam.marvelbattle' },
               { store_name: 'Google', id_in_store: 'com.smallgiantgames.empires' }]
    urls_list.map.with_index do |url, i|
      expect(CsvParser.get_data_from_url(url) == results[i]).to eq(true)
    end
  end
end
