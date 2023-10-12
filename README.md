# Geodesic

`CLLocationCoordinate2D` extensions for solving geodesic problems on an ellipsoid model of the Earth.

```swift
let lax = CLLocationCoordinate2D(latitude: 33.9424964, longitude: -118.4080486)
let jfk = CLLocationCoordinate2D(latitude: 40.6399278, longitude: -73.7786925)
let distance = lax.distanceTo(jfk)
// distance is approx. 3,982,961 m
```

### Usage notes:
- Output azimuths are by default returned in the interval (-180, 180]. To use compass bearings [0-360), modify the Geodesic struct by run the following line **before** carrying out any calculations.
```swift
Geodesic.useCompassAzimuths = true
```


## License

Geodesic is released under the [MIT License](https://github.com/sbooth/Geodesic/blob/main/LICENSE.txt).
