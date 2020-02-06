# frozen_string_literal: true

class PlayerService
  def create_player(name)
    @result = Player.create(name: name)
    self
  end

  def self.index
    Player.all.order(:created_at)
  end
end
