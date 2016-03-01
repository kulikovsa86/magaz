require 'rails_helper'

module Magaz
  RSpec.describe PropertyGroupsController, type: :controller do

    routes { Magaz::Engine.routes }

    before :each do
      sign_in create(:magaz_user)
    end

    let (:property_group) { create(:magaz_property_group_with_properties) }
    let (:property_group_root) { create(:magaz_property_group_with_groups) }

    describe "GET #index" do
      it "responds successfully with a HTTP 200 status code" do
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns groups variable and renders template" do
        get :index
        expect(assigns(:groups)).to eq([property_group])
        expect(response).to render_template(:index)
      end

      it "assigns parent group and renders template" do
        get :index, parent_id: property_group_root.id
        expect(assigns(:parent_group)).to eq(property_group_root)
        expect(response).to render_template(:index)
      end

      it "redirects to properties if group is not empty" do
        get :index, parent_id: property_group.id
        expect(response).to redirect_to(property_group_properties_path(property_group))
      end
    end

    describe "GET #new" do
      it "responds successfully with a HTTP 200 status code" do
        get :new
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variable and renders template" do
        get :new, parent_id: property_group.id
        expect(assigns(:property_group)).to be_a_new(PropertyGroup)
        expect(assigns(:parent_group)).to eq(property_group)
        expect(response).to render_template(:new)
      end
    end

    describe "GET #edit" do
      before :each do
        @pg = property_group_root.children.take
        get :edit, id: @pg.id
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variable and renders template" do
        expect(assigns(:property_group)).to eq(@pg)
        expect(assigns(:parent_group)).to eq(property_group_root)
        expect(response).to render_template(:edit)
      end
    end

    describe "POST #create" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_property_group)
      end

      context "valid attributes" do
        it "creates a new instance" do
          expect {
            post :create, property_group: @params
          }.to change{ PropertyGroup.count }.by(1)
        end

        it "adds new child to parent category" do
          expect {
            post :create, property_group: @params, parent_id: property_group
          }.to change{ property_group.reload.children.count }.by(1)
        end

        it "redirects to index path" do
          post :create, property_group: @params
          expect(response).to redirect_to(property_groups_path(PropertyGroup.last))
        end
      end

      context "invalid attributes" do
        before :each do
          @params.delete "name"
        end

        it "doesn't save the new instance" do
          expect {
            post :create, property_group: @params
          }.to_not change{ PropertyGroup.count }
        end

        it "re-renders the new template" do
          post :create, property_group: @params
          expect(response).to render_template(:new)
        end
      end
    end

    describe "PUT #update" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_property_group)
      end

      context "valid attributes" do
        it "locates the requested instance" do
          put :update, id: property_group, property_group: @params
          expect(assigns(:property_group)).to eq(property_group)
        end

        it "changes instance attributes" do
          put :update, id: property_group, property_group: @params
          property_group.reload
          %w|code name|.each do |field|
            expect(property_group[field]).to eq(@params[field])
          end
        end
      end

      context "invalid attributes" do
        before :each do
          @params[:name] = ''
        end

        it "doesn't change the instance attributes" do
          old_name = property_group.name
          put :update, id: property_group, property_group: @params
          property_group.reload
          expect(property_group.name).to eq(old_name)
        end

        it "re-renders the edit template" do
          put :update, id: property_group, property_group: @params
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "PUT #up/#down" do
      it "moves the property_group up and redirects" do
        pg = property_group_root.children.last
        expect {
          put :up, property_group_id: pg
        }.to change{ pg.reload.position }.by(-1)
        expect(response).to redirect_to(property_groups_path(property_group_root))
      end

      it "moves the category down and redirects" do
        pg = property_group_root.children.first
        expect {
          put :down, property_group_id: pg
        }.to change{ pg.reload.position }.by(1)
        expect(response).to redirect_to(property_groups_path(property_group_root))
      end
    end

    describe "DELETE #destroy" do
      it "deletes the instance" do
        pg = create(:magaz_property_group)
        expect {
          delete :destroy, id: pg
        }.to change{ PropertyGroup.count }.by(-1)
      end

      it "redirects to products index" do
        delete :destroy, id: property_group_root.children.first
        expect(response).to redirect_to(property_groups_path(property_group_root))
      end
    end

  end
end
