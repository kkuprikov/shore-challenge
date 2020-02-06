# frozen_string_literal: true

class PlayersController < ApplicationController
  def index
    render json: PlayerService.index
  end

  def create
    render json: PlayerService.new(player_params).process.result
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
end
