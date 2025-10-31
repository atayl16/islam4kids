class PrintablesController < ApplicationController
  def index
    @printables = Rails.cache.fetch('printables/published-collection', expires_in: 12.hours) do
      Printable.published.order(created_at: :desc).to_a
    end
  end

  def show
    @printable = Rails.cache.fetch("printables/#{params[:id]}", expires_in: 12.hours) do
      Printable.published.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to printables_path, alert: 'Printable not found'
  end
end
