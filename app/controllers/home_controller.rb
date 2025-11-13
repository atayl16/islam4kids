class HomeController < ApplicationController
  def index
    @games = Rails.cache.fetch('games/published-collection', expires_in: 12.hours) do
      Game.published.order(created_at: :desc).limit(6).to_a
    end

    @printables = Rails.cache.fetch('printables/published-collection', expires_in: 12.hours) do
      Printable.published.order(created_at: :desc).limit(6).to_a
    end
  end
end
