import '../features/cities/data/models/city_model.dart';

class MapsUtil {
  static String windy(CityModel city, {bool fullScreen = false}) {
    if (fullScreen) {
      return '''
      <iframe width="100%" height="100%" src="https://embed.windy.com/embed.html?lat=${city.latitude}&lon=${city.longitude}&detailLat=${city.latitude}&detailLon=${city.longitude}&zoom=4&overlay=wind&product=ecmwf&menu=&message=false&marker=true&calendar=now&pressure=&type=map&location=coordinates&detail=&metricWind=km%2Fh&metricTemp=%C2%B0C&radarRange=-1" frameborder="0"></iframe>
      ''';
    }

    return '''
  <iframe width="1100" height="900" src="https://embed.windy.com/embed2.html?lat=${city.latitude}&lon=${city.longitude}&detailLat=${city.latitude}&detailLon=${city.longitude}&width=1100&height=900&zoom=4&overlay=wind&product=ecmwf&menu=&message=false&marker=true&calendar=now&pressure=&type=map&location=coordinates&detail=&metricWind=km%2Fh&metricTemp=%C2%B0C&radarRange=-1" frameborder="-10"></iframe>
  ''';
  }

  static String rainViewer(CityModel city, {bool zoom = false}) {
    return """
  <!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" rel="stylesheet"/>
    <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
    <style type="text/css">
        li {
            list-style: none;
            display: inline-block;
        }
    </style>
</head>
<body>
<!--
<ul style="text-align:center; position: absolute;top: 0; left: 0; right: 0; height: 50px;">
    <li><input type="radio" name="kind" checked="checked" onchange="setKind('radar')">Radar (Past + Future) <input type="radio" name="kind" onchange="setKind('satellite')">Infrared Satellite</li>

    <li><input type="button" onclick="stop(); showFrame(animationPosition - 1); return;" value="&lt;" /></li>
    <li><input type="button" onclick="playStop();" value="Play / Stop" /></li>
    <li><input type="button" onclick="stop(); showFrame(animationPosition + 1); return;" value="&gt;" /></li>

    <li><select id="colors" onchange="setColors(); return;">
        <option value="0">Black and White Values</option>
        <option value="1">Original</option>
        <option value="2" selected="selected">Universal Blue</option>
        <option value="3">TITAN</option>
        <option value="4">The Weather Channel</option>
        <option value="5">Meteored</option>
        <option value="6">NEXRAD Level-III</option>
        <option value="7">RAINBOW @ SELEX-SI</option>
        <option value="8">Dark Sky</option>
    </select></li>
</ul>
 -->
<!-- <div id="timestamp" style="text-align:center; position: absolute;top: 50px; left: 0; right: 0; height: 80px;">FRAME TIME</div> -->

<div id="mapid" style="position: absolute; top: 0; left: 0; bottom: 0; right: 0;"></div>

<script>
    var map = L.map('mapid',{ zoomControl: $zoom }).setView([${city.latitude}, ${city.longitude}], 3);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attributions: 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors'
    }).addTo(map);

    /**
     * RainViewer radar animation part
     * @type {number[]}
     */
    var apiData = {};
    var mapFrames = [];
    var lastPastFramePosition = -1;
    var radarLayers = [];

    var optionKind = 'radar'; // can be 'radar' or 'satellite'

    var optionTileSize = 512; // can be 256 or 512.
    var optionColorScheme = 8; // from 0 to 8. Check the https://rainviewer.com/api/color-schemes.html for additional information
    var optionSmoothData = 1; // 0 - not smooth, 1 - smooth
    var optionSnowColors = 1; // 0 - do not show snow colors, 1 - show snow colors

    var animationPosition = 0;
    var animationTimer = true;

    var loadingTilesCount = 0;
    var loadedTilesCount = 0;

    function startLoadingTile() {
        loadingTilesCount++;
    }
    function finishLoadingTile() {
        // Delayed increase loaded count to prevent changing the layer before
        // it will be replaced by next
        setTimeout(function() { loadedTilesCount++; }, 250);
    }
    function isTilesLoading() {
        return loadingTilesCount > loadedTilesCount;
    }

    /**
     * Load all the available maps frames from RainViewer API
     */
    var apiRequest = new XMLHttpRequest();
    apiRequest.open("GET", "https://api.rainviewer.com/public/weather-maps.json", true);
    apiRequest.onload = function(e) {
        // store the API response for re-use purposes in memory
        apiData = JSON.parse(apiRequest.response);
        initialize(apiData, optionKind);
    };
    apiRequest.send();

    /**
     * Initialize internal data from the API response and options
     */
    function initialize(api, kind) {
        // remove all already added tiled layers
        for (var i in radarLayers) {
            map.removeLayer(radarLayers[i]);
        }
        mapFrames = [];
        radarLayers = [];
        animationPosition = 0;

        if (!api) {
            return;
        }
        if (kind == 'satellite' && api.satellite && api.satellite.infrared) {
            mapFrames = api.satellite.infrared;

            lastPastFramePosition = api.satellite.infrared.length - 1;
            showFrame(lastPastFramePosition, true);
        }
        else if (api.radar && api.radar.past) {
            mapFrames = api.radar.past;
            if (api.radar.nowcast) {
                mapFrames = mapFrames.concat(api.radar.nowcast);
            }

            // show the last "past" frame
            lastPastFramePosition = api.radar.past.length - 1;
            showFrame(lastPastFramePosition, true);
        }
        play();
    }

    /**
     * Animation functions
     * @param path - Path to the XYZ tile
     */
    function addLayer(frame) {
        if (!radarLayers[frame.path]) {
            var colorScheme = optionKind == 'satellite' ? 0 : optionColorScheme;
            var smooth = optionKind == 'satellite' ? 0 : optionSmoothData;
            var snow = optionKind == 'satellite' ? 0 : optionSnowColors;

            var source = new L.TileLayer(apiData.host + frame.path + '/' + optionTileSize + '/{z}/{x}/{y}/' + colorScheme + '/' + smooth + '_' + snow + '.png', {
                tileSize: 256,
                opacity: 0.01,
                zIndex: frame.time
            });

            // Track layer loading state to not display the overlay
            // before it will completelly loads
            source.on('loading', startLoadingTile);
            source.on('load', finishLoadingTile);
            source.on('remove', finishLoadingTile);


            radarLayers[frame.path] = source;
        }
        if (!map.hasLayer(radarLayers[frame.path])) {
            map.addLayer(radarLayers[frame.path]);
        }
    }

    /**
     * Display particular frame of animation for the @position
     * If preloadOnly parameter is set to true, the frame layer only adds for the tiles preloading purpose
     * @param position
     * @param preloadOnly
     * @param force - display layer immediatelly
     */
    function changeRadarPosition(position, preloadOnly, force) {
        while (position >= mapFrames.length) {
            position -= mapFrames.length;
        }
        while (position < 0) {
            position += mapFrames.length;
        }

        var currentFrame = mapFrames[animationPosition];
        var nextFrame = mapFrames[position];

        addLayer(nextFrame);

        // Quit if this call is for preloading only by design
        // or some times still loading in background
        if (preloadOnly || (isTilesLoading() && !force)) {
            return;
        }

        animationPosition = position;

        if (radarLayers[currentFrame.path]) {
            radarLayers[currentFrame.path].setOpacity(0);
        }
        radarLayers[nextFrame.path].setOpacity(100);


        // var pastOrForecast = nextFrame.time > Date.now() / 1000 ? 'FORECAST' : 'PAST';

        // document.getElementById("timestamp").innerHTML = pastOrForecast + ': ' + (new Date(nextFrame.time * 1000)).toString();
    }

    /**
     * Check avialability and show particular frame position from the timestamps list
     */
    function showFrame(nextPosition, force) {
        var preloadingDirection = nextPosition - animationPosition > 0 ? 1 : -1;

        changeRadarPosition(nextPosition, false, force);

        // preload next next frame (typically, +1 frame)
        // if don't do that, the animation will be blinking at the first loop
        changeRadarPosition(nextPosition + preloadingDirection, true);
    }

    /**
     * Stop the animation
     * Check if the animation timeout is set and clear it.
     */
    function stop() {
        if (animationTimer) {
            clearTimeout(animationTimer);
            animationTimer = false;
            return true;
        }
        return false;
    }

    function play() {
        showFrame(animationPosition + 1);

        // Main animation driver. Run this function every 500 ms
        animationTimer = setTimeout(play, 500);
    }

    function playStop() {
        if (!stop()) {
            play();
        }
    }

    /**
     * Change map options
     */
    function setKind(kind) {
        optionKind = kind;
        initialize(apiData, optionKind);
    }


    function setColors() {
        var e = document.getElementById('colors');
        optionColorScheme = e.options[e.selectedIndex].value;
        initialize(apiData, optionKind);
    }


    /**
     * Handle arrow keys for navigation between next  prev frames
     */
    document.onkeydown = function (e) {
        e = e || window.event;
        switch (e.which || e.keyCode) {
            case 37: // left
                stop();
                showFrame(animationPosition - 1, true);
                break;

            case 39: // right
                stop();
                showFrame(animationPosition + 1, true);
                break;

            default:
                return; // exit this handler for other keys
        }
        e.preventDefault();
        return false;
    }
</script>

</body>
</html>

  """;
  }

