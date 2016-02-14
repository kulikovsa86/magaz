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

module Magaz
  class Order < ActiveRecord::Base
    belongs_to :delivery
    belongs_to :payment
    belongs_to :status

    has_many :line_items, dependent: :destroy
    has_many :order_statuses, dependent: :destroy

    before_create :check_status
    attr_accessor :status_changed
    after_save :log_status, if: :status_id_changed?

    validates :customer, presence: true
    validates :phone, presence: true
    validates :email, presence: true

    attr_accessor :company_valid
    validates :company, presence: true, if: :company_valid

    attr_accessor :skip_delivery_valid
    validates :delivery, presence: true, unless: :skip_delivery_valid

    with_options if: :delivery_need? do |o|
      o.validates :address1, presence: true
      o.validates :address2, presence: true
      o.validates :address3, presence: true
      o.validates :address4, presence: true
      o.validates :post_code, presence: true, if: :post_code_need?
    end

    attr_accessor :skip_payment_valid
    validates :payment, presence: true, unless: :skip_payment_valid

    attr_accessor :pdt_valid
    validates :pdt, presence: true, if: :pdt_valid
    
    alias items line_items
    alias statuses order_statuses

    def num
      "#{id}".rjust(3, '0')
    end

    def total_price
      items.to_a.sum do |item|
        item.total_order_price
      end
    end

    def has_moulded?
      !items.to_a.select{ |item| item.product.moulded }.empty?
    end

    def take_items_from_cart(cart)
      cart.items.each do |item|
        item.cart_id = nil
        item.price = item.cart_price
        items << item
      end
    end

    def formatted_pdt
      if pdt
        pdt.strftime('%d.%m.%Y %H:%M')
      else
        ''
      end
    end

    # param_items = [ {id: "id", count: "count"}, ... ]
    def recount(param_items) 
      param_items.each do |param_item|
        item = items.find_by_id(param_item[:id])
        item.update(count: param_item[:count], manual: false) if item
      end
    end

    # param_items = [ {id: "id", count: "count"}, ... ]
    def recount_unit(param_items)
      param_items.each do |param_item|
        item = items.find_by_id(param_item[:id])
        item.update(total_count: param_item[:total_count], manual: true) if item
      end
    end

    def history
      statuses.order(:created_at => :desc).map { |s| "#{s.created_at.strftime('%Y-%m-%d %H:%M')} #{s.status.name} &#13;&#10;" }
    end

    def self.opened
      Order.joins(:status).where(:magaz_statuses => { closed: false }).order(created_at: :desc)
    end

    def self.closed
      Order.joins(:status).where(:magaz_statuses => { closed: true }).order(created_at: :desc)
    end



    private

      def delivery_need?
        delivery.address_required if (!skip_delivery_valid && delivery)
      end

      def post_code_need?
        delivery.post_code_required if (!skip_delivery_valid && delivery)
      end

      def check_status
        self.status = Status.NEW unless status_id
      end

      def log_status
        statuses.create!(status_id: status_id)
      end

  end
end
