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
      Cage.destroy_all
      Dinosaur.destroy_all
      Species.destroy_all
      Diet.destroy_all
    end
  rescue => e
    fail "Failure to remove old records: #{e.class}: '#{e}'"
  end

  def seed_diets
    puts 'Seeding diets'
    Diet::DIET_TYPES.each do |vt|
      Diet.create! name: vt
    end
  end

  def seed_species(diet)
    puts "Seeding species for diet #{diet.name}"
    if diet.name == 'herbivore'
      Species::HERBIVORE_SPECIES.each do |species_name|
        Species.create! name: species_name, diet_id: diet.id
      end
    else
      Species::CARNIVORE_SPECIES.each do |species_name|
        Species.create! name: species_name, diet_id: diet.id
      end
    end
  end

  def seed_cages(species)
    if species.diet.name == :herbivore
      puts "Seeding cage for diet #{species.diet.name}"
      Cage.create!(number: "#{species.diet.name}0", diet_id: species.diet.id)
    else
      puts "Seeding cage for species #{species.name}"
      Cage.create!(number: "#{species.name}0", diet_id: species.diet.id, species_id: species.id)
    end

  end

  def seed_dinos(species)
    @name = Faker::Name.name
    until Dinosaur.find_by(name: @name).nil?
      @name = Faker::Name.name
    end

    puts "Seeding dinosaur #{@name}"
    svc = DinosaurCreateService.new(species: species, name: @name)
    svc.create
  end
end

seeder = JurassicParkSeeder.new

seeder.destroy_all_prior
seeder.seed_diets

puts 'Seeding cages'
Diet.find_each do |diet|
  seeder.seed_species(diet)
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
