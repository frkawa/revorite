class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text        :text
      t.bigint      :likes_count
      t.bigint      :repost_count
      t.timestamps
    end
  end
end
