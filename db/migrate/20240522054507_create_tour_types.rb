class CreateTourTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :tour_types do |t|
      t.string :type_name

      t.timestamps
    end
  end
end
