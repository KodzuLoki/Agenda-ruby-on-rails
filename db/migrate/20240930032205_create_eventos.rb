class CreateEventos < ActiveRecord::Migration[7.2]
  def change
    create_table :eventos do |t|
      t.string :titulo
      t.text :descripcion
      t.datetime :fecha
      t.integer :usuario_id

      t.timestamps
    end
  end
end
