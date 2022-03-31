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

  public var data:LDTkProj_Level;

  public function new(level:LDTkProj_Level) {
    super(Game.ME);
    this.data = level;
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
    }

    // Create Blocks
    for (regBlock in data.l_Entities.all_RegBlock) {
      blocks.add(new RegBlock(regBlock.cx, regBlock.cy));
    }

    for (heavyBlock in data.l_Entities.all_HeavyBlock) {
      blocks.add(new HeavyBlock(heavyBlock.cx, heavyBlock.cy));
    }

    for (ignitionBlock in data.l_Entities.all_IgnitionBlock) {
      blocks.add(new IgnitionBlock(ignitionBlock.cx, ignitionBlock.cy));
    }

    // Create collectibles
    for (heart in data.l_Entities.all_Heart) {
      collectibles.add(new Heart(heart));
    }

    for (gem in data.l_Entities.all_Gem) {
      collectibles.add(new Gem(gem.cx, gem.cy));
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

  public function hasAnyCollision(cx:Int, cy:Int) {
    for (block in blocks) {
      if (block.cx == cx && block.cy == cy) {
        return true;
      }
    }
    return false;
  }

  public function hasAnyBlockCollision(cx:Int, cy:Int) {
    for (block in blocks) {
      if (block.cx == cx && block.cy == cy) {
        return true;
      }
    }
    return false;
  }

  public function getBlockCollision(cx:Int, cy:Int) {
    for (block in blocks) {
      if (block.cx == cx && block.cy == cy) {
        return block;
      }
    }
    return null;
  }

  public function hasExitCollision(x:Int, y:Int) {
    for (exit in exits) {
      if (exit.cx == x && exit.cy == y) {
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
      this.pause();
      new GameOver();
    }
  }

  function render() {
    // Placeholder level render
    root.removeChildren();

    // var tlGroup = data.l_Level.render();
    // root.addChild(tlGroup);
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

  override function postUpdate() {
    super.postUpdate();

    if (invalidated) {
      invalidated = false;
      render();
    }
  }

  override function onDispose() {}
}