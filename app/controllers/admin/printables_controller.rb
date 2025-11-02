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
      handle_attachment_removal

      if @printable.update(printable_params)
        redirect_to admin_printable_path(@printable), notice: 'Printable was successfully updated.'
      else
        # Reload to ensure attachments are in a valid state after failed update
        @printable.reload
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @printable = Printable.find(params[:id])
      @printable.destroy
      redirect_to admin_printables_path, notice: 'Printable was successfully deleted.'
    end

    private

    def handle_attachment_removal
      purge_if_requested(:thumbnail_image)
      purge_if_requested(:pdf_file)
      purge_if_requested(:image_file)
    end

    def purge_if_requested(attachment_name)
      return unless params.dig(:printable, "remove_#{attachment_name}") == '1'

      attachment = @printable.public_send(attachment_name)
      attachment.purge if attachment.attached?
    end

    def printable_params
      params.expect(printable: %i[title description printable_type status pdf_file image_file
                                  thumbnail_image])
    end
  end
end
