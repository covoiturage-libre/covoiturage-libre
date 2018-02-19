class Cms::Page < ApplicationRecord

  self.table_name = 'cms_pages'

  validates_presence_of :name, :title, :slug, :meta_desc

  def simple_format_body
    simple_format(body)
  end

end
