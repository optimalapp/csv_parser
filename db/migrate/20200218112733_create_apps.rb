# frozen_string_literal: true

class CreateApps < ActiveRecord::Migration[6.0]
  def change
    create_table :apps do |t|
      t.string :store_name
      t.string :id_in_store, unique: true
      t.index :id_in_store

      t.timestamps
    end
  end
end
