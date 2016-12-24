# == Schema Information
#
# Table name: magaz_property_values
#
#  id            :integer          not null, primary key
#  property_id   :integer
#  value         :string
#  valuable_id   :integer
#  valuable_type :string
#  position      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module Magaz
  class PropertyValue < ActiveRecord::Base
    belongs_to :property
    belongs_to :valuable, polymorphic: true

    scope :features, -> { joins(property: :property_kind).where('magaz_property_kinds' => { id: Magaz::PropertyKind::FEATURE.id }) }

    scoped_search on: :value

  end
end
