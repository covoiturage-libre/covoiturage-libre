class CreateCmsPages < ActiveRecord::Migration[5.0]
  def change
    create_table :cms_pages do |t|
      t.string :name
      t.string :slug
      t.string :title
      t.string :meta_desc
      t.text :body

      t.timestamps
    end
  end
end
