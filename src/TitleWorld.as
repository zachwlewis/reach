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
	public class TitleWorld extends World 
	{
		private var select:Sfx;
		public function TitleWorld() 
		{
			select = new Sfx(Assets.SELECT);
		}
		
		override public function begin():void 
		{
			Text.size = 9000;
			var t:Text;
			t = new Text("REACH");
			Text.size = 20;
			var t2:Text = new Text("A GAME FOR LUDUM DARE 19\nCREATED BY ZACHARY LEWIS\nPRESENTED BY THE GAME STUDIO");
			Text.size = 32;
			var t3:Text = new Text("CLICK TO DEPART");
			addGraphic(t, 0, 0, 120);
			addGraphic(t2, 0, t.width - 6, 38+120);
			addGraphic(t3, 0, FP.screen.width/2 - t3.width/2, FP.screen.height*3/4 - t3.height);
			super.begin();
		}
		
		override public function update():void 
		{
			if (Input.mouseReleased)
			{
				FP.world = new UniverseWorld();
				select.play(0.1);
			}
			super.update();
		}
		
	}

}