# frozen_string_literal: true

class PlayerService
  def self.create_player(name)
    Player.create(name: name)
  end
end
