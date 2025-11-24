# Admin controller for viewing Beads issues (read-only)
module Admin
  class BeadsController < BaseController
    def index
      @stats = BeadsService.stats
      @issues = fetch_filtered_issues || []
      @issues_by_priority = group_issues(@issues)
      @has_filters = params[:status].present? || params[:priority].present? || params[:label].present?

      # Get unique labels for filter dropdown
      all_issues = BeadsService.all_issues
      @all_labels = all_issues.flat_map { |i| i["labels"] || [] }.uniq.sort

      # Get unique statuses
      @all_statuses = all_issues.map { |i| i["status"] }.uniq.sort
    end

    def show
      @issue = BeadsService.show_issue(params[:id])

      if @issue.blank? || @issue.empty?
        redirect_to admin_beads_path, alert: "Issue not found: #{params[:id]}"
        return
      end

      @dependency_tree = BeadsService.dependency_tree(params[:id])
    end

    helper_method :filter_params

    private

    def fetch_filtered_issues
      status = params[:status].presence
      priority = params[:priority].presence
      label = params[:label].presence

      if status || priority || label
        BeadsService.filter_issues(
          status: status,
          priority: priority,
          label: label
        )
      else
        BeadsService.all_issues
      end
    rescue StandardError => e
      Rails.logger.error("Error fetching filtered issues: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      []
    end

    def group_issues(issues)
      return {} if issues.blank?
      issues.group_by { |i| i["priority"] || 4 }.sort.to_h
    end

    def filter_params
      params.permit(:status, :priority, :label)
    end
  end
end
