# == Schema Information
#
# Table name: magaz_comments
#
#  id         :integer          not null, primary key
#  name       :string
#  text       :text
#  rate       :integer
#  accepted   :boolean          default(FALSE)
#  fresh      :boolean          default(TRUE)
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require_dependency "magaz/application_controller"

module Magaz
  class CommentsController < ApplicationController

    before_action :set_comment, only: [:edit, :update, :destroy]

    # GET    /products/:product_id/comments(.:format)
    def index
      @filter = 'all'
      @filter = params[:filter] if params[:filter]
      if params[:product_id]
        @product = Product.find_by_permalink(params[:product_id])
        @parent_category = @product.category
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
      @comments = @comments.paginate(page: params[:page], per_page: 10)
    end

    # GET    /comments/:id/edit(.:format)
    def edit
      @product = @comment.product
    end

    # PATCH/PUT  /comments/:id(.:format)
    def update
      if @comment.update(comment_params)
        redirect_to product_comments_path(@comment.product), notice: t('.success')
      else
        @product = @comment.product
        render :edit
      end
    end

    # DELETE /comments/:id(.:format)
    def destroy
      @product = @comment.product
      @comment.destroy
      redirect_to product_comments_path(@product), notice: t('.success')
    end

    # POST   /comments/shift(.:format)
    def shift
      shift_params = params.require(:shift).permit(:product_id, :items => [:id, :checked])
      Comment.shift(shift_params)
      if params[:shift][:product_id]
        @product = Product.find_by_permalink(params[:shift][:product_id])
        redirect_to product_comments_path(@product)
      else
        redirect_to comments_path
      end
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
