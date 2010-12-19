package  
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Zachary Weston Lewis
	 */
	public class GameOverWorld extends World 
	{
		private var distance:Number;
		private var discoveries:Number;
		private var select:Sfx;
		public function GameOverWorld(dist:Number, disc:uint) 
		{
			distance = dist;
			discoveries = disc;
			select = new Sfx(Assets.SELECT);
		}
		
		override public function begin():void 
		{
			Text.size = 32;
			var t:Text = new Text("THE UNIVERSE HAS RECLAIMED YOUR SOUL.\nYOU DIED " + distance.toFixed(1) + " LIGHTYEARS AWAY\nFROM YOUR HOME, DISCOVERING " + discoveries + "\nUNKNOWN PLANETARY BODIES.\n\n\n\n\n\n\nCLICK ANYWHERE TO EXPLORE THE COSMOS\nAGAIN.");
			addGraphic(t);
			super.begin();
		}
		
		override public function update():void 
		{
			if (Input.mouseReleased)
			{
				FP.world = new UniverseWorld;
				select.play(0.1);
			}
			super.update();
		}
		
	}

}