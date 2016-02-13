# == Schema Information
#
# Table name: magaz_statuses
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  note       :text
#  closed     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class Status < ActiveRecord::Base

    acts_as_list

    def self.NEW
      Status.find_by(code: '01')
    end

  end
end
