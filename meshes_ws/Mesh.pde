class Mesh {
  // radius refers to the mesh 'bounding sphere' redius.
  // see: https://en.wikipedia.org/wiki/Bounding_sphere
  float radius = 150;
  PShape shape;
  // mesh representation
  ArrayList<PVector> vertices;

  // rendering mode
  boolean retained;

  // visual modes
  // 0. Faces and edges
  // 1. Wireframe (only edges)
  // 2. Only faces
  // 3. Only points
  int mode;

  // visual hints
  boolean boundingSphere;

  Mesh() {
    build();
    //use processing style instead of pshape's, see https://processing.org/reference/PShape.html
    shape.disableStyle();
  }

  // compute both mesh vertices and pshape
  void build() {
    vertices = new ArrayList<PVector>();
    int n = 20;
    float angle = 360.0/n;
    shape = createShape();
    shape.beginShape(TRIANGLE_FAN);
    shape.vertex(0, 0);
    vertices.add(new PVector(0, 0, 0));
    
    for (int i = 0; i < n; i++){
        float x = radius * cos(radians(angle * i));
        float y = radius * sin(radians(angle * i));
        shape.vertex(x, y);
        vertices.add(new PVector(x, y, 0));
    }
    
    shape.vertex(radius, 0);
    vertices.add(new PVector(radius, 0, 0));
    shape.endShape(CLOSE);
  }


  void drawImmediate() {
    beginShape(TRIANGLE_FAN);
    for(PVector v : vertices)
      vertex(v.x, v.y ,v.z);
    endShape(CLOSE);
  }

  void draw() {
    pushStyle();

    // mesh visual attributes
    int strokeWeight = 3;
    color lineColor = color(255, retained ? 0 : 255, 0);
    color faceColor = color(0, retained ? 0 : 255, 255, 100);

    strokeWeight(strokeWeight);
    stroke(lineColor);
    fill(faceColor);
    // visual modes
    switch(mode) {
    case 1:
      noFill();
      break;
    case 2:
      noStroke();
      break;
    case 3:
      lineColor = color(0, 0, 0);
      stroke(lineColor);
      break;
    }

    // rendering modes
    if (retained)
      shape(shape);
    else
      drawImmediate();
    popStyle();

    // visual hint
    if (boundingSphere) {
      pushStyle();
      noStroke();
      fill(0, 255, 255, 125);
      sphere(radius);
      popStyle();
    }
  }
}