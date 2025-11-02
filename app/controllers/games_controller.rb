class GamesController < ApplicationController
  def index
    @games = Rails.cache.fetch('games/published-collection', expires_in: 12.hours) do
      Game.published.order(created_at: :desc).to_a
    end
  end
end
