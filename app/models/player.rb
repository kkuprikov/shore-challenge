# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :frame_sets
  has_many :game_players
  has_many :games, through: :game_players
end
