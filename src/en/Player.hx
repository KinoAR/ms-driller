package en;

import dn.legacy.Controller.ControllerAccess;

/**
 * Player class
 * that allows us to move around in the game world.
 */
class Player extends BaseEnt {
  public var ct:ControllerAccess;
  public var listener:EventListener<Player>;

  public function new(x:Int, y:Int) {
    super(x, y);
    setup();
  }

  public function setup() {
    ct = Main.ME.controller.createAccess('player');
    listener = EventListener.create();

    setupStats();
  }

  public function setupStats() {
    this.health = 3;
  }

  override function onPreStepX() {
    super.onPreStepX();
  }

  override function onPreStepY() {
    super.onPreStepY();
    if (level.hasAnyCollision(cx, cy + 1)
      && yr >= 0.5
      || level.hasAnyCollision(cx + M.round(xr), cy + 1)
      && yr >= 0.5) {
      // Handle squash and stretch for entities in the game
      if (level.hasAnyCollision(cx, cy + M.round(yr + 0.3))) {
        setSquashY(0.6);
        dy = 0;
      }
      yr = 0.3;
      dy = 0;
    }

    if (level.hasAnyCollision(cx, cy + 1)) {
      // setSquashY(0.6);
      yr = -0.1;
      dy = -0.1;
    }

    if (level.hasAnyCollision(cx, cy - 1)) {
      yr = 1.01;
      dy = .1;
      // setSquashY(0.6);
    }
  }

  public function handleMovement() {}
}