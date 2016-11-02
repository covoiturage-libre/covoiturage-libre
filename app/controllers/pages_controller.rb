class PagesController < ApplicationController

  STATIC_PAGES = %w(association stickers press faq contact terms_of_service legal_notice).freeze

  STATIC_PAGES.each do |page|
    define_method(page.to_sym) { nil }
  end

end