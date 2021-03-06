class trail extends Vec3D {
  Vec3D orientation;
  int strength = 255;

  trail(Vec3D p, Vec3D o) {
    super(p);
    orientation = o.copy();
    orientation = orientation.normalize();
  }

  void update() {
    strength = strength-5;
    render();
    if (strength<1) {
      flock.removeTrail(this);
    }
  }

  void render() {
    stroke(strength/2);
    strokeWeight(2);
    point(x, y, z);
  }
}