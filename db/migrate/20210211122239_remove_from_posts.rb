class RemoveFromPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :repost_count, :bigint
    remove_column :posts, :comments_count, :bigint
    remove_column :posts, :likes_count, :bigint
  end
end
