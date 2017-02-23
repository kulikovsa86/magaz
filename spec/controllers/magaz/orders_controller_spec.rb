# == Schema Information
#
# Table name: magaz_orders
#
#  id               :integer          not null, primary key
#  customer         :string
#  company          :string
#  phone            :string
#  email            :string
#  delivery_id      :integer
#  address1         :string
#  address2         :string
#  address3         :string
#  address4         :string
#  post_code        :string
#  payment_id       :integer
#  status_id        :integer
#  pdt              :datetime
#  customer_comment :text
#  manager_comment  :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe OrdersController, type: :controller do
    
    routes { Magaz::Engine.routes }

    let(:order) { create(:magaz_order_with_items) }

    before :each do
      sign_in create(:magaz_user)
    end

    describe "GET #index" do
      before :each do
        get :index
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:orders)).to eq([order])
        expect(assigns(:filter)).to eq('all')

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
        expect(assigns(:order)).to be_a_new(Order)
      end

      it "renders template" do
        expect(response).to render_template(:new)
      end
    end

    describe "POST #create" do
      subject { post :create, order: @params}

      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_order)
        @o = create(:magaz_order)
      end

      context "valid attributes" do
        it "creates a new instance" do
          expect { subject }.to change{ Order.count }.by(1)
        end

        it "redirects to edit path" do
          expect(subject).to redirect_to(edit_contacts_order_path(Order.last))
        end
      end

      context "invalid attributes" do
        before :each do
          @params["customer"] = ""
        end

        it "doesn't save the new instance" do
          expect{ subject }.to_not change{ Order.count }
        end

        it "re-renders new template" do
          expect(subject).to render_template(:new)
        end
      end
    end

    describe "GET #edit*" do
      context "edit" do
        before :each do
          get :edit, id: order
        end

        it "responds successfully with a HTTP 200 status code" do
          expect(response).to be_success
          expect(response).to have_http_status(200)
        end

        it "assigns variables and renders template" do
          expect(assigns(:order)).to eq(order)
          expect(response).to render_template(:edit)
        end
      end

      context "edit_?" do
        {:edit_items => 'form_items', :edit_contacts => 'form_contacts', :edit_delivery => 'form_delivery', :edit_payment => 'form_payment'}.each do |method, form|

          it "responds successfully with a HTTP 200 status code" do
            get method, id: order
            expect(response).to be_success
            expect(response).to have_http_status(200)
          end

          it "assigns variables and renders template" do
            get method, id: order
            expect(assigns(:order)).to eq(order)
            expect(assigns(:form)).to eq(form)
            expect(response).to render_template(:edit)
          end
        end
      end
    end

    describe "PUT #update" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_order)
      end

      context "valid attributes" do
        before :each do
          request.env['HTTP_REFERER'] = edit_items_order_path(order)
          put :update, id: order.id, order: @params, member: 'edit_items'
        end

        it "locates the requested instance" do
          expect(assigns(:order)).to eq(order)
        end

        it "change instance attributes" do
          order.reload
          %w|customer phone email|.each do |field|
            expect(order[field]).to eq(@params[field])
          end
        end

        it "redirects to order items path" do
          expect(response).to redirect_to(edit_items_order_path(order))
        end
      end

      context "invalid attributes" do
        before :each do
          @params[:customer] = ''
        end

        it "doesn't change the instance attributes" do
          old_customer = order.customer
          put :update, id: order, order: @params
          order.reload
          expect(order.customer).to eq(old_customer)
        end

        it "re-renders the edit template" do
          form = Faker::Lorem.word
          put :update, id: order, order: @params, form: form
          expect(assigns(:form)).to eq(form)
          expect(response).to render_template(:edit)
        end
      end

      context "notifications" do
        subject { put :update, id: order, order: @params }

        it "notifies custom event" do
          @params[:status_id] = 1
          expect{ subject }.to instrument("magaz.custom_event").with(options: {event_type: 'status updated', order: order.id, user: 1})
        end

        it "doesn't notify event if status not changed" do
          expect{ subject }.to_not instrument("magaz.custom_event")
        end
      end
    end

    describe "DELETE #destroy" do
      before do
        request.env['HTTP_REFERER'] = edit_items_order_path(order)
      end

      it "does not delete the instance" do
        o = create(:magaz_order)
        expect {
          delete :destroy, id: o
        }.to change{ Order.count }.by(0)
      end

      it "redirects to back" do
        delete :destroy, id: order
        expect(response).to redirect_to(edit_items_order_path(order))
      end
    end

    describe "PUT #recount" do
      it "assigns variables" do
        put :recount, id: order, items: [{}]
        expect(assigns(:order)).to eq(order)
      end

      it "redirects to order items" do
        put :recount, id: order, items: [{}]
        expect(response).to redirect_to(edit_items_order_path(order))
      end

      context "doesn't notify if not changed" do
        it "count" do
          item = order.items.take
          expect { 
            put :recount, id: order, items: [{id: item.id, count: item.count}] 
          }.to_not instrument("magaz.custom_event")
        end
      end

      context "notifies if changes" do
        it "count" do
          item = order.items.take
          expect { 
            put :recount, id: order, items: [{id: item.id, count: item.count + 1}] 
          }.to instrument("magaz.custom_event").with(options: {event_type: 'count changed', order: order.id, user: 1})
        end

        it "unit_count" do
          item = order.items.take
          expect { 
            put :recount, id: order, recount_unit: true, items: [{id: item.id, total_count: Random.rand(100)}]
          }.to instrument("magaz.custom_event").with(options: {event_type: 'unit count changed', order: order.id, user: 1})
        end
      end
    end

  end
end
