class GameManager
{
  //instance of main PApplet
  private PApplet appInstance;
  
  //PShape representing the world sphere
  private PShape skySphere;
  
  private PShape transparentSphere;
  
  //List of aim in the world
  private ArrayList<Aim> aimList;
  
  //Used to handle cameras
  private CameraManager camManager;
  
  //Ued to handle the joystick
  private JoypadManager joyManager;
  
  private Logger logger;
  
  private int score;
  
  private GameState gameState;
  
  private PieMenu pieMenu;
  
  //GameManager constructor initalised with instance of main PApplet
  GameManager(Main pInstance)
  {
    this.appInstance = pInstance;
    
    this.aimList = new ArrayList<Aim>();
    
    this.skySphere = createskySphere();

    this.transparentSphere = createTransparentSphere();
    
    this.camManager = new CameraManager(this.appInstance);
    
    this.joyManager = new JoypadManager(this.appInstance);
    
    this.logger = new Logger("GameManager");
    
    this.score = 0;
    
    this.gameState = GameState.MENU;
    
    this.pieMenu = new PieMenu(this.joyManager);
  }
  
  //Public methods
  
  //Update all components of the game manager and draw 3D Models
  public void update()
  { 
    if(this.gameState == GameState.MENU)
    {
      if(!this.joyManager.isEmpty())
      {
        this.joyManager.update();
        
        if(this.joyManager.shootClicked())
        {
          if(this.pieMenu.getCurrentOption() == MenuOption.QUIT)
          {
            exit();
          }
          else if(this.pieMenu.getCurrentOption() == MenuOption.START)
          {
            this.gameState = GameState.PLAYING;
            createRandomAimSphere();
          }
        }
        this.pieMenu.draw();
      }
    }
    else if(this.gameState == GameState.PLAYING)
    {
      drawskySphere();
      drawCrossHair();
      drawFloor();
      
      lights();
      
      for(int i=0;i<aimList.size();i++)
      {
        if(aimList.get(i).isDead())
          destroySphere(aimList.get(i),true);
      }
      
      for(int i=0;i<aimList.size();i++)
      {
        emissive(color(80,80,80));
        aimList.get(i).draw();
      }
      
      if(!this.joyManager.isEmpty())
      {
        this.joyManager.update();
        
        handleTranslation();
        handleSight();
   
        this.camManager.getMainCam().feed();
        
        if(this.joyManager.shootClicked())
        {
          Aim currentTarget = currentTarget();
          if(currentTarget != null)
          {
            if(currentTarget.getColor().equals(this.joyManager.getAdditiveColorPressed()))
              destroySphere(currentTarget,false);
            else
              this.score--;
          }
          else
          {
            this.score--;
          }
        }
      }
      else
      {
        this.logger.log("Please plug a XBox 360/One joypad and restart the application");
      }
      
      drawScore();
    }
  }
  
  
  public void createAimSphere(PVector pos)
  { 
    if(inSphere(pos,Config.aimRadius))
      this.aimList.add(new Aim(pos.copy()));
    else
    {
      this.logger.log("Sphere outside radius");
    }
  }
  
  //Private methods
  
  //Get current aim the player is looking at or null if he looks in the void
  private Aim currentTarget()
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
  
  //Returns true if the player is looking at the sphere given in parameter
  private boolean isLookingAtSphere(Aim aim)
  {

    final PVector playerPos = this.camManager.getPlayerPos();
    final PVector playerDir = this.camManager.getPlayerDirection();

    PVector spherePos = aim.getPosition();
    PVector playerToSphere = PVector.sub(playerPos,spherePos);
      
    if(-playerToSphere.dot(playerDir) <= 0)
      return false;
      
    return abs(PVector.add(playerPos,PVector.mult(playerDir,playerToSphere.mag())).dist(spherePos)) < aim.getRadius();
  }

  //Return true if the position given in parameter is within the world sphere, with a delta to position if necessary
  private boolean inSphere(PVector pos, float delta)
  {
    return pow(Config.spherePos.x - pos.x,2) + pow(Config.spherePos.y - pos.y,2) + pow(Config.spherePos.z - pos.z,2) < pow(Config.skySphereRadius - delta,2);
  }
  
  //Remove the aim given in parameter from the aimList
  private void destroySphere(Aim aim, boolean isDead)
  {
    if(!isDead)
      this.score += millis() - aim.getSpawnTime() > Config.aimLifespan*1000 ? 0 : (Config.aimLifespan*1000 - (millis() - aim.getSpawnTime()))/1000 ;
    else
      this.score -= 1;
      
    this.aimList.remove(aimList.indexOf(aim));
    createRandomAimSphere();
  }
  
