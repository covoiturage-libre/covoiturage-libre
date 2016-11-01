require 'csv'
require 'awesome_print'

class GeonameSource
  def initialize(url)
    download = open(url)

    @csv = CSV.open(download, 'r', { col_sep: "\t" })
  end

  def each
    @csv.each do |row|
      yield(row)
    end
    @csv.close
  end
end