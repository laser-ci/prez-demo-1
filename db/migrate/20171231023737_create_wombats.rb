class CreateWombats < ActiveRecord::Migration[5.1]
  def change
    create_table :wombats do |t|
      t.string :title
      t.text :body
      t.boolean :published

      t.timestamps
    end
  end
end
