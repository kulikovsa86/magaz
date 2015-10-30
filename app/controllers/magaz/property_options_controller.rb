require_dependency "magaz/application_controller"

module Magaz
  class PropertyOptionsController < ApplicationController

    before_action :set_property, only: [:create, :destroy, :up, :down]

    def create
      @property_option = @property.property_options.create(property_option_params)
      flash[:notice] = t('.success')
      redirect_to edit_property_path(@property)
    end

    def destroy
      @property_option = @property.property_options.find(params[:id])
      @property_option.destroy
      flash[:notice] = t('.success')
      redirect_to edit_property_path(@property)
    end

    def up
      option = @property.property_options.find(params[:id])
      option.move_higher
      redirect_to edit_property_path(@property)
    end

    def down
      option = @property.property_options.find(params[:id])
      option.move_lower
      redirect_to edit_property_path(@property)
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
