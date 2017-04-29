
var TripDrawing = function() {
  var self = this;

  self.init = function(aRouting, aPointArray) {
    self.totalDistance = 0.0;
    self.totalTime = 0.0;
    self.maxRank = 99;
    self.points = [];
    self.routing = aRouting;
    if (self.hasAFirstLatLon(aPointArray)) {
      self.points = aPointArray;
      self.renderRouting();
    }
    self.observeGeonameChanges();
    self.manageCocoonEvents();
    self.observeAndGetRouteInfo();
  }

  self.observeGeonameChanges = function() {
    $('.trip_points_lon input').change(self.updateOrCreatePoint);
  }

  self.manageCocoonEvents = function() {
    $('#steps')
      .on('cocoon:after-insert', function(e, el) {
        $(el).find('.trip_points_lon input:first').change(self.updateOrCreatePoint);
        self.reorderSteps();
      })
      .on("cocoon:before-remove", function(e, el) {
        self.deletedRank = parseInt($(el).find('.trip_points_rank input:first').val());
      })
      .on("cocoon:after-remove", function(e, el) {
        self.removePointAtIndex(self.deletedRank);
        self.reorderSteps();
      });
  }

  self.updateOrCreatePoint = function() {
    var lon = parseFloat($(this).val());
    var lat = parseFloat($(this).parent().siblings('.trip_points_lat:first').find('input:first').val());
    var kind = $(this).parent().siblings('.trip_points_kind:first').find('input:first').val();
    var rank = parseInt($(this).parent().siblings('.trip_points_rank:first').find('input:first').val());
    var point = new Point(lat, lon, rank, kind);
    self.points[point.rank] = point.arrayValue();
    console.log(self.points);
    self.renderRouting();
  }

  self.removePointAtIndex = function(index) {
    if (index === self.maxRank ) {
      self.points[index] = null;
    } else {
      self.points.splice(index, 1);
    }
    self.renderRouting();
  }

  self.reorderSteps = function() {
    $('#steps .nested-fields').each(function(index, value) {
      var newIndex = parseInt(index) + 1;
      $(this).find('.trip_points_city label:first').text('Étape '+ newIndex);
      $(this).find('.trip_points_rank input:first').val(newIndex);
    });
  }

  // rendering and routing methods

  self.renderRouting = function() {
    self.routing.setWaypoints(self.cloneAndTrimArray());
    self.routing.route();
  }

  self.observeAndGetRouteInfo = function() {
    self.routing.on('routesfound', function (e) {
      self.totalDistance = e.routes[0].summary.totalDistance;
      self.totalTime = e.routes[0].summary.totalTime;
      $("#trip_total_distance").val(self.totalDistance);
      $("#trip_total_time").val(self.totalTime);
      $("#distance_and_time").text(metersToKmString(self.totalDistance) + " km - " + secondsToStringFR(self.totalTime))
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


var Point = function(lat, lon, rank, kind) {
  this.lat = lat;
  this.lon = lon;
  this.rank = rank;
  this.kind = kind;
  this.arrayValue = function() {
    return [this.lat, this.lon];
  }
}

// Util functions

function isFloat(n){
  return Number(n) === n && n % 1 !== 0;
}

function secondsToStringFR(seconds)
{
  var sentence = "";
  var numyears = Math.floor(seconds / 31536000);
  var numdays = Math.floor((seconds % 31536000) / 86400);
  var numhours = Math.floor(((seconds % 31536000) % 86400) / 3600);
  var numminutes = Math.floor((((seconds % 31536000) % 86400) % 3600) / 60);
  var numseconds = (((seconds % 31536000) % 86400) % 3600) % 60;
  if (numyears > 0)
    var sentence = sentence + numyears + " ans ";
  if (numdays > 0)
    var sentence = sentence + numdays + " jours ";
  if (numhours > 0)
    var sentence = sentence + numhours + " heures ";
  if (numminutes > 0)
    var sentence = sentence + numminutes + " minutes ";
  return sentence;
}

function metersToKmString(meters) {
  return Math.round( (meters / 1000) * 10 ) / 10;
}

