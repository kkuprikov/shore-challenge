# frozen_string_literal: true

class CreateGamesPlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :games_players do |t|
      t.references :game
      t.references :player

      t.timestamps
    end
  end
end
