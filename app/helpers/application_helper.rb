module ApplicationHelper
  include Pagy::Frontend

  def render_nested_groups(groups)
    s = content_tag(:ul) do
      groups.map do |group, sub_groups|
        content_tag(:li, (group.name +  render_nested_groups(sub_groups)).html_safe)
      end.join.html_safe
    end
  end
end
