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

require 'rails_helper'

module Magaz
  RSpec.describe CommentsController, type: :controller do

    routes { Magaz::Engine.routes }

    before :each do
      sign_in create(:magaz_user)
    end

    let(:comment) { create(:magaz_comment) }
    let(:product) { create(:magaz_product_with_comments) }

    describe "GET #index" do
      it "responds successfully with a HTTP 200 status code" do
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        get :index, product_id: comment.product
        expect(assigns(:filter)).to eq('all')
        expect(assigns(:product)).to eq(comment.product)
        expect(assigns(:parent_category)).to eq(comment.product.category)
        expect(assigns(:comments)).to eq([comment])
      end

      it "renders index" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe "GET #edit" do
      before :each do
        get :edit, id: comment
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:product)).to eq(comment.product)
        expect(assigns(:comment)).to eq(comment)
      end

      it "renders edit" do
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #update" do
      context "valid attributes" do
        before :each do
          @params = attributes_with_foreign_keys_for(:magaz_comment)
        end

        it "locates the requested instance" do
          put :update, id: comment, comment: @params
          expect(assigns(:comment)).to eq(comment)
        end

        it "changes instance attributes" do
          put :update, id: comment, comment: @params
          comment.reload
          %w|name text rate accepted fresh|.each do |field|
            expect(comment[field]).to eq(@params[field])
          end
        end

        it "redirects to edit page" do
          put :update, id: comment, comment: @params
          expect(response).to redirect_to(product_comments_path(comment.product))
        end
      end

      context "invalid attributes" do
        before :each do
          @params = attributes_with_foreign_keys_for(:magaz_comment)
          @params[:name] = ''
        end

        it "doesn't change the instance attributes" do
          old_name = comment.name
          put :update, id: comment, comment: @params
          comment.reload
          expect(comment.name).to eq(old_name)
        end

        it "assigns variables" do
          put :update, id: comment, comment: @params
          expect(assigns(:comment)).to eq(comment)
          expect(assigns(:product)).to eq(comment.product)
        end

        it "re-renders the edit template" do
          put :update, id: comment, comment: @params
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "DELETE #destroy" do
      it "deletes instance and redirects" do
        c = create(:magaz_comment)
        expect {
          delete :destroy, id: c
        }.to change{ Comment.count }.by(-1)
        expect(response).to redirect_to(product_comments_path(c.product))
      end
    end

  end
end
