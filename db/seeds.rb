# db/seeds.rb
require 'faker'

# Crear 10 usuarios ficticios
10.times do
  Usuario.create!(
    nombre: Faker::Name.name,
    email: Faker::Internet.email,
  )
end

puts "Se han creado 10 usuarios ficticios"
