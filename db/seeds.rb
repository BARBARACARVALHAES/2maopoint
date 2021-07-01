# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Trade.destroy_all
ItemCategory.destroy_all
CarrefourUnit.destroy_all
p "Destroyed the database"

ItemCategory::ITEM_CATEGORIES.each do |item|
  i = ItemCategory.create!(name: item)
  p "Created category #{i.name}"
end

CSV.foreach('./database-lojas-carrefour.csv', headers: true, encoding:'utf-8', col_sep: ",") do |row|
  # Create a hash for each MOA with the header of the CSV file
  unit = row.to_h  
  u = CarrefourUnit.create!(
    name: unit["Nome"], 
    address: "#{unit['Endereço']}, #{unit['Número']}",
    city: unit['Cidade'],
    cep: unit['CEP'],
    suburb: unit['Bairro'],
    )
  p "Create #{u.id} Carrefour Unit"
end

5.times do |n|
  u = User.create!(
    email: "test#{n + 1}@test.com",
    password: "123456",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    cpf: Faker::Number.number(digits: 11),
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
    phone: "2100000000#{n}",
    address: Faker::Address.street_address,
    confirmed_at: Time.now,
    optin_ads: [true, false].sample,
    optin_privacy: true
  )
  p "Create #{u.id} user"
end


ceps = [
  '08090-284', 
  '04849-529', 
  '04843-425', 
  '08226-021', 
  '04180-112', 
  '04236-094', 
  '02317-262', 
  '03047-000', 
  '03807-020', 
  '08240-001', 
  '08240-001', 
  '08421-510', 
  '08150-640', 
  '18190-000', 
  '08081-511', 
  '04852-410',
  '01517-100',
  '04849-309',
  '08475-250',
  '08412-120',
  '04849-333',
  '08344-010',
  '04893-052',
  '04894-017',
  '02012-030',
  '03195-105'
]

20.times do |_n|
  buyer = User.all.sample
  seller = User.where.not(id: buyer.id).sample
  author = [buyer, seller].sample
  buyer_cep = ceps.sample
  seller_cep = (ceps - [buyer_cep]).sample
  t = Trade.create!(
    buyer: buyer,
    seller: seller,
    date: Faker::Time.between(from: DateTime.now, to: DateTime.now + 30),
    item: Faker::Lorem.word,
    item_category: ItemCategory.all.sample,
    carrefour_unit: CarrefourUnit.all.sample,
    buyer_accepted: [true, false].sample,
    seller_accepted: [true, false].sample,
    buyer_cep: buyer_cep,
    seller_cep: seller_cep,
    receiver_phone: [buyer.phone, seller.phone].sample,
    receiver_name: Faker::Name.first_name,
    author: author,
    lat_buyer: rand(-23.701420495330392..-23.458942508769738),
    long_buyer: rand(-46.8124555391923..-46.457071538413445),
    lat_seller: rand(-23.701420495330392..-23.458942508769738),
    long_seller: rand(-46.8124555391923..-46.457071538413445)
  )
  p "Create #{t.id} trades"
end
