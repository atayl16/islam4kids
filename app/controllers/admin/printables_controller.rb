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
      attachments_to_remove = collect_attachments_to_remove

      if @printable.update(printable_params)
        purge_attachments_safely(attachments_to_remove)
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

    def collect_attachments_to_remove
      attachments = []
      %i[thumbnail_image pdf_file image_file].each do |attachment_name|
        attachments << attachment_name if params.dig(:printable, "remove_#{attachment_name}") == '1'
      end
      attachments
    end

    def purge_attachments_safely(attachment_names)
      purge_attachments(attachment_names)
    rescue StandardError => e
      Rails.logger.error("Failed to purge attachments: #{e.message}")
      # Optionally flash a warning to the user
    end

    def purge_attachments(attachment_names)
      attachment_names.each do |attachment_name|
        attachment = @printable.public_send(attachment_name)
        attachment.purge if attachment.attached?
      end
    end

    def printable_params
      params.expect(printable: %i[title description printable_type status pdf_file image_file
                                  thumbnail_image])
    end
  end
end
