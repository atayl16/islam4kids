module ApplicationHelper
  def status_badge_classes(status, color_scheme: :emerald)
    return 'bg-slate-300 text-slate-700' if status == 'archived'
    return 'bg-amber-400 text-amber-900' if status == 'draft'

    case color_scheme
    when :violet
      'bg-violet-400 text-violet-900'
    when :indigo
      'bg-indigo-400 text-indigo-900'
    else
      'bg-emerald-400 text-emerald-900'
    end
  end

  def status_badge_index_classes(status, color_scheme: :emerald)
    return 'bg-slate-100 text-slate-800 ring-1 ring-slate-600' if status == 'archived'
    return 'bg-amber-100 text-amber-800 ring-1 ring-amber-600' if status == 'draft'

    case color_scheme
    when :violet
      'bg-violet-100 text-violet-800 ring-1 ring-violet-600'
    when :indigo
      'bg-indigo-100 text-indigo-800 ring-1 ring-indigo-600'
    else
      'bg-emerald-100 text-emerald-800 ring-1 ring-emerald-600'
    end
  end

  # Beads issue tracker helpers
  def priority_badge_color(priority)
    case priority.to_i
    when 0 then 'bg-red-600'
    when 1 then 'bg-orange-500'
    when 2 then 'bg-blue-500'
    when 3 then 'bg-green-500'
    else 'bg-gray-500'
    end
  end

  def priority_label(priority)
    case priority.to_i
    when 0 then 'Critical'
    when 1 then 'High'
    when 2 then 'Normal'
    when 3 then 'Low'
    else 'Very Low'
    end
  end

  def status_badge_color(status)
    case status.to_s
    when 'open' then 'bg-blue-100 text-blue-800'
    when 'in_progress' then 'bg-yellow-100 text-yellow-800'
    when 'closed' then 'bg-green-100 text-green-800'
    when 'blocked' then 'bg-red-100 text-red-800'
    else 'bg-gray-100 text-gray-800'
    end
  end

  def type_badge_color(type)
    case type.to_s
    when 'epic' then 'bg-purple-100 text-purple-800'
    when 'feature' then 'bg-blue-100 text-blue-800'
    when 'bug' then 'bg-red-100 text-red-800'
    when 'chore' then 'bg-yellow-100 text-yellow-800'
    else 'bg-gray-100 text-gray-800' # Default for 'task' and unknown types
    end
  end
end
