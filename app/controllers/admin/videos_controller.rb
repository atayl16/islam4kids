# Allow admin CRUD operations on Videos.
module Admin
  class VideosController < Admin::BaseController
    def index
      @videos = Video.all.ordered
    end

    def show
      @video = Video.find(params[:id])
    end

    def new
      @video = Video.new
    end

    def edit
      @video = Video.find(params[:id])
    end

    def create
      @video = Video.new(video_params)
      if @video.save
        redirect_to admin_video_path(@video), notice: 'Video was successfully created.'
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      @video = Video.find(params[:id])
      if @video.update(video_params)
        redirect_to admin_video_path(@video), notice: 'Video was successfully updated.'
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @video = Video.find(params[:id])
      @video.destroy
      redirect_to admin_videos_path, notice: 'Video was successfully deleted.'
    end

    private

    def video_params
      params.require(:video).permit(:title, :description, :video_url, :status, :featured, :position)
    end
  end
end
