class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references     :post, foreign_key: true
      t.float          :rate
      t.string         :title
      t.integer        :price
      t.timestamps
    end
  end
end
