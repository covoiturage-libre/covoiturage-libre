class CreateCmsPageParts < ActiveRecord::Migration[5.0]
  def change
    create_table :cms_page_parts do |t|
      t.string :name
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
