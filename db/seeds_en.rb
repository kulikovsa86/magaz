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

Magaz::Delivery.create!(code: '01', name: 'Pickup', address_required: false, post_code_required: false)
Magaz::Delivery.create!(code: '02', name: 'Courier', address_required: true, post_code_required: false)
Magaz::Delivery.create!(code: '03', name: 'Post service', address_required: true, post_code_required: true)

Magaz::Payment.create!(code: '01', name: 'Bank transfer')
Magaz::Payment.create!(code: '02', name: 'Cash on delivery')

Magaz::Dimension.create!(code: '01', name: 'p', full_name: 'Piece')
Magaz::Dimension.create!(code: '011', name: 'u', full_name: 'Unit')
Magaz::Dimension.create!(code: '02', name: 'm', full_name: 'Meter')
Magaz::Dimension.create!(code: '021', name: 'lm', full_name: 'Linear meter')
Magaz::Dimension.create!(code: '03', name: 'kg', full_name: 'Kilogram')

Magaz::Status.create!(code: '01', name: 'New')
Magaz::Status.create!(code: '02', name: 'Confirmed')
Magaz::Status.create!(code: '03', name: 'Paid')
Magaz::Status.create!(code: '04', name: 'Picked (in stock)')
Magaz::Status.create!(code: '05', name: 'Sent')
Magaz::Status.create!(code: '10', name: 'Executed', closed: true)
Magaz::Status.create!(code: '11', name: 'Cancelled', closed: true)

Magaz::PropertyType.create!(code: '01', name: 'List')
Magaz::PropertyType.create!(code: '02', name: 'Integer')
Magaz::PropertyType.create!(code: '021', name: 'Float')
Magaz::PropertyType.create!(code: '03', name: 'String')
Magaz::PropertyType.create!(code: '04', name: 'Text')
Magaz::PropertyType.create!(code: '05', name: 'Boolean')
Magaz::PropertyType.create!(code: '10', name: 'Colors')

Magaz::PropertyKind.create!(code: '01', name: 'Description')
Magaz::PropertyKind.create!(code: '02', name: 'Calculated')
Magaz::PropertyKind.create!(code: '03', name: 'Special')

Magaz::User.create(email: 'user@example.com', password: 'useruser')
