# Allow admin CRUD operations on Printables.
module Admin
  class PrintablesController < Admin::BaseController
    def index
      @printables = Printable.order(created_at: :desc)
    end

    def show
      @printable = Printable.find(params[:id])
    end

    def new
      @printable = Printable.new
    end

    def edit
      @printable = Printable.find(params[:id])
    end

    def create
      @printable = Printable.new(printable_params)
      if @printable.save
        redirect_to admin_printable_path(@printable), notice: 'Printable was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @printable = Printable.find(params[:id])
      if @printable.update(printable_params)
        redirect_to admin_printable_path(@printable), notice: 'Printable was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @printable = Printable.find(params[:id])
      @printable.destroy
      redirect_to admin_printables_path, notice: 'Printable was successfully deleted.'
    end

    private

    def printable_params
      params.expect(printable: %i[title description printable_type published published_at pdf_file thumbnail_image])
    end
  end
end
