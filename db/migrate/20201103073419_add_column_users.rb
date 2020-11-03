class AddColumnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :description, :text
    add_column :users, :posts_count, :bigint
    add_column :users, :following_count, :bigint
    add_column :users, :followers_count, :bigint
    add_column :users, :likes_count, :bigint
  end
end
