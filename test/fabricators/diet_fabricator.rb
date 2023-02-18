# frozen_string_literal: true

Fabricator(:diet) do
  name { Diet::DIET_TYPES.sample }
end

Fabricator(:carnivore, from: :diet) do
  name { 'Carnivore' }
end

Fabricator(:herbivore, from: :diet) do
  name { 'Herbivore' }
end
