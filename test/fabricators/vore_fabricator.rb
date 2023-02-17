# frozen_string_literal: true

Fabricator(:vore) do
  name { Vore::VORE_TYPES.sample }
end

Fabricator(:carnivore, from: :vore) do
  name { 'Carnivore' }
end

Fabricator(:herbivore, from: :vore) do
  name { 'Herbivore' }
end
