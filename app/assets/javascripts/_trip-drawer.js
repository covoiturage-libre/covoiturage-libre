// Util functions

function equalPointArray(a1, a2) {
  // check n x 2 arrays for equality
  if (a1.length !== a2.length) {
    return false;
  }
  var i = a1.length;
  while (i--) {
    if (a1[i][0] !== a2[i][0] || a1[i][1] !== a2[i][1]) {
      return false;
    }
  }
  return true;
}

function numberAppendString(num, string) {
  if (num > 0) {
    return num + string;
  }
  return "";
}

function secondsToStringFR(seconds) {
  var numyears = Math.floor(seconds / 31536000);
  var numdays = Math.floor((seconds % 31536000) / 86400);
  var numhours = Math.floor(((seconds % 31536000) % 86400) / 3600);
  var numminutes = Math.floor((((seconds % 31536000) % 86400) % 3600) / 60);
  var numseconds = (((seconds % 31536000) % 86400) % 3600) % 60;
  
  var sentence = "";
  sentence = sentence + numberAppendString(numyears, " ans ");
  sentence = sentence + numberAppendString(numdays, " jours ");
  sentence = sentence + numberAppendString(numhours, " heures ");
  sentence = sentence + numberAppendString(numminutes, " minutes ");
  
  return sentence;
}

function metersToKmString(meters) {
  return Math.round( (meters / 1000) * 10 ) / 10;
}

var Point = function(lat, lon, rank, kind) {
  this.lat = lat;
  this.lon = lon;
  this.rank = rank;
  this.kind = kind;
  this.arrayValue = function() {
    return [this.lat, this.lon];
  };
};

var TripDrawing = function() {
  var self = this;

  self.init = function(aRouting, aPointArray) {
    self.totalDistance = 0.0;
    self.totalTime = 0.0;
    // this is also defined in the model
    self.maxRank = 99;
    // trip is passing by those points
    self.points = [];
    // to check for changes
    self.lastPoints = [];
    self.routing = aRouting;
    if (self.hasAFirstLatLon(aPointArray)) {
      self.points = aPointArray;
      self.renderRouting();
    }
    self.observeGeonameChanges();
    self.manageCocoonEvents();
    self.observeAndGetRouteInfo();
  };

  self.observeGeonameChanges = function() {
    $(".trip_points_lon input").change(self.reorderSteps);
  };

  self.manageCocoonEvents = function() {
    $("#steps")
      .on("cocoon:after-insert", function(e, el) {
        $(el).find(".trip_points_lon input:first").change(self.reorderSteps);
        self.reorderSteps();
      })
      .on("cocoon:after-remove", function(e, el) {
        self.reorderSteps();
      })
      .on("sortupdate", function(e, el) {
        self.reorderSteps();
      });
  };

  self.updateOrCreatePoint = function() {
    var lon = parseFloat($(this).val());
    var lat = parseFloat($(this).parent().siblings(
      ".trip_points_lat:first").find("input:first").val());
    if (!isNaN(lon) && !isNaN(lat)) {
      var kind = $(this).parent().siblings(
        ".trip_points_kind:first").find("input:first").val();
      var rank = parseInt($(this).parent().siblings(
        ".trip_points_rank:first").find("input:first").val());
      var point = new Point(lat, lon, rank, kind);
      self.points[point.rank] = point.arrayValue();
    }
  };

  self.reorderSteps = function() {
    // Reset coordinates array
    self.points = [];
    // Explore start/end DOM and get coordinates
    $("#city_from").find(".trip_points_lon input:first").each(
      self.updateOrCreatePoint);
    $("#city_to").find(".trip_points_lon input:first").each(
      self.updateOrCreatePoint);
    // Explore DOM steps
    $("#steps .nested-fields").each(function(index, value) {
      var newIndex = parseInt(index) + 1;
      // Rename labels, update rank
      $(this).find(".step-nb:first").text(newIndex);
      $(this).find(".trip_points_rank input:first").val(newIndex);
      // Make coordinates list
      $(this).find(".trip_points_lon input:first").each(self.updateOrCreatePoint);
    });
    self.renderRouting();
  };

  // rendering and routing methods

  self.renderRouting = function() {
    // Check for changes before contacting osrm
    if (!self.equalArrays()) {
      // Keep copy of waypoints
      self.lastPoints = self.points.slice(0);
      self.routing.setWaypoints(self.cloneAndTrimArray());
      self.routing.route();
    }
  };

  self.observeAndGetRouteInfo = function() {
    self.routing.on("routesfound", function (e) {
      self.totalDistance = e.routes[0].summary.totalDistance;
      self.totalTime = e.routes[0].summary.totalTime;
      $("#trip_total_distance").val(self.totalDistance);
      $("#trip_total_time").val(self.totalTime);
      $("#distance_and_time").text(metersToKmString(self.totalDistance)
        + " km - " + secondsToStringFR(self.totalTime));
    });
  };

  // more or less "private" methods

  self.cloneAndTrimArray = function() {
    var copiedArray = self.points.slice(0);
    return copiedArray.filter(function(val) { return val !== null; });
  };
  
  self.equalArrays = function() {
    // make copies
    var a1 = self.points.slice(0);
    var a2 = self.lastPoints.slice(0);
    // trim copied sparse arrays
    a1 = a1.filter(function(val) { return val !== null; });
    a2 = a2.filter(function(val) { return val !== null; });
    // compare values
    return equalPointArray(a1, a2);
  }

  self.hasAFirstLatLon = function(anArray) {
    var result = true;
    if (anArray[0][0] === 0) { result = false; }
    if (anArray[0][1] === 0) { result = false; }
    return result;
  };

};
