require_dependency "magaz/application_controller"

module Magaz
  class PropertiesController < ApplicationController
    before_action :set_property, only: [:edit, :update, :destroy]

    # GET /properties
    def index
      @properties = Property.all
    end


    # GET /properties/new
    def new
      @property = Property.new
    end

    # GET /properties/1/edit
    def edit
    end

    # POST /properties
    def create
      @property = Property.new(property_params)

      if @property.save
        redirect_to edit_property_path(@property), notice: t('.success')
      else
        render :new
      end
    end

    # PATCH/PUT /properties/1
    def update
      if @property.update(property_params)
        redirect_to edit_property_path(@property), notice: t('.success')
      else
        render :edit
      end
    end

    # DELETE /properties/1
    def destroy
      @property.destroy
      redirect_to properties_url, notice: t('.success')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_property
        @property = Property.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def property_params
        params.require(:property).permit(:code, :name, :property_type_id, :static)
      end
  end
end
