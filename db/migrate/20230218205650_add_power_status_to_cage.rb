class AddPowerStatusToCage < ActiveRecord::Migration[7.0]
  def change
    # In the spec, this is initially only shown as two values, but could in the
    #   future include more, depending on how the state of power plays out.
    add_column :cages, :power_status, :text, null: false, default: 'active',
               comment: 'Determine whether the cage is powered or unpowered: ACTIVE or DOWN'
  end
end
