class Cms::PagePart < ApplicationRecord

  self.table_name = 'cms_page_parts'

  validates_presence_of :name, :body

end