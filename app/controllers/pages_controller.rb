class PagesController < ApplicationController

  STATIC_PAGES = %w(association stickers press faq contact terms).freeze

  STATIC_PAGES.each do |page|
    define_method(page.to_sym) { nil }
  end

end