import damkjer.ocd.*;

import net.java.games.input.*;

import java.util.Random;

class GameManager
{
  PApplet appInstance;
  
  private PShape worldSphere;
  
  private ArrayList<Aim> aimList;
  
  private CameraManager camManager;
  
  private JoypadManager joyManager;
  
  private Logger logger;
  
  GameManager(Main pInstance)
  {
    this.appInstance = pInstance;
    
    this.aimList = new ArrayList<Aim>();
    
    this.worldSphere = createWorldSphere();
    
    this.camManager = new CameraManager(this.appInstance);
    
    this.joyManager = new JoypadManager(this.appInstance);
    
    this.logger = new Logger("GameManager");
  }
  
  public void update()
  {

    drawWorldSphere();
    drawCrossHair();
    drawFloor();
    
    for(int i=0;i<aimList.size();i++)
    {
      aimList.get(i).draw();
    }
    
    if(!this.joyManager.isEmpty())
    {
      this.joyManager.update();
      
      handleTranslation();
      handleSight();
      
      if(this.joyManager.shootClicked())
      {
        Aim currentTarget = currentTarget();
        if(currentTarget != null)
        {
          if(currentTarget.getColor().equals(this.joyManager.getAdditiveColorPressed()))
            destroySphere(currentTarget);
        }
      }
      
      this.camManager.getMainCam().feed();
      
    }
    else
    {
      this.logger.log("Please plug a XBox 360/One joypad and restart the application");
    }
  }
  
  public Aim currentTarget()
  {
    float minDist = MAX_FLOAT;
    PVector playerPos = this.camManager.getPlayerPos();
    
    Aim currentTarget = null;
    
    for(int i=0;i<this.aimList.size();i++)
    {
      Aim currentAim = this.aimList.get(i);
      
      if(isLookingAtSphere(currentAim))
      {
        float distToSphere = playerPos.dist(currentAim.getPosition());
        if(distToSphere < minDist)
        {
           minDist = distToSphere;
           currentTarget = currentAim;
        }
      }
    }
    
    return currentTarget;
  }
  
  public boolean isLookingAtSphere(Aim aim)
  {

    final PVector playerPos = this.camManager.getPlayerPos();
    final PVector playerDir = this.camManager.getPlayerDirection();

    PVector spherePos = aim.getPosition();
    PVector playerToSphere = PVector.sub(playerPos,spherePos);
      
    if(-playerToSphere.dot(playerDir) <= 0)
      return false;
      
    return abs(PVector.add(playerPos,PVector.mult(playerDir,playerToSphere.mag())).dist(spherePos)) < aim.getRadius();
  }

  private boolean inSphere(PVector pos, float delta)
  {
    return pow(Config.spherePos.x - pos.x,2) + pow(Config.spherePos.y - pos.y,2) + pow(Config.spherePos.z - pos.z,2) < pow(Config.sphereRadius - delta,2);
  }
  
  private void destroySphere(Aim aim)
  {
    aimList.remove(aimList.indexOf(aim));
  }
  
  public PVector getAttitudeToPos(PVector pos)
  {
    final PVector playerPos = this.camManager.getPlayerPos();
    final PVector lookAt = pos;
    final PVector delta = playerPos.sub(lookAt);
    
    PVector correctAtt = new PVector(0,0);
    correctAtt.x = delta.x < 0 ? atan2(delta.x,delta.z) + 2*PI : atan2(delta.x,delta.z);
    correctAtt.y = delta.y < 0 ? -atan2(delta.y,sqrt(delta.x * delta.x + delta.z * delta.z)) : atan2(delta.y,sqrt(delta.x * delta.x + delta.z * delta.z));
    
    return correctAtt;
  }
  
