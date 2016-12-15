module Magaz
  module ApplicationHelper
    
    def active_class(link_path)
      current_page?(link_path) ? "active" : ""
    end

    def active_tab(tab)
      if tab == controller_name
        "active"
      else
        ""
      end
    end


    def t_att(model, attribute)
      t("activerecord.attributes.#{model}.#{attribute}")
    end

    def str2bool(val)
      if val.class == String && val == "1"
        true
      else
        false
      end
    end

    def active_section(section)
      # if section == "categories" && %w|categories products variants|.include?(controller_name)
      if section == "categories" && (controller_name == 'categories' || request.fullpath.include?('product'))
        "active"
      elsif section == "properties" && %w|properties property_groups property_options property_args|.include?(controller_name)
        "active"
      elsif section == "comments"
        if request.fullpath.exclude?('product') && request.fullpath.include?('comment')
          "active"  
        end
      elsif section == controller_name
        "active"
      else
        ""
      end
    end

    def action_list
      [t('magaz.common.move'), t('magaz.common.remove')]
    end

    def default_action
      t('magaz.common.move')
    end

    def setting_moulded?
      Magaz::Setting.get_bool('magaz-moulded')
    end

    def property_kind_icon(property)
      content_tag :span do
        if property.variant?
          content_tag(:i, nil, :class => "fa fa-pencil-square fa-fw") 
        elsif property.special?
          content_tag(:i, nil, :class => "fa fa-cog fa-fw")
        end
      end
    end

  end
end
