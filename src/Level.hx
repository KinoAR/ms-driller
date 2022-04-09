import en.blocks.StaticBlock;
import en.collectibles.SilverGem;
import en.collectibles.RubyGem;
import en.enemy.Candlebi;
import h2d.Bitmap;
import hxd.Timer;
import en.collectibles.Gem;
import en.blocks.HeavyBlock;
import en.blocks.IgnitionBlock;
import en.blocks.RegBlock;
import en.blocks.Block;
import en.collectibles.Heart;
import en.hazards.Exit;
import scn.GameOver;
import scn.Pause;
import en.Player;
import en.Enemy;
import en.Collectible;

class Level extends dn.Process {
  var game(get, never):Game;

  inline function get_game()
    return Game.ME;

  var fx(get, never):Fx;

  inline function get_fx()
    return Game.ME.fx;

  /** Level grid-based width**/
  public var cWid(get, never):Int;

  inline function get_cWid()
    return 16;

  /** Level grid-based height **/
  public var cHei(get, never):Int;

  inline function get_cHei()
    return 16;

  /** Level pixel width**/
  public var pxWid(get, never):Int;

  inline function get_pxWid()
    return cWid * Const.GRID;

  /** Level pixel height**/
  public var pxHei(get, never):Int;

  inline function get_pxHei()
    return cHei * Const.GRID;

  var invalidated = true;

  public var scnPause:Pause;

  public var collectibles:Group<Collectible>;
  public var enemies:Group<Enemy>;
  public var blocks:Group<Block>;

  public var exits:Group<Exit>;

  public var player:Player;

  public var score:Int;
  public var highScore:Int;
  public var timer:Float;
  public var bg:h2d.Graphics;

  public var data:LDTkProj_Level;

  public function new(level:LDTkProj_Level) {
    super(Game.ME);
    this.data = level;
    this.score = 0;
    this.highScore = 0;
    this.timer = 0;
    var bgTile = hxd.Res.img.BGLarge.toTile();
    bg = new h2d.Graphics(root);
    bg.tileWrap = true;
    bg.tile = bgTile;

    // bg.width = game.w();
    // bg.height = game.h();

    createRootInLayers(Game.ME.scroller, Const.DP_BG);
    createGroups();
    createEntities();
  }

  public function createGroups() {
    collectibles = new Group<Collectible>();
    blocks = new Group<Block>();
    enemies = new Group<Enemy>();
    exits = new Group<Exit>();
  }

  public function createEntities() {
    // Create Player

    for (ePlayer in data.l_Entities.all_Player) {
      player = new Player(ePlayer.cx, ePlayer.cy);
      game.camera.trackEntity(player, true);
    }

    // Create Enemies
    for (eCandlebi in data.l_Entities.all_Candlebi) {
      var lCandlebi = new Candlebi(eCandlebi.cx, eCandlebi.cy);
      enemies.add(lCandlebi);
    }

    // Create Blocks
    for (cx in 0...data.l_IEntityGrid.cWid) {
      for (cy in 0...data.l_IEntityGrid.cHei) {
        var tileInt = data.l_IEntityGrid.getInt(cx, cy);
        trace(tileInt);
        switch (tileInt) {
          // Regular Block
          case 3:
            blocks.add(new RegBlock(cx, cy));
          // Static Block
          case 4:
            blocks.add(new StaticBlock(cx, cy));
          // Steel Block
          case 5:
            blocks.add(new HeavyBlock(cx, cy));
          // Ignition Block
          case 6:
            blocks.add(new IgnitionBlock(cx, cy));
        }
      }
    }

    // Create collectibles
    for (heart in data.l_Entities.all_Heart) {
      collectibles.add(new Heart(heart));
    }

    for (gem in data.l_Entities.all_Gem) {
      collectibles.add(new Gem(gem.cx, gem.cy));
    }

    for (rGem in data.l_Entities.all_RubyGem) {
      collectibles.add(new RubyGem(rGem.cx, rGem.cy));
    }

    for (sGem in data.l_Entities.all_SilverGem) {
      collectibles.add(new SilverGem(sGem.cx, sGem.cy));
    }

    // Create Hazards
    for (exit in data.l_Entities.all_Exit) {
      exits.add(new Exit(exit.cx, exit.cy));
    }
  }

