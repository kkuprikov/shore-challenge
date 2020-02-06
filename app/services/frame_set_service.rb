# frozen_string_literal: true

class FrameSetService < BaseService
  FRAME_SIZE = 2
  LAST_FRAME_SIZE = 3
  PINS_COUNT = 10

  def initialize(game_id:, player_id:)
    @frame_set = FrameSet.find_by(game_id: game_id, player_id: player_id)
  end

  def add_score(score)
    unless @frame_set
      @result = { status: 400, data: [], errors: ['Can\'t find any frame data for this game and player'] }
      return self
    end

    if invalid_input?(score)
      @result = { status: 400, data: [], errors: ['No cheating today'] }
      return self
    end

    if @frame_set.complete?
      @result = { status: 400, data: [], errors: ["This game is complete for player #{@frame_set.player_id}"] }
      return self
    end

    new_frames = @frame_set.frames

    if @frame_set.current_frame_complete?
      new_frames << [score]
    elsif
      new_frames.last << score
    end

    @frame_set.update(frames: new_frames)

    @result = { status: 200, data: { frames: new_frames }, errors: [] }
    self
  end

  def get_frames_with_scores
    @result = @frame_set.frames.each_with_index.map do |frame, i|
      { frame: frame, score: @frame_set.score(i) }
    end

    self
  end

  private

  def invalid_input?(score)
    return true if score > PINS_COUNT
    return false if @frame_set.current_frame_complete?
    return false if @frame_set.full? && !@frame_set.current_frame_complete?

    score > PINS_COUNT - @frame_set.frames.last.last.to_i
  end
end
