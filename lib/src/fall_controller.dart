/// Controller class to manage and update particle fall parameters.
class FallController {
  int totalParticles;
  double particleFallSpeed;
  double particleSize;
  double particleRotationSpeed;
  double particleWindSpeed;

  /// Callback function that is triggered when any of the parameters are updated.
  /// The function accepts the following optional parameters:
  /// - totalObjects: the total number of particles.
  /// - speed: the speed at which the particles fall.
  /// - particleSize: the size of the particles.
  /// - windSpeed: the speed at which the particles are affected by wind.
  /// - rotationSpeed: the speed at which the particles rotate.
  Function({
    int? totalObjects,
    double? speed,
    double? particleSize,
    double? windSpeed,
    double? rotationSpeed,
  })? _onUpdate;

  /// Constructor to initialize the `FallController` with optional parameters.
  ///
  /// Parameters:
  /// - `totalParticles`: The total number of particles (default is 40).
  /// - `particleFallSpeed`: The speed at which the particles fall (default is 0.05).
  /// - `particleSize`: The size of each particle (default is 30.0).
  /// - `particleRotationSpeed`: The rotation speed of the particles (default is 0.02).
  /// - `particleWindSpeed`: The wind speed affecting the particles (default is 1.0).
  FallController({
    this.totalParticles = 40,
    this.particleFallSpeed = 0.05,
    this.particleSize = 30.0,
    this.particleRotationSpeed = 0.02,
    this.particleWindSpeed = 1.0,
  });

  /// Private method to notify the update callback with the new values.
  ///
  /// Parameters:
  /// - `totalObjects`: The updated total number of particles.
  /// - `speed`: The updated fall speed of the particles.
  /// - `particleSize`: The updated size of the particles.
  /// - `windSpeed`: The updated wind speed affecting the particles.
  /// - `rotationSpeed`: The updated rotation speed of the particles.
  void _notifyUpdate({
    int? totalObjects,
    double? speed,
    double? particleSize,
    double? windSpeed,
    double? rotationSpeed,
  }) {
    if (_onUpdate != null) {
      _onUpdate!(
        totalObjects: totalObjects,
        speed: speed,
        particleSize: particleSize,
        windSpeed: windSpeed,
        rotationSpeed: rotationSpeed,
      );
    }
  }

  /// Method to update the total number of particles.
  ///
  /// Parameters:
  /// - `newTotal`: The new total number of particles.
  void updateTotalParticles(int newTotal) {
    totalParticles = newTotal;
    _notifyUpdate(totalObjects: totalParticles);
  }

  /// Method to update the fall speed of the particles.
  ///
  /// Parameters:
  /// - `newSpeed`: The new speed at which the particles fall.
  void updateParticleFallSpeed(double newSpeed) {
    particleFallSpeed = newSpeed;
    _notifyUpdate(speed: particleFallSpeed);
  }

  /// Method to update the size of the particles.
  ///
  /// Parameters:
  /// - `newSize`: The new size of the particles.
  void updateParticleSize(double newSize) {
    particleSize = newSize;
    _notifyUpdate(particleSize: particleSize);
  }

  /// Method to update the wind speed affecting the particles.
  ///
  /// Parameters:
  /// - `newWindSpeed`: The new wind speed affecting the particles.
  void updateParticleWindSpeed(double newWindSpeed) {
    particleWindSpeed = newWindSpeed;
    _notifyUpdate(windSpeed: particleWindSpeed);
  }

  /// Method to update the rotation speed of the particles.
  ///
  /// Parameters:
  /// - `newRotationSpeed`: The new rotation speed of the particles.
  void updateParticleRotationSpeed(double newRotationSpeed) {
    particleRotationSpeed = newRotationSpeed;
    _notifyUpdate(rotationSpeed: particleRotationSpeed);
  }

  /// Setter to assign the callback function for updates.
  ///
  /// The callback function will be invoked whenever any of the parameters are updated.
  set onUpdate(
      Function({
        int? totalObjects,
        double? speed,
        double? particleSize,
        double? windSpeed,
        double? rotationSpeed,
      })? callback) {
    _onUpdate = callback;
  }
}
