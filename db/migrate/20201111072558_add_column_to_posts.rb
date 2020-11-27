class AddColumnToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :comments_count, :bigint, default: 0
  end
end
