# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FrameSet, type: :model do
  let(:empty_frameset) { described_class.create(frames: [[]]) }
  let(:one) { described_class.create(frames: [[1, 2]]) }
  let(:two) { described_class.create(frames: [[10], [5, 2]]) }

  FRAMES_DATA = [
    { data: [[]], score: 0, complete: false },
    { data: [[6]], score: 6, complete: false },
    { data: [[6, 4], [2]], score: 14, complete: false },
    { data: [[1, 2]], score: 3, complete: true },
    { data: [[1, 2], [3]], score: 6, complete: false },
    { data: [[10], [5, 2]], score: 24, complete: true },
    { data: [[6, 4], [3, 4]], score: 20, complete: true },
    { data: [[6, 4], [3]], score: 16, complete: false },
    { data: [[10], [10], [3, 4]], score: 47, complete: true },
    { data: [[10], [5, 5], [3, 4]], score: 40, complete: true },
    { data: [[10], [10], [10], [10], [10], [10], [10], [10], [10], [10]], score: 270, complete: false },
    { data: [[10], [10], [10], [10], [10], [10], [10], [10], [10], [10, 10, 10]], score: 300, complete: true }
  ].freeze

  describe 'score' do
    FRAMES_DATA.each do |row|
      it "should eq #{row[:score]} for #{row[:data]} frameset" do
        frame = described_class.create(frames: row[:data])
        expect(frame.total_score).to eq(row[:score])
      end
    end
  end

  describe 'current_frame_complete?' do
    FRAMES_DATA.each do |row|
      it "should eq #{row[:complete]} for #{row[:data]} frameset" do
        frame = described_class.create(frames: row[:data])
        expect(frame.current_frame_complete?).to eq(row[:complete])
      end
    end
  end
end
