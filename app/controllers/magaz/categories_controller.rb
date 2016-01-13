require_dependency "magaz/application_controller"

module Magaz
  class CategoriesController < ApplicationController
    before_action :set_category, only: [:edit, :update, :destroy]

    # GET /categories/(:parent_id)
    def index
      if params[:parent]
        @parent_category = Category.find_by_permalink(params[:parent])
        @categories = @parent_category.children.order(:position)
      else
        @categories = Category.roots.order(:position)
      end
      if @parent_category && !@parent_category.products.empty?
        redirect_to category_products_path(@parent_category)
      end
    end

    # GET /categories/new/(:parent_id)
    def new
      @category = Category.new
      if params[:parent]
        @parent_category = Category.find_by_permalink(params[:parent])
      end
      @all_properties = Property.all
    end

    # GET /categories/1/edit
    def edit
      @parent_category = @category.parent
    end

    # POST /categories
    def create
      @category = Category.new(category_params)
      if @category.save
        if params[:parent]
          Category.find_by_permalink(params[:parent]).add_child @category
        end
        redirect_to edit_category_path(@category), notice: t('.success')
      else
        render :new
      end
    end

    # PATCH/PUT /categories/1
    def update
      if @category.update(category_params)
        redirect_to edit_category_path(@category), notice: t('.success')
      else
        render :edit
      end
    end

    # PATCH  /categories/:category_id/up(.:format)
    def up
      category = Category.find_by_permalink(params[:category_id])
      category.move_higher
      redirect_to categories_path(parent: category.parent)
    end

    # PATCH  /categories/:category_id/down(.:format)
    def down
      category = Category.find_by_permalink(params[:category_id])
      category.move_lower
      redirect_to categories_path(parent: category.parent)
    end

    # DELETE /categories/1
    def destroy
      @parent_category = @category.parent
      @category.destroy
      redirect_to categories_path(@parent_category), notice: t('.success')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_category
        @category = Category.find_by_permalink(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def category_params
        params.require(:category).permit(:code, :name, :description, :hidden, property_group_ids: [])
      end
  end
end
