class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.references :node, index: true, foreign_key: true
      t.string :title, null: false
      t.string :intro
      t.text :body, null: false
      t.string :image
      t.datetime :published_at # 如果为空表示今天发布

      t.timestamps null: false
    end
  end
end
