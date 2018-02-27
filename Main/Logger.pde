import java.util.Map;

class Logger
{
  String prefix;
  HashMap<Object,Integer> loggedData;
  
  Logger(String pPrefix)
  {
    this.prefix = pPrefix;
    this.loggedData = new HashMap<Object,Integer>();
  }
  
  //
  public void log(Object data)
  {
    boolean noDelay = false;
    log(data,noDelay);
  }
  
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