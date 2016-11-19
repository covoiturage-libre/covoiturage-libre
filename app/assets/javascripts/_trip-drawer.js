var Point = function(lat, lon, rank, kind) {
  this.lat = lat;
  this.lon = lon;
  this.rank = rank;
  this.kind = kind;
  this.arrayValue = function() {
    return [parseFloat(this.lat), parseFloat(this.lon)];
  }
}

var TripPoints = function() {
  var self = this;

  self.init = function(aRouting, aPointArray) {
    self.currentRank = 0;
    self.routing = aRouting;
    self.points = new Array(2); // should contain only arrayValues of the points
    if (self.hasAFirstLatLon(aPointArray)) {
      self.points = aPointArray;
      self.renderRouting();
    }
    self.observeGeonameChanges();
    self.manageCocoonEvents();
  }

  self.cleanPointsArray = function() {
    for (var i = 0; i < self.points.length; i++) {
      if (self.points[i] == undefined) {
        self.points.splice(i, 1);
        i--;
      }
    };
  }

  self.addPoint = function(point) {
    self.points[point.rank] = point.arrayValue();
    self.renderRouting();
  }

  self.removePoint = function(point) {

  }

  self.changePoint = function(point) {

  }

  self.observeGeonameChanges = function() {
    $('.trip_points_lon input').change(self.grabPointFields);
  }

  self.renderRouting = function() {
    self.cleanPointsArray();
    self.routing.setWaypoints(self.points);
    self.routing.route();
  }

  self.manageCocoonEvents = function() {
    $('#steps')
      .on('cocoon:before-insert', function(e, step) {

      })
      .on('cocoon:after-insert', function(e, step) {
        self.currentRank += 1;
        $(step).find('.trip_points_rank input').val(self.currentRank);
        $(step).find('.geoname').geonameAutocomplete();
        $(step).find('.trip_points_lon input').change(self.grabPointFields);
      })
      .on("cocoon:before-remove", function(e, step) {
        // do nothing
      })
      .on("cocoon:after-remove", function(e, step) {
        // do nothing
      });
  }

  self.grabPointFields = function() {
    var lon = $(this).val();
    var lat = $(this).parent().siblings('.trip_points_lat').find('input').val();
    var kind = $(this).parent().siblings('.trip_points_kind').find('input').val();
    var rank = $(this).parent().siblings('.trip_points_rank').find('input').val();
    var point = new Point(lat, lon, rank, kind);
    self.addPoint(point);
  }

  self.hasAFirstLatLon = function(anArray) {
    var result = true;
    if (anArray[0][0] == 0) { result = false; }
    if (anArray[0][1] == 0) { result = false; }
    return result;
  }

}