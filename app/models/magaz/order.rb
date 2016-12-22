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

    has_many :line_items, as: :liable, dependent: :destroy
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

    def total_price_s
      sprintf("%.2f", total_price).sub('.', ',')
    end

    def including_nds
      (total_price / 1.18 * 0.18).round 2
    end

    def including_nds_s
      sprintf("%.2f", including_nds).sub('.', ',')
    end

    def has_moulded?
      !items.to_a.select{ |item| item.product.moulded }.empty?
    end

    def take_items_from_cart(cart)
      cart.items.each do |item|
        # item.cart_id = nil
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
      changed = false
      param_items.each do |param_item|
        item = items.find_by_id(param_item[:id])
        if item
          count = item.count
          item.update(count: param_item[:count], manual: false, total_count: nil)
          changed = true if count != item.count
        end
      end
      changed
    end

    # param_items = [ {id: "id", total_count: "count"}, ... ]
    def recount_unit(param_items)
      changed = false
      param_items.each do |param_item|
        item = items.find_by_id(param_item[:id])
        if item && item.total_count != BigDecimal(param_item[:total_count])
          item.update(total_count: param_item[:total_count], manual: true)
          changed = true
        end
      end
      changed
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

    def self.fresh
      Order.where(status: Status.NEW).order(created_at: :desc)
    end

    def contacts
      "#{company} #{post_code} #{address1} #{address2} #{address3} #{address4} #{phone} #{email} #{customer}".strip.squeeze
    end

    def bill_array
      items = []
      line_items.select(:product_id, :variant_id).distinct.each do |line_item|
        product_id = line_item.product_id
        product = Magaz::Product.find(product_id) if product_id
        variant_id = line_item.variant_id
        variant = Magaz::Variant.find(variant_id) if variant_id
        price = line_items.find_by(product_id: product_id, variant_id: variant_id).price
        price_str = sprintf("%.2f", price).sub('.', ',')
        count = line_items.where(product_id: product_id, variant_id: variant_id).to_a.sum {|item| item.amount}
        sum_str = sprintf("%.2f", count * price).sub('.', ',')
        if product.short_name && !product.short_name.empty?
          product_name = product.short_name
        else
          product_name = product.name
        end
        if variant_id
          full_name = "#{product_name} #{variant.name}"
        else
          full_name = "#{product_name}"
        end
        dim = product.calc_dim ? product.calc_dim.name : Magaz::Dimension.default.name
        items << [full_name, count, dim, price_str, sum_str]
      end
      items
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
