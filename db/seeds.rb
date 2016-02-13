
Magaz::User.delete_all
Magaz::Order.delete_all

Magaz::PropertyValue.delete_all
Magaz::Variant.delete_all
Magaz::Comment.delete_all
Magaz::Product.delete_all
Magaz::Category.delete_all
Magaz::PropertyOption.delete_all
Magaz::Property.delete_all
Magaz::PropertyType.delete_all
Magaz::PropertyGroup.delete_all

Magaz::Dimension.delete_all
Magaz::Delivery.delete_all
Magaz::Payment.delete_all
Magaz::Status.delete_all

delivery = Magaz::Delivery.create!(code: '01', name: 'Самовывоз', address_required: false, post_code_required: false)
Magaz::Delivery.create!(code: '02', name: 'Курьер', address_required: true, post_code_required: false)
Magaz::Delivery.create!(code: '03', name: 'Почта России', address_required: true, post_code_required: true)

Magaz::Payment.create!(code: '01', name: 'Безналичный расчет')
payment = Magaz::Payment.create!(code: '02', name: 'Наличными при получении')

Magaz::Dimension.create!(code: '01', name: 'шт', full_name: 'Штука')
Magaz::Dimension.create!(code: '011', name: 'ед', full_name: 'Единица')
Magaz::Dimension.create!(code: '02', name: 'м', full_name: 'Метр')
Magaz::Dimension.create!(code: '021', name: 'пм', full_name: 'Погонный метр')
Magaz::Dimension.create!(code: '03', name: 'кг', full_name: 'Килограмм')

staus_new = Magaz::Status.create!(code: '01', name: 'Новый')
Magaz::Status.create!(code: '02', name: 'Подтвержден')
Magaz::Status.create!(code: '03', name: 'Оплачен')
Magaz::Status.create!(code: '04', name: 'Скомплектован (на складе)')
Magaz::Status.create!(code: '05', name: 'Отправлен')
Magaz::Status.create!(code: '10', name: 'Исполнен', closed: true)
Magaz::Status.create!(code: '11', name: 'Отменен', closed: true)

list = Magaz::PropertyType.create!(code: '01', name: 'Список')
num = Magaz::PropertyType.create!(code: '02', name: 'Целочисленный')
float = Magaz::PropertyType.create!(code: '021', name: 'Число с плавающей точкой')
str = Magaz::PropertyType.create!(code: '03', name: 'Строковый')
text = Magaz::PropertyType.create!(code: '04', name: 'Текстовый')
bool = Magaz::PropertyType.create!(code: '05', name: 'Логический')
color = Magaz::PropertyType.create!(code: '10', name: 'Цвет')

# -----------------------------

Magaz::PropertyGroup.find_or_create_by_path %w|Общее Габаритные-размеры|
Magaz::PropertyGroup.find_or_create_by_path %w|Общее Внешний-вид|

pg_origin = Magaz::PropertyGroup.find_or_create_by_path %w|ЭВМ Происхождение|
pg_proc = Magaz::PropertyGroup.find_or_create_by_path %w|ЭВМ Процессор|
pg_mem = Magaz::PropertyGroup.find_or_create_by_path %w|ЭВМ Память|
pg_mon = Magaz::PropertyGroup.find_or_create_by_path %w|ЭВМ Экран|
pg_hdd = Magaz::PropertyGroup.find_or_create_by_path %w|ЭВМ Устройство-хранения-данных|

Magaz::PropertyGroup.find_or_create_by_path %w|Бытовая-техника Холодильники|
Magaz::PropertyGroup.find_or_create_by_path %w|Бытовая-техника Морозильники|
Magaz::PropertyGroup.find_or_create_by_path %w|Бытовая-техника Плиты|
Magaz::PropertyGroup.find_or_create_by_path %w|Бытовая-техника Вытяжки|

pg_pos = Magaz::PropertyGroup.find_or_create_by_path %w|РТИ Рукава|
pg_plate = Magaz::PropertyGroup.find_or_create_by_path %w|РТИ Техпластины|


pg_origin.add_combo_property('Страна', %w|Китай Тайвань Корея Япония|)
pg_origin.add_combo_property('Компания', %w|HP ASUS Acer DELL MSI|)
pg_proc.add_combo_property('Тип', %w|A10 A8 A6 Core-i7 Core-i5 Core-i3|)
pg_proc.add_number_property('Частота, МГЦ')
pg_mem.add_combo_property('Размер, ГБ', %w|4 6 8 12 16 32|)
pg_mem.add_combo_property('Тип', %w|DDR3 DDR4 DDR5|)
pg_mon.add_number_property('Размер,"')
pg_mon.add_combo_property('Разрешение', %w|1024x768 1440x900 5000x2500|)

