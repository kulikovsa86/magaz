require 'rails_helper'

module Magaz
  RSpec.describe SettingsController, type: :controller do

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #update" do
      it "returns http success" do
        get :update
        expect(response).to have_http_status(:success)
      end
    end

  end
end
