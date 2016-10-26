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


Magaz::PropertyGroup.find_or_create_by_path %w|Общее Габаритные-размеры|
Magaz::PropertyGroup.find_or_create_by_path %w|Общее Внешний-вид|

pg_origin = Magaz::PropertyGroup.find_or_create_by_path %w|ЭВМ Происхождение|
pg_proc = Magaz::PropertyGroup.find_or_create_by_path %w|ЭВМ Процессор|
pg_mem = Magaz::PropertyGroup.find_or_create_by_path %w|ЭВМ Память|
pg_mon = Magaz::PropertyGroup.find_or_create_by_path %w|ЭВМ Экран|
pg_hdd = Magaz::PropertyGroup.find_or_create_by_path %w|ЭВМ Устройство-хранения-данных|

pg_origin.add_combo_property('Страна', %w|Китай Тайвань Корея Япония|)
pg_origin.add_combo_property('Компания', %w|HP ASUS Acer DELL MSI|)
pg_proc.add_combo_property('Тип', %w|A10 A8 A6 Core-i7 Core-i5 Core-i3|)
pg_proc.add_number_property('Частота, МГЦ', {min: 1000, max: 10000})
pg_mem.add_combo_property('Размер, ГБ', %w|4 6 8 12 16 32|)
pg_mem.add_combo_property('Тип', %w|DDR3 DDR4 DDR5|)
pg_mon.add_number_property('Размер,"', {min: 19, max: 29})
pg_mon.add_combo_property('Разрешение', %w|1024x768 1440x900 5000x2500|)
pg_hdd.add_combo_property('Тип', %w|HDD HDD+SDD SDD|)
pg_hdd.add_number_property('Размер, ГБ', {min: 100, max: 3000})

notes = Magaz::Category.find_or_create_by_path %w|Компьютеры Ноутбуки|
desk = Magaz::Category.find_or_create_by_path %w|Компьютеры Настольные|
mon = Magaz::Category.find_or_create_by_path %w|Компьютеры Мониторы|

[notes, desk, mon].each do |cat|
  cat.property_groups << pg_origin
  if cat != mon
    cat.property_groups << [pg_proc, pg_mem, pg_hdd]
  end
end

p1 = Magaz::Product.create(name: 'ASUS K501', category: notes, price: 57260, description: Faker::Lorem.paragraph)
p1.images << Magaz::Image.create(picture: File.open(Magaz.image_dir + "asus-1.jpg", "r"))

p11 = Magaz::Product.create(name: 'ASUS K505', category: notes, description: Faker::Lorem.paragraph)
p11.images << Magaz::Image.create(picture: File.open(Magaz.image_dir + "asus-2.jpg", "r"))
p2 = Magaz::Product.create(name: 'HP 15-ac', category: notes, price: 55401, description: Faker::Lorem.paragraph)
p2.images << Magaz::Image.create(picture: File.open(Magaz.image_dir + "hp.jpg", "r"))
p3 = Magaz::Product.create(name: 'Lenovo Idealpad 500', category: notes, price: 45011, description: Faker::Lorem.paragraph)
p3.images << Magaz::Image.create(picture: File.open(Magaz.image_dir + "lenovo.jpg", "r"))

p4 = Magaz::Product.create(name: 'MicroXpress', category: desk, price: 35000, description: Faker::Lorem.paragraph)
p4.images << Magaz::Image.create(picture: File.open(Magaz.image_dir + "micro.jpg", "r"))
p5 = Magaz::Product.create(name: 'MSI Night', category: desk, price: 75000, description: Faker::Lorem.paragraph)
p5.images << Magaz::Image.create(picture: File.open(Magaz.image_dir + "msi.jpg", "r"))

p6 = Magaz::Product.create(name: 'Samsung S29', category: mon, price: 15000, description: Faker::Lorem.paragraph)
p6.images << Magaz::Image.create(picture: File.open(Magaz.image_dir + "samsung.jpg", "r"))
p7 = Magaz::Product.create(name: 'Benq U111', category: mon, price: 13333, description: Faker::Lorem.paragraph)
p7.images << Magaz::Image.create(picture: File.open(Magaz.image_dir + "benq.jpg", "r"))

Magaz::Product.all.each { |p| p.rand_properties }

15.times { |i| Magaz::Comment.create(name: "User #{i}", text: "Comment comment comment #{i}", rate: 5, product: p1) }

o1 = Magaz::Order.create!(customer: 'Иванов Иван', phone: '111-22-333', email: 'ivanoff@example.com', status: Magaz::Status.NEW, payment: Magaz::Payment.non_cash, delivery: Magaz::Delivery.pickup)
o1.line_items << Magaz::LineItem.create!(product: p1, count: 2, price: p1.price)
o1.line_items << Magaz::LineItem.create!(product: p3, count: 2, price: p3.price)

o2 = Magaz::Order.create!(customer: 'Петров Петр', phone: '123-45-678', email: 'petroff@example.com', status: Magaz::Status.NEW, payment: Magaz::Payment.non_cash, delivery: Magaz::Delivery.pickup)
o2.line_items << Magaz::LineItem.create!(product: p2, price: p2.price, count: 4) << Magaz::LineItem.create!(product: p3, price: p3.price, count: 7)

v11 = Magaz::Variant.create!(product: p11, name: 'mod-1', price: 60000)
v12 = Magaz::Variant.create!(product: p11, name: 'mod-2', price: 70000)

o3 = Magaz::Order.create!(customer: 'Сидоров Сидр', phone: '555-55-55', email: 'sidoroff@example.com', status: Magaz::Status.NEW, payment: Magaz::Payment.non_cash, delivery: Magaz::Delivery.pickup)
o3.line_items << Magaz::LineItem.create!(product: p11, variant: v11, count: 2, price: v11.price)
o3.line_items << Magaz::LineItem.create!(product: p11, variant: v12, count: 2, price: v12.price)
