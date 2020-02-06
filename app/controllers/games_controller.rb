# frozen_string_literal: true

require 'pry'
class GamesController < ApplicationController
  def index
    @result = GameService.new.index.result
    render_json_with_status
  end

  def show
    # show game with frame sets and their player ids
    @result = GameService.new(params[:id]).show.result
    render_json_with_status
  end

  def create
    @result = GameService.new(game_params).create_game.result
    render_json_with_status
  end

  def add_score
    service_params = { game_id: score_params[:id],
                       player_id: score_params[:player_id] }
    @result = FrameSetService.new(**service_params)
                             .add_score(score_params[:score].to_i)
                             .result
    render_json_with_status
  end

  private

  def game_params
    params.require(:game).permit(player_ids: [])
  end

  def score_params
    params.permit(:id, :player_id, :score).to_h.symbolize_keys
  end
end
