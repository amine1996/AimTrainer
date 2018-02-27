import org.gamecontrolplus.*;

class JoypadManager
{
  private PApplet appInstance;
  
  private ControlIO joypadControl;
  private ControlDevice joypadInputs;
  
  //Vector representing joystick values (x,y)
  private PVector leftJoy;
  private PVector rightJoy;
  
  //Boolean representing button states (pressed, released)
  private boolean buttonY;
  private boolean buttonX;
  private boolean buttonA;
  private boolean buttonB; 
  
  //Float representing the shoot button value (depending on how much it's pressed)
  private float buttonShoot;
  
  //True if the shoot button has been clicked (Pressed then released)
  private boolean shootClicked;
  
  private Logger logger;
 
  JoypadManager(PApplet pAppInstance)
  {
    this.appInstance = pAppInstance; 
    
    this.joypadControl = ControlIO.getInstance(this.appInstance);
    
    if(this.joypadControl != null)
      this.joypadInputs = joypadControl.getMatchedDeviceSilent("joystick");
    
    this.logger = new Logger("JoypadManager");
    
    this.leftJoy = new PVector(0,0);
    this.rightJoy = new PVector(0,0);
    
    this.shootClicked = false;
  }
  
  //Return false if on the ControlIO object is null
  public boolean isEmpty()
  {
    return (this.joypadControl == null || this.joypadInputs == null);
  }
  
  //Return value of right joystick
  public PVector getRightJoy()
  {
    return this.rightJoy;
  }
  
  //Returns value of the left joystick
  public PVector getLeftJoy()
  {
    return this.leftJoy;
  }
  
  //Returns a PVector(r,g,b) representing the color pressed by the user
  public PVector getAdditiveColorPressed()
  {
    ArrayList<Colors> colors = new ArrayList<Colors>();
    
    if(this.buttonB)
      colors.add(Colors.RED);
    
    if(this.buttonA)
      colors.add(Colors.GREEN);
      
    if(this.buttonX)
      colors.add(Colors.BLUE);
     
    if(this.buttonY)
      colors.add(Colors.YELLOW);
    
    if(colors.size() > 0)
    {
      String colorPressed = "";
      
      for(Colors col : colors)
        colorPressed += col+"+";
        
      logger.log("Color pressed : "+ colorPressed.substring(0,colorPressed.length()-1),true);
    }
    
    return ColorMaker.colorAddition(colors);
  }
  
  //Return the value of the shoot button
  public float getShootButton()
  {
    return this.buttonShoot;
  }
  
  //Return the value of the shootClicked boolean (True if button has been pressed then released)
  public boolean shootClicked()
  {
    return this.shootClicked;
  }
  
  //Update the joystick components
  public void update()
  {
    this.leftJoy.x = map(this.joypadInputs.getSlider("X").getValue(), -1, 1, -1, 1);
    this.leftJoy.y = map(this.joypadInputs.getSlider("Y").getValue(), -1, 1, -1, 1);

    this.rightJoy.x = map(this.joypadInputs.getSlider("RX").getValue(), -1 , 1, -1, 1);
    this.rightJoy.y = map(this.joypadInputs.getSlider("RY").getValue(), -1, 1, -1, 1);
    
    this.buttonB = this.joypadInputs.getButton("BB").getValue() == 0 ? false : true;
    this.buttonA = this.joypadInputs.getButton("BA").getValue()  == 0 ? false : true;
    this.buttonX = this.joypadInputs.getButton("BX").getValue()  == 0 ? false : true;
    this.buttonY = this.joypadInputs.getButton("BY").getValue()  == 0 ? false : true;
    
    float buttonShootNow = map(this.joypadInputs.getSlider("RT").getValue(), -1, 1, 0, 1);
    
    if(this.buttonShoot > 0 && buttonShootNow == 0)
    {
      this.logger.log("Clicked shoot button",true);
      this.shootClicked = true;
    }
    else
    {
      this.shootClicked = false;
    }
    
    this.buttonShoot = buttonShootNow;
  }
}