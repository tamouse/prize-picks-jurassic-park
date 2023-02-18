# frozen_string_literal: true

require 'faker'

Fabricator(:dinosaur) do
  diet
  species { |attrs| Fabricate(:species, diet: attrs[:diet]) }

  name    { sequence(:name) { |seq| "#{Faker::Name.name}#{seq}" } }
  alive   true
end