  static String rainViewerWithGoogle(CityModel city, {bool zoom = false}) {
    return """
    <!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" rel="stylesheet"/>
    <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
    <style type="text/css">
        li {
            list-style: none;
            display: inline-block;
        }
    </style>
</head>
<body>

<!-- <ul style="text-align:center; position: absolute;top: 0; left: 0; right: 0; height: 50px;">
    <li><input type="radio" name="kind" checked="checked" onchange="setKind('radar')">Radar (Past + Future) <input type="radio" name="kind" onchange="setKind('satellite')">Infrared Satellite</li>

    <li><input type="button" onclick="stop(); showFrame(animationPosition - 1); return;" value="&lt;" /></li>
    <li><input type="button" onclick="playStop();" value="Play / Stop" /></li>
    <li><input type="button" onclick="stop(); showFrame(animationPosition + 1); return;" value="&gt;" /></li>

    <li><select id="colors" onchange="setColors(); return;">
        <option value="0">Black and White Values</option>
        <option value="1">Original</option>
        <option value="2" selected="selected">Universal Blue</option>
        <option value="3">TITAN</option>
        <option value="4">The Weather Channel</option>
        <option value="5">Meteored</option>
        <option value="6">NEXRAD Level-III</option>
        <option value="7">RAINBOW @ SELEX-SI</option>
        <option value="8">Dark Sky</option>
    </select></li>
</ul> -->

<!-- <div id="timestamp" style="text-align:center; position: absolute;top: 50px; left: 0; right: 0; height: 80px;">FRAME TIME</div> -->

<div id="mapid" style="position: absolute; top: 0; left: 0; bottom: 0; right: 0;"></div>

<script>
    var map;
    function initMap() {
    
        map = new google.maps.Map(document.getElementById('mapid'), {
          center: {lat: ${city.latitude}, lng: ${city.longitude}},
          zoom: 5,
          styles: styles,
          gestureHandling: "auto",
          zoomControl: false,
          streetViewControl: false,
          mapTypeControl: false,
          disableDefaultUI: true,
          keyboardShortcuts: false,
        });
        
        // set marker 
        var marker = new google.maps.Marker({
            position: {lat: ${city.latitude}, lng: ${city.longitude}},
            map: map,
            title: '${city.name}',
            icon: {
                url: 'https://rasidweather.com/images/map-marker.svg',
                scaledSize: new google.maps.Size(30, 30),
               
                anchor: new google.maps.Point(15, 15),    
            },  
          });
          
    


        /**
         * Load actual radar animation frames timestamps from RainViewer API
         */
        var apiRequest = new XMLHttpRequest();
        apiRequest.open("GET", "https://api.rainviewer.com/public/weather-maps.json", true);
        apiRequest.onload = function(e) {
            // store the API response for re-use purposes in memory
            apiData = JSON.parse(apiRequest.response);
            initialize(apiData, optionKind);
        };
        apiRequest.send();
    }

    /**
     * RainViewer radar animation part
     * @type {number[]}
     */
    var apiData = {};
    var mapFrames = [];
    var lastPastFramePosition = -1;
    var radarLayers = [];

    var optionKind = 'radar'; // can be 'radar' or 'satellite'

    var optionTileSize = 256; // can be 256 or 512.
    var optionColorScheme = 2; // from 0 to 8. Check the https://rainviewer.com/api/color-schemes.html for additional information
    var optionSmoothData = 1; // 0 - not smooth, 1 - smooth
    var optionSnowColors = 1; // 0 - do not show snow colors, 1 - show snow colors

    var animationPosition = 0;
    var animationTimer = false;

    /**
     * Initialize internal data from the API response and options
     */
    function initialize(api, kind) {
        // remove all already added tiled layers
        map.overlayMapTypes.clear();

        mapFrames = [];
        radarLayers = [];
        animationPosition = 0;

        if (!api) {
            return;
        }
        if (kind == 'satellite' && api.satellite && api.satellite.infrared) {
            mapFrames = api.satellite.infrared;

            lastPastFramePosition = api.satellite.infrared.length - 1;
            showFrame(lastPastFramePosition);
        }
        else if (api.radar && api.radar.past) {
            mapFrames = api.radar.past;
            if (api.radar.nowcast) {
                mapFrames = mapFrames.concat(api.radar.nowcast);
            }

            // show the last "past" frame
            lastPastFramePosition = api.radar.past.length - 1;
            showFrame(lastPastFramePosition);
        }
    }

    /**
     * Animation functions
     * @param path - Path to the XYZ tile
     */
    function addLayer(frame) {
        if (!radarLayers[frame.path]) {
            var colorScheme = optionKind == 'satellite' ? 0 : optionColorScheme;
            var smooth = optionKind == 'satellite' ? 0 : optionSmoothData;
            var snow = optionKind == 'satellite' ? 0 : optionSnowColors;

            radarLayers[frame.path] = new google.maps.ImageMapType({
              getTileUrl: function(coord, zoom) {
                return [apiData.host + frame.path, optionTileSize,
                    zoom, coord.x, coord.y, colorScheme, smooth + '_' + snow + '.png'].join('/');
              },
              tileSize: new google.maps.Size(256, 256),
              opacity: 0.001,
            });
            map.overlayMapTypes.push(radarLayers[frame.path]);
        }
    }

    /**
     * Display particular frame of animation for the @position
     * If preloadOnly parameter is set to true, the frame layer only adds for the tiles preloading purpose
     * @param position
     * @param preloadOnly
     */
    function changeRadarPosition(position, preloadOnly) {
        while (position >= mapFrames.length) {
            position -= mapFrames.length;
        }
        while (position < 0) {
            position += mapFrames.length;
        }

        var currentFrame = mapFrames[animationPosition];
        var nextFrame = mapFrames[position];

        addLayer(nextFrame);

        if (preloadOnly) {
            return;
        }

        animationPosition = position;

        if (radarLayers[currentFrame.path]) {
            radarLayers[currentFrame.path].setOpacity(0);
        }
        radarLayers[nextFrame.path].setOpacity(100);


        // var pastOrForecast = nextFrame.time > Date.now() / 1000 ? 'FORECAST' : 'PAST';

        // document.getElementById("timestamp").innerHTML = pastOrForecast + ': ' + (new Date(nextFrame.time * 1000)).toString();
    }

    /**
     * Check avialability and show particular frame position from the timestamps list
     */
    function showFrame(nextPosition) {
        var preloadingDirection = nextPosition - animationPosition > 0 ? 1 : -1;

        changeRadarPosition(nextPosition);

        // preload next next frame (typically, +1 frame)
        // if don't do that, the animation will be blinking at the first loop
        changeRadarPosition(nextPosition + preloadingDirection, true);
    }

    /**
     * Stop the animation
     * Check if the animation timeout is set and clear it.
     */
    function stop() {
        if (animationTimer) {
            clearTimeout(animationTimer);
            animationTimer = false;
            return true;
        }
        return false;
    }

    function play() {
        showFrame(animationPosition + 1);

        // Main animation driver. Run this function every 500 ms
        animationTimer = setTimeout(play, 500);
    }

    function playStop() {
        if (!stop()) {
            play();
        }
    }

    /**
     * Change map options
     */
    function setKind(kind) {
        optionKind = kind;
        initialize(apiData, optionKind);
    }


    function setColors() {
        var e = document.getElementById('colors');
        optionColorScheme = e.options[e.selectedIndex].value;
        initialize(apiData, optionKind);
    }


    /**
     * Handle arrow keys for navigation between next  prev frames
     */
    document.onkeydown = function (e) {
        e = e || window.event;
        switch (e.which || e.keyCode) {
            case 37: // left
                stop();
                showFrame(animationPosition - 1);
                break;

            case 39: // right
                stop();
                showFrame(animationPosition + 1);
                break;

            default:
                return; // exit this handler for other keys
        }
        e.preventDefault();
        return false;
    }

   var styles =[
    {
        "featureType": "all",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "saturation": 36
            },
            {
                "color": "#000000"
            },
            {
                "lightness": 40
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#000000"
            },
            {
                "lightness": 16
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 17
            },
            {
                "weight": 1.2
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 25
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 21
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 17
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 29
            },
            {
                "weight": 0.2
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 18
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 16
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 19
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 17
            }
        ]
    }
]


</script>

<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBvQZuSothZVqt7UM1337uDT0ACRfkrueA&callback=initMap" async defer></script>

</body>
</html>

    """;
  }
}
