# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def form_field(label, field)
    haml_tag(:dt) do
      haml_tag(:div, label.to_s)
    end
    
    haml_tag(:dd, find_and_preserve(field))
  end
  
  def nav_link(name)
    haml_tag(:li, {:class => (controller.kind_of?("#{name.to_s.camelize}Controller".constantize) ? 'active' : 'inactive' )}) do
      puts link_to(name.to_s.titleize, self.send("#{name.to_s.tableize}_path"))
    end
  end
  
  def section_for(object, options = {}, &block)
    case options[:header]
    when Array
      headers = []
      options[:header].each_with_index do |header, index|
        case header
        when String
          headers << header
        when Symbol
          headers << link_to(header.to_s.titleize, self.send("#{header.to_s}_path"))
        when ActiveRecord::Base
          headers << link_to(header.to_s, self.send("#{ActionController::RecordIdentifier.singular_class_name(header)}_path", header))
        end
      end
      
      options[:header] = headers
    end

    case object
    when Symbol
      name    = object
      header  = options[:header] || object.to_s.titleize
    when ActiveRecord::Base
      header = options[:header]
      
      unless header
        if object.new_record?
          header = "New #{ActionController::RecordIdentifier.singular_class_name(object).titleize}"
        else
          header = object.to_s
        end
      end
      
      name = ActionController::RecordIdentifier.singular_class_name(object)
    when Enumerable
      header  = options[:header] || ActionController::RecordIdentifier.plural_class_name(object.to_a.first).titleize
      header << " (#{object.size})" if object.size > 0
      name    = ActionController::RecordIdentifier.plural_class_name(object.to_a.first)
    end
    
    haml_tag(:div, {:class => :section, :id => name}) do
      haml_tag(:div, {:class => :body}) do
        haml_tag(:div, {:class => :header}) do
          haml_tag(:h1) do
            case header
            when String
              puts header
            when Array
              haml_tag(:ul) do
                header.each do |item|
                  haml_tag(:li, item)
                end
              end
            end
          end
        end
        
        puts capture_haml(name, &block) if block_given?
      end
    end
  end
end
