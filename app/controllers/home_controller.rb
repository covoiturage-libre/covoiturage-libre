class HomeController < ApplicationController

  def index
    @page_part_1 = Cms::PagePart.where(id: 1)
    @search = Search.new
  end

end
