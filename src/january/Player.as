package january
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		
		[Embed(source="../assets/art/player.png")] private var sprite:Class;
		
		public var boundsLeft : int;
		public var boundsRight : int;
		
		public var scrollLeft: int;
		public var scrollRight: int;
		
		public var tongueBox: FlxSprite;
		
		protected var _tongueUp: Boolean;
		
		public function Player()
		{
			x = PlayState.startingX + 25; y = 79;
			
			super(x, y);
			loadGraphic(sprite, false, true, 16, 33);
			maxVelocity.x = 25;
			
			width    = 8;
			height   = 31;
			offset.x = 3;
			offset.y = 2;
			
			tongueBox = new FlxSprite().makeGraphic(8,1);
			tongueBox.visible = false;
			
			// Set player's x position bounds
			boundsLeft = 10;
			boundsRight = FlxG.width - frameWidth;
			
			// Add animations.
			addAnimation("idle", [19,16,18,17,15,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], 6);
			addAnimation("tongueUp", [1, 2], 12, false);
			addAnimation("tongueDown", [1, 0], 12, false);
			addAnimation("walk", [6, 7, 8, 9, 10, 3, 4, 5], 6);
			addAnimation("walkTongue", [11, 12, 13, 20, 21, 22, 23, 24], 6);
		}
		
		public function onOverlap(SnowRef: Snowflake, PlayerRef: Player):void
		{
			var pressedUpKey:Boolean = FlxG.keys.UP || FlxG.keys.W;
			if (!pressedUpKey)
				SnowRef.onIncidental();
		}
		
		public function get tongueUp():Boolean
		{
			return _tongueUp;
		}
		
		override public function update():void
		{			
			//////////////
			// MOVEMENT //
			//////////////
			
			var pressedUpKey:Boolean = FlxG.keys.UP || FlxG.keys.W;
			var pressedLeftKey:Boolean = FlxG.keys.LEFT || FlxG.keys.A;
			var pressedRightKey:Boolean = FlxG.keys.RIGHT || FlxG.keys.D;
			var releasedLeftRightKey:Boolean = FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("RIGHT") || FlxG.keys.justReleased("A") || FlxG.keys.justReleased("D");
			var releasedUpKey:Boolean = FlxG.keys.justReleased("UP") || FlxG.keys.justReleased("W");
			
			if (pressedLeftKey)
			{	
				facing = LEFT;
				velocity.x = -maxVelocity.x;
			}
			else if (pressedRightKey)
			{
				facing = RIGHT;
				velocity.x = maxVelocity.x;
			}
			else if (releasedLeftRightKey)
				velocity.x = 0;
			else
				velocity.x = 0;
			
			///////////////
			// ANIMATION //
			///////////////
			
			if (velocity.x != 0)	
			{				
				if (pressedUpKey)					
					play("walkTongue");					
				else					
					play("walk");				
			}				
			else				
			{       				
				if (pressedUpKey)					
				{					
					// Skip to frame to smooth out the transition.					
					if (releasedLeftRightKey)						
						frame = 2;						
					else if (frame != 2)						
						play("tongueUp");					
				}					
				else if (releasedUpKey)					
				{					
					// Chain together two animations.					
					play("tongueDown");					
					if (finished) play("idle");					
				}					
				else if (releasedLeftRightKey)					
					play("idle");				
			}			
			
			// TONGUE-TOGGLING CODE.
//			if (velocity.x != 0) // if moving
//			{
//				if (_tongueUp == false && releasedUpDownKey == true)
//				{
//					play("walkTongue");
//					_tongueUp = true;
//				}	
//				else if (_tongueUp == true && releasedUpDownKey == true)
//				{
//					play("walk");
//					_tongueUp = false;
//				}
//				else if (_tongueUp == false && releasedUpDownKey == false)
//					play("walk");
//				else if (_tongueUp == true && releasedUpDownKey == false)
//					play("walkTongue");
//			}
//			else // not moving
//			{	
//				if (_tongueUp == false && releasedUpDownKey == true)
//				{
//					play("tongueUp");	
//					_tongueUp = true;
//				}
//				else if (_tongueUp == true && releasedUpDownKey == true)//(FlxG.keys.justReleased("UP") || FlxG.keys.justReleased("W"))
//				{
//					play("tongueDown");
//					if (finished) play("idle");
//					_tongueUp = false;
//				}
//				else if (_tongueUp == true && releasedUpDownKey == false && releasedLeftRightKey == true)
//					frame = 2;
//				else if (releasedLeftRightKey == true)
//				{
//					play("idle");
//					_tongueUp = false;
//				}	
//			}
			
			super.update();
			
			////////////////
			// COLLISIONS //
			////////////////
			
			// Update scrolling boundaries.
			scrollLeft	= PlayState.camera.scroll.x + boundsLeft;
			scrollRight = PlayState.camera.scroll.x + boundsRight;
		
			if (x < scrollLeft)
				x = scrollLeft;
			else if (x > scrollRight)
				x = scrollRight;
			
			if (facing == RIGHT)
			{
				tongueBox.x = this.x + 1;
				tongueBox.y = this.y + 4;
			}	
			else // facing == LEFT
			{
				tongueBox.x = this.x + 1;
				tongueBox.y = this.y + 4;
			}
			
		}
		
	}
	
}