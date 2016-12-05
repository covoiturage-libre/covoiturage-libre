class HomeController < ApplicationController

  def index
    # meta data
    @meta[:title] = 'Covoiturage Libre'
    @meta[:description] = 'Site de covoiturage gratuit et ouvert à tous'

    # cms data
    @page_part_1 = Cms::PagePart.where(id: 1)

    @search = Search.new
  end

end
