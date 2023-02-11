# frozen_string_literal: true

Fabricator(:vore) do
  name { Vore::VORE_TYPES.sample }
end

Fabricator(:carinore, from: :vore) do
  name { 'Carinore' }
end

Fabricator(:herbivore, from: :vore) do
  name { 'Herbivore' }
end
