# frozen_string_literal: true

require 'faker'

Fabricator(:dinosaur) do
  vore
  species { |attrs| Fabricate(:species, vore: attrs[:vore]) }

  name    { sequence(:name) { |seq| "#{Faker::Name.name}#{seq}" } }
  alive   true
end
