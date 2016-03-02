# == Schema Information
#
# Table name: magaz_property_args
#
#  id          :integer          not null, primary key
#  property_id :integer
#  min         :decimal(, )
#  max         :decimal(, )
#  step        :decimal(, )
#  default     :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe PropertyArgsController, type: :controller do

    routes { Magaz::Engine.routes }

    before :each do
      sign_in create(:magaz_user)
    end

    let(:property_arg) { create(:magaz_property_arg) }

    describe "GET #index" do
      before :each do
        get :index, property_id: property_arg.property
      end        

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variable and renders template" do
        expect(assigns(:property)).to eq(property_arg.property)
        expect(assigns(:property_arg)).to eq(property_arg)
        expect(assigns(:parent_group)).to eq(property_arg.property.group)
        expect(response).to render_template(:index)
      end
    end

    describe "PUT #update" do
      before :each do
        @params = attributes_with_foreign_keys_for(:magaz_property_arg)
        put :update, id: property_arg, property_arg: @params
      end

      it "locates the requested instance" do
        expect(assigns(:property_arg)).to eq(property_arg)
        expect(assigns(:property)).to eq(property_arg.property)
      end

      it "changes instance attributes" do
        property_arg.reload
        %w|min max step default|.each do |field|
          expect(property_arg[field]).to eq(@params[field])
        end
      end

      it "redirects to index page" do
        expect(response).to redirect_to(property_property_args_path(property_arg.property))
      end
    end

  end
end
