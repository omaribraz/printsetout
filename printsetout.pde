import processing.opengl.*;
import toxi.geom.*;
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
Mesh3D cave;

WB_KDTree vertexTree;
WB_KDTree vertexTree1;

ArrayList xMax = new ArrayList();
ArrayList yMax = new ArrayList();
ArrayList zMax = new ArrayList();
ArrayList  meshpts= new ArrayList();
ArrayList<Vec3D> cavepts;

float DIM = 1500;
boolean showOctree = false;
boolean useSphere = true;

float RADIUS = 20;


MeshOctree octree;

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

  octree=new MeshOctree(new Vec3D(-1, -1, -1).scaleSelf(a), DIM*2);

  for (int i = 0; i <10; i++) {
    flock.addBoid(new Boid(random(550, 750), random(550, 650), random(150, 250)));
  }
  gfx=new ToxiclibsSupport(this);

  octree.addAll(cavepts);
}

void draw() {
  background(0);
  flock.run();

  if (showOctree) octree.draw();
  stroke(255, 0, 0);
  noFill();


  pushMatrix();
  fill(40, 120);
  noStroke();
  strokeWeight(.1);
  stroke(10);
  lights();
  //gfx.origin(new Vec3D(),0);
  gfx.mesh(cave, false, 10);
  // render.drawFaces(cave);
  popMatrix();
}