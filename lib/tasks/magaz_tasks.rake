namespace :magaz do
  desc 'Load seed data for the Magaz'
  task seed: :environment do
    require File.join(Magaz.root, 'db', 'seeds')
  end
end
