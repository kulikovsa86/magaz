require_dependency "magaz/application_controller"

module Magaz
  class CommentsController < ApplicationController

    # before_action :set_product, only: [:index]
    before_action :set_comment, only: [:edit, :update, :destroy]

    # GET    /products/:product_id/comments(.:format)
    def index
      @filter = 'all'
      @filter = params[:filter] if params[:filter]
      if params[:product_id]
        @product = Product.find_by_permalink(params[:product_id])
        @comments = @product.comments.order(:created_at)
      else
        @comments = Comment.all.order(:created_at)
      end
      if @filter == 'new'
        @comments = @comments.where(fresh: true)
      elsif @filter == 'accepted'
        @comments = @comments.where(accepted: true)
      elsif @filter == 'hidden'
        @comments = @comments.where(accepted: false)
      end    
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
        params.require(:comment).permit(:name, :text, :rate, :accepted, :fresh)
      end

  end
end