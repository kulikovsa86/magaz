# == Schema Information
#
# Table name: magaz_payments
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  note       :text
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe PaymentsController, type: :controller do

    routes { Magaz::Engine.routes }

    before :each do
      sign_in create(:magaz_user)
    end

    let(:payment) { create(:magaz_payment) }

    describe "GET #index" do
      before :each do
        get :index
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:payments)).to eq([payment])
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
        expect(assigns(:payment)).to be_a_new(Payment)
      end

      it "renders template" do
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_payment)
      end

      context "valid attributes" do
        subject { post :create, payment: @params }

        it "creates a new instance" do
          expect { subject }.to change{ Payment.count }.by(1)
        end

        it "redirects to edit path" do
          expect(subject).to redirect_to(edit_payment_path(Payment.last))
        end
      end

      context "invalid attributes" do
        before :each do
          @params.delete "name"
        end

        subject { post :create, payment: @params }

        it "doesn't save the new instance" do
          expect{ subject }.to_not change{ Payment.count }
        end

        it "re-renders new template" do
          expect(subject).to render_template(:new)
        end
      end
    end

    describe "GET #edit" do
      before :each do
        get :edit, id: payment
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables and render template" do
        expect(assigns(:payment)).to eq(payment)
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #update" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_payment)
      end

      context "valid attributes" do
        before :each do
          put :update, id: payment, payment: @params
        end

        it "locates the requested instance" do
          expect(assigns(:payment)).to eq(payment)
        end

        it "change instance attributes" do
          payment.reload
          %w|code name note|.each do |field|
            expect(payment[field]).to eq(@params[field])
          end
        end

        it "redirects to edit path" do
          expect(response).to redirect_to(edit_payment_path(payment))
        end
      end

      context "invalid attributes" do
        before :each do
          @params["name"] = ''
        end

        it "doesn't change the instance attributes" do
          old_name = payment.name
          put :update, id: payment, payment: @params
          payment.reload
          expect(payment.name).to eq(old_name)
        end

        it "re-renders the edit template" do
          put :update, id: payment, payment: @params
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "PUT #up/#down" do
      it "moves the payment up and redirects" do
        d = create_list(:magaz_payment, 5).last
        expect {
          put :up, payment_id: d
        }.to change{ d.reload.position }.by(-1)
        expect(response).to redirect_to(payments_path)
      end

      it "moves the destroy down and redirects" do
        d = create_list(:magaz_payment, 5).first
        expect {
          put :down, payment_id: d
        }.to change{ d.reload.position }.by(1)
        expect(response).to redirect_to(payments_path)
      end
    end

    describe "DELETE #destroy" do
      it "deletes the instance" do
        d = create(:magaz_payment)
        expect {
          delete :destroy, id: d
        }.to change{ Payment.count }.by(-1)
      end

      it "redirects to index" do
        delete :destroy, id: payment
        expect(response).to redirect_to(payments_path)
      end
    end

  end
end
