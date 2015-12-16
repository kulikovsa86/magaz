module Magaz
  class PropertyGroup < ActiveRecord::Base
    acts_as_tree dependent: :destroy
    acts_as_list scope: :parent

    has_many :properties, dependent: :destroy
  end
end
