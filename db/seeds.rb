# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


vores = Vore::VORE_TYPES.map do |v|
  Vore.find_or_create_by(name: v)
end

vores.map do |v|
  species_list = v.name == 'herbivore' ? Species::HERBIVORE_SPECIES : Species::CARNIVORE_SPECIES
  species_list.map do |s|
    Species.find_or_create_by(name: s, vore: v)
  end
end

pp Vore.all.pluck(:id, :name)
pp Species.all.pluck(:id, :name, :vore_id)
