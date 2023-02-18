# frozen_string_literal: true

# Primary discinction is the diet type
class CreateSpecies < ActiveRecord::Migration[7.0]
  def change
    create_table :species do |t|
      t.string :name,
               null: false, unique: true,
               comment: 'Species of dinosaur, e.g. Tyranosaurus'

      t.belongs_to :diet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
