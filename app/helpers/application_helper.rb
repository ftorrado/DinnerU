module ApplicationHelper
  # Returns the '+active+' HTML class if this is the current section
  def active_if_section(section_name, current_section = '')
    'active' if section_name == current_section
  end
end
