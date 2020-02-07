# frozen_string_literal: true

class GameService < BaseService
  MAX_PLAYERS = ENV.fetch('MAX_PLAYERS') { 8 }

  def initialize(params: {})
    @player_ids = params[:player_ids]
  end

  def index
    @result = { status: 200, data: Game.all.as_json(only: :id, include: { 
      players: { only: [:id, :name] } }) }
    self
  end

  def show id
    game = Game.find(id)
    frame_sets = game.frame_sets.map do |frame_set|
      FrameSetService.new(game_id: game.id, player_id: frame_set.player_id)
        .get_frames_with_scores.result
    end

    @result = {status: 200, data: { id: game.id, frame_sets: frame_sets }}

    self
  rescue ActiveRecord::RecordNotFound => e
    @result = { status: 400, data: [], errors: ["Game not found: #{e.id}"] }
    self
  end

  def create_game(_params)
    if @player_ids.empty?
      @result = { status: 400, data: [], errors: ['At least one player id should be provided'] }
      return self
    end

    Player.find(@player_ids)
    game_id = Game.create.id

    game_player_hashes = @player_ids.map { |id| { player_id: id, game_id: game_id } }

    FrameSet.insert_all(game_player_hashes)
    GamePlayer.insert_all(game_player_hashes)

    @result = { status: 200, data: [game_id: game_id, player_ids: @player_ids], errors: [] }

    self
  rescue ActiveRecord::RecordNotFound => e
    @result = { status: 400, data: [], errors: ["Player not found: #{e.id}"] }
    self
  end
end
