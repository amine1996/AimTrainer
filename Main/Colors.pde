import java.util.Random;

//Joypad colors
public enum Colors
{
  NONE,
  BLUE,
  GREEN,
  RED,
  YELLOW
}

public static class ColorMaker
{
  private static final Random randomGenerator = new Random();
  private static final int colorValue = 200;
  
  public static ArrayList<Colors> getColors()
  {
    ArrayList<Colors> allColors = new ArrayList<Colors>();
    
    //Remove yellow because additive
    allColors.add(Colors.NONE);
    allColors.add(Colors.BLUE);
    allColors.add(Colors.GREEN);
    allColors.add(Colors.RED);
    allColors.add(Colors.YELLOW);
    
    return allColors;  
  }
  
  public static PVector getBlue()
  {
    return new PVector(0,0,colorValue);
  }
  
  public static PVector getGreen()
  {
    return new PVector(0,colorValue,0);
  }
  
  public static PVector getRed()
  {
    return new PVector(colorValue,0,0);
  }
  
  public static PVector getRandomAdditiveColor()
  {
    ArrayList<Colors> colors = getColors();
    int size = colors.size();
    
    int firstColor = randomGenerator.nextInt(size*2);
    int secondColor = randomGenerator.nextInt(size*2);
    
    
    ArrayList<Colors> addition = new ArrayList<Colors>();
    addition.add(firstColor <= size ? Colors.NONE : getColors().get(firstColor%size));
    addition.add(secondColor <= size ? Colors.NONE : getColors().get(secondColor%size));
    
    while(addition.get(0) == addition.get(1))
      addition.set(0,colors.get(randomGenerator.nextInt(size-1)+1));
      
    if(addition.contains(Colors.YELLOW))
      addition.set((addition.indexOf(Colors.YELLOW)+1)%2,Colors.NONE);
    
    return colorAddition(addition);
  }
  
  
  public static PVector colorAddition(ArrayList<Colors> colors)
  {
    PVector additiveColors = new PVector(0,0,0);
    for(int i=0;i<colors.size();i++)
    {
      switch(colors.get(i))
      {
        case BLUE:
          additiveColors.add(getBlue());
          break; 
        case GREEN:
          additiveColors.add(getGreen());
          break;
        case RED:
          additiveColors.add(getRed());
          break;
        case YELLOW:
          ArrayList<Colors> addition = new ArrayList<Colors>();
          addition.add(Colors.RED);
          addition.add(Colors.GREEN);
          
          additiveColors.add(colorAddition(addition));
          break;
        default:
          break;
      }
    }
    return additiveColors;
  }
}