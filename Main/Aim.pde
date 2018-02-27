class Aim
{
  PShape sphere;
  
  PVector position;
  
  PVector aimColor;
  
  float radius;
  
  Aim(PVector pPos)
  {
    this.radius = Config.aimRadius;
    
    this.sphere = createShape(SPHERE,this.radius);
    setRandomColor();
    this.sphere.setStroke(false);
    
    this.position = pPos;
  }
  
  
  Aim(PVector pPos, float pAimRadius)
  {
    this.radius = pAimRadius;
    
    this.sphere = createShape(SPHERE,this.radius);
    setRandomColor();
    this.sphere.setStroke(false);
    
    this.position = pPos;
  }
  
  public void setRandomColor()
  {
    this.aimColor = ColorMaker.getRandomAdditiveColor();
    
    this.sphere.setFill(color(aimColor.x,aimColor.y,aimColor.z));
  }
  
  public PVector getColor()
  {
    return aimColor;
  }
  
  public void setColor(color c)
  {
    this.sphere.setFill(c);
  }
  
  public PVector getPosition()
  {
    return this.position.copy();
  }
  
  public float getRadius()
  {
    return this.radius; 
  }
  
  public void draw()
  {
    pushMatrix();
      translate(this.position.x,this.position.y,this.position.z);
      shape(this.sphere);
    popMatrix();
  }
}