  public void createRandomAimSphere()
  { 
    //https://math.stackexchange.com/questions/1585975/how-to-generate-random-points-on-a-sphere
    
    PVector spherePos = new PVector();
    
    spherePos.x = random(0,100);
    spherePos.y = random(0,100);
    spherePos.z = random(0,100);
    
    spherePos.normalize();
    
    spherePos.x = map(spherePos.x,0,1,-1,1);
    spherePos.y = map(spherePos.y,0,1,-1,0);
    spherePos.z = map(spherePos.z,0,1,-1,1);
    
    spherePos.mult(Config.sphereRadius/2);
    
    if(inSphere(spherePos,Config.aimRadius))
    {
      aimList.add(new Aim(spherePos));
    }
    else
    {
      logger.log("Sphere outside radius, recreating one");
      createRandomAimSphere();
    }
  }
  
  public void createAimSphere(PVector pos)
  { 
    if(inSphere(pos,Config.aimRadius))
      aimList.add(new Aim(pos.copy()));
    else
    {
      logger.log("Sphere outside radius");
    }
  }
  
  public void drawWorldSphere()
  {
    this.appInstance.pushMatrix();
      translate(Config.spherePos.x,Config.spherePos.y,Config.spherePos.z);
      this.appInstance.shape(this.worldSphere);
    this.appInstance.popMatrix();
  }
  
  public void drawCrossHair()
  {
    final PVector pos = this.camManager.getPlayerPos();
    final PVector attitude = this.camManager.getPlayerAttitude();
    
    pushMatrix();
        //Positionne la croix sur la caméra //<>//
        translate(pos.x, pos.y, pos.z);
        //Rotation par rapport à l'axe Y
        rotateY(attitude.x);  
        //Rotation par rapport à l'axe X
        rotateX(-attitude.y);
        //Pousse la croix de 2 en Z //<>//
        translate(0, 0, -2);
      
        //Dessine la croix //<>//
        fill(0);
        stroke(255,0,0);
        strokeWeight(1); //<>//
        line(-0.1,0,0.1,0);
        line(0,-0.1,0,0.1);
      popMatrix();
  }

  public void drawFloor()
  {
     pushMatrix();
        fill(255); //<>//
        translate(0,10,0);
        rotateX(radians(90));
        ellipse(0,0,Config.sphereRadius*2,Config.sphereRadius*2);
    popMatrix();
  }
  
  private void handleTranslation()
  {
    final PVector leftJoy = this.joyManager.getLeftJoy();
    final damkjer.ocd.Camera playerCam = this.camManager.getPlayerCam();
    
    if(abs(leftJoy.x) > 0.1 || abs(leftJoy.y) > 0.1)
    {
      PVector oldTarget = this.camManager.getPlayerTarget();
      
      playerCam.truck(leftJoy.x);
      playerCam.dolly(leftJoy.y);
         
      PVector newPos = Utilities.arrayToPVector(playerCam.position());
      
      if(inSphere(newPos,20))
      {        
        PVector newTarget = this.camManager.getPlayerTarget();
        playerCam.jump(newPos.x,0,newPos.z);
        playerCam.aim(newTarget.x,oldTarget.y,newTarget.z);
      }
      else{
        playerCam.truck(-leftJoy.x);
        playerCam.dolly(-leftJoy.y); 
      }
    }
  }
 
  private void handleSight()
  {
    final PVector rightJoy = this.joyManager.getRightJoy();
    final damkjer.ocd.Camera playerCam = this.camManager.getPlayerCam();
    
    if(abs(rightJoy.x) > 0.1 || abs(rightJoy.y) > 0.1)
    { 
      float angleX = radians(rightJoy.x) * 2.0;
      float angleY = radians(rightJoy.y) * 2.0;
      
      playerCam.pan(angleX);
      playerCam.tilt(angleY);
    }
  }

  //3D methods
  PShape createWorldSphere()
  {
    PImage skyDome = loadImage("./data/Sky019.jpg");
    
    sphereDetail(100);
    noStroke();
    PShape sphere = createShape(SPHERE,Config.sphereRadius);
    sphere.setTexture(skyDome);
    
    return sphere;
  }
}