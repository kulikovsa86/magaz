
Magaz::Category.delete_all
Magaz::PropertyOption.delete_all
Magaz::Property.delete_all
Magaz::PropertyType.delete_all


list = Magaz::PropertyType.create!(code: '01', name: 'Список')
num = Magaz::PropertyType.create!(code: '02', name: 'Цифровой')
str = Magaz::PropertyType.create!(code: '03', name: 'Строковый')
text = Magaz::PropertyType.create!(code: '04', name: 'Текстовый')
bool = Magaz::PropertyType.create!(code: '05', name: 'Логический')
color = Magaz::PropertyType.create!(code: '10', name: 'Цвет')

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

Magaz::Product.create!(name: 'Всё путем', category: cat)
Magaz::Product.create!(name: 'Бендер. Kill all humans', category: cat)
Magaz::Product.create!(name: 'Гомер Симсон', category: cat)
