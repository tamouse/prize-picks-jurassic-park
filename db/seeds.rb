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

  def seed_cages(vore)
    puts "Seeding cage for vore #{vore.name}"
    Cage.create!(number: "#{vore.name}0", vore_id: vore.id)
  end

  def seed_dinos(species)
    @name = Faker::Name.name
    until Dinosaur.find_by(name: @name).nil?
      @name = Faker::Name.name
    end

    puts "Seeding dinosaur #{@name}"
    dino = Dinosaur.create!(species: species, vore: species.vore, name: @name)
    cage = Cage.find_by(vore: species.vore)
    dino.create_assignment(cage: cage)
  end
end

seeder = JurassicParkSeeder.new

seeder.destroy_all_prior
seeder.seed_vores
Vore.find_each do |vore|
  seeder.seed_species(vore)
  seeder.seed_cages(vore)
end

# Two of each
Species.find_each do |species|
  2.times { seeder.seed_dinos(species) }
end
