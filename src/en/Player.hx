package en;

import dn.legacy.Controller.ControllerAccess;

/**
 * Player class
 * that allows us to move around in the game world.
 */
class Player extends BaseEnt {
  public var ct:ControllerAccess;
  public var listener:EventListener<Player>;

  public static inline var INVINCIBLE_TIME:Float = 3;

  public static inline var MOVE_SPD:Float = .3;
  public static inline var JUMP_FORCE:Float = 1;

  public var isInvincible(get, null):Bool;

  public inline function get_isInvincible() {
    return cd.has('invincibleTime');
  }

  public function new(x:Int, y:Int) {
    super(x, y);
    setup();
  }

  public function setup() {
    ct = Main.ME.controller.createAccess('player');
    listener = EventListener.create();

    setupStats();
    setupGraphic();
  }

  public function setupStats() {
    this.health = 3;
  }

  public function setupGraphic() {
    var g = this.spr.createGraphics();
    var size = 16;
    g.beginFill(0xffff00);
    g.drawRect(0, 0, size, size);
    g.endFill();
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

  override function update() {
    super.update();
    updateInvincibility();
    updateCollisions();
    handleMovement();
  }

  public function handleMovement() {
    var left = ct.leftDown();
    var right = ct.rightDown();
    var up = ct.upDown();

    if (left || right || up) {
      if (left) {
        dx = -MOVE_SPD;
      } else if (right) {
        dx = MOVE_SPD;
      }

      if (up) {
        dy = JUMP_FORCE;
      }
    }
  }

  /**
   * Updates the invincibility of the sprite
   * using the blinking capability.
   */
  public function updateInvincibility() {
    if (isInvincible) {
      // spr.alpha = 1;
      if (!cd.has('invincible')) {
        cd.setF('invincible', 5, () -> {
          spr.alpha = 0;
        });
      } else {
        spr.alpha = 1;
      }
    } else {
      spr.alpha = 1;
    }
  }

  public function updateCollisions() {
    if (level != null) {
      collideWithEnemy();
      collideWithCollectible();
      collideWithExit();
    }
  }

  public function collideWithEnemy() {}

  public function collideWithCollectible() {}

  public function collideWithExit() {}

  override function takeDamage(value:Int = 1) {
    // Shake camera when the player takes damage.
    if (!isInvincible) {
      Game.ME.camera.shakeS(0.5, 0.5);
      super.takeDamage(value);
      cd.setS('invincibleTime', INVINCIBLE_TIME);
      this.knockback();
      // Play Damage Sound
      Assets.damageSnd.play();
    }
  }
}