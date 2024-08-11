import domain/game

import eventsourcing
import eventsourcing/memory_store

pub type Context {
  Context(
    secret_key_base: String,
    static_directory: String,
    port: Int,
    host: String,
    dev: Bool,
    event_store_game: eventsourcing.EventStore(
      memory_store.MemoryStore(
        game.Game,
        game.GameCommand,
        game.GameEvent,
        game.GameError,
      ),
      game.Game,
      game.GameCommand,
      game.GameEvent,
      game.GameError,
    ),
    eventsourcing_game: eventsourcing.EventSourcing(
      memory_store.MemoryStore(
        game.Game,
        game.GameCommand,
        game.GameEvent,
        game.GameError,
      ),
      game.Game,
      game.GameCommand,
      game.GameEvent,
      game.GameError,
      eventsourcing.AggregateContext(
        game.Game,
        game.GameCommand,
        game.GameEvent,
        game.GameError,
      ),
    ),
  )
}