  /** TRUE if given coords are in level bounds **/
  public inline function isValid(cx, cy)
    return cx >= 0 && cx < cWid && cy >= 0 && cy < cHei;

  /** Gets the integer ID of a given level grid coord **/
  public inline function coordId(cx, cy)
    return cx + cy * cWid;

  /** Ask for a level render that will only happen at the end of the current frame. **/
  public inline function invalidate() {
    invalidated = true;
  }

  public function getCollectible(cx:Int, cy:Int) {
    for (collectible in collectibles) {
      if (collectible.cx == cx && collectible.cy == cy && collectible.isAlive()) {
        return collectible;
      }
    }
    return null;
  }

  public function hasAnyCollision(cx:Int, cy:Int) {
    // 1 Standds for Floor in LDTK Int grid layer
    if (data.l_LevelIGrid.getInt(cx, cy) == 1) {
      return true;
    }
    for (block in blocks) {
      if (block.cx == cx && block.cy == cy && block.isAlive()) {
        return true;
      }
    }
    return false;
  }

  public function hasAnyBlockCollision(cx:Int, cy:Int) {
    for (block in blocks) {
      if (block.cx == cx && block.cy == cy && block.isAlive()) {
        return true;
      }
    }
    return false;
  }

  public function getBlockCollision(cx:Int, cy:Int) {
    for (block in blocks) {
      if (block.cx == cx && block.cy == cy && block.isAlive()) {
        return block;
      }
    }
    return null;
  }

  /**
   * Handles enemy collision.
   * Can use type is to separate into
   * what happens against different types of enemies.
   * @param cx 
   * @param cy 
   */
  public function getEnemyCollision(cx:Int, cy:Int) {
    for (enemy in enemies) {
      if (enemy.cx == cx && enemy.cy == cy && enemy.isAlive()) {
        return enemy;
      }
    }
    return null;
  }

  public function hasExitCollision(x:Int, y:Int) {
    for (exit in exits) {
      if (exit.cx == x && exit.cy == y && exit.isAlive()) {
        return true;
      }
    }
    return false;
  }

  /**
   * Handles pausing the game
   */
  public function handlePause() {
    if (game.ca.isKeyboardPressed(K.ESCAPE)) {
      Assets.pauseIn.play();
      this.pause();
      scnPause = new Pause();
    }
  }

  public function handleGameOver() {
    if (player.isDead()) {
      game.deathCount += 1;
      this.pause();
      new GameOver();
    }
  }

  function render() {
    // Placeholder level render
    root.removeChildren();

    root.addChild(bg);
    // bg.tile.dx += timer * 10;
    // Parallax Scroll
    bg.beginTileFill(bg.tile);
    var xStep = Std.int(game.w() / bg.tile.width);
    var yStep = Std.int(game.h() / bg.tile.height);
    var size = bg.tile.width;
    for (x in 0...xStep) {
      for (y in 0...yStep) {
        bg.drawTile(x * size, y * size, bg.tile);
      }
    }
    bg.endFill();
    var scroll = Math.abs(Math.cos(timer));
    var scroller = Timer.elapsedTime * 20;
    bg.tile.scrollDiscrete(scroller * -1, scroller);
    var tlGroup = data.l_LevelIGrid.render();
    tlGroup.y += 16;
    root.addChild(tlGroup);
    // for (cx in 0...cWid)
    //   for (cy in 0...cHei) {
    //     var g = new h2d.Graphics(root);
    //     if (cx == 0
    //       || cy == 0
    //       || cx == cWid - 1
    //       || cy == cHei - 1) g.beginFill(0xffcc00); else
    //       g.beginFill(Color.randomColor(rnd(0, 1), 0.5, 0.4));
    //     g.drawRect(cx * Const.GRID, cy * Const.GRID, Const.GRID, Const.GRID);
    //   }
  }

  override function update() {
    super.update();
    updateTimer();
    handlePause();
    handleGameOver();
  }

  public function updateTimer() {
    timer += Timer.elapsedTime;
    game.invalidateHud();
  }

  override function postUpdate() {
    super.postUpdate();
    invalidate();
    if (invalidated) {
      invalidated = false;
      render();
    }
  }

  override function onDispose() {
    player.dispose();

    for (block in blocks) {
      block.destroy();
    }

    for (collectible in collectibles) {
      collectible.destroy();
    }

    for (enemy in enemies) {
      enemy.destroy();
    }
  }
}