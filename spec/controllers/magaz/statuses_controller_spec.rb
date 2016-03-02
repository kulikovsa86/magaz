# == Schema Information
#
# Table name: magaz_statuses
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  note       :text
#  closed     :boolean          default(FALSE)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe StatusesController, type: :controller do

    routes { Magaz::Engine.routes }

    before :each do
      sign_in create(:magaz_user)
    end

    let(:status) { create(:magaz_status) }
    let(:statuses) { create_list(:magaz_status, 5) }

    describe "GET #index" do
      before :each do
        get :index
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:statuses)).to eq([status])
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
        expect(assigns(:status)).to be_a_new(Status)
      end

      it "renders template" do
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_status)
      end

      context "valid attributes" do
        subject { post :create, status: @params }

        it "creates a new instance" do
          expect { subject }.to change{ Status.count }.by(1)
        end

        it "redirects to edit path" do
          expect(subject).to redirect_to(edit_status_path(Status.last))
        end
      end

      context "invalid attributes" do
        before :each do
          @params.delete "name"
        end

        subject { post :create, status: @params }

        it "doesn't save the new instance" do
          expect{ subject }.to_not change{ Status.count }
        end

        it "re-renders new template" do
          expect(subject).to render_template(:new)
        end
      end
    end

    describe "GET #edit" do
      before :each do
        get :edit, id: status
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables and render template" do
        expect(assigns(:status)).to eq(status)
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #update" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_status)
      end

      context "valid attributes" do
        before :each do
          put :update, id: status, status: @params
        end

        it "locates the requested instance" do
          expect(assigns(:status)).to eq(status)
        end

        it "change instance attributes" do
          status.reload
          %w|code name note closed|.each do |field|
            expect(status[field]).to eq(@params[field])
          end
        end

        it "redirects to edit path" do
          expect(response).to redirect_to(edit_status_path(status))
        end
      end

      context "invalid attributes" do
        before :each do
          @params["name"] = ''
        end

        it "doesn't change the instance attributes" do
          old_name = status.name
          put :update, id: status, status: @params
          status.reload
          expect(status.name).to eq(old_name)
        end

        it "re-renders the edit template" do
          put :update, id: status, status: @params
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "PUT #up/#down" do
      it "moves the status up and redirects" do
        s = statuses.last
        expect {
          put :up, status_id: s
        }.to change{ s.reload.position }.by(-1)
        expect(response).to redirect_to(statuses_path)
      end

      it "moves the destroy down and redirects" do
        s = statuses.first
        expect {
          put :down, status_id: s
        }.to change{ s.reload.position }.by(1)
        expect(response).to redirect_to(statuses_path)
      end
    end

    describe "DELETE #destroy" do
      it "deletes the instance" do
        s = create(:magaz_status)
        expect {
          delete :destroy, id: s
        }.to change{ Status.count }.by(-1)
      end

      it "redirects to index" do
        delete :destroy, id: status
        expect(response).to redirect_to(statuses_path)
      end
    end

  end
end
