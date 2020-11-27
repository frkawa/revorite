class SetDefaultvalueToPosts < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :likes_count, :bigint, default: 0
    change_column :posts, :repost_count, :bigint, default: 0
  end
end
