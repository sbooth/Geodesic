# Geodesic

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsbooth%2FGeodesic%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/sbooth/Geodesic)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsbooth%2FGeodesic%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/sbooth/Geodesic)

`CLLocationCoordinate2D` extensions for solving geodesic problems on an ellipsoid model of the Earth.

```swift
let lax = CLLocationCoordinate2D(latitude: 33.9424964, longitude: -118.4080486)
let jfk = CLLocationCoordinate2D(latitude: 40.6399278, longitude: -73.7786925)
let distance = lax.distanceTo(jfk)
// distance is approx. 3,982,961 m
```
## License

Geodesic is released under the [MIT License](https://github.com/sbooth/Geodesic/blob/main/LICENSE.txt).
