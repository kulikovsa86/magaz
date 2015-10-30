module Magaz
  module ApplicationHelper
    def t_att(model, attribute)
      t("activerecord.attributes.#{model}.#{attribute}")
    end
  end
end
