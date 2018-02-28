public enum GameState
{
  MENU,
  PLAYING
}

static class Config
{
  //Radius of the sky sphere
  final static float skySphereRadius = 300;
  
  //Default radius of a sphere
  final static float aimRadius = 5;
  
  //Default pos of the sky sphere
  final static PVector spherePos = new PVector(0,10,0);
  
  //Logger delay between two logs if same object (In seconds)
  final static int loggerDelay = 5;
  
  final static int aimLifespan = 5;
}