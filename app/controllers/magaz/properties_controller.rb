# == Schema Information
#
# Table name: magaz_properties
#
#  id                :integer          not null, primary key
#  code              :string
#  name              :string
#  description       :text
#  property_type_id  :integer
#  static            :boolean          default(FALSE)
#  variant           :boolean          default(FALSE)
#  position          :integer
#  property_group_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  property_kind_id  :integer
#

require_dependency "magaz/application_controller"

module Magaz
  class PropertiesController < ApplicationController
    before_action :set_property, only: [:edit, :update, :destroy, :up, :down, :descr]
    before_action :set_group, only: [:index, :new, :create]

    # GET    /property_groups/:property_group_id/properties(.:format)
    def index
      @properties = @parent_group.properties.order(:position)
    end

    # GET    /property_groups/:property_group_id/properties/new(.:format)
    def new
      @property = Property.new
      @property_group = @parent_group
    end

    # GET    /properties/:id/edit(.:format)
    def edit
      @parent_group = @property.group
    end

    # GET    /properties(/:id)/descr(.:format)
    def descr
      @parent_group = @property.group
    end

    # POST   /property_groups/:property_group_id/properties(.:format)
    def create
      @property = Property.new(property_params)
      @property.property_group_id = @parent_group.id
      @property_group = @parent_group
      if @property.save
        redirect_to property_group_properties_path(@parent_group), notice: t('.success')
      else
        render :new
      end
    end

    # PATCH/PUT /properties/1
    def update
      if @property.update(property_params)
        if params[:descr]
          redirect_to property_description_path(@property), notice: t('.success')
        else
          redirect_to edit_property_path(@property), notice: t('.success')
        end
      else
        render :edit
      end
    end

    # PATCH  /properties/:property_id/up(.:format)
    def up
      @property.move_higher
      @parent_group = @property.property_group
      redirect_to property_group_properties_path(@parent_group)
    end

    # PATCH  /properties/:property_id/down(.:format)
    def down
      @property.move_lower
      @parent_group = @property.property_group
      redirect_to property_group_properties_path(@parent_group)
    end

    # DELETE /properties/1
    def destroy
      @parent_group = @property.group
      @property.destroy
      redirect_to property_group_properties_path(@parent_group), notice: t('.success')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_property
        if params[:id]
          @property = Property.find(params[:id])
        elsif params[:property_id]
          @property = Property.find(params[:property_id])
        else
          @property = Property.new
        end
      end

      def set_group
        @parent_group = PropertyGroup.find(params[:property_group_id])
      end

      # Only allow a trusted parameter "white list" through.
      def property_params
        params.require(:property).permit(:code, :name, :description, :property_type_id, :static, :variant, :property_kind_id)
      end

  end
end
