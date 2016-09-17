class Point < ApplicationRecord
  belongs_to :trip

  def as_json(options={})
    super(
        only: [:kind, :rank, :city]
    ).merge(location: {
        lat: lat.to_f, lon: lon.to_f
    })
  end

end
