# frozen_string_literal: true

class GamesPlayers < ApplicationRecord
  belongs_to :game
  belongs_to :player
end
