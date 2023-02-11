# frozen_string_literal: true

require 'faker'

Fabricator(:dinosaur) do
  vore
  species { |attrs| Fabricate(:species, vore: attrs[:vore]) }
  cage    { |attrs| Fabricate(:cage, vore: attrs[:vore]) }

  name    { Faker::Name.name }
  alive   true
end
