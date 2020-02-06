# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Games API', type: :request do
  let(:game) { Game.create }
  let(:player) { Player.create(name: 'Josh') }
  let(:game_player) { GamesPlayers.create(game_id: game.id, player_id: player.id) }
  let(:frame_set) { FrameSet.create(game_id: game.id, player_id: player.id) }

  describe 'adding score' do
    before(:each) { game; player; game_player; frame_set }
    it 'should add some scores' do
      post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 9 }
      post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 1 }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).dig('data', 'frames')).to eq([[9, 1]])
    end

    context 'with strike' do
      it 'should be in separate frame 1' do
        post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 10 }
        post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 2 }

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body).dig('data', 'frames')).to eq([[10], [2]])
      end

      it 'should be in separate frame 2' do
        post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 2 }
        post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 5 }
        post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 10 }

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body).dig('data', 'frames')).to eq([[2, 5], [10]])
      end

      it 'should add maximum scores' do
        12.times do
          post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 10 }
        end

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body).dig('data', 'frames')).to eq([[10], [10], [10], [10], [10], [10], [10], [10], [10], [10, 10, 10]])
      end
    end

    it 'should not add bad score' do
      post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 11 }

      expect(response.status).to eq(400)
    end
  end

  describe 'viewing games' do
    # TODO
  end
end
