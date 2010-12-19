package  
{
	/**
	 * ...
	 * @author Zachary Weston Lewis
	 */
	public class Assets 
	{
		[Embed(source = '../assets/raw/sounds.swf', symbol = 'bgm.wav')] public static const BGM:Class;
		[Embed(source = '../assets/raw/sounds.swf', symbol = 'powerup.wav')] public static const Powerup:Class;
		[Embed(source = '../assets/raw/sounds.swf', symbol = 'select.wav')] public static const SELECT:Class;
	}

}