function isFloat(n){
  return Number(n) === n && n % 1 !== 0;
}

var Point = function(lat, lon, rank, kind) {
  this.lat = lat;
  this.lon = lon;
  this.rank = rank;
  this.kind = kind;
  this.arrayValue = function() {
    return [this.lat, this.lon];
  }
}

var TripDrawing = function() {
  var self = this;

  self.init = function(aRouting, aPointArray) {
    self.points = [];
    self.routing = aRouting;
    if (self.hasAFirstLatLon(aPointArray)) {
      self.points = aPointArray;
      self.renderRouting();
    }
    self.observeGeonameChanges();
    self.manageCocoonEvents();
  }

  self.observeGeonameChanges = function() {
    $('.trip_points_lon input').change(self.updateOrCreatePoint);
  }

  self.manageCocoonEvents = function() {
    $('#steps')
      .on('cocoon:after-insert', function(e, el) {
        self.reorderSteps();
        $(el).find('.trip_points_lon input:first').change(self.updateOrCreatePoint);
      })
      .on("cocoon:after-remove", function(e, el) {
        var deletedRank = parseInt($(el).find('.trip_points_rank input:first').val());
        self.removePointAtIndex(deletedRank);
        self.reorderSteps();
      });
  }

  self.updateOrCreatePoint = function() {
    var lon = parseFloat($(this).val());
    if (isFloat(lon)) {
      var lat = parseFloat($(this).parent().siblings('.trip_points_lat:first').find('input:first').val());
      var kind = $(this).parent().siblings('.trip_points_kind:first').find('input:first').val();
      var rank = parseInt($(this).parent().siblings('.trip_points_rank:first').find('input:first').val());
      var point = new Point(lat, lon, rank, kind);
      self.points[point.rank] = point.arrayValue();
      self.renderRouting();
    }
  }

  self.removePointAtIndex = function(index) {
    self.points[index] = null;
    self.renderRouting();
  }

  self.renderRouting = function() {
    self.routing.setWaypoints(self.cloneAndTrimArray());
    self.routing.route();
  }

  self.reorderSteps = function() {
    $('#steps .nested-fields').each(function(index, value) {
      var newIndex = parseInt(index) + 1;
      $(this).find('.trip_points_city label:first').text('Étape '+ newIndex);
      $(this).find('.trip_points_rank input:first').val(newIndex);
    });
  }

  // more or less "private" methods

  self.cloneAndTrimArray = function() {
    var copiedArray = self.points.slice(0);
    return copiedArray.filter(function(val) { return val !== null; })
  }

  self.hasAFirstLatLon = function(anArray) {
    var result = true;
    if (anArray[0][0] == 0) { result = false; }
    if (anArray[0][1] == 0) { result = false; }
    return result;
  }

}