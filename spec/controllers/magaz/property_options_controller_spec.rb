# == Schema Information
#
# Table name: magaz_property_options
#
#  id          :integer          not null, primary key
#  property_id :integer
#  code        :string
#  name        :string
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe PropertyOptionsController, type: :controller do

    routes { Magaz::Engine.routes }

    before :each do
      sign_in create(:magaz_user)
    end

    let(:option) { create(:magaz_property_option) }
    let(:property) { create(:magaz_property) }
    let(:options) { create_list(:magaz_property_option, 5, property: property) }

    describe "GET #index" do
      before :each do
        get :index, property_id: option.property
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:property)).to eq(option.property)
        expect(assigns(:parent_group)).to eq(option.property.group)
      end

      it "renders index" do
        expect(response).to render_template(:index)
      end
    end

    describe "POST #create" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_property_option)
      end

      subject { post :create, property_option: @params, property_id: property }

      it "creates a new instance" do
        expect { subject }.to change{ PropertyOption.count }.by(1)
      end

      it "redirects to property index" do
        expect(subject).to redirect_to(property_property_options_path(property))
      end
    end

    describe "PUT #up/#down" do
      it "moves the instance up and redirects" do
        opt = options.last
        expect {
          put :up, property_option_id: opt
        }.to change{ opt.reload.position }.by(-1)
        expect(response).to redirect_to(property_property_options_path(property))
      end

      it "moves the instance down and redirects" do
        opt = options.first
        expect {
          put :down, property_option_id: opt
        }.to change{ opt.reload.position }.by(1)
        expect(response).to redirect_to(property_property_options_path(property))
      end
    end

    describe "DELETE #destroy" do
      it "deletes the instance" do
        opt = create(:magaz_property_option)
        expect {
          delete :destroy, id: opt
        }.to change{ PropertyOption.count }.by(-1)
      end

      it "redirects to index" do
        delete :destroy, id: option
        expect(response).to redirect_to(property_property_options_path(option.property))
      end
    end

  end
end
