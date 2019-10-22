class CreateInitiatives < ActiveRecord::Migration[5.0]
  def change
    create_table :initiatives do |table_element|
      table_element.string :name
      table_element.string :description
    end
  end
end
