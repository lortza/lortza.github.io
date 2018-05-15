---
layout: post
title:  Implementing a Cities Autocomplete with the Google Places API in React
date:   2018-05-15
---

I recently built a [City Data React app](https://github.com/lortza/react_rails_api_city_data) which consumes a [separate Rails API](https://github.com/lortza/rails_api_integrator). The user inputs a US city, and in return gets local weather, events, new articles, and Flickr photos.

In the spirit of consistent input and a better user-experience, I wanted the location input field to be an autocomplete. I was surprised to discover that implementing one in vanilla Javascript was much easier than I expected.

## Autocomplete Using Vanilla Javascript

This implementation is based on code from [this handy tutorial](https://www.w3docs.com/learn-javascript/places-autocomplete.html).

```html
<!-- index.html -->

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- 1. Load the Google Places library -->
    <script src="https://maps.googleapis.com/maps/api/js?sensor=false&libraries=places&language=en"></script>

  </head>
  <body>

    <!-- 2. Insert and input tag with a useful id -->
    <input type="text" id="autocomplete"/>

    <!-- 3. Use this script to call the Google Places API -->
    <script>
      var input = document.getElementById('autocomplete')

      // Limit the results to just Cities in the US
      var options = {
        types: ['(cities)'],
        componentRestrictions: {country: "us"}
       }
      var autocomplete = new google.maps.places.Autocomplete(input, options)

      google.maps.event.addListener(autocomplete, 'place_changed', function(){
         var place = autocomplete.getPlace()
      })
    </script>

  </body>
</html>
```

I mean, that just *worked* right out of the box.

But my project is in React. So this vanilla Javascript approach didn't work no matter how much I tried to coerce it into playing nicely in my `<ReportForm />` component.

Thankfully, there's an npm package for that!

## Autocomplete in React

This is more complicated than the vanilla javascript implementation above, but accomplishable! At a high level, this is how it works: the React app input field is a component that hits the Google Places API. The form then takes this result and passes it in a call to the Rails API.

More specifically:

- The user starts typing in the location input field
- The input field component hits the Google API to return location suggestions
- The user selects one of those suggestions
- The user submits the form
- The form data is used to hit the Rails API
- React displays the results from the Rails API data

The React App Architecture looks like this:

```
App.js                    ← Houses the whole app
- ReportForm              ← Submits the form and formats user input
  - LocationSearchInput   ← Interacts with the Google Places API
    - PlacesAutocomplete  ← Renders the input field
- Report                  ← Interacts with the Rails API
  - Weather (etc)         ← Displays the data
```

### Install the npm package

```
npm install --save react-places-autocomplete
```

The readme is full of great configuration information: [https://github.com/kenny-hibino/react-places-autocomplete](https://github.com/kenny-hibino/react-places-autocomplete).

### Add the Google Places library to your index.html

```html
<!-- public/index.html -->
<head>
  ...
  <!-- As of 5/2018 this non-api-key version is working. -->
  <script src="https://maps.googleapis.com/maps/api/js?sensor=false&libraries=places&language=en"></script>

  <!-- You may need to switch to the api-key version -->
  <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places"></script>
</head>
```

### Build the LocationSearchInput Component

Create a file called `src/components/LocationSearchInput.js`. The [npm package readme](https://github.com/kenny-hibino/react-places-autocomplete) provides fully-functional starter code. This version below has a couple of tweaks to meet the needs of my project.

```js
// src/components/LocationSearchInput.js

import React from 'react'
import PlacesAutocomplete, { geocodeByAddress } from 'react-places-autocomplete'

class LocationSearchInput extends React.Component {
  constructor(props) {
    super(props);
    this.state = { address: '' }
  }

  handleChange = (address) => {
    this.setState({ address })
  }

  // When the user selects an autocomplete suggestion...
  handleSelect = (address) => {
    // Pull in the setFormLocation function from the parent ReportForm
    const setFormLocation = this.props.setFormLocation

    geocodeByAddress(address)
      .then(function(results){
        // Set the location in the parent ReportFrom
        setFormLocation(results[0].formatted_address)
      })
      .catch(error => console.error('Error', error))
  }

  render() {
    const renderInput = ({ getInputProps, getSuggestionItemProps, suggestions }) => (
      <div className="autocomplete-root">
        <input className="form-control" {...getInputProps()} />
        <div className="autocomplete-dropdown-container">
          {suggestions.map(suggestion => (
            <!-- Add a style of "suggestion" to the suggested locations -->
            <div {...getSuggestionItemProps(suggestion)} className="suggestion">
              <span>{suggestion.description}</span>
            </div>
          ))}
        </div>
      </div>
    );

    // Limit the suggestions to show only cities in the US
    const searchOptions = {
      types: ['(cities)'],
      componentRestrictions: {country: "us"}
     }

    return (
      <PlacesAutocomplete
        value={this.state.address}
        onChange={this.handleChange}
        onSelect={this.handleSelect}
        // Pass the search options prop
        searchOptions={searchOptions}
      >
        {renderInput}
      </PlacesAutocomplete>
    );
  }
}

export default LocationSearchInput
```

### Write the CSS for the Autocomplete Suggestion Text
```css
/* src/App.css */

.suggestion {
  background-color: #f1f1f1;
  color: gray;
  font-size: 80%;
  padding: 0.25em 0.7em;
}
```

### Add the LocationSearchInput to the ReportForm

The `<ReportForm />` component ties together the user input acquired by the autocomplete input field and the `<App />` component. The biggest challenge I had in implementing this feature was getting the selected autocomplete data into the function that handles the form submission so that it could be passed on to the Rails API call. I solved it by creating a `state` in the `<ReportForm />`. `state` turned out to be a helpful middle ground, tying these to functions together.

```js
// src/components/ReportForm.js

import React from "react"
// import the LocationSearchInput
import LocationSearchInput from './LocationSearchInput'

class ReportForm extends React.Component {
  // Set up a state to help pass data back to the parent App component
  constructor(){
    super()
    this.state = {
      cityLoc: '',
      stateLoc: ''
    }
  }

  // Get the info from the LocationSearchInput component and save
  // it to state here in ReportForm.
  setFormLocation = (googleLocation) => {
    // The Google result comes back as a comma-separated string:
    // "Austin, TX, USA". Parse it into usable data.
    let parsedLoc = googleLocation.split(', ')
    this.setState({
      cityLoc: parsedLoc[0],
      stateLoc: parsedLoc[1]
    })
  }

  // Process the form submission with the info that was just
  // saved to ReportForm.state
  createReportLocation = (e) => {
    e.preventDefault()
    const inputLocation = {
      cityLoc: this.state.cityLoc,
      stateLoc: this.state.stateLoc
    }
    // Call the parent App component's setReportLocation function, which
    // sets App.state. so that all other components will have access to it.
    this.props.setReportLocation(inputLocation)
  }

  // Render the form
  render(){
    return (
      // Set the form submission handler to createReportLocation
      <form onSubmit={this.createReportLocation}  className="card card-body mb-3">
        <div className="row">
          <div className="col-sm-12">
            <p>Enter a US City</p>
          </div>
        </div>

        <div className="row">
          <div className="col-sm-10">
            // Pass the setFormLocation function as a prop to be called
            // in the LocationSearchInput component.
            <LocationSearchInput setFormLocation={this.setFormLocation}/>
          </div>

          <div className="col-sm-2">
            <button type="submit" className="btn btn-xs btn-primary">Submit</button>
          </div>
        </div>
      </form>
    )
  }
}

export default ReportForm
```

Now that the autocomplete information has made its way to the topmost component, the `<App />` component, everything becomes business as usual. The `<Report />` component receives the location information from `<App />` after the call to the Rails API.

```js
// src/components/App.js

class App extends Component {
  ...
  // Sets the state of App.js and is called from within the ReportForm
  setReportLocation = (location) => {
    this.setState({
      cityLoc: location.cityLoc,
      stateLoc: location.stateLoc
    })
    // Call the function to get the Rails API Data,
    // passing it this location information
    this.getReportData(location)
  }
    ...
    // Pass on the report data to the Report
    {reportData ? <Report data={reportData} cityLoc={cityLoc} stateLoc={stateLoc}/> : ""}
    ...
}

export default App;

```

That wraps up the Google Places location autocomplete in React inplementaion. To see the full app, check out [the repo](https://github.com/lortza/react_rails_api_city_data).
