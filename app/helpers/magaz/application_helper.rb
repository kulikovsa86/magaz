module Magaz
  module ApplicationHelper
    
    def active_class(link_path)
      current_page?(link_path) ? "active" : ""
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
      if section == "categories" && %w|categories products variants|.include?(controller_name)
        "active"
      elsif section == controller_name
        "active"
      else
        ""
      end
    end
  end
end
