# == Schema Information
#
# Table name: magaz_variants
#
#  id         :integer          not null, primary key
#  product_id :integer
#  price      :decimal(8, 2)
#  name       :string
#  hidden     :boolean          default(FALSE)
#  position   :integer
#  stock      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe VariantsController, type: :controller do
    routes { Magaz::Engine.routes }

    let(:variant) { create(:magaz_variant) }
    let(:product) { create(:magaz_product_with_variants) }
    let(:category) { create(:magaz_category_with_properties_and_products) }

    before :each do
      sign_in create(:magaz_user)
    end

    describe "GET #index" do
      before :each do
        get :index, product_id: product
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:product)).to eq(product)
        expect(assigns(:parent_category)).to eq(product.category)
        expect(assigns(:variants)).to eq(product.variants)
      end

      it "renders index" do
        expect(response).to render_template(:index)
      end
    end

    describe "GET #new" do
      it "responds successfully with a HTTP 200 status code" do
        get :new, product_id: product
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        p = category.products.take
        image_count = 5
        1.upto(image_count) { p.images << Magaz::Image.create(picture: Faker::Internet.url) }
        get :new, product_id: p
        expect(assigns(:product)).to eq(p)
        expect(assigns(:p)).to eq(p)
        expect(assigns(:parent_category)).to eq(p.category)
        expect(assigns(:variant)).to be_a_new(Variant)
        expect(assigns(:property_groups)).to eq(p.category.property_groups)
        expect(assigns(:images)).to eq(p.images)
        expect(assigns(:options)).to be_a(Array)
      end

      it "renders template" do
        get :new, product_id: product
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_category)
        @p = create(:magaz_product)
      end

      context "valid attributes" do

        subject { post :create, product_id: @p, variant: @params, var_name: Faker::Lorem.word }

        it "creates a new instance" do
          expect { subject }.to change{ Variant.count }.by(1)
        end

        it "redirects to variants path" do
          expect(subject).to redirect_to(product_variants_path(@p))
        end
      end

      context "invalid attributes" do
        subject { post :create, product_id: @p, variant: @params }

        it "doesn't save the new instance" do
          expect{ subject }.to_not change{ Variant.count }
        end

        it "re-renders new template" do
          expect(subject).to render_template(:new)
        end
      end
    end

    describe "GET #edit" do
      it "responds successfully with a HTTP 200 status code" do
        get :edit, id: product.variants.take
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables and render template" do
        p = category.products.take
        image_count = 5
        1.upto(image_count) { p.images << Magaz::Image.create(picture: Faker::Internet.url) }
        v = p.variants.take
        get :edit, id: v
        expect(assigns(:variant)).to eq(v)
        expect(assigns(:product)).to eq(p)
        expect(assigns(:parent_category)).to eq(p.category)
        expect(assigns(:property_groups)).to eq(p.category.property_groups)
        expect(assigns(:images)).to eq(p.images)
        expect(assigns(:options)).to be_a(Array)
      end
    end

    describe "PUT #update" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_variant)
      end

      context "valid attributes" do
        before :each do
          put :update, id: variant, variant: @params, var_name: @params["name"]
        end

        it "locates the requested instance" do
          expect(assigns(:variant)).to eq(variant)
        end

        it "change instance attributes" do
          variant.reload
          %w|price name|.each do |field|
            expect(variant[field]).to eq(@params[field])
          end
        end

        it "redirects to variants path" do
          expect(response).to redirect_to(product_variants_path(variant.product))
        end
      end

      context "invalid attributes" do
        it "doesn't change the instance attributes" do
          old_name = variant.name
          old_price = variant.price
          put :update, id: variant, variant: @params
          variant.reload
          expect(variant.name).to eq(old_name)
          expect(variant.price).to eq(old_price)
        end

        it "re-renders the edit template" do
          put :update, id: variant, variant: @params
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "POST #shift" do
      it "assigns new values and redirects" do
        post :shift, shift: {product: product, items: [{id: variant.id, checked: true}] }
        expect(assigns(:product)).to eq(product)
        expect(response).to redirect_to(product_variants_path(product))
      end
    end

    describe "PUT #up/#down" do
      it "moves the variant up and redirects" do
        v = product.variants.last
        expect {
          put :up, variant_id: v
        }.to change{ v.reload.position }.by(-1)
        expect(response).to redirect_to(product_variants_path(product))
      end

      it "moves the variant down and redirects" do
        v = product.variants.first
        expect {
          put :down, variant_id: v
        }.to change{ v.reload.position }.by(1)
        expect(response).to redirect_to(product_variants_path(product))
      end
    end

    describe "DELETE #destroy" do
      it "deletes the instance" do
        v = create(:magaz_variant)
        expect {
          delete :destroy, id: v
        }.to change{ Variant.count }.by(-1)
      end

      it "redirects to variant index" do
        delete :destroy, id: product.variants.take
        expect(response).to redirect_to(product_variants_path(product))
      end
    end

  end
end
