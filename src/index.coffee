#import Contentful from 'contentful-ui-extensions-sdk'
Contentful = require('contentful-ui-extensions-sdk')
import cfStyle from 'contentful-ui-extensions-sdk/dist/cf-extension.css'
import Style from './style.css'
# import leaflet from 'leaflet'
import geocoder from './geocoder.coffee'

mymap = L.map('map').setView([51.505, -0.09], 13)

L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox.streets',
    accessToken: 'pk.eyJ1IjoibjRuMCIsImEiOiJjam45OXQ5ZHYwb3JjM3ZwaWZ2d2ZwMnNnIn0.e2D_4CHpVY5mFOFRJhTrcw'
}).addTo(mymap)

Contentful.init (ext) ->
    ext.window.startAutoResizer()

    locales = ext.locales.available

    input = document.getElementById('geo-query')
    button = document.getElementById('geo-btn')

    button.addEventListener 'click', ->
        query = input.value
        locales.map (locale) ->
            geocoder.geocode(query, locale.substring(0, 2))
                .then (location) => 
                    mymap.setView([location.lat, location.lng], 13)
                    console.log 'my map is doing great', location
                    input.value = location.address
                    Object.keys(location).forEach (key) ->
                        if field = ext.entry.fields[key]
                            field.setValue location[key], locale
                .catch (err) => console.warn 'HORROR', err

# input = document.getElementById('geo-query')
# button = document.getElementById('geo-btn')

# mymap = L.map('map').setView([51.505, -0.09], 13)

# L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
#     attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
#     maxZoom: 18,
#     id: 'mapbox.streets',
#     accessToken: 'pk.eyJ1IjoibjRuMCIsImEiOiJjam45OXQ5ZHYwb3JjM3ZwaWZ2d2ZwMnNnIn0.e2D_4CHpVY5mFOFRJhTrcw'
# }).addTo(mymap)

# button.addEventListener 'click', ->
#     query = input.value
#     ['en', 'es'].map (locale) ->
#         geocoder.geocode(query, locale.substring(0, 2))
#             .then (location) => 
#                 console.log 'tomasha', location
#                 console.log([location.lat, location.lng], 13)
#                 mymap.setView([location.lat, location.lng], 13)
#                 input.value = location.address
#                 # Object.keys(location).forEach (key) ->
#                 #     if field = ext.entry.fields[key]
#                 #         field.setValue location[key], locale
#             .catch (err) => console.warn 'HORROR', err