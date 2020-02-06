# frozen_string_literal: true

class FrameSet < ApplicationRecord
  belongs_to :game
  belongs_to :player

  MAX_FRAMES = 10
  MAX_PINS = 10

  def frames_count
    frames.size
  end

  def full?
    frames.size == MAX_FRAMES
  end

  def complete?
    full? && current_frame_complete?
  end

  def total_score
    frames.each_with_index.map { |_, i| score(i) }.reduce(:+)
  end

  def score(frame_index)
    frame = frames[frame_index]
    return 0 if frame.empty?

    if frames.size == frame_index + 1
      sum(frame)
    elsif strike?(frame)
      next_frame = frames[frame_index + 1]
      return sum(frame) if next_frame.nil?

      if strike?(next_frame)
        # we need to go deeper
        third_frame = frames[frame_index + 2]
        return sum(frame) + sum(next_frame) if third_frame.nil?

        sum(frame) + sum(next_frame) + third_frame[0]
      else
        sum(frame) + next_frame[0].to_i + next_frame[1].to_i
      end
    elsif spare?(frame)
      next_frame = frames[frame_index + 1]
      return sum(frame) if next_frame.nil?

      sum(frame) + next_frame[0].to_i
    else
      sum(frame)
    end
  end

  def current_frame_complete?
    last_frame = frames.last

    if full?
      if (last_frame.size == 3) && (strike?(last_frame[0..0]) || spare?(last_frame[0..1]))
        true
      else strike?(last_frame)
       false
      end
    elsif strike?(last_frame) || last_frame.size == 2
      true
    else
      false
    end
  end

  private

  def strike?(frame)
    frame.size == 1 && sum(frame) == MAX_PINS
  end

  def spare?(frame)
    frame.size == 2 && sum(frame) == MAX_PINS
  end

  def sum(frame)
    frame.map(&:to_i).reduce(:+).to_i
  end
end
