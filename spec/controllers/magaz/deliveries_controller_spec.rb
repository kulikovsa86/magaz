require 'rails_helper'

module Magaz
  RSpec.describe DeliveriesController, type: :controller do

    routes { Magaz::Engine.routes }

    before :each do
      sign_in create(:magaz_user)
    end

    let(:delivery) { create(:magaz_delivery) }

    describe "GET #index" do
      before :each do
        get :index
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:deliveries)).to eq([delivery])
      end

      it "renders index" do
        expect(response).to render_template(:index)
      end
    end

    describe "GET #new" do
      before :each do
        get :new
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:delivery)).to be_a_new(Delivery)
      end

      it "renders template" do
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_delivery)
      end

      context "valid attributes" do
        subject { post :create, delivery: @params }

        it "creates a new instance" do
          expect { subject }.to change{ Delivery.count }.by(1)
        end

        it "redirects to edit path" do
          expect(subject).to redirect_to(edit_delivery_path(Delivery.last))
        end
      end

      context "invalid attributes" do
        before :each do
          @params.delete "name"
        end

        subject { post :create, delivery: @params }

        it "doesn't save the new instance" do
          expect{ subject }.to_not change{ Delivery.count }
        end

        it "re-renders new template" do
          expect(subject).to render_template(:new)
        end
      end
    end

    describe "GET #edit" do
      before :each do
        get :edit, id: delivery
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables and render template" do
        expect(assigns(:delivery)).to eq(delivery)
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #update" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_delivery)
      end

      context "valid attributes" do
        before :each do
          put :update, id: delivery, delivery: @params
        end

        it "locates the requested instance" do
          expect(assigns(:delivery)).to eq(delivery)
        end

        it "change instance attributes" do
          delivery.reload
          %w|code name note address_required post_code_required|.each do |field|
            expect(delivery[field]).to eq(@params[field])
          end
        end

        it "redirects to edit path" do
          expect(response).to redirect_to(edit_delivery_path(delivery))
        end
      end

      context "invalid attributes" do
        before :each do
          @params["name"] = ''
        end

        it "doesn't change the instance attributes" do
          old_name = delivery.name
          put :update, id: delivery, delivery: @params
          delivery.reload
          expect(delivery.name).to eq(old_name)
        end

        it "re-renders the edit template" do
          put :update, id: delivery, delivery: @params
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "PUT #up/#down" do
      it "moves the delivery up and redirects" do
        d = create_list(:magaz_delivery, 5).last
        expect {
          put :up, delivery_id: d
        }.to change{ d.reload.position }.by(-1)
        expect(response).to redirect_to(deliveries_path)
      end

      it "moves the destroy down and redirects" do
        d = create_list(:magaz_delivery, 5).first
        expect {
          put :down, delivery_id: d
        }.to change{ d.reload.position }.by(1)
        expect(response).to redirect_to(deliveries_path)
      end
    end

    describe "DELETE #destroy" do
      it "deletes the instance" do
        d = create(:magaz_delivery)
        expect {
          delete :destroy, id: d
        }.to change{ Delivery.count }.by(-1)
      end

      it "redirects to index" do
        delete :destroy, id: delivery
        expect(response).to redirect_to(deliveries_path)
      end
    end

  end
end
