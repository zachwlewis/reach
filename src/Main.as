package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
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
			if (checkDomain(["thegamestudio.net", "kongregate.com"]))
			{
				FP.world = new TitleWorld;
			}
			super.init();
		}
		
		public function checkDomain (allowed:*):Boolean
		{
			var url:String = FP.stage.loaderInfo.url;
			var startCheck:int = url.indexOf('://' ) + 3;
			
			if (url.substr(0, startCheck) == 'file://') return true;
			
			var domainLen:int = url.indexOf('/', startCheck) - startCheck;
			var host:String = url.substr(startCheck, domainLen);
			
			if (allowed is String) allowed = [allowed];
			for each (var d:String in allowed)
			{
				if (host.substr(-d.length, d.length) == d) return true;
			}
			
			return false;
		}
		
	}
	
}