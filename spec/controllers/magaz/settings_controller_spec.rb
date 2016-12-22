# == Schema Information
#
# Table name: magaz_settings
#
#  id         :integer          not null, primary key
#  name       :string
#  value      :string
#  param      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe SettingsController, type: :controller do

    routes { Magaz::Engine.routes }

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

      it "renders index" do
        expect(response).to render_template(:index)
      end
    end

    describe "POST #update" do
      before :each do
        @params = {:mouled => '0', :'show-images' => '0', :'show-colors' => '0'}
      end

      it "sets settings values" do
        expect {
          post :update, magaz: @params
        }.to change{ Setting.count }.by(26)
      end

      it "redirects to index" do
        post :update, magaz: @params
        expect(response).to redirect_to(settings_path)
      end
    end

  end
end
