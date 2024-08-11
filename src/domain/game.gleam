pub const default = UninitializedGame

pub type Game {
  UninitializedGame
  Game
}

pub type GameCommand {
  CreateOrder
  ConfirmOrder
  PayOrder
  CancelOrder
}

pub type GameEvent {
  OrderCreated
  OrderConfirmed
  OrderPaid
  OrderCancelled
}

pub type GameError

pub fn handle(
  game: Game,
  command: GameCommand,
) -> Result(List(GameEvent), GameError) {
  todo
}

pub fn apply(game: Game, event: GameEvent) -> Game {
  todo
}
