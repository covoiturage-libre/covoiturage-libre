require 'csv'
require 'awesome_print'

class GeonameSource
  def initialize(input_file)
    @csv = CSV.open(input_file, 'r', { col_sep: "\t" })
  end

  def each
    @csv.each do |row|
      yield(row)
    end
    @csv.close
  end
end