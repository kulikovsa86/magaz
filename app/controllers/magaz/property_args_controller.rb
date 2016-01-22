require_dependency "magaz/application_controller"

module Magaz
  class PropertyArgsController < ApplicationController

    before_action :set_property, only: [:index]
    before_action :set_property_arg, only: [:update]

    # GET    /properties/:property_id/property_args(.:format)
    def index
      @property_arg = @property.property_arg
      @parent_group = @property.group
    end

    # PATCH/PUT  /property_args/:id(.:format)
    def update
      @property_arg.update(property_arg_params)
      @property = @property_arg.property
      redirect_to property_property_args_path(@property), notice: t('.success')
    end

    private

      def set_property
        @property = Property.find(params[:property_id])
      end

      def set_property_arg
        @property_arg = PropertyArg.find(params[:id])
      end

      def property_arg_params
        params.require(:property_arg).permit(:min, :max, :step, :default)
      end

  end
end