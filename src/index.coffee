#import Contentful from 'contentful-ui-extensions-sdk'
Contentful = require('contentful-ui-extensions-sdk')
import Style from 'contentful-ui-extensions-sdk/dist/cf-extension.css'
import geocoder from './geocoder.coffee'
import Vue from 'vue'

window.widget = new Vue(
    el: '#widget'
    data:
        query: ''
        location: {}
    methods:
        geocode: (query) -> 
            geocoder.geocode(query, ['es', 'en', 'fr', 'de'])
                .then (location) => 
                    console.log 'location', location
                    this.location = location
                .catch (err) => console.warn 'HORROR', err
)

console.log 'content', Contentful
#When UI Extensions SDK is loaded the callback will be executed.
Contentful.init (extensionsApi) ->
    #"extensionsApi" is providing an interface documented here:
    #https://github.com/contentful/ui-extensions-sdk/blob/master/docs/ui-extensions-sdk-frontend.md

    #Automatically adjust UI Extension size in the Web App.
    extensionsApi.window.startAutoResizer()
    console.log('init', extensionsApi.fields)
    # inputEl = document.querySelector('.cf-form-input')

    # # The field this UI Extension is assigned to.
    # field = extensionsApi.field

    # document.querySelector('.instance-param-value').appendChild(document.createTextNode(extensionsApi.parameters.instance.exampleParameter))
    # document.querySelector('.installation-param-value').appendChild(document.createTextNode(extensionsApi.parameters.installation.exampleParameter))


    # #Callback for changes of the field value.
    # detachValueChangeHandler = field.onValueChanged(valueChangeHandler)
    # #Handle keyboard input.
    # inputEl.addEventListener('input', keyboardInputHandler)
    # #Handle DOM "onbeforeunload" event.
    # window.addEventListener('onbeforeunload', unloadHandler)

    # #Handler for external field value changes (e.g. when multiple authors are working on the same entry).
    # valueChangeHandler = (value) -> inputEl.value = value or ''

    # #Event handler for keyboard input.
    # keyboardInputHandler = () ->
    #     value = inputEl.value
    #     if (typeof value isnt 'string' or value is '')
    #         field.removeValue()
    #     else
    #         field.setValue(value)

    # #Event handler for window unload.
    # unloadHandler = () ->
    #     window.removeEventListener('onbeforeunload', unloadHandler);
    #     inputEl.removeEventListener('input', keyboardInputHandler);
    #     detachValueChangeHandler();