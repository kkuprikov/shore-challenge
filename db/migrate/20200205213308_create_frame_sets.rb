# frozen_string_literal: true

class CreateFrameSets < ActiveRecord::Migration[6.0]
  def change
    create_table :frame_sets do |t|
      t.json :frames, null: false, default: [[]]
      t.references :game
      t.references :player

      t.timestamps
    end
  end
end
