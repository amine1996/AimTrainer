import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;

class JoypadManager
{
  private PApplet appInstance;
  
  private ControlIO joypadControl;
  private ControlDevice joypadInputs;
  
  private PVector leftJoy;
  private PVector rightJoy;
  
  private boolean buttonY;
  private boolean buttonX;
  private boolean buttonA;
  private boolean buttonB; 
  
  private float buttonShoot;
  
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
  
  public boolean isEmpty()
  {
    return (this.joypadControl == null || this.joypadInputs == null);
  }
  
  public PVector getRightJoy()
  {
    return this.rightJoy;
  }
  
  public PVector getLeftJoy()
  {
    return this.leftJoy;
  }
  
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
  
  public float getShootButton()
  {
    return this.buttonShoot;
  }
  
  public boolean shootClicked()
  {
    return this.shootClicked;
  }
  
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
      logger.log("Clicked shoot button",true);
      this.shootClicked = true;
    }
    else
    {
      this.shootClicked = false;
    }
    
    this.buttonShoot = buttonShootNow;
  }
}