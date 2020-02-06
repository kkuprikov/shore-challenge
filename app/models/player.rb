# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :frame_sets
  has_many :games, through: :games_players
end
