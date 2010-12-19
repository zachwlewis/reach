package  
{
	/**
	 * ...
	 * @author Zachary Weston Lewis
	 */
	public class UniverseHelper 
	{
		public var itemList:Object;
		public function UniverseHelper() 
		{
			itemList = new Object();
		}
		
		public function addPlanet(p:Planet):Boolean
		{
			if (itemList[p.planetName] == null)
			{
				itemList[p.planetName] = p;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public static function generateRandomString(strlen:Number):String{
		  var chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		  var num_chars:Number = chars.length - 1;
		  var randomChar:String = "";
		 
		  for (var i:Number = 0; i < strlen; i++){
		  randomChar += chars.charAt(Math.floor(Math.random() * num_chars));
		  }
		  return randomChar;
		}
		
	}

}