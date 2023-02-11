# frozen_string_literal: true

# Initiasl Miration for the Vore model
class CreateVores < ActiveRecord::Migration[7.0]
  def change
    create_table :vores do |t|
      t.string :name,
               null: false, unique: true,
               comment: 'Carnivore, Herbivore, Omnivore, etc. for normalizing information'

      t.timestamps
    end
  end
end
