# frozen_string_literal: true

Fabricator(:cage) do
  number { sequence(:number) { |i| "#{i}-#{Faker::Number.number.to_s}" } }
  power_status 'active'
end
