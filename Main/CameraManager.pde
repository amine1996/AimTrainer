import damkjer.ocd.*;

class CameraManager 
{
  //Main PApplet (where the image will be sent)
  private PApplet appInstance;
  
  //Player camera
  private damkjer.ocd.Camera playerCam;
  
  //Spectator cam, to observe for a different perspective
  private damkjer.ocd.Camera spectatorCam;
  
  //Cam that will be used to feed the screen
  private damkjer.ocd.Camera mainCam;
  
  //Used to log text to console output
  private Logger logger;
  
  //Constructor initalised with main PApplet
  CameraManager(PApplet pInstance)
  {
    this.appInstance = pInstance;
      
    this.playerCam = createPlayerCamera();
    this.spectatorCam = createSpectatorCamera();
    
    this.mainCam = playerCam;
    
    this.logger = new Logger("CameraManager");
  }
  
  //Public methods
  public PVector getPlayerPos()
  {
    return Utilities.arrayToPVector(this.playerCam.position());
  }
  
  public PVector getPlayerAttitude()
  {
    return Utilities.arrayToPVector(this.playerCam.attitude());
  }
  
  public PVector getPlayerTarget()
  {
    return Utilities.arrayToPVector(this.playerCam.target());
  }
  
  //Calculate direction of the player
  public PVector getPlayerDirection()
  {
    return getPlayerPos().sub(getPlayerTarget()).normalize().mult(-1);
  }
 
  public damkjer.ocd.Camera getMainCam()
  {
    return this.mainCam;
  }
  
  public damkjer.ocd.Camera getPlayerCam()
  {
    return this.playerCam;
  }
  
  public damkjer.ocd.Camera getSpectatorCam()
  {
    return this.spectatorCam;
  }
  
  public void swapMainCam()
  {
    this.mainCam = this.mainCam == this.playerCam ? this.spectatorCam : this.playerCam;
  }
  
  public void setPlayerCamAsMain()
  {
    this.mainCam = this.playerCam;
  }
  
  public void setSpectatorCamAsMain()
  {
    this.mainCam = this.spectatorCam;
  }
  
  //Private methods
  
  //Create player camera with default settings
  private damkjer.ocd.Camera createPlayerCamera()
  {
    final PVector posPlayer = new PVector(0,0,0);
    final PVector targetPlayer = new PVector(0,0,-Config.skySphereRadius/2);
    final PVector upVectorPlayer = new PVector(0,1,0);
    
    return createCamera(posPlayer,targetPlayer,upVectorPlayer,70,1,1000);
  }
  
  //Create spectator camera with default settings
  private damkjer.ocd.Camera createSpectatorCamera()
  {
    final PVector posSpectator = new PVector(0,-Config.skySphereRadius/2,0);
    final PVector targetSpectator = new PVector(0,0,0.0001);
    final PVector upVectorSpectator = new PVector(0,1,0);
    
    return createCamera(posSpectator, targetSpectator,upVectorSpectator,70,1,1000);
  }
  
  //Return camera object initalised with parameters
  private damkjer.ocd.Camera createCamera(PVector pos, PVector target, PVector upVector, float fov, float near, float far)
  {
    return new damkjer.ocd.Camera(this.appInstance,pos.x,pos.y,pos.z,target.x,target.y,target.z,upVector.x,upVector.y,upVector.z,fov,near,far);
  }
}