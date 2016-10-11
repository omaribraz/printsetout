class Boid extends Vec3D {
  Vec3D vel;
  Vec3D acc;
  float r;
  float maxforce;   
  float maxspeed;  

  Boid(Vec3D pos, Vec3D _vel) {
    super (pos);
    vel = _vel;
    acc = new Vec3D(0, 0, 0);
    r = 7.0;
    maxspeed = 2;
    maxforce = 0.07;
  }


  void run() {
    flock();
    //if (frameCount%1==0) trail();
    update();
    borders();
    render();
  }

  void applyForce(Vec3D force) {
    acc.addSelf(force);
  }

  void checkMesh() {



    //println(cave.intersectsRay( new Ray3D(this, new Vec3D(0, 0, 1))));
    //Ray3D r = new Ray3D(this, vel);
    // gfx.ray(r,100);

    // ray.toLine3DWithPointAtDistance(100);
    // println(cave.intersectsRay(ray));
    //IsectData3D isec = cave.getIntersectionData();
    //Vec3D a1 = isec.pos.copy();
    //stroke(255,0,0);
    //strokeWeight(6);
    //point(a1.x,a1.y,a1.z);
  }


  void flock() {

    List boidpos = null;

    boidpos = boidoctree.getPointsWithinSphere(this.copy(), 120);

    if (boidpos!=null) {

      Vec3D sep = separate(boidpos);   
      Vec3D ali = align(boidpos);      
      Vec3D coh = cohesion(boidpos);   
      //Vec3D stig = seektrail(flock.trailPop);

      sep.scaleSelf(3.0);
      ali.scaleSelf(0.6);
      coh.scaleSelf(0.1);
      //stig.scaleSelf(0.5);

      applyForce(sep);
      applyForce(ali);
      applyForce(coh);
      //applyForce(stig);
    }
  }


  void update() {

    vel.addSelf(acc);
    vel.limit(maxspeed);
    this.addSelf(vel);
    //super.x = pos.x;
    //super.y = pos.y;
    //super.z = pos.z;
    acc.scaleSelf(0);
  }

  Vec3D seek(Vec3D target) {
    Vec3D desired = target.subSelf(this);  
    desired.normalize();
    desired.scaleSelf(maxspeed);
    Vec3D steer = desired.subSelf(vel);
    steer.limit(maxforce);  
    return steer;
  }

  void trail() {
    trail tr = new trail(this.copy(), vel.copy());
    flock.addTrail(tr);
  }

  void render() {
    float theta = vel.headingXY() + radians(90);

    stroke(255);
    pushMatrix();
    translate(x, y, z);
    rotate(theta);
    obj.setFill(color(255, 255, 255));
    obj.setStroke(100);
    obj.scale(1);
    shape(obj);
    popMatrix();
  }

  // Separation
  Vec3D separate (List<Boid> boids) {
    float desiredseparation = 45.0f*45.0f;
    Vec3D steer = new Vec3D(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = this.distanceToSquared(other);
      if ((d > 0) && (d < desiredseparation)) {
        Vec3D diff = this.sub(other);
        diff.normalize();
        diff.scaleSelf(1/d);    
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.scaleSelf(1/(float)count);
    }
    if (steer.magnitude() > 0) {
      steer.normalize();
      steer.scaleSelf(maxspeed);
      steer.subSelf(vel);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  Vec3D align (List<Boid> boids) {
    float neighbordist = 70.0f*70.0f;
    Vec3D sum = new Vec3D(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = this.distanceToSquared(other);
      if ((d > 0) && (d < neighbordist)) {
        sum.addSelf(other.vel);
        count++;
      }
    }
    if (count > 0) {
      sum.scaleSelf(1/(float)count);
      sum.normalize();
      sum.scaleSelf(maxspeed);
      Vec3D steer = sum.subSelf(vel);
      steer.limit(maxforce);
      return steer;
    } else {
      return new Vec3D(0, 0, 0);
    }
  }


  // Cohesion
  Vec3D cohesion (List<Boid> boids) {
    float neighbordist = 80.0f*80.0f;
    Vec3D sum = new Vec3D(0, 0, 0);   
    int count = 0;
    for (Boid other : boids) {
      float d = this.distanceToSquared(other);
      if ((d > 0) && (d < neighbordist)) {
        sum.addSelf(other); 
        count++;
      }
    }
    if (count > 0) {
      sum.scaleSelf(1/(float)count);
      return seek(sum);
    } else {
      return new Vec3D(0, 0, 0);
    }
  }

  Vec3D seektrail(ArrayList tPop) {
    float neighbordist = 90;
    Vec3D sum = new Vec3D(0, 0, 0);  
    int count = 0;

    for (int i = 0; i < tPop.size(); i++) {
      trail t = (trail) tPop.get(i); 
      float distance = this.distanceTo(t);
      if ((distance < neighbordist)&&(inView(t, 60))) {
        sum.addSelf(t); 
        count++;
      }
    }
    if (count > 0) {
      sum.scaleSelf(1/(float)count);
      return seek(sum);
    }    
    return sum;
  }

  boolean inView(Vec3D target, float angle) {
    boolean resultBool; 
    Vec3D vec = target.copy().subSelf(this.copy());
    float result = vel.copy().angleBetween(vec);
    result = degrees(result);
    if (result < angle) {
      resultBool = true;
    } else { 
      resultBool = false;
    }
    return resultBool;
  }

  // Wraparound
  void borders() {
    List cavepoints = null;
    cavepoints = meshoctree.getPointsWithinSphere(this.copy(), 50);

    if (cavepoints !=null) {
      if (cavepoints.size()>0) {
        // Ray3D bnc = new Ray3D(this,vel);



        vel.scaleSelf(-3);
      }
    }
  }
}