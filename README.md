# Geodesic

`CLLocationCoordinate2D` extensions for geodesic calculations.

## Usage

```swift
let lax = CLLocationCoordinate2D(latitude: 33.9424964, longitude: -118.4080486)
let jfk = CLLocationCoordinate2D(latitude: 40.6399278, longitude: -73.7786925)
let distance = lax.distanceTo(jfk)
// distance is approx. 3,982,961 m
```

## Cocoapods

This podspec still needs to be merged and published, via:
https://guides.cocoapods.org/making/making-a-cocoapod.html#release


Until then, the Geodesic Swift wrapper needs to know how to find the C-based CGeodesic framework, so you will need to preface the path to that framework as below:

```
    pod 'CGeodesic', :git => 'https://github.com/sbooth/CGeodesic'
    pod 'Geodesic', :git => 'https://github.com/sbooth/Geodesic'
```

## License

Geodesic is released under the [MIT License](https://github.com/sbooth/Geodesic/blob/main/LICENSE.txt).
