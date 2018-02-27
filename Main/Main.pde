GameManager gameManager;

void setup()
{
  size(displayWidth, displayHeight, P3D); 

  this.gameManager = new GameManager(this);
}

void draw()
{
  background(100,100,100);

  this.gameManager.update();
}

void keyPressed()
{
  if(key == 'a')
  {
    //this.camManager.setPlayerCamAsMain();
    this.gameManager.createRandomAimSphere();
  }
}