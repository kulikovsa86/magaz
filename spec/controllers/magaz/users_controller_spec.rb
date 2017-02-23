# == Schema Information
#
# Table name: magaz_users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe UsersController, type: :controller do

    routes { Magaz::Engine.routes }

    let(:password) { Faker::Internet.password(8) }
    let(:user) { create(:magaz_user, password: password, profile: nil) }

    before :each do
      sign_in user
    end

    describe "GET #profile" do
      before :each do
        get :edit
      end

      it "responds successfully with a HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "assigns variables" do
        expect(assigns(:user)).to eq(user)
      end

      it "renders index" do
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #update" do
      before :each do
        @params = {email: Faker::Internet.free_email('foo'), profile_attributes: attributes_with_foreign_keys_for(:magaz_profile) }
      end

      context "valid attributes" do
        it "locates the requested instance" do
          put :update, user: @params
          expect(assigns(:user)).to eq(user)
        end

        it "change user attributes" do
          put :update, user: @params
          user.reload
          expect(user.email).to eq(@params[:email])
        end

        it "creates profile instance" do
          expect {
            put :update, user: @params
          }.to change{ Profile.count }.by(1)
        end

        it "changes profile attributes" do
          user.create_profile
          put :update, user: @params
          user.reload
          %w|first_name last_name phone email|.each do |field|
            expect(user.profile[field]).to eq(@params[:profile_attributes][field])
          end
        end
      end

      context "invalid attributes" do
        before :each do
          @params[:email] = ""
        end

        it "doesn't change the instance attributes" do
          email = user.email
          put :update, user: @params
          user.reload
          expect(user.email).to eq(email)
        end

        it "re-renders the edit template" do
          put :update, user: @params
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "PUT #update_password" do
      before :each do
        new_password = Faker::Internet.password(8)
        @params = {password: new_password, password_confirmation: new_password, current_password: password}
      end

      context "valid attributes" do
        it "locates the requested instance" do
          put :update_password, user: @params
          expect(assigns(:user)).to eq(user)
        end

        it "redirects to edit path" do
          put :update_password, user: @params
          expect(response).to redirect_to(edit_profile_path)
        end
      end

      context "invalid attributes" do
        it "re-renders template" do
          @params[:password_confirmation] = ''
          put :update_password, user: @params
          expect(response).to render_template(:edit)
        end
      end
    end

  end
end
