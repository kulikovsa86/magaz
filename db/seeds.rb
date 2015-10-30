
Magaz::Category.delete_all
Magaz::PropertyOption.delete_all
Magaz::Property.delete_all
Magaz::PropertyType.delete_all


list = Magaz::PropertyType.create!(code: '01', name: 'Список')
num = Magaz::PropertyType.create!(code: '02', name: 'Цифровой')
str = Magaz::PropertyType.create!(code: '03', name: 'Строковый')

Magaz::PropertyType.create!(code: '04', name: 'Текстовый')
Magaz::PropertyType.create!(code: '05', name: 'Логический')
Magaz::PropertyType.create!(code: '10', name: 'Цвет')

prop = Magaz::Property.create!(code: '01', name: 'prop-1', static: false, property_type: list)

Magaz::PropertyOption.create!(code: '01', name: 'opt1', property_id: prop.id)
Magaz::PropertyOption.create!(code: '02', name: 'opt2', property_id: prop.id)
Magaz::PropertyOption.create!(code: '03', name: 'opt3', property_id: prop.id)

Magaz::Property.create!(code: '02', name: 'prop-2', static: false, property_type: num)
Magaz::Property.create!(code: '03', name: 'prop-3', static: true, property_type: str)

cat = Magaz::Category.find_or_create_by_path %w|Категория-1 Подкатегория-11 Секция-111|
Magaz::Category.find_or_create_by_path %w|Категория-1 Подкатегория-11 Секция-112|
Magaz::Category.find_or_create_by_path %w|Категория-1 Подкатегория-11 Секция-113|
Magaz::Category.find_or_create_by_path %w|Категория-1 Подкатегория-11 Секция-114|
Magaz::Category.find_or_create_by_path %w|Категория-1 Подкатегория-11 Секция-115|
Magaz::Category.find_or_create_by_path %w|Категория-1 Подкатегория-11 Секция-116|
Magaz::Category.find_or_create_by_path %w|Категория-1 Подкатегория-12|
Magaz::Category.find_or_create_by_path %w|Категория-1 Подкатегория-13|
Magaz::Category.find_or_create_by_path %w|Категория-2 Подкатегория-21|
Magaz::Category.find_or_create_by_path %w|Категория-2 Подкатегория-22|
Magaz::Category.find_or_create_by_path %w|Категория-3 Подкатегория-31 Секция-311|
Magaz::Category.find_or_create_by_path %w|Категория-3 Подкатегория-31|
Magaz::Category.find_or_create_by_path %w|Категория-3 Подкатегория-31|

Magaz::Product.create!(name: 'Продукт 1', category: cat)
Magaz::Product.create!(name: 'Продукт 2', category: cat)
Magaz::Product.create!(name: 'Продукт 3', category: cat)