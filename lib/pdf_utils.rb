# -*- coding: utf-8 -*-

require 'prawn'
require 'prawn/measurement_extensions'
require 'prawn/table'
require 'ru_propisju'

module PdfUtils

  # def create_bill(payment_details, delivery_details, signatories, order)
  def create_bill(order)

    tmp_dir = Rails.root.join("tmp", "pdfutils")

    unless Dir.exist?(tmp_dir)
      Dir.mkdir(tmp_dir)
    end

    filename = "Счет на оплату N#{order.id}.pdf"

    filepath = Rails.root.join(tmp_dir, filename)

    Prawn::Document.generate(filepath, top_margin: 10.mm, left_margin: 30.mm) do 

      font_families.update(
        "DejaVuSans" => {
          :normal =>  Magaz.root_path.join("lib", "assets", "fonts", "DejaVuSans.ttf"),
          :bold =>  Magaz.root_path.join("lib", "assets", "fonts", "DejaVuSans-Bold.ttf")
        },
        "Calibri" => {
          :normal =>  Magaz.root_path.join("lib", "assets", "fonts", "calibri.ttf"),
          :bold =>  Magaz.root_path.join("lib", "assets", "fonts", "calibrib.ttf")
        },

      )

      font("Calibri", size: 10)

      # ===================================================
      # ВНИМАНИЕ!
      # ===================================================

      text %{
Внимание! Оплата данного счета означает согласие с условиями поставки товара. Уведомление об оплате 
обязательно, в противном случае не гарантируется наличие товара на складе. Товар отпускается по факту
прихода денег на р/с Поставщика, самовывозом, при наличии доверенности и паспорта.
}, align: :center, leading: 0, size: 8

      # ===================================================
      # РЕКВИЗИТЫ ПОЛУЧАТЕЛЯ
      # ===================================================

      move_down 5.mm

      # --- наименование банка получателя
      bank_name_cell = make_cell(content: Magaz::Setting.get('magaz-bank-name'), colspan: 2, borders: [:left, :top, :right])
      label_bank_cell = make_cell(content: "Банк получателя", colspan: 2, borders: [:left], size: 8)
      # --- БИК
      bik_cell = make_cell(content: Magaz::Setting.get('magaz-bik'), borders: [:left, :top, :right])
      # --- Кор счет
      corr_account_cell = make_cell(content: Magaz::Setting.get('magaz-corr-account'), borders: [:right])
      # --- Счет №
      label_account_cell = make_cell(content: "Счет №", rowspan: 3)
      account_cell = make_cell(content: Magaz::Setting.get('magaz-abon-account'), rowspan: 3)
      # --- ИНН
      inn_cell = make_cell(content: "ИНН #{Magaz::Setting.get('magaz-inn')}")
      # --- КПП
      kpp_cell = make_cell(content: "КПП #{Magaz::Setting.get('magaz-kpp')}")
      # --- Получатель
      recipient_cell = make_cell(content: Magaz::Setting.get('magaz-recipient'), colspan: 2, borders: [:left])
      label_receiver_cell = make_cell(content: "Получатель", colspan: 2, borders: [:left, :bottom, :right], size: 8)
      # ---
      data = [
        [bank_name_cell, 'БИК', bik_cell],
        [label_bank_cell, 'Корр. сч.', corr_account_cell],
        [inn_cell, kpp_cell, label_account_cell, account_cell],
        [recipient_cell],
        [label_receiver_cell]
      ]
      table(data, column_widths: [50.mm, 50.mm, 20.mm, 50.mm], cell_style: {padding: [2, 2, 2, 2]})
      
      # ===================================================
      # ЗАГОЛОВОК
      # ===================================================
      
      move_down 10.mm

      from_date = order.created_at.strftime "%d.%m.%Y"
      text "Счет на оплату №#{order.id} от #{from_date}", size: 16, style: :bold
      stroke_horizontal_rule
      # --- Поставщик
      supplier_cell = make_cell(content: Magaz::Setting.get('magaz-supplier'))
      # --- Грузоотправитель 
      shipper_cell = make_cell(content: Magaz::Setting.get('magaz-shipper'))
      # --- Покупатель
      buyer_cell = make_cell(content: order.payer_info)
      # --- Грузополучатель
      consignee = make_cell(content: order.consignee_info)
      # ---
      data = [
        ['Поставщик:', supplier_cell],
        ['Грузоотправитель:', shipper_cell],
        ['Покупатель:', buyer_cell],
        ['Грузополучатель:', consignee]
      ]

      table(data, column_widths: [40.mm, 130.mm], cell_style: {borders: [], padding: [2, 2, 2, 2]}) do
        column(1).font_style = :bold
        column(1).size = 10
      end

      # ===================================================
      # Таблица товаров
      # ===================================================

      move_down 5.mm
      data = []
      data << %w{№ Товары Кол-во Ед. Цена Сумма}
      order.bill_array.each_with_index do |item, index|
        data << [index+1, *item] if index != order.bill_array.size - 1
      end
      table(data, column_widths: [10.mm, 90.mm, 20.mm, 10.mm, 15.mm, 25.mm]) do        
        # ---
        column(0).align = :center
        column(2).align = :right
        column(4).align = :right
        column(5).align = :right        
        row(0).align = :center
        row(0).font_style = :bold
        # --- border
        row(0).border_top_width = 2
        #row(-1).border_bottom_width = 2
        column(0).border_left_width = 2
        column(-1).border_right_width = 2
        # --- all cells
        cells.padding = 2
      end

      # --- последняя строка таблицы
      start_new_page if cursor < 215
      data = [[order.bill_array.size, *order.bill_array.last]]
      table(data, column_widths: [10.mm, 90.mm, 20.mm, 10.mm, 15.mm, 25.mm]) do        
        # ---
        column(0).align = :center
        column(2).align = :right
        column(4).align = :right
        column(5).align = :right        
        # --- border
        #row(0).border_top_width = 2
        row(-1).border_bottom_width = 2
        column(0).border_left_width = 2
        column(-1).border_right_width = 2
        # --- all cells
        cells.padding = 2
      end

      data = [
        ['Итого:', order.total_price_s],
        ['В том числе НДС', order.including_nds_s],
        ['Всего к оплате:', order.total_price_s]
      ]
      table(data, column_widths: [145.mm, 25.mm]) do
        cells.borders = []
        cells.padding = 2
        cells.font_style = :bold
        cells.padding = 2
        cells.align = :right
      end

      # ===================================================
      # Итоговая стоимость и сумма прописью
      # ===================================================

      move_down 5.mm
      text "Всего наименований #{order.bill_array.size}, на сумму #{order.total_price_s} руб."
      text RuPropisju.rublej(Float(order.total_price)), style: :bold
      stroke_horizontal_rule

      # ===================================================
      # Подписанты
      # ===================================================

      move_down 5.mm

      sign_row = ['', 'должность', '', 'подпись', '', 'расшифровка подписи']
      sign_row_2 = ['', '', '', 'подпись', '', 'расшифровка подписи']
      data = [
        ['Руководитель', Magaz::Setting.get('magaz-head-position'), '', '', '', Magaz::Setting.get('magaz-head-name')],
        sign_row,
        [{content: 'Главный (старший) бухгалтер', colspan: 2}, '', '', '', Magaz::Setting.get('magaz-accountant')],
        sign_row_2,
        [{content: 'Ответственный', colspan: 2}, '', '', '', Magaz::Setting.get('magaz-responsible')],
        sign_row_2
      ]
      
      table(data, column_widths: [30.mm, 30.mm, 5.mm, 40.mm, 5.mm, 60.mm]) do
        cells.borders = []
        row(0).column(1).borders = [:bottom]
        rows([0, 2, 4]).columns([3, 5]).borders = [:bottom]
        rows([1, 3, 5]).padding = 0
        rows([1, 3, 5]).size = 8
        rows([1, 3, 5]).valign = :top
        columns([1, 3, 5]).align = :center
        row(0).column(1).font_style = :bold
        rows([0, 2, 4]).column(5).font_style = :bold
        columns([2,4,5]).padding_right = 5
      end
    end
    
    # ---
    return filename, filepath
  end
end

