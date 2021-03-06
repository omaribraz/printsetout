void meshrun() {
  //mesh = new HEC_FromOBJFile(sketchPath("data/"+"mesh3.obj")).create();
  cave = (WETriangleMesh) new STLReader().loadBinary(sketchPath("data/"+"cave.stl"), STLReader.WEMESH);
  //vertexTree = mesh.getVertexTree();
  //int novert = mesh.getNumberOfVertices();
  //vertexTree1 = cave.getVertexTree();
  cave.flipVertexOrder();
  int novert1 = cave.getNumVertices();

  cavepts = (new ArrayList<Vec3D>(cave.getVertices()));

  for (int i=0; i< novert1; i++) {
    Vec3D a = cavepts.get(i);
    xMax.add(a.x);
    yMax.add(a.y);
    zMax.add(a.z);
  }
  
  


  //for (int i=0; i< novert1; i++) {
  //  Vec3D = cave.getVerteces(i);
  //  float xfPos = (Float)  vertex1.xf();
  //  float yfPos = (Float)  vertex1.yf();
  //  float zfPos = (Float)  vertex1.zf();
  //  xMax.add(xfPos);
  //  yMax.add(yfPos);
  //  zMax.add(zfPos);
  //}


  //render = new WB_Render( this );

  float xmaxf = Collections.max(xMax);
  float ymaxf = Collections.max(yMax);
  float zmaxf = Collections.max(zMax);
  float xminf = Collections.min(xMax);
  float yminf = Collections.min(yMax);
  float zminf = Collections.min(zMax);
  xmaxint =(int)xmaxf;
  ymaxint =(int)ymaxf;
  zmaxint =(int)zmaxf;
  xminint =(int)xminf;
  yminint =(int)yminf;
  zminint =(int)zminf;

  xMax.clear();
  yMax.clear();
  zMax.clear();
}