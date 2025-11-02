module ApplicationHelper
  def status_badge_classes(status, color_scheme: :emerald)
    return 'bg-slate-300 text-slate-700' if status == 'archived'
    return 'bg-amber-400 text-amber-900' if status == 'draft'

    case color_scheme
    when :violet
      'bg-violet-400 text-violet-900'
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
    else
      'bg-emerald-100 text-emerald-800 ring-1 ring-emerald-600'
    end
  end
end
