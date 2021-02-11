class RemoveFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :posts_count, :bigint
    remove_column :users, :following_count, :bigint
    remove_column :users, :followers_count, :bigint
    remove_column :users, :likes_count, :bigint
  end
end
