Magaz::User.delete_all
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
Magaz::PropertyType.delete_all
Magaz::PropertyGroup.delete_all
Magaz::PropertyKind.delete_all

Magaz::Dimension.delete_all
Magaz::Delivery.delete_all
Magaz::Payment.delete_all
Magaz::Status.delete_all

Magaz::Delivery.create!(code: '01', name: 'Самовывоз', address_required: false, post_code_required: false)
Magaz::Delivery.create!(code: '02', name: 'Курьер', address_required: true, post_code_required: false)
Magaz::Delivery.create!(code: '03', name: 'Почта России', address_required: true, post_code_required: true)

Magaz::Payment.create!(code: '01', name: 'Безналичный расчет')
Magaz::Payment.create!(code: '02', name: 'Наличными при получении')

Magaz::Dimension.create!(code: '01', name: 'шт', full_name: 'Штука')
Magaz::Dimension.create!(code: '011', name: 'ед', full_name: 'Единица')
Magaz::Dimension.create!(code: '02', name: 'м', full_name: 'Метр')
Magaz::Dimension.create!(code: '021', name: 'пм', full_name: 'Погонный метр')
Magaz::Dimension.create!(code: '03', name: 'кг', full_name: 'Килограмм')

Magaz::Status.create!(code: '01', name: 'Новый')
Magaz::Status.create!(code: '02', name: 'Подтвержден')
Magaz::Status.create!(code: '03', name: 'Оплачен')
Magaz::Status.create!(code: '04', name: 'Скомплектован (на складе)')
Magaz::Status.create!(code: '05', name: 'Отправлен')
Magaz::Status.create!(code: '10', name: 'Исполнен', closed: true)
Magaz::Status.create!(code: '11', name: 'Отменен', closed: true)

Magaz::PropertyType.create!(code: '01', name: 'Список')
Magaz::PropertyType.create!(code: '02', name: 'Целочисленный')
Magaz::PropertyType.create!(code: '021', name: 'Число с плавающей точкой')
Magaz::PropertyType.create!(code: '03', name: 'Строковый')
Magaz::PropertyType.create!(code: '04', name: 'Текстовый')
Magaz::PropertyType.create!(code: '05', name: 'Логический')
Magaz::PropertyType.create!(code: '10', name: 'Цвет')

Magaz::PropertyKind.create!(code: '01', name: 'Описание')
Magaz::PropertyKind.create!(code: '02', name: 'Расчетный')
Magaz::PropertyKind.create!(code: '03', name: 'Специальный')

Magaz::User.create(email: 'user@example.com', password: 'useruser')
