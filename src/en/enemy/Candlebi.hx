package en.enemy;

/**
 * Enemy that walks side to side within the game
 * and will make the exploding boxes detonate
 * when they walk into them.
 */
class Candlebi extends Enemy {
  public static inline var MOVE_SPD:Float = .1;

  /**
   * Whether the enemy should flip their direction or not.
   * This value is set to 1 or - 1.
   */
  public var flip:Int = 1;

  override function setupGraphics() {
    var g = this.spr.createGraphics();
    g.beginFill(0xff0000);
    var size = Const.GRID;
    g.drawRect(0, 0, size, size);
    g.endFill();
    g.y -= 8;
  }

  override function update() {
    super.update();
    handleMovement();
  }

  override function onPreStepX() {
    super.onPreStepX();

    if (level.hasAnyCollision(cx + 1,
      cy - 1) && xr >= 0.7) // Handle squash and stretch for entities in the game
    {
      xr = 0.5;
      dx = 0;
      setSquashY(0.6);
      flipX();
    }

    if (level.hasAnyCollision(cx - 1, cy - 1) && xr <= 0.3) {
      xr = 0.3;
      dx = 0;
      setSquashY(0.6);
      flipX();
    }
  }

  override function onPreStepY() {
    super.onPreStepY();

    if (level.hasAnyCollision(cx, cy)
      && yr >= 0.5
      || level.hasAnyCollision(cx + M.round(xr), cy)
      && yr >= 0.5) {
      // Handle squash and stretch for entities in the game
      if (level.hasAnyCollision(cx, cy + M.round(yr + 0.3))) {
        // setSquashY(0.6);
        dy = 0;
      }
      yr = 0.5;
      dy = 0;
    }
  }

  public function handleMovement() {
    dx = MOVE_SPD;
  }

  public function flipX() {
    flip *= -1;
  }
}