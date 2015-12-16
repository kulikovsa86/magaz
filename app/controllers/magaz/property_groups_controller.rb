require_dependency "magaz/application_controller"

module Magaz
  class PropertyGroupsController < ApplicationController
    before_action :set_property_group, only: [:edit, :update, :destroy]

    # GET    /property_groups(/:parent_id)(.:format)
    def index
      if params[:parent_id]
        @parent_group = PropertyGroup.find(params[:parent_id])
        @groups = @parent_group.children.order(:position)
      else
        @groups = PropertyGroup.roots.order(:position)
      end
      if @parent_group && !@parent_group.properties.empty?
        redirect_to property_group_properties_path(@parent_group)
      end
    end

    # GET    /property_groups/new(/:parent_id)(.:format)
    def new
      @property_group = PropertyGroup.new
      if params[:parent_id]
        @parent_group = PropertyGroup.find(params[:parent_id])
      end
    end

    # GET /property_groups/1/edit
    def edit
      @parent_group = @property_group.parent
    end

    # POST   /property_groups(/:parent_id)(.:format)
    def create
      @property_group = PropertyGroup.new(property_group_params)
      if @property_group.save
        if params[:parent_id]
          PropertyGroup.find(params[:parent_id]).add_child @property_group
        end
        redirect_to @property_group, notice: t('.success')
      else
        render :new
      end
    end

    # PATCH/PUT /property_groups/1
    def update
      if @property_group.update(property_group_params)
        redirect_to edit_property_group_path(@property_group), notice: t('.success')
      else
        render :edit
      end
    end

    # PATCH  /property_groups/:property_group_id/up(.:format)
    def up
      group = PropertyGroup.find(params[:property_group_id])
      group.move_higher
      redirect_to property_groups_path(parent_id: group.parent)
    end

    # PATCH  /property_groups/:property_group_id/down(.:format)
    def down
      group = PropertyGroup.find(params[:property_group_id])
      group.move_lower
      redirect_to property_groups_path(parent_id: group.parent)
    end

    # DELETE /property_groups/1
    def destroy
      @parent_group = @property_group.parent
      @property_group.destroy
      redirect_to property_groups_path(@parent_group), notice: t('.success')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_property_group
        @property_group = PropertyGroup.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def property_group_params
        params.require(:property_group).permit(:name, :code)
      end
  end
end