pg_pos.add_number_property('Внутренний диаметр, мм')
pg_pos.add_number_property('Рабочее давление, МПа')
pg_pos.add_number_property('Минимальная длина, м')
pg_pos.add_number_property('Максимальная длина, м')
pg_pos.add_number_property('Длина, м')

pg_plate.add_number_property('Длина, п/м')
pg_plate.add_number_property('Ширина, мм')
pg_plate.add_number_property('Минимальная ширина, мм')
pg_plate.add_number_property('Максимальная ширина, мм')
pg_plate.add_number_property('Толщина, мм')
pg_plate.add_number_property('Минимальная толщина, мм')
pg_plate.add_number_property('Максимальная толщина, мм')


notes = Magaz::Category.find_or_create_by_path %w|Компьютеры Ноутбуки|
Magaz::Category.find_or_create_by_path %w|Компьютеры Настольные|
Magaz::Category.find_or_create_by_path %w|Компьютеры Планшеты|
Magaz::Category.find_or_create_by_path %w|Компьютеры Комплектующие|
Magaz::Category.find_or_create_by_path %w|Компьютеры Мониторы|
Magaz::Category.find_or_create_by_path %w|Электроника Мобильные-телефоны|
Magaz::Category.find_or_create_by_path %w|Электроника Фото-и-видеокамеры|
Magaz::Category.find_or_create_by_path %w|Электроника Телевизоры|
Magaz::Category.find_or_create_by_path %w|Бытовая-техника Крупная-техника-для-кухни|
Magaz::Category.find_or_create_by_path %w|Бытовая-техника Мелкая-техника-для-кухни|
Magaz::Category.find_or_create_by_path %w|Бытовая-техника Техника-для-дома|
Magaz::Category.find_or_create_by_path %w|РТИ Рукава|
Magaz::Category.find_or_create_by_path %w|РТИ Кольца|
Magaz::Category.find_or_create_by_path %w|РТИ Техпластины|

p1 = Magaz::Product.create(name: 'ASUS K501LB', category: notes, price: 57260)
p2 = Magaz::Product.create(name: 'HP 15-ac000', category: notes, price: 55401)
p3 = Magaz::Product.create(name: 'Lenovo Ideapad 100S 11', category: notes, price: 45011)

Magaz::Comment.create(name: 'Ирина', text: 'Крутая штука', rate: 5, accepted: false, product: p1)
Magaz::Comment.create(name: 'Николай', 
	text: %|Исходя из имени миграции, Rails может сообщить, что добавляется 
	(или удаляется) один или несколько столбцов к таблице, имена и типы 
	данных берутся из параметров. Rails ищет соответствие двум шаблонам: 
	add_XXX_to_TABLE и remove_XXX_from_TABLE 
	rails generate migration add_quantity_to_line_items quantity:integer 
	rails generate migration add_measure_to_products measure:belongs_to 
	Здесь мы сообщаем, что в таблицу line_items мы хотим добавить поле quntity с типом integer|, 
	rate: 2, accepted: false, product: p1)
Magaz::Comment.create(name: 'Алиса', text: 'Мама... агу... ааа па.. баба', rate: 3, accepted: false, product: p1)

v11 = Magaz::Variant.create!(product: p1, name: 'mod-1', price: 60000)
v12 = Magaz::Variant.create!(product: p1, name: 'mod-2', price: 70000)

o1 = Magaz::Order.create!(customer: 'Иванов Иван', phone: '111-22-333', email: 'ivanoff@example.com', status: staus_new, payment: payment, delivery: delivery)
o1.line_items << Magaz::LineItem.create!(product: p1, variant: v11, count: 2, price: v11.price)
o1.line_items << Magaz::LineItem.create!(product: p1, variant: v12, count: 2, price: v12.price)

o2 = Magaz::Order.create!(customer: 'Петров Петр', phone: '123-45-678', email: 'petroff@example.com', status: staus_new, payment: payment, delivery: delivery)
o2.line_items << Magaz::LineItem.create!(product: p2, price: p2.price, count: 4) << Magaz::LineItem.create!(product: p3, price: p3.price, count: 7)

Magaz::User.create(email: 'user@example.com', password: 'useruser')
