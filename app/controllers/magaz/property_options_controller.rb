# == Schema Information
#
# Table name: magaz_property_options
#
#  id          :integer          not null, primary key
#  property_id :integer
#  code        :string
#  name        :string
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require_dependency "magaz/application_controller"

module Magaz
  class PropertyOptionsController < ApplicationController

    before_action :set_property, only: [:index, :create]

    #  GET    /properties/:property_id/property_options(.:format)
    def index
      @parent_group = @property.group
    end

    # POST   /properties/:property_id/property_options(.:format)
    def create
      @property_option = @property.property_options.create(property_option_params)
      flash[:notice] = t('.success')
      redirect_to property_property_options_path(@property)
    end

    # PATCH  /property_options/:property_option_id/up(.:format)
    def up
      option = PropertyOption.find(params[:property_option_id])
      @property = option.property
      option.move_higher
      redirect_to property_property_options_path(@property)
    end

    # PATCH  /property_options/:property_option_id/down(.:format)
    def down
      option = PropertyOption.find(params[:property_option_id])
      @property = option.property
      option.move_lower
      redirect_to property_property_options_path(@property)
    end

    # DELETE /property_options/:id(.:format)
    def destroy
      option = PropertyOption.find(params[:id])
      @property = option.property
      option.destroy
      flash[:notice] = t('.success')
      redirect_to property_property_options_path(@property)
    end

    private

      def set_property
        @property = Property.find(params[:property_id])
      end

      def property_option_params
        params.require(:property_option).permit(:name)
      end

  end
end
