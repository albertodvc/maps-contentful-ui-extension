
# import debounce from 'lodash/debounce'
import PromiseThrottle from 'promise-throttle'

promiseThrottle = new PromiseThrottle
	requestsPerSecond: 1
	promiseImplementation: Promise

geocode = (address, lang) ->
	url = 'https://nominatim.openstreetmap.org/search/' + address + '?format=json&addressdetails=1&accept-language=' + lang
	return fetch(url)
		.then (response) -> response.json()
		.then (data) => 
			if data and data.length
				return 
					lat: data[0].lat
					lng: data[0].lon
					country: data[0].address.country
					region: data[0].address.state
					sub_region: data[0].address.county
					city: data[0].address.city
					postal_code: data[0].address.postcode
			else
				throw new Error('Unknown error')

export default {
	geocode: (address, langs) ->
		Promise.all langs.map (lang) ->
			promiseThrottle.add => geocode address, lang
}