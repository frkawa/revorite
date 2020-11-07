class SetDefaultvalueToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :posts_count, :bigint, default: 0
    change_column :users, :following_count, :bigint, default: 0
    change_column :users, :followers_count, :bigint, default: 0
    change_column :users, :likes_count, :bigint, default: 0
  end
end
