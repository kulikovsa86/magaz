# == Schema Information
#
# Table name: magaz_products
#
#  id           :integer          not null, primary key
#  name         :string
#  var_name     :string
#  category_id  :integer
#  description  :text
#  price        :decimal(8, 2)
#  hidden       :boolean          default(TRUE)
#  article      :string
#  weight       :decimal(6, 3)
#  position     :integer
#  permalink    :string
#  input_dim_id :integer
#  calc_dim_id  :integer
#  correct      :boolean          default(FALSE)
#  moulded      :boolean          default(FALSE)
#  stock        :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  short_name   :string
#

require 'rails_helper'

module Magaz
  RSpec.describe ProductsController, type: :controller do

    routes { Magaz::Engine.routes }

    before :each do
      sign_in create(:magaz_user)
    end

    let(:category) { create(:magaz_category) }
    let(:category_p) { create(:magaz_category_with_products) }
    let(:product) { create(:magaz_product) }

    describe "GET #index" do
      before :each do
        get :index, category_id: category
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:parent_category)).to eq(category)
        expect(assigns(:products)).to eq(category.products)
      end

      it "renders index" do
        expect(response).to render_template(:index)
      end
    end

    describe "GET #new" do
      before :each do
        get :new, category_id: category
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:parent_category)).to eq(category)
        expect(assigns(:product)).to be_a_new(Product)
        expect(assigns(:dimensions)).to eq(Dimension.all)
      end

      it "renders new" do
        expect(response).to render_template(:new)
      end
    end

    describe "GET #edit" do
      before :each do
        get :edit, id: product
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:product)).to eq(product)
        expect(assigns(:dimensions)).to eq(Dimension.all)
      end

      it "renders edit" do
        expect(response).to render_template(:edit)
      end
    end

    describe "GET #descr" do
      before :each do
        get :descr, product_id: product
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:product)).to eq(product)
      end

      it "renders descr" do
        expect(response).to render_template(:descr)
      end
    end

    describe "POST #create" do
      context "valid attributes" do
        before :each do
          @params = attributes_with_foreign_keys_for(:magaz_product)
        end

        it "creates a new instance" do
          expect {
            post :create, category_id: category, product: @params
          }.to change{ Product.count }.by(1)
        end

        it "assigns variables" do
          post :create, category_id: category, product: @params
          expect(assigns(:parent_category)).to eq(category)
          expect(assigns(:product)).to eq(Product.last)
          expect(assigns(:category)).to eq(category)
        end

        it "redirects to edit product" do
          post :create, category_id: category, product: @params
          expect(response).to redirect_to(edit_product_path(Product.last))
        end
      end

      context "invalid attributes" do
        before :each do
          @params = attributes_with_foreign_keys_for(:magaz_product)
          @params.delete "name"
        end

        it "doesn't save the new product" do
          expect {
            post :create, category_id: category, product: @params
          }.to_not change{ Product.count }
        end

        it "re-renders the new method" do
          post :create, category_id: category, product: @params
          expect(response).to render_template(:new)
        end
      end
    end

    describe "PUT #update" do
      context "valid attributes" do
        before :each do
          @params = attributes_with_foreign_keys_for(:magaz_product)
        end

        it "locates the requested instance" do
          put :update, id: product, product: @params
          expect(assigns(:product)).to eq(product)
        end

        it "changes instance attributes" do
          put :update, id: product, product: @params
          product.reload
          %w|name description price hidden article weight correct moulded|.each do |field|
            expect(product[field]).to eq(@params[field])
          end
        end

        it "redirects to edit product" do
          put :update, id: product, product: @params
          expect(response).to redirect_to(edit_product_path(product))
        end

        it "redirects to product description" do
          put :update, id: product, product: @params, descr: true
          expect(response).to redirect_to(product_description_path(product))
        end
      end

      context "invalid attributes" do
        before :each do
          @params = attributes_with_foreign_keys_for(:magaz_product)
          @params[:name] = ''
        end

        it "doesn't change the instance attributes" do
          old_name = product.name
          put :update, id: product, product: @params
          product.reload
          expect(product.name).to eq(old_name)
        end

        it "assigns variables" do
          put :update, id: product, product: @params
          expect(assigns(:parent_category)).to eq(product.category)
        end

        it "re-renders the edit template" do
          put :update, id: product, product: @params
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "PUT #up/#down" do
      it "moves the product up and redirects" do
        p = category_p.products.last
        expect {
          put :up, product_id: p
        }.to change{ p.reload.position }.by(-1)
        expect(response).to redirect_to(category_products_path(category_p))
      end

      it "moves the product down and redirects" do
        p = category_p.products.first
        expect {
          put :down, product_id: p
        }.to change{ p.reload.position }.by(1)
        expect(response).to redirect_to(category_products_path(category_p))
      end
    end

    describe "DELETE #destroy" do
      it "deletes the instance" do
        p = create(:magaz_product)
        expect {
          delete :destroy, id: p
        }.to change{ Product.count }.by(-1)
      end

      it "redirects to products index" do
        delete :destroy, id: category_p.products.take
        expect(response).to redirect_to(category_products_path(category_p))
      end

      it "redirects to categories index if category is empty" do
        delete :destroy, id: product
        expect(response).to redirect_to(categories_path(product.category))
      end
    end

    describe "POST #upload" do

      subject { post :upload, product_id: product, picture: Faker::Internet.url }

      it "creates image object" do
        expect{ subject }.to change{ product.images.count }.by(1)
      end

      it "redirects to gallery" do
        expect(subject).to redirect_to(product_gallery_path(product))
      end
    end

    describe "GET #gallery" do

      before :each do
        get :gallery, product_id: product
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:product)).to eq(product)
        expect(assigns(:parent_category)).to eq(product.category)
      end

      it "renders gallery" do
        expect(response).to render_template(:gallery)
      end
    end

    describe "GET #properties" do
      before :each do
        @cat_pp = create(:magaz_category_with_properties_and_products)
        @p = @cat_pp.products.first
        get :properties, product_id: @p
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:product)).to eq(@p)
        expect(assigns(:parent_category)).to eq(@cat_pp)
        expect(assigns(:property_groups)).to eq(@cat_pp.property_groups)
      end

      it "renders properties" do
        expect(response).to render_template(:properties)
      end
    end

    describe "POST #properties_create" do
      it "redirects to product properties path" do
        post :properties_create, product_id: product, var_name: Faker::Lorem.word, properties: [{}]
        expect(response).to redirect_to(product_properties_path(product))
      end
    end

    describe "PUT #image_up/#image_down" do
      before :each do
        @p = create(:magaz_product_with_images)
      end

      it "moves image up and redirects" do
        image = @p.images.last
        expect {
          put :image_up, product_id: @p, image_id: image
        }.to change{ image.reload.position }.by(-1)
        expect(response).to redirect_to(product_gallery_path(@p))
      end

      it "moves image up and redirects" do
        image = @p.images.first
        expect {
          put :image_down, product_id: @p, image_id: image
        }.to change{ image.reload.position }.by(1)
        expect(response).to redirect_to(product_gallery_path(@p))
      end
    end

    describe "DELETE #image_destroy" do
      it "deletes instance and redirects" do
        p = create(:magaz_product_with_images)
        expect {
          delete :image_destroy, product_id: p, image_id: p.images.first
        }.to change{ Image.count }.by(-1)
        expect(response).to redirect_to(product_gallery_path(p))
      end
    end

    describe "PUT #shift" do
      it "assigns new values and redirects" do
        post :shift, shift: { parent: category_p, target: category.id, items: [{id: product.id, checked: true}] }
        expect(assigns(:parent_category)).to eq(category_p)
        expect(response).to redirect_to(category_products_path(category_p))
      end
    end

    describe "GET #next/#prev" do
      it "assigns next product" do
        get :next, product_id: category_p.products.first
        expect(assigns(:product)).to eq(category_p.products.second)
      end

      it "assigns prev product" do
        get :prev, product_id: category_p.products.second
        expect(assigns(:product)).to eq(category_p.products.first)
      end

      it "redirects to current tab" do
        p_from = category_p.products.first
        p_to = category_p.products.second
        get :next, product_id: p_from, to: 'descr'
        expect(response).to redirect_to(product_description_path(p_to))
        get :next, product_id: p_from, to: 'gallery'
        expect(response).to redirect_to(product_gallery_path(p_to))
        get :next, product_id: p_from, to: 'prop'
        expect(response).to redirect_to(product_properties_path(p_to))
        get :next, product_id: p_from, to: 'vars'
        expect(response).to redirect_to(product_variants_path(p_to))
        get :next, product_id: p_from, to: 'comments'
        expect(response).to redirect_to(product_comments_path(p_to))
        get :next, product_id: p_from
        expect(response).to redirect_to(edit_product_path(p_to))
      end
    end

  end
end
