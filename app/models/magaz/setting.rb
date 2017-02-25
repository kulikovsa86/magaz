# == Schema Information
#
# Table name: magaz_settings
#
#  id         :integer          not null, primary key
#  name       :string
#  value      :string
#  param      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class Setting < ActiveRecord::Base

    class << self

      def latest
        Magaz::Setting.order(:updated_at).last
      end

      def set(name, value)
        s = Magaz::Setting.find_or_create_by(name: name)
        s.value = value
        s.save
        s.id
      end

      def get(name)
        s = Setting.find_by(name: name)
        if s
          s.value
        else
          nil
        end
      end

      # val: nil, false, '0' -> false; else -> true
      def set_bool(name, val)
        s = Magaz::Setting.find_or_create_by(name: name)
        if !val || val == '0'
          s.value = '0'
        else
          s.value = '1'
        end
        s.save
        s.value
      end

      def get_bool(name)
        if get(name) && get(name) != '0'
          true
        else
          false
        end
      end

    end

  end
end
