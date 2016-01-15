require_dependency "magaz/application_controller"

module Magaz
  class VariantsController < ApplicationController

    before_action :set_product, only: [:index, :new, :create]
    before_action :set_variant, only: [:edit, :update]

    # GET    /products/:product_id/variants(.:format)
    def index
      @parent_category = @product.category
    end

    # GET    /products/:product_id/variants/new(.:format)
    def new
      @p = @product
      @parent_category = @product.category
      @variant = Variant.new
      # @properties = @product.category.dynamic_properties
      @property_groups = @product.category.property_groups
      @images = @product.images
      @options = []
      @product.images.each { |image| @options << [image.id, image.id, {:'data-img-src' => image.picture.url}] }
    end

    # POST   /products/:product_id/variants(.:format)
    def create
      # variant = @product.variants.create(variant_params)
      @variant = Variant.new(variant_params)
      @variant.name = params[:var_name]
      @variant.product_id = @product.id
      if @variant.save
        @variant.set_properties(params[:properties]) if params[:properties]
        redirect_to product_variants_path(@product), notice: t('.success')
      else
        @parent_category = @product.category
        @property_groups = @product.category.property_groups
        @images = @product.images
        @options = []
        @product.images.each { |image| @options << [image.id, image.id, {:'data-img-src' => image.picture.url}] }
        render :new
      end
    end

    # GET    /variants/:id/edit(.:format)
    def edit
      @product = @variant.product
      @parent_category = @product.category
      @property_groups = @product.category.property_groups
      @images = @product.images
      @options = []
      @product.images.each { |image| @options << [image.id, image.id, {:'data-img-src' => image.picture.url}] }
    end

    # PATCH/PUT  /variants/:id(.:format)
    def update
      redirect_to product_variants_path(@variant.product), notice: t('.success')
    end

    # DELETE /variants/:id(.:format)
    def destroy
      @variant = Variant.find(params[:id])
      @product = @variant.product
      @variant.destroy
      redirect_to product_variants_path(@product), notice: t('.success')
    end

    private
      def set_product
        @product = Product.find_by_permalink(params[:product_id])
      end

      def set_variant
        @variant = Variant.find(params[:id])
      end

      def variant_params
        params.require(:variant).permit(:price, image_ids: [])
      end

      def variant_properties
        params.require(:properties)
      end
  end
end