  //Return the attitude (yaw,pitch,roll) vector that is looking at the position given in parameter
  private PVector getAttitudeToPos(PVector pos)
  {
    final PVector playerPos = this.camManager.getPlayerPos();
    final PVector lookAt = pos;
    final PVector delta = playerPos.sub(lookAt);
    
    PVector correctAtt = new PVector(0,0);
    correctAtt.x = delta.x < 0 ? atan2(delta.x,delta.z) + 2*PI : atan2(delta.x,delta.z);
    correctAtt.y = delta.y < 0 ? -atan2(delta.y,sqrt(delta.x * delta.x + delta.z * delta.z)) : atan2(delta.y,sqrt(delta.x * delta.x + delta.z * delta.z));
    
    return correctAtt;
  }
  
  //Create a random aim sphere within the sphere with a random color
  private void createRandomAimSphere()
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
    
    spherePos.mult(Config.skySphereRadius/2);
    
    if(inSphere(spherePos,Config.aimRadius))
    {
      this.aimList.add(new Aim(spherePos));
    }
    else
    {
      this.logger.log("Sphere outside radius, recreating one");
      createRandomAimSphere();
    }
  } //<>//
  
  //Move the player's camera using the joystick values
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
 
  //Move the sight of the player's camera depend on the joystick values
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
  private PShape createskySphere()
  {
    PImage skyDome = loadImage("./data/Space2.png");
    
    sphereDetail(100);
    noStroke();
    PShape sphere = createShape(SPHERE,Config.skySphereRadius);
    sphere.setTexture(skyDome);
    
    return sphere;
  }

  private PShape createTransparentSphere()
  {
    sphereDetail(100);
    noStroke();
    PShape sphere = createShape(SPHERE,Config.skySphereRadius);
    sphere.setFill(color(0,0,200,0));
    
    return sphere;
  }
  
  //Draw the sky sphere
  private void drawskySphere()
  {
    pushMatrix();
      translate(Config.spherePos.x,Config.spherePos.y,Config.spherePos.z);
      shape(this.skySphere);
    popMatrix();
  }
  
  //Draw the transparent sphere
  private void drawTransparentSphere()
  {
    pushMatrix();
      translate(Config.spherePos.x,Config.spherePos.y,Config.spherePos.z);
      shape(this.transparentSphere);
    popMatrix();
  }
  
  //Draw the crosshair
  private void drawCrossHair()
  {
    final PVector pos = this.camManager.getPlayerPos();
    final PVector attitude = this.camManager.getPlayerAttitude();
    
    pushMatrix();
      //Positionne la croix sur la caméra
      translate(pos.x, pos.y, pos.z);
      //Rotation par rapport à l'axe Y
      rotateY(attitude.x);  
      //Rotation par rapport à l'axe X
      rotateX(-attitude.y);
      //Pousse la croix de 2 en Z
      translate(0, 0, -2);
      
      //Dessine la croix
      fill(0);;
      stroke(255,0,0);
      strokeWeight(1);
      line(-0.1,0,0.1,0);
      line(0,-0.1,0,0.1);
    popMatrix();
  }

  //Draw the floor
  private void drawFloor()
  {
    pushMatrix();
      noStroke();
      fill(color(220,200,255,50));
      translate(0,10,0);
      rotateX(radians(90));
      ellipse(0,0,Config.skySphereRadius*2,Config.skySphereRadius*2);
    popMatrix();
    
    pushMatrix();
      stroke(0);
      fill(0);
      for(int i=0;i<Config.skySphereRadius*2;i++)
      {
        line(-Config.skySphereRadius*2,10,-Config.skySphereRadius*2+i*10,Config.skySphereRadius*2,10,-Config.skySphereRadius*2+i*10);
        line(-Config.skySphereRadius*2+i*10,10,-Config.skySphereRadius*2,-Config.skySphereRadius*2+i*10,10,Config.skySphereRadius*2);
      }
    popMatrix();
  }
  
  //Draw screen
  private void drawScore()
  {
    final PVector pos = this.camManager.getPlayerPos();
    final PVector attitude = this.camManager.getPlayerAttitude();
    final int textSize = 32;
    final String scoreText = "Score : "+ this.score;

    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
      translate(pos.x, pos.y, pos.z);
      rotateY(attitude.x);  
      rotateX(-attitude.y);
      translate(width/3,-height/2.8,-1000);
      
      smooth(10);
      noStroke();
      
      textSize(textSize);
      fill(255);
      text(scoreText,0,0,0);
    popMatrix();
   hint(ENABLE_DEPTH_TEST);
  }
  
}