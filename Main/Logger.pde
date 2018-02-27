import java.util.Map;

class Logger
{
  //Usually the className
  String prefix;
  
  //Store the logged data
  HashMap<Object,Integer> loggedData;
  
  Logger(String pPrefix)
  {
    this.prefix = pPrefix;
    this.loggedData = new HashMap<Object,Integer>();
  }
  
  //Call the function log with noDelay set as false
  public void log(Object data)
  {
    boolean noDelay = false;
    log(data,noDelay);
  }
  
  //Log the data passed in parameter preceded with the prefix
  //If the data has already been logged in the past 5 seconds, just ignore it
  public void log(Object data, boolean noDelay)
  {
    if(loggedData.get(data) == null)
    {
      println(this.prefix + ":" + data);
      loggedData.put(data,millis());
    }
    else
    {
      if(millis() - loggedData.get(data) > 5000 || noDelay)
      {
        println(this.prefix + ":" + data);
        loggedData.put(data,millis());
      }
    }
  }
}