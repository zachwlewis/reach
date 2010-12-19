package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * Reach: A game for Ludum Dare 19
	 * @author Zachary Weston Lewis
	 */
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(640, 480);
			// Space is black.
			FP.screen.color = 0;
			//FP.console.enable();
		}
		
		override public function init():void 
		{
			FP.world = new UniverseWorld;
			super.init();
		}
		
	}
	
}