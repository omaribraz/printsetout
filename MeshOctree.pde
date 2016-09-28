class MeshOctree extends PointOctree {

  MeshOctree(Vec3D o, float d) {
    super(o,d);
  }

  void draw() {
    drawNode(this);
  }

  void drawNode(PointOctree n) {
    if (n.getNumChildren() > 0) {
      noFill();
      stroke(255);
      pushMatrix(); 
      translate(n.x, n.y, n.z);
      box(n.getNodeSize());
      popMatrix();
      PointOctree[] childNodes=n.getChildren();
      for (int i = 0; i < 8; i++) {
        if(childNodes[i] != null) drawNode(childNodes[i]); 
      }
    }
  }
}