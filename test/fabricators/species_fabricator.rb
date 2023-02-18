# frozen_string_literal: true

Fabricator(:species, from: 'Species') do
  name { Species::ALL_SPECIES.sample }
  diet { Diet.find_or_create_by(name: Diet::DIET_TYPES.sample) }
end

Fabricator(:carnivore_species, from: :species) do
  name { Species::CARNIVORE_SPECIES.sample }
  diet { Diet.find_or_create_by(name: :carnivore) }
end

Fabricator(:herbivore_species, from: :species) do
  name { Species::HERBIVORE_SPECIES.sample }
  diet { Diet.find_or_create_by(name: :herbivore) }
end
