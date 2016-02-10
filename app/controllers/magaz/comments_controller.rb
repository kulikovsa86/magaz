require_dependency "magaz/application_controller"

module Magaz
  class CommentsController < ApplicationController

    before_action :set_product, only: [:index]
    before_action :set_comment, only: [:edit, :update, :destroy]

    # GET    /products/:product_id/comments(.:format)
    def index
      @comments = @product.comments.order(:created_at)
    end

    # GET    /comments/:id/edit(.:format)
    def edit
      @product = @comment.product
    end

    # PATCH/PUT  /comments/:id(.:format)
    def update
      @comment.update(comment_params)
      redirect_to product_comments_path(@comment.product), notice: t('.success')
    end

    # DELETE /comments/:id(.:format)
    def destroy
      @product = @comment.product
      @comment.destroy
      redirect_to product_comments_path(@product), notice: t('.success')
    end

    private
      def set_product
        @product = Product.find_by_permalink(params[:product_id])
      end

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:name, :text, :rate, :accepted)
      end

  end
end