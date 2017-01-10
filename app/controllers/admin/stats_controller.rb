class Admin::StatsController < AdminController

  def index
  end

  def trips_count
    @t1 = Date.today - 3.months
    @t2 = Time.now
  end

  def trips_tab
  end

end
