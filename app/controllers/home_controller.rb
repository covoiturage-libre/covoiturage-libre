class HomeController < ApplicationController

  def index
    # cms data
    @page_part_1 = Cms::PagePart.where(id: 1)

    @search = Search.new
  end

end
