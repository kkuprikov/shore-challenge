# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Games API', type: :request do
  let(:game) { Game.create }
  let(:game2) { Game.create }
  let(:player) { Player.create(name: 'Josh') }
  let(:player2) { Player.create(name: 'Bob') }
  let(:game_player) { GamePlayer.create(game_id: game.id, player_id: player.id) }
  let(:game_player2) { GamePlayer.create(game_id: game.id, player_id: player2.id) }
  let(:game2_player2) { GamePlayer.create(game_id: game2.id, player_id: player2.id) }
  let(:frame_set) { FrameSet.create(game_id: game.id, player_id: player.id, frames: [[10]]) }
  let(:frame_set2) { FrameSet.create(game_id: game.id, player_id: player2.id) }
  let(:frame_set3) { FrameSet.create(game_id: game2.id, player_id: player2.id) }

  describe 'POST /games/:id/add_score' do
    before(:each) { game; player; game_player; frame_set }
    it 'should add some scores' do
      post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 9 }
      post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 1 }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).dig('data', 'frames')).to eq([[10], [9, 1]])
    end

    context 'with strike' do
      it 'should be in separate frame 1' do
        post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 10 }
        post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 2 }

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body).dig('data', 'frames')).to eq([[10], [10], [2]])
      end

      it 'should be in separate frame 2' do
        post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 2 }
        post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 5 }
        post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 10 }

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body).dig('data', 'frames')).to eq([[10], [2, 5], [10]])
      end

      it 'should add maximum scores' do
        11.times do
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

  describe 'GET games/:id' do
    before { game; player; player2; game_player; game_player; frame_set; frame_set2 }

    it 'should return game with frame sets' do
      post "/games/#{game.id}/add_score", params: { player_id: player.id, score: 9 }
      get "/games/#{game.id}"

      expect(response.status).to eq(200)
      
      expect(JSON.parse(response.body).dig('data', 'frame_sets').first.dig('player', 'name')).to eq player.name
      expect(JSON.parse(response.body).dig('data', 'frame_sets').size).to eq game.frame_sets.size

      expect(JSON.parse(response.body).dig('data', 'frame_sets').first['frames'].first['frame']).to eq([10])
      expect(JSON.parse(response.body).dig('data', 'frame_sets').first['frames'].first['score']).to eq(19)

      expect(JSON.parse(response.body).dig('data', 'frame_sets').first['frames'].last['frame']).to eq([9])
      expect(JSON.parse(response.body).dig('data', 'frame_sets').first['frames'].last['score']).to eq(9)
    end
  end

  describe 'GET /games' do
    before { game; game2; player; player2; game_player; game_player2 }
    it 'should return game ids' do
      get '/games'

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data'].map{|d| d['id']}).to contain_exactly(game.id, game2.id)
    end
  end
end
