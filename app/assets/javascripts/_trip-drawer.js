// Util functions

function equalDouble(d1, d2) {
  // cheeck equality between two (1 x 2) arrays
  return (d1[0] === d2[0] && d1[1] === d2[1]);
}

function equalPointArray(a1, a2) {
  // check n x 2 arrays for equality
  if (a1.length === a2.length) {
    var i = a1.length;
    while (i--) {
      if (!equalDouble(a1[i], a2[i])) {
        return false;
      }
    }
    return true;
  }
  return false;
}

function numberAppendString(num, string) {
  if (num > 0) {
    return num + string;
  }
  return "";
}

function secondsToStringFR(seconds) {
  var numYears = Math.floor(seconds / 31536000);
  var numDays = Math.floor((seconds % 31536000) / 86400);
  var numHours = Math.floor(((seconds % 31536000) % 86400) / 3600);
  var numMinutes = Math.floor((((seconds % 31536000) % 86400) % 3600) / 60);
  var numSeconds = (((seconds % 31536000) % 86400) % 3600) % 60;
  
  var sentence = [];
  sentence.push(numberAppendString(numYears, " ans "));
  sentence.push(numberAppendString(numDays, " jours "));
  sentence.push(numberAppendString(numHours, " heures "));
  sentence.push(numberAppendString(numMinutes, " minutes "));
  
  return sentence.join("");
}

function metersToKmString(meters) {
  // Rounded to 1 decimal (decimeters)
  // metersToKmString(6789) = 6.8
  return String(Math.round( (meters / 1000) * 10 ) / 10);
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

  self.init = function(aRouting, aPointArray, maxRank) {
    self.totalDistance = 0.0;
    self.totalTime = 0.0;
    // depends on server side model point.rb
    // max nb of steps = maxRank - 1
    self.maxRank = maxRank;
    self.maxReached = false;
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
      .on("cocoon:before-insert", function(e, el) {
        self.maxReached = $("#steps .nested-fields").length > self.maxRank - 2;
      })
      .on("cocoon:after-insert", function(e, el) {
        if (!self.maxReached) {
          $(el).find(".trip_points_lon input:first").change(self.reorderSteps);
          self.reorderSteps();
        } else {
          $("#steps .nested-fields").last().remove();
        }
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
      var field = $(this);
      field.find(".step-nb:first").text(newIndex);
      field.find(".trip_points_rank input:first").val(newIndex);
      // Make coordinates list
      field.find(".trip_points_lon input:first").each(self.updateOrCreatePoint);
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
  };

  self.hasAFirstLatLon = function(anArray) {
    var result = true;
    if (anArray[0][0] === 0) { result = false; }
    if (anArray[0][1] === 0) { result = false; }
    return result;
  };

};
