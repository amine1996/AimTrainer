public enum MenuOption
{
  QUIT,
  START
}

class PieMenu
{
  private PImage backgroundImage;
    
  private String[] options = { "Quit", "Start"};
  
  private float diam;
  
  private float textdiam;
  
  private JoypadManager joyManager;
  
  private MenuOption currentOption;
  
  private Logger logger;
  
  private color transparent;
  
  private color semiTransparentPurple;
  
  private color semiTransparentWhite;

  PieMenu(JoypadManager pJoyManager)
  {
    diam = min(width, height) * 0.8;
    textdiam = diam/2.75;
    this.joyManager = pJoyManager;
    
    this.backgroundImage = loadImage("./data/MenuBackground.jpg");
    
    this.currentOption = MenuOption.START;
    
    this.logger = new Logger("PieMenu");
    
    this.transparent= color(255,255,255,0);
    
    this.semiTransparentPurple = color(100, 0, 200,100);
    
    this.semiTransparentWhite = color(255,255,255,100);
    
  }
   
  void draw() 
  {
    background(this.backgroundImage);
    
    textAlign(CENTER, CENTER);
    noStroke();
    smooth();
    
    this.update();
  }
  
  //Public methods
  
  public void update()
  {
    fill(this.transparent);
    ellipse(width/2, height/2, diam+3, diam+3);
    
    //Get the angle depending on the joystick values
    float angle = this.joyManager.getRightJoy().y >= 0 ? 2 : 5;
    float step = options.length/TWO_PI;

    //Constructon of the pie menu and definition of the choice made by the user depending on the joystick value
    for (int i=0; i<options.length; i++) 
    {
      float s = (i/step-PI*0.50) + PI /2;
      float e = ((i+0.99)/step-PI*0.50) + PI /2;
      
      if (angle>= s && angle <= e) 
      {
        fill(this.semiTransparentPurple);
        currentOption = i == 0 ? MenuOption.QUIT : MenuOption.START;
      } 
      else
      {
        fill(this.semiTransparentWhite);
      }
      arc(width/2, height/2, diam, diam, s, e);
    }
   
    //Print option's text on each part of the pie menu
    for (int i=0; i<options.length; i++) 
    {
      float m = i/step + PI /2;
      fill(255);
      stroke(color(0,0,0));
      textSize(64);
      text(options[i], width/2+cos(m)*textdiam, height/2+sin(m)*textdiam);
    }
   
    fill(semiTransparentWhite);
    ellipse(width/2, height/2, 50, 50);
  }
  
  //Return the user choice
  public MenuOption getCurrentOption()
  {
    return this.currentOption;
  }
}