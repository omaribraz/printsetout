import processing.opengl.*;
import toxi.geom.*;
import toxi.geom.Ray3D;
import toxi.geom.Ray3DIntersector;
import toxi.geom.ReadonlyVec3D;
import toxi.geom.TriangleIntersector;
import toxi.geom.Intersector3D;
import toxi.geom.IsectData3D;
import toxi.geom.mesh.*;
import toxi.volume.*;
import toxi.processing.*;
import java.util.Iterator;
import java.util.*;
import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import hypermedia.net.*;
import peasy.org.apache.commons.math.geometry.*;

import peasy.*;

import java.util.Map;
import controlP5.*;

import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

PeasyCam cam;
PShape obj;

int xmaxint;
int ymaxint;
int xminint;
int yminint;
int zminint;
int zmaxint;

WB_Render render;
HE_Mesh mesh;
WETriangleMesh cave;

WB_KDTree vertexTree;
WB_KDTree vertexTree1;

ArrayList xMax = new ArrayList();
ArrayList yMax = new ArrayList();
ArrayList zMax = new ArrayList();
ArrayList meshpts= new ArrayList();
ArrayList<Vec3D> cavepts;
ArrayList <Vec3D> Boidpos = new ArrayList();

float DIM = 1500;
boolean showOctree = true;
boolean useSphere = true;

float RADIUS = 20;


Octree meshoctree;
Octree boidoctree;

Flock flock;

ToxiclibsSupport gfx;

void setup() {
  size(1400, 800, P3D);
  smooth();
  flock = new Flock();
  cam = new PeasyCam(this, 750, 750, 0, 2200);
  obj = loadShape("data/"+"drone.obj");
  obj.scale(3);

  meshrun();

  Vec3D a =cave.computeCentroid() ;

  meshoctree=new Octree(new Vec3D(-1, -1, -1).scaleSelf(a), DIM*2);
  boidoctree =new Octree(new Vec3D(-1, -1, -1).scaleSelf(a), DIM*2);

  for (int i = 0; i <1; i++) {
    flock.addBoid(new Boid(new Vec3D(random(500, 850), random(550, 930), random(190, 350)), new Vec3D(random(-TWO_PI, TWO_PI), random(-TWO_PI, TWO_PI), random(-TWO_PI, TWO_PI))));
  }

  gfx=new ToxiclibsSupport(this);



  meshoctree.addAll(cavepts);
}


void draw() {
  background(0);

  for (Boid b : flock.boids) {
    boidoctree.addBoid(b);
  }

  boidoctree.run();



  flock.run();

  for (Boid b : flock.boids) {
    b.checkMesh();
  }




  //if (showOctree) octree.draw();
  stroke(255, 0, 0);
  noFill();


  pushMatrix();
  fill(40, 120);
  noStroke();
  strokeWeight(.1);
  stroke(10);
  lights();
  gfx.mesh(cave, false, 10);
  popMatrix();
}