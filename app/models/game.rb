# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :frame_sets
  has_many :game_players
  has_many :players, through: :game_players
end
