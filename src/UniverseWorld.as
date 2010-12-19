package  
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.tweens.motion.LinearPath;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Zachary Weston Lewis
	 */
	public class UniverseWorld extends World 
	{
		private var lifespan:Number;
		private var isDragging:Boolean;
		private var theUniverse:UniverseHelper;
		private var dragPoint:Point;
		private var initialCamera:Point;
		private var currentPlanet:Planet;
		private var transitionTween:LinearMotion;
		private var hoverPlanet:Planet;
		private var lifespanText:Text;
		private var lifetime:Number;
		private var currentDistance:Number;
		private var nextPlanet:Planet;
		public function UniverseWorld() 
		{
			theUniverse = new UniverseHelper();
			transitionTween = new LinearMotion();
			lifespan = 100;
			lifetime = 0;
			currentDistance = 0;
		}
		
		override public function begin():void 
		{
			Text.size = 24;
			lifespanText = new Text("LIFE EXPECTANCY: " + (lifespan - lifetime).toFixed(1) + " YEARS",0,0,FP.screen.width);
			lifespanText.scrollX = 0;
			lifespanText.scrollY = 0;
			addGraphic(lifespanText, -1, 0, FP.screen.height - 28);
			addTween(transitionTween, false);
			var home:Planet = createPlanet(FP.screen.width / 2, FP.screen.height / 2);
			FP.camera.x = home.x - FP.screen.width/2;
			FP.camera.y = home.y - FP.screen.height/2;
			super.begin();
		}
		
		override public function update():void 
		{
			if (transitionTween.active)
			{
				FP.camera.x = transitionTween.x;
				FP.camera.y = transitionTween.y;
				lifespanText.text = "LIFE EXPECTANCY: " + (lifespan - lifetime + currentDistance * (1 - transitionTween.scale)).toFixed(1) + " YEARS";
			}
			else
			{
				updateMouse();
			}
			super.update();
		}
		
		protected function updateMouse():void
		{
			hoverPlanet = Planet(collidePoint("planet", mouseX, mouseY));
			if (Input.mousePressed)
			{
				// Start camera pan.
				dragPoint = new Point(Input.mouseX, Input.mouseY);
				initialCamera = FP.camera.clone();
				isDragging = true;
			}
			else if (Input.mouseReleased)
			{
				// End camera pan.
				isDragging = false;
				
				// Check to see if it was actually a click.
				if (FP.distance(dragPoint.x, dragPoint.y, Input.mouseX, Input.mouseY) <= GC.DISTANCE_CLICK_THRESHOLD)
				{
					trace("Click detected.");
					var clickedPlanet:Planet = Planet(collidePoint(GC.TYPE_PLANET , mouseX, mouseY));
					if (clickedPlanet)
					{
						if (currentPlanet.hasRouteTo(clickedPlanet))
						{
							nextPlanet = clickedPlanet;
							centerPlanet(currentPlanet, 1, gotoNextPlanet, Ease.cubeOut);
							currentDistance = 0;
							//setCurrentPlanet(clickedPlanet);
						}
					}
				}
			}
			
			if (isDragging)
			{
				// Handle the pan.
				FP.setCamera(initialCamera.x + dragPoint.x - Input.mouseX, initialCamera.y + dragPoint.y - Input.mouseY);
			}
		}
		
		private function gotoNextPlanet():void
		{
			centerPlanet(nextPlanet, 2.5, completeTravel, null);
			currentDistance = FP.distance(currentPlanet.x, currentPlanet.y, nextPlanet.x, nextPlanet.y) / GC.SCALE_LIGHTYEARS;
			lifetime += currentDistance;
		}
		
		private function completeTravel():void
		{
			 setCurrentPlanet(nextPlanet);
		}
		
		public function setCurrentPlanet(p:Planet):void
		{
			if (currentPlanet != null)
			{
				Image(currentPlanet.graphic).color = 0xffffff;
				
			}
			currentPlanet = p;
			currentPlanet.linesTween.start();
			Image(currentPlanet.graphic).color = GC.COLOR_CURRENT_PLANET;
			//centerPlanet(currentPlanet, 5);
			if (!currentPlanet.isVisited)
			{
				// It's our first time here! Sweet!
				currentPlanet.visit();
				var initialPlanets:uint = FP.rand(7) + FP.rand(3);
				for (var i:uint = 0; i < initialPlanets; i++)
				{
					currentPlanet.addRoute(createPlanet(currentPlanet.x, currentPlanet.y));
				}
				
			}
			
			trace("setCurrentPlanet");
		}
		
		public function centerPlanet(p:Planet, t:Number = 1, callback:Function = null, easing:Function = null):void
		{
			transitionTween.complete = callback;
			transitionTween.setMotion(FP.camera.x, FP.camera.y, (p.x + p.halfWidth) - FP.screen.width / 2, (p.y + p.halfHeight) - FP.screen.height / 2, t, easing);
			transitionTween.start();
		}
		
		public function createPlanet(x:int, y:int):Planet
		{
			var newName:String = UniverseHelper.generateRandomString(8);
			while (theUniverse.itemList[newName] is Planet)
			{
				newName = UniverseHelper.generateRandomString(8);
			}
			var newDistance:int = FP.rand(GC.DISTANCE_MAX_NEW_PLANET - GC.DISTANCE_MIN_NEW_PLANET) + GC.DISTANCE_MIN_NEW_PLANET;
			var newAngle:Number = FP.random * 2 * Math.PI;
			
			var newPlanet:Planet = new Planet(newName, newDistance * Math.cos(newAngle), newDistance * Math.sin(newAngle));
			if (collideRect(GC.TYPE_PLANET,newPlanet.x, newPlanet.y, newPlanet.width, newPlanet.height) != null)
			{
				// If we hit another planet, not a good planet.
				return null;
			}
			else
			{
				theUniverse.addPlanet(newPlanet);
				if (currentPlanet == null)
				{
					setCurrentPlanet(newPlanet);
				}
				add(newPlanet);
				return newPlanet;
			}
		}
		
		override public function render():void 
		{
			if (hoverPlanet != null)
			{
				hoverPlanet.drawName();
			}
			currentPlanet.drawRoutes();
			currentPlanet.drawName(GC.COLOR_CURRENT_PLANET);
			super.render();
		}
		
	}

}