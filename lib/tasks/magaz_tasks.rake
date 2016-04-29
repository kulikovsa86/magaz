namespace :magaz do
  desc 'Load seed data for the Magaz'
  task seed: :environment do
    require File.join(Magaz.root, 'db', 'seeds')
  end

  desc "'Generate fake products"
  task fake_products: :environment do
    require File.join(Magaz.root, 'db', 'fake_products')
  end
end
