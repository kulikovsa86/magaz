namespace :magaz do
  desc 'Load seed data for the Magaz (rus)'
  task seed: :environment do
    require File.join(Magaz.root, 'db', 'seeds')
  end

  desc "Generate fake products (rus)"
  task fake_products: :environment do
    require File.join(Magaz.root, 'db', 'fake_products')
  end

  desc 'Load seed data for the Magaz (en)'
  task seed_en: :environment do
    require File.join(Magaz.root, 'db', 'seeds_en')
  end

  desc "Generate fake products (en)"
  task fake_products_en: :environment do
    require File.join(Magaz.root, 'db', 'fake_products_en')
  end
end
