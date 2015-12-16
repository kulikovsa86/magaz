
Magaz::User.delete_all

Magaz::Order.delete_all

Magaz::Product.delete_all
Magaz::Category.delete_all
Magaz::PropertyOption.delete_all
Magaz::Property.delete_all
Magaz::PropertyType.delete_all
Magaz::PropertyGroup.delete_all

Magaz::Delivery.delete_all
Magaz::Payment.delete_all
Magaz::Status.delete_all

delivery = Magaz::Delivery.create!(code: '01', name: 'Самовывоз', address_required: false, post_code_required: false)
Magaz::Delivery.create!(code: '02', name: 'Курьер', address_required: true, post_code_required: false)
Magaz::Delivery.create!(code: '03', name: 'Почта России', address_required: true, post_code_required: true)

Magaz::Payment.create!(code: '01', name: 'Безналичный расчет')
payment = Magaz::Payment.create!(code: '02', name: 'Наличными при получении')

staus_new = Magaz::Status.create!(code: '01', name: 'Новый')
Magaz::Status.create!(code: '02', name: 'Подтвержден')
Magaz::Status.create!(code: '03', name: 'Оплачен')
Magaz::Status.create!(code: '04', name: 'Скомплектован (на складе)')
Magaz::Status.create!(code: '05', name: 'Отправлен')
Magaz::Status.create!(code: '10', name: 'Исполнен')
Magaz::Status.create!(code: '11', name: 'Отменен')

list = Magaz::PropertyType.create!(code: '01', name: 'Список')
num = Magaz::PropertyType.create!(code: '02', name: 'Цифровой')
str = Magaz::PropertyType.create!(code: '03', name: 'Строковый')
text = Magaz::PropertyType.create!(code: '04', name: 'Текстовый')
bool = Magaz::PropertyType.create!(code: '05', name: 'Логический')
color = Magaz::PropertyType.create!(code: '10', name: 'Цвет')

# -----------------------------

Magaz::PropertyGroup.create(code: '01', name: 'group 1')
Magaz::PropertyGroup.create(code: '02', name: 'group 2')
Magaz::PropertyGroup.create(code: '03', name: 'group 3')

size = Magaz::Property.create!(code: '01', name: 'Размер', static: false, property_type: list)
Magaz::PropertyOption.create!(code: '01', name: 'S', property: size)
Magaz::PropertyOption.create!(code: '02', name: 'M', property: size)
Magaz::PropertyOption.create!(code: '03', name: 'L', property: size)

Magaz::Property.create!(code: '02', name: 'Производитель', static: true, property_type: str)
Magaz::Property.create!(code: '03', name: 'Цвет', static: false, property_type: color)

cat = Magaz::Category.find_or_create_by_path %w|Одежда Футболки|
Magaz::Category.find_or_create_by_path %w|Одежда Джинсы|
Magaz::Category.find_or_create_by_path %w|Обувь Ботинки|
Magaz::Category.find_or_create_by_path %w|Обувь Кеды|
Magaz::Category.find_or_create_by_path %w|Компьютеры Стационарные|
Magaz::Category.find_or_create_by_path %w|Компьютеры Ноутбуки|

p1 = Magaz::Product.create!(name: 'Всё путем', category: cat, price: 100.0)
p2 = Magaz::Product.create!(name: 'Бендер. Kill all humans', category: cat, price: 200.0)
p3 = Magaz::Product.create!(name: 'Гомер Симпсон', category: cat, price: 30.0)

v11 = Magaz::Variant.create!(product: p1, price: 110)
v12 = Magaz::Variant.create!(product: p1, price: 120)

o1 = Magaz::Order.create!(customer: 'Иванов Иван', phone: '111-22-333', email: 'ivanoff@example.com', status: staus_new, payment: payment, delivery: delivery)
o1.line_items << Magaz::LineItem.create!(product: p1, variant: v11, count: 2, price: 200)
o1.line_items << Magaz::LineItem.create!(product: p1, variant: v12, count: 2, price: 300)

o2 = Magaz::Order.create!(customer: 'Петров Петр', phone: '123-45-678', email: 'petroff@example.com', status: staus_new, payment: payment, delivery: delivery)
o2.line_items << Magaz::LineItem.create!(product: p2, count: 4) << Magaz::LineItem.create!(product: p3, count: 7)

Magaz::User.create(email: 'user@example.com', password: 'useruser')
