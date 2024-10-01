class AddCiudadToEventos < ActiveRecord::Migration[7.2]
  def change
    add_column :eventos, :ciudad, :string
  end
end
