exportDe
  queue = []
  # Amount of time (in milliseconds) to pause between each trip to the
  # Geocoding API, which places limits on frequency.
  queryPause = 250

  ###*
  # executeNext() - execute the next function in the queue. 
  #                  If a result is returned, fulfill the promise.
  #                  If we get an error, reject the promise (with message).
  #                  If we receive OVER_QUERY_LIMIT, increase interval and try again.
  ###

  executeNext = ->
    task = queue[0]
    url = 'http://maps.googleapis.com/maps/api/geocode/json?address=' + task.address + '&sensor=false&language=' + task.lang
    $http.get(url).success (data) ->
      if data and data.status == 'OK'
        result = data.results[0]
        location = 
          lat: result.geometry.location.lat
          lng: result.geometry.location.lng
          address: result.formatted_address
        i = 0
        while i < result.address_components.length
          addr = result.address_components[i]
          switch addr.types[0]
            when 'country'
              location.country = addr.short_name
            when 'administrative_area_level_1'
              location.region = addr.long_name
            when 'administrative_area_level_2'
              location.sub_region = addr.long_name
            when 'locality'
              location.city = addr.long_name
            when 'postal_code'
              location.postal_code = addr.long_name
          i++
        queue.shift()
        task.d.resolve location
        if queue.length
          $timeout executeNext, queryPause
      else
        queue.shift()
        task.d.resolve false
        if queue.length
          $timeout executeNext, queryPause
    return

  { locationForAddress: (address, lang) ->
    
    d = $q.defer()
    queue.push
      address: address
      lang: lang
      d: d
    if queue.length == 1
      executeNext()
    d.promise
 }