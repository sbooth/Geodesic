# Geodesic

A `CLLocationCoordinate2D` extension for geodesic calculations.

```swift
let lax = CLLocationCoordinate2D(latitude: 33.9424964, longitude: -118.4080486)
let jfk = CLLocationCoordinate2D(latitude: 40.6399278, longitude: -73.7786925)
let distance = lax.distanceTo(jfk)
// distance is approx. 3,982,961 m
```
