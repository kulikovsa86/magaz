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

module Magaz
  class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
    devise :database_authenticatable, :rememberable, :trackable
    
    has_one :profile, dependent: :destroy
    accepts_nested_attributes_for :profile
    devise :database_authenticatable, :validatable, password_length: 6..128

    validates :email, presence: true
    validates :email, allow_blank: true, email_format: { message: 'Не похоже, что это адрес электронной почты' }

    def fio
      if profile
        "#{profile.first_name} #{profile.last_name}"
      else
        nil
      end
    end

  end
end
