# == Schema Information
#
# Table name: magaz_categories
#
#  id          :integer          not null, primary key
#  code        :string
#  name        :string
#  description :text
#  hidden      :boolean          default(TRUE)
#  parent_id   :integer
#  position    :integer
#  permalink   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require_dependency "magaz/application_controller"

module Magaz
  class CategoriesController < ApplicationController
    before_action :set_category, only: [:edit, :update, :destroy, :descr, :image_destroy, :seo]

    # GET /categories/(:parent)
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

    # GET    /categories(/:product_id)/descr(.:format)
    def descr
      @parent_category = @category.parent
    end

    # GET    /categories(/:id)/seo(.:format)
    def seo
      @parent_category = @category.parent
    end

    # GET /categories/new/(:parent)
    def new
      @category = Category.new
      if params[:parent]
        @parent_category = Category.find_by_permalink(params[:parent])
      end
    end

    # GET    /categories/:id/edit(.:format)
    def edit
      @parent_category = @category.parent
    end

    # POST /categories
    def create
      @category = Category.new(category_params)
      if @demo_mode
        redirect_to categories_path, alert: t("magaz.demo.disabled")
      elsif @category.save
        if params[:parent]
          Category.find_by_permalink(params[:parent]).add_child @category
        end
        redirect_to edit_category_path(@category), notice: t('.success')
      else
        render :new
      end
    end

    # PATCH/PUT  /categories/:id(.:format)
    def update
      if @demo_mode
        redirect_to categories_path, alert: t("magaz.demo.disabled")
      elsif @category.update(category_params)
        if params[:descr]
          redirect_to category_description_path(@category), notice: t('.success')
        elsif params[:seo]
          redirect_to category_seo_path(@category), notice: t('.success')
        else
          redirect_to edit_category_path(@category), notice: t('.success')
        end
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
      if @demo_mode
        redirect_to categories_path, alert: t("magaz.demo.disabled")
      else
        @parent_category = @category.parent
        @category.destroy
        redirect_to categories_path(@parent_category), notice: t('.success')
      end
    end

    # DELETE /categories/:id/image(.:format)
    def image_destroy
      if @demo_mode
        redirect_to categories_path, alert: t("magaz.demo.disabled")
      else
        @category.image.destroy
        redirect_to edit_category_path(@category), notice: t('.success')
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_category
        @category = Category.find_by_permalink(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def category_params
        params.require(:category).permit(:code, :name, :description, :hidden, :picture, :title, :meta_description, :meta_keywords, property_group_ids: [])
      end
  end
end
