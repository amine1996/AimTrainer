class Aim
{
  //Shape representing the sphere
  private PShape sphere;
  
  //Absolute position of the sphere
  private PVector position;
  
  //RGB Vector color of the sphere
  private PVector aimColor;
  
  //Radius of the sphere
  private float radius;
  
  //When the aim appeared
  private int spawnTime;
  
  
  //Constructor initialised with position
  Aim(PVector pPos)
  {
    this.radius = Config.aimRadius;
    sphereDetail(20);
    this.sphere = createShape(SPHERE,this.radius);
    setRandomColor();
    this.sphere.setStroke(false);
    this.spawnTime = millis();
    
    this.position = pPos;
  }
  
  //Constructor initalised with position and radius
  Aim(PVector pPos, float pAimRadius)
  {
    this.radius = pAimRadius;
    
    this.sphere = createShape(SPHERE,this.radius);
    setRandomColor();
    this.sphere.setStroke(false);
    
    this.position = pPos;
  }
  
  public int getSpawnTime()
  {
    return this.spawnTime;
  }
  
  public boolean isDead()
  {
    return millis() - this.spawnTime > Config.aimLifespan * 1000;
  }
  
  //Fill the sphere with a random color
  public void setRandomColor()
  {
    this.aimColor = ColorMaker.getRandomAdditiveColor();
    
    this.sphere.setFill(color(aimColor.x,aimColor.y,aimColor.z));
  }
  
  //Return a vector representing the sphere
  public PVector getColor()
  {
    return this.aimColor;
  }
  
  //Fill sphere with color c
  public void setColor(color c)
  {
    this.sphere.setFill(c);
  }
  
  //Return the position of the sphere
  public PVector getPosition()
  {
    return this.position.copy();
  }
  
  //Return the radius of the sphere
  public float getRadius()
  {
    return this.radius; 
  }
  
  //Draw the sphere
  public void draw()
  {
    pushMatrix();
      translate(this.position.x,this.position.y,this.position.z);
      shape(this.sphere);
    popMatrix();
  }
}