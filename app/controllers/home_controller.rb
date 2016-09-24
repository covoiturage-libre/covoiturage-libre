class HomeController < ApplicationController

  def index
    @search = Search.new
  end

end
