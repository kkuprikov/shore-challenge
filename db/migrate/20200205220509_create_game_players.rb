# frozen_string_literal: true

class CreateGamePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :game_players do |t|
      t.references :game
      t.references :player

      t.timestamps
    end
  end
end
