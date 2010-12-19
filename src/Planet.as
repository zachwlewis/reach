package  
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import flash.display.BlendMode;
	
	/**
	 * ...
	 * @author Zachary Weston Lewis
	 */
	public class Planet extends Entity 
	{
		// Protected
		protected var routes:Vector.<Planet>;
		
		
		// Public
		public var planetName:String;
		public var isVisited:Boolean;
		
		public function Planet(name:String, x:int, y:int) 
		{
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
				Draw.linePlus(x + halfWidth, y + halfHeight, planet.x + planet.halfHeight, planet.y + planet.halfWidth, GC.COLOR_AVAILABLE_ROUTE);
			}
		}
		
		public function center():void
		{
			FP.camera.x = (x + halfWidth) - FP.screen.width / 2;
			FP.camera.y = (y + halfHeight) - FP.screen.height / 2;
		}
		
	}

}