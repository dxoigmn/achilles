# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def nav_link(name)
    open(:li, {:class => (controller.kind_of?("#{name.to_s.camelize}Controller".constantize) ? 'active' : 'inactive' )}) do
      puts link_to(name.to_s.titleize, self.send("#{name.to_s.tableize}_path"))
    end
  end
end
