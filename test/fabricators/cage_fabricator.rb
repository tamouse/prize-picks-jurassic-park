# frozen_string_literal: true

Fabricator(:cage) do
  number { sequence(:number) { |i| "#{i}-#{Faker::Number.number.to_s}" } }
  vore { Vore.find_or_create_by(name: Vore::VORE_TYPES.sample) }
end

Fabricator(:herbivore_cage, from: :cage) do
  vore { Vore.find_or_create_by(name: :herbivore) }
end

Fabricator(:carnivore_cage, from: :cage) do
  vore { Vore.find_or_create_by(name: :carnivore) }
end
