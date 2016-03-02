# == Schema Information
#
# Table name: magaz_categories
#
#  id          :integer          not null, primary key
#  code        :string
#  name        :string
#  description :string
#  hidden      :boolean          default(TRUE)
#  parent_id   :integer
#  position    :integer
#  permalink   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe CategoriesController, type: :controller do

    routes { Magaz::Engine.routes }

    before :each do
      sign_in create(:magaz_user)
    end

    let(:category) { create(:magaz_category) }
    let(:category_with_children) { create(:magaz_category_with_children) }
    let(:product) { create(:magaz_product) }

    describe "GET #index" do
      it "responds successfully with a HTTP 200 status code" do
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns root categories and renders index" do
        categories = create_list(:magaz_category, 5)
        get :index
        expect(assigns(:categories)).to eq(categories)
        expect(response).to render_template(:index)
      end

      it "assigns children categories and renders index" do
        get :index, parent: category_with_children
        expect(assigns(:parent_category)).to eq(category_with_children)
        expect(assigns(:categories)).to eq(category_with_children.children)
        expect(response).to render_template(:index)
      end

      it "redirects if category is empty" do
        category.children << product.category
        cc = product.category
        get :index, parent: cc
        expect(assigns(:parent_category)).to eq(cc)
        expect(assigns(:categories)).to eq([])
        expect(response).to redirect_to(category_products_path(cc))
      end
    end

    describe "GET #new" do
      it "responds successfully with a HTTP 200 status code" do
        get :new
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables and renders new" do
        get :new, parent: category
        expect(assigns(:category)).to be_a_new(Category)
        expect(assigns(:parent_category)).to eq(category)
        expect(response).to render_template(:new)
      end
    end

    describe "GET #edit" do
      before :each do
        @c = category_with_children.children.first
        get :edit, id: @c
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables and render template" do
        expect(assigns(:category)).to eq(@c)
        expect(assigns(:parent_category)).to eq(category_with_children)
        expect(response).to render_template(:edit)
      end
    end

    describe "POST #create" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_category)
      end

      context "valid attributes" do
        it "creates a new instance" do
          expect {
            post :create, category: @params
          }.to change{ Category.count }.by(1)
        end

        it "adds new child to parent category" do
          expect {
            post :create, category: @params, parent: category
          }.to change{ category.reload.children.count }.by(1)
        end

        it "redirects to edit path" do
          post :create, category: @params
          expect(response).to redirect_to(edit_category_path(Category.last))
        end
      end

      context "invalid attributes" do
        before :each do
          @params.delete "name"
        end

        it "doesn't save the new instance" do
          expect {
            post :create, category: @params
          }.to_not change{ Category.count }
        end

        it "re-renders the new template" do
          post :create, category: @params
          expect(response).to render_template(:new)
        end
      end
    end

    describe "PUT #update" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_category)
      end

      context "valid attributes" do
        it "locates the requested instance" do
          put :update, id: category, category: @params
          expect(assigns(:category)).to eq(category)
        end

        it "changes instance attributes" do
          put :update, id: category, category: @params
          category.reload
          %w|code name description hidden|.each do |field|
            expect(category[field]).to eq(@params[field])
          end
        end
      end

      context "invalid attributes" do
        before :each do
          @params[:name] = ''
        end

        it "doesn't change the instance attributes" do
          old_name = category.name
          put :update, id: category, category: @params
          category.reload
          expect(category.name).to eq(old_name)
        end

        it "re-renders the edit template" do
          put :update, id: category, category: @params
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "PUT #up/#down" do
      it "moves the category up and redirects" do
        c = category_with_children.children.last
        expect {
          put :up, category_id: c
        }.to change{ c.reload.position }.by(-1)
        expect(response).to redirect_to(categories_path(category_with_children))
      end

      it "moves the category down and redirects" do
        c = category_with_children.children.first
        expect {
          put :down, category_id: c
        }.to change{ c.reload.position }.by(1)
        expect(response).to redirect_to(categories_path(category_with_children))
      end
    end

    describe "DELETE #destroy" do
      it "deletes the instance" do
        c = create(:magaz_category)
        expect {
          delete :destroy, id: c
        }.to change{ Category.count }.by(-1)
      end

      it "redirects to products index" do
        delete :destroy, id: category_with_children.children.first
        expect(response).to redirect_to(categories_path(category_with_children))
      end
    end

  end
end
