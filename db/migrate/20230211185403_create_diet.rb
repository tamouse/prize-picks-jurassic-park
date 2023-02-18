# frozen_string_literal: true

# Initiasl Miration for the Diet model
class CreateDiets < ActiveRecord::Migration[7.0]
  def change
    create_table :diets do |t|
      t.string :name,
               null: false, unique: true,
               comment: 'Carnivore, Herbivore, Omnivore, etc. for normalizing information'

      t.timestamps
    end
  end
end
