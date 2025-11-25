# Admin controller for viewing Beads issues (read-only)
module Admin
  class BeadsController < BaseController
    def index
      @stats = BeadsService.stats
      @issues = fetch_filtered_issues
      @issues_by_priority = group_issues(@issues)
      @has_filters = filters_present?
      setup_filter_options
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

    # rubocop:disable Metrics/MethodLength
    # Justification: Method includes necessary error handling and logging
    def fetch_filtered_issues
      if filters_present?
        BeadsService.filter_issues(
          status: params[:status].presence,
          priority: params[:priority].presence,
          label: params[:label].presence
        )
      else
        BeadsService.all_issues
      end
    rescue StandardError => e
      log_fetch_error(e)
      []
    end
    # rubocop:enable Metrics/MethodLength

    def filters_present?
      params[:status].present? || params[:priority].present? || params[:label].present?
    end

    def setup_filter_options
      all_issues = BeadsService.all_issues
      @all_labels = extract_unique_labels(all_issues)
      @all_statuses = all_issues.pluck('status').uniq.sort
    end

    def extract_unique_labels(issues)
      issues.flat_map { |i| i['labels'] || [] }.uniq.sort
    end

    def log_fetch_error(error)
      Rails.logger.error("Error fetching filtered issues: #{error.message}")
      Rails.logger.error(error.backtrace.join("\n"))
    end

    def group_issues(issues)
      return {} if issues.blank?

      issues.group_by { |i| i['priority'] || 4 }.sort.to_h
    end

    def filter_params
      params.permit(:status, :priority, :label)
    end
  end
end
