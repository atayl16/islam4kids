module ApplicationHelper
  def status_badge_classes(status, color_scheme: :emerald)
    return 'bg-slate-300 text-slate-700' if status == 'archived'
    return 'bg-amber-400 text-amber-900' if status == 'draft'

    base_color = color_scheme == :violet ? 'violet' : 'emerald'
    "bg-#{base_color}-400 text-#{base_color}-900"
  end

  def status_badge_index_classes(status, color_scheme: :emerald)
    return 'bg-slate-100 text-slate-800 ring-1 ring-slate-600' if status == 'archived'
    return 'bg-amber-100 text-amber-800 ring-1 ring-amber-600' if status == 'draft'

    base_color = color_scheme == :violet ? 'violet' : 'emerald'
    "bg-#{base_color}-100 text-#{base_color}-800 ring-1 ring-#{base_color}-600"
  end
end

