# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

class JurassicParkSeeder

  def destroy_all_prior
    puts 'Remove all old records'
    ApplicationRecord.transaction do
      Assignment.destroy_all
      Cage.destroy_all
      Dinosaur.destroy_all
      Species.destroy_all
      Vore.destroy_all
    end
  rescue => e
    fail "Failure to remove old records: #{e.class}: '#{e}'"
  end

  def seed_vores
    puts 'Seeding vores'
    Vore::VORE_TYPES.each do |vt|
      Vore.create! name: vt
    end
  end

  def seed_species(vore)
    puts "Seeding species for vore #{vore.name}"
    if vore.name == 'herbivore'
      Species::HERBIVORE_SPECIES.each do |species_name|
        Species.create! name: species_name, vore_id: vore.id
      end
    else
      Species::CARNIVORE_SPECIES.each do |species_name|
        Species.create! name: species_name, vore_id: vore.id
      end
    end
  end

  def seed_cages(species)
    if species.vore.name == :herbivore
      puts "Seeding cage for vore #{species.vore.name}"
      Cage.create!(number: "#{species.vore.name}0", vore_id: species.vore.id)
    else
      puts "Seeding cage for species #{species.name}"
      Cage.create!(number: "#{species.name}0", vore_id: species.vore.id, species_id: species.id)
    end

  end

  def seed_dinos(species)
    @name = Faker::Name.name
    until Dinosaur.find_by(name: @name).nil?
      @name = Faker::Name.name
    end

    puts "Seeding dinosaur #{@name}"
    svc = DinosaurCreateService.new(species: species, name: name)
    svc.create
  end
end

seeder = JurassicParkSeeder.new

seeder.destroy_all_prior
seeder.seed_vores

puts 'Seeding cages'
Vore.find_each do |vore|
  seeder.seed_species(vore)
end

puts 'Seeding species'
Species.find_each do |species|
  seeder.seed_cages(species)
end

puts 'Seeding dinosaurs'
Species.find_each do |species|
  # Two of each
  2.times { seeder.seed_dinos(species) }
end
