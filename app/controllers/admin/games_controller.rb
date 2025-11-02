# Allow admin CRUD operations on Games.
module Admin
  class GamesController < Admin::BaseController
    def index
      @games = Game.order(created_at: :desc)
    end

    def show
      @game = Game.find(params[:id])
    end

    def new
      @game = Game.new
    end

    def edit
      @game = Game.find(params[:id])
    end

    def create
      @game = Game.new(game_params)
      if @game.save
        redirect_to admin_game_path(@game), notice: 'Game was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @game = Game.find(params[:id])
      if @game.update(game_params)
        redirect_to admin_game_path(@game), notice: 'Game was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @game = Game.find(params[:id])
      @game.destroy
      redirect_to admin_games_path, notice: 'Game was successfully deleted.'
    end

    private

    def game_params
      params.expect(game: %i[title description game_url source_attribution status thumbnail_image])
    end
  end
end
