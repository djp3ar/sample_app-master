class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :university
      t.string :title
      t.string :email
      t.string :accounttype
      t.timestamps
    end
  end
end
