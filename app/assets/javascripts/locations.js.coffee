@init_location_map = (bmap) ->
  @map = new BMap.Map bmap
  @map.enableScrollWheelZoom
  @map.addControl(new BMap.NavigationControl())
  #point = new BMap.Point lng, lat
  #map.centerAndZoom point, 16
  #marker1 = new BMap.Marker new BMap.Point(lng, lat)
  #map.addOverlay(marker1)
@locations_markers = []
@init_locations_markers = (locations) ->
  for index, l of locations
    marker = get_location_marker(l)
    @locations_markers.push(marker)
  @locations_markers

@get_point = (lat, lng) ->
  new BMap.Point(lng, lat)

@point_to_marker = (point) ->
  new BMap.Marker(point)

@get_marker = (lat, lng) ->
  new BMap.Marker(
    new get_point(lat, lng)
  )

@get_location_marker = (l) ->
  get_marker(l.lat, l.lon)


@init_location_info = (marker, html) ->
  info = new BMap.InfoWindow(html)
  marker.addEventListener 'click', () -> this.openInfoWindow(info)

@init_locations = (bmap, locations) ->
  @init_location_map(bmap)
  @init_locations_markers(locations)

@add_location = () ->
  @loc_marker = new BMap.Marker(@map.getCenter())
  map.addOverlay(@loc_marker)
  @loc_marker.enableDragging()

@post_location = (marker, token) ->
  point = marker.getPosition()
  $.post('/locations.js', {'authenticity_token': token, 'location[lat]': point.lat.toString(), 'location[lng]': point.lon.toString() }, (data) -> eval(data))
