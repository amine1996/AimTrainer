GameManager gameManager;

void setup()
{
  size(displayWidth, displayHeight, P3D); 

  this.gameManager = new GameManager(this);
}

void draw()
{
  background(100,100,100);

  //Update GameManager and draw 3D Models
  this.gameManager.update();
}

void keyPressed()
{
  if(key == 'a')
  {
    this.gameManager.createRandomAimSphere();
  }
}