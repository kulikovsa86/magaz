require 'rails_helper'

module Magaz
  RSpec.describe PropertiesController, type: :controller do

    routes { Magaz::Engine.routes }

    before :each do
      sign_in create(:magaz_user)
    end

    let(:property) { create(:magaz_property) }
    let(:property_group) { create(:magaz_property_group) }

    describe "GET #index" do
      it "responds successfully with a HTTP 200 status code" do
        get :index, property_group_id: property.group
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variable and renders template" do
        get :index, property_group_id: property.group
        expect(assigns(:properties)).to eq([property])
        expect(response).to render_template(:index)
      end
    end

    describe "GET #new" do
      before :each do
        get :new, property_group_id: property_group
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:parent_group)).to eq(property_group)
        expect(assigns(:property_group)).to eq(property_group)
        expect(assigns(:property)).to be_a_new(Property)
      end

      it "renders new" do
        expect(response).to render_template(:new)
      end
    end

    describe "GET #edit" do
      before :each do
        get :edit, id: property
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:property)).to eq(property)
        expect(assigns(:parent_group)).to eq(property.group)
      end

      it "renders edit" do
        expect(response).to render_template(:edit)
      end
    end

    describe "POST #create" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_property)
      end

      context "valid attributes" do
        it "creates a new instance" do
          expect {
            post :create, property_group_id: create(:magaz_property_group), property: @params
          }.to change{ Property.count }.by(1)
        end

        it "assigns variables" do
          post :create, property_group_id: property_group, property: @params
          expect(assigns(:parent_group)).to eq(property_group)
          expect(assigns(:property_group)).to eq(property_group)
          expect(assigns(:property)).to eq(Property.last)
        end

        it "redirects to group index" do
          post :create, property_group_id: property_group, property: @params
          expect(response).to redirect_to(property_group_properties_path(property_group))
        end
      end

      context "invalid attributes" do
        before :each do
          @params.delete "name"
        end

        it "doesn't save the new property" do
          expect {
            post :create, property_group_id: property_group, property: @params
          }.to_not change{ Property.count }
        end

        it "re-renders the new method" do
          post :create, property_group_id: property_group, property: @params
          expect(response).to render_template(:new)
        end
      end
    end

    describe "PUT #update" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_property)
      end

      context "valid attributes" do
        it "locates the requested instance" do
          put :update, id: property, property: @params
          expect(assigns(:property)).to eq(property)
        end

        it "changes instance attributes" do
          put :update, id: property, property: @params
          property.reload
          %w|code name description static variant|.each do |field|
            expect(property[field]).to eq(@params[field])
          end
        end

        it "redirects to edit property" do
          put :update, id: property, property: @params
          expect(response).to redirect_to(edit_property_path(property))
        end
      end

      context "invalid attributes" do
        before :each do
          @params = attributes_with_foreign_keys_for(:magaz_property)
          @params[:name] = ''
        end

        it "doesn't change the instance attributes" do
          old_name = property.name
          put :update, id: property, property: @params
          property.reload
          expect(property.name).to eq(old_name)
        end

        it "re-renders the edit template" do
          put :update, id: property, property: @params
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "PUT #up/#down" do
      it "moves the property up and redirects" do
        p = create(:magaz_property_group_with_properties).properties.last
        expect {
          put :up, property_id: p
        }.to change{ p.reload.position }.by(-1)
        expect(response).to redirect_to(property_group_properties_path(p.group))
      end

      it "moves the property down and redirects" do
        p = create(:magaz_property_group_with_properties).properties.first
        expect {
          put :down, property_id: p
        }.to change{ p.reload.position }.by(1)
        expect(response).to redirect_to(property_group_properties_path(p.group))
      end
    end

    describe "DELETE #destroy" do
      it "deletes the instance" do
        p = create(:magaz_property)
        expect {
          delete :destroy, id: p
        }.to change{ Property.count }.by(-1)
      end

      it "redirects to group index" do
        delete :destroy, id: property.id
        expect(response).to redirect_to(property_group_properties_path(property.group))
      end
    end

  end
end
