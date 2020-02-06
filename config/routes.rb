# frozen_string_literal: true

Rails.application.routes.draw do
  resources :players, only: %i[index create]
  resources :games, only: %i[index create] do
    member do
      post :add_score
    end
  end
end
