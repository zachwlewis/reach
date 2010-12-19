package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.utils.Draw;
	import flash.display.BlendMode;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Zachary Weston Lewis
	 */
	public class Planet extends Entity 
	{
		// Protected
		protected var routes:Vector.<Planet>;
		protected var numTween:NumTween;
		protected var nameText:Text;
		
		
		// Public
		public var planetName:String;
		public var isVisited:Boolean;
		
		public function Planet(name:String, x:int, y:int) 
		{
			numTween = new NumTween();
			numTween.tween(0, 1, 1);
			addTween(numTween, true);
			routes = new Vector.<Planet>();
			planetName = name;
			isVisited = false;
			this.x = x;
			this.y = y;
			var size:int = (5 + FP.rand(48)) * 2;
			var bmd:BitmapData = new BitmapData(size+1, size+1, true, 0);
			// Draw our planet. It's going to be fucking awesome.
			Draw.setTarget(bmd);
			Draw.circlePlus(size / 2, size / 2, size / 2, 0xffffff, 1, true);
			var g:Image = new Image(bmd);
			Text.size = 24;
			nameText = new Text(name);
			nameText.x = -nameText.width;
			nameText.y = -24;
			graphic = g;
			width = size;
			height = size;
			type = GC.TYPE_PLANET;
			trace("Planet " + planetName + " created.");
		}
		
		public function visit():void
		{
			isVisited = true;
		}
		
		public function addRoute(p:Planet):void
		{
			if (p != null)
			{
				// If we already know this planet, we're done!
				var isKnown:Boolean = false;
				for each(var planet:Planet in routes)
				{
					if (p == planet)
					{
						isKnown = true;
						break;
					}
				}
				
				// If we don't know it, add it.
				if (!isKnown)
				{
					routes.push(p);
					p.addRoute(this);
				}
			}
		}
		
		public function hasRouteTo(p:Planet):Boolean
		{
			var routeExists:Boolean = false;
			for each(var planet:Planet in routes)
			{
				if (planet == p)
				{
					routeExists = true;
					break;
				}
			}
			return routeExists;
		}
		
		public function drawRoutes():void
		{
			// Set to the default buffer.
			Draw.resetTarget();
			
			// Draw our routes.
			for each(var planet:Planet in routes)
			{
				Draw.linePlus(x + halfWidth, y + halfHeight, planet.x + planet.halfHeight, planet.y + planet.halfWidth, GC.COLOR_AVAILABLE_ROUTE, numTween.value);
			}
		}
		
		public function drawName(c:uint = 0xffffff):void
		{
			nameText.color = c;
			nameText.render(FP.buffer, new Point(x, y), FP.camera);
		}
		
		override public function update():void 
		{
			Image(graphic).alpha = numTween.value;
			super.update();
		}
		
		public function center():void
		{
			FP.camera.x = (x + halfWidth) - FP.screen.width / 2;
			FP.camera.y = (y + halfHeight) - FP.screen.height / 2;
		}
		
	}

}