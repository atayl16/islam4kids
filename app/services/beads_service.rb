# Service for interacting with Beads issue tracker via CLI
class BeadsService
  class << self
    # Get all issues
    def all_issues
      result = execute_command("bd list --json")
      JSON.parse(result)
    rescue StandardError => e
      Rails.logger.error("Beads CLI error: #{e.message}, falling back to direct file read")
      read_issues_from_file
    end

    # Get ready issues (no blockers)
    def ready_issues
      result = execute_command("bd ready --json 2>/dev/null || echo '[]'")
      JSON.parse(result)
    rescue StandardError => e
      Rails.logger.error("Beads ready CLI error: #{e.message}, calculating from issues")
      issues = read_issues_from_file
      # Ready issues are those that are open and have no dependencies blocking them
      all_blocked_ids = issues.flat_map { |i| i["dependencies"]&.select { |d| d["type"] == "blocks" }&.map { |d| d["depends_on_id"] } || [] }.uniq
      issues.select { |i| i["status"] == "open" && !all_blocked_ids.include?(i["id"]) }
    end

    # Get project statistics
    def stats
      result = execute_command("bd stats")
      parse_stats(result)
    rescue StandardError => e
      Rails.logger.error("Beads stats CLI error: #{e.message}, calculating from issues")
      calculate_stats_from_issues
    end

    # Get single issue details
    def show_issue(id)
      result = execute_command("bd show #{sanitize_id(id)} --json 2>/dev/null || echo '{}'")
      parsed = JSON.parse(result)
      return parsed unless parsed.empty?
      # Fallback to file read if CLI returns empty
      read_issues_from_file.find { |issue| issue["id"] == sanitize_id(id) }
    rescue StandardError => e
      Rails.logger.error("Beads show CLI error: #{e.message}, falling back to file read")
      read_issues_from_file.find { |issue| issue["id"] == sanitize_id(id) }
    end

    # Get dependency tree for an issue
    def dependency_tree(id)
      execute_command("bd dep tree #{sanitize_id(id)}")
    rescue StandardError => e
      Rails.logger.error("Beads dep tree error: #{e.message}")
      "Error loading dependency tree"
    end

    # Get blocked issues
    def blocked_issues
      result = execute_command("bd blocked --json 2>/dev/null || echo '[]'")
      JSON.parse(result)
    rescue StandardError => e
      Rails.logger.error("Beads blocked error: #{e.message}")
      []
    end

    # Filter issues by various criteria
    def filter_issues(status: nil, priority: nil, label: nil)
      issues = all_issues

      issues = issues.select { |i| i["status"] == status } if status.present?
      issues = issues.select { |i| i["priority"] == priority.to_i } if priority.present?
      issues = issues.select { |i| i["labels"]&.include?(label) } if label.present?

      issues
    end

    # Group issues by priority
    def issues_by_priority
      all_issues.group_by { |i| i["priority"] }.sort.to_h
    end

    # Group issues by status
    def issues_by_status
      all_issues.group_by { |i| i["status"] }
    end

    private

    def execute_command(command)
      # Execute within the Rails root directory where .beads is located
      Dir.chdir(Rails.root) do
        `#{command}`.strip
      end
    end

    def sanitize_id(id)
      # Only allow alphanumeric and hyphens to prevent command injection
      id.to_s.gsub(/[^a-zA-Z0-9\-]/, "")
    end

    def parse_stats(output)
      stats = {
        total: 0,
        open: 0,
        in_progress: 0,
        closed: 0,
        blocked: 0,
        ready: 0
      }

      output.each_line do |line|
        stats[:total] = line.match(/Total Issues:\s+(\d+)/)[1].to_i if line.include?("Total Issues:")
        stats[:open] = line.match(/Open:\s+(\d+)/)[1].to_i if line.include?("Open:")
        stats[:in_progress] = line.match(/In Progress:\s+(\d+)/)[1].to_i if line.include?("In Progress:")
        stats[:closed] = line.match(/Closed:\s+(\d+)/)[1].to_i if line.include?("Closed:")
        stats[:blocked] = line.match(/Blocked:\s+(\d+)/)[1].to_i if line.include?("Blocked:")
        stats[:ready] = line.match(/Ready:\s+(\d+)/)[1].to_i if line.include?("Ready:")
      end

      stats
    end

    def default_stats
      {
        total: 0,
        open: 0,
        in_progress: 0,
        closed: 0,
        blocked: 0,
        ready: 0
      }
    end

    def read_issues_from_file
      issues_file = Rails.root.join(".beads", "issues.jsonl")
      return [] unless File.exist?(issues_file)

      File.readlines(issues_file).map do |line|
        JSON.parse(line.strip)
      rescue JSON::ParserError => e
        Rails.logger.error("Error parsing JSONL line: #{e.message}")
        nil
      end.compact
    rescue StandardError => e
      Rails.logger.error("Error reading issues file: #{e.message}")
      []
    end

    def calculate_stats_from_issues
      issues = read_issues_from_file
      all_blocked_ids = issues.flat_map { |i| i["dependencies"]&.select { |d| d["type"] == "blocks" }&.map { |d| d["depends_on_id"] } || [] }.uniq

      {
        total: issues.count,
        open: issues.count { |i| i["status"] == "open" },
        in_progress: issues.count { |i| i["status"] == "in_progress" },
        closed: issues.count { |i| i["status"] == "closed" },
        blocked: issues.count { |i| all_blocked_ids.include?(i["id"]) },
        ready: issues.count { |i| i["status"] == "open" && !all_blocked_ids.include?(i["id"]) }
      }
    end
  end
end
