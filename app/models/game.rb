# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :frame_sets
  has_many :players, through: :games_players
end
