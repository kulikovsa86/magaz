Magaz::Order.delete_all

Magaz::PropertyValue.delete_all
Magaz::Variant.delete_all
Magaz::Comment.delete_all
Magaz::Image.delete_all

Magaz::Product.delete_all
Magaz::Category.delete_all
Magaz::PropertyOption.delete_all
Magaz::PropertyArg.delete_all
Magaz::Property.delete_all
Magaz::PropertyGroup.delete_all

pg_hoses = Magaz::PropertyGroup.find_or_create_by_path %w|РТИ Рукава|
pg_hoses.add_string_property("Стандарт", static: true)
pg_hoses.add_combo_property("Рабочая среда", 
  ["Вода техническая", 
    "Вода горячая", 
    "Пищевые вещества", 
    "Воздух, углекислый газ, азот и другие инертные газы",
    "Абразивные материалы (песок от пескоструйных аппаратов)",
    "Бензины, керосины, масла",
    "Насыщенный пар",
    "Слабые растворы неорганических кислот и щелочей концентрации до 20 %"],
    static: true)
pg_hoses.add_string_property("Класс", static: true)
pg_hoses.add_float_property("Внутренний диаметр, мм")
pg_hoses.add_float_property("Рабочее давление, МПа")
pg_hoses.add_number_property("Длина, п/м", variant: true)

cat_hoses_pressure = Magaz::Category.find_or_create_by_path(["Рукава", "Рукава напорные"])
cat_hoses_pressure.property_groups << pg_hoses
hose_v = Magaz::Product.create(
  name: "Рукав В",
  category: cat_hoses_pressure,
  price: 1,
  description: "Гибкий трубопровод для подачи под давлением рабочей среды: \
    вода техническая, слабые растворы неорганических кислот и \
    щелочей концентрации до 20% (кроме растворов азотной кислоты)")
hose_vg = Magaz::Product.create(
  name: "Рукав ВГ",
  category: cat_hoses_pressure,
  price: 1,
  description: "Гибкий трубопровод для подачи под давлением рабочей среды: вода горячая")


pg_rings = Magaz::PropertyGroup.find_or_create_by_path %w|РТИ Кольца|
pg_cuffs = Magaz::PropertyGroup.find_or_create_by_path %w|РТИ Манжеты|


