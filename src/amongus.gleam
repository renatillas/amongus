import domain/game
import infrastructure/context.{type Context, Context}
import infrastructure/router

import dot_env as dot
import dot_env/env
import eventsourcing
import eventsourcing/memory_store
import gleam/erlang/process
import gleam/int
import gleam/result
import logging
import mist
import radiate
import wisp

pub fn main() {
  wisp.configure_logger()
  logging.set_level(logging.Info)

  let secret_key_base = wisp.random_string(64)

  load_env_variables()
  let assert Ok(app_port) = env.get_string("APP_PORT")
  let assert Ok(host) = env.get_string("APP_HOST")
  let assert Ok(dev) = env.get_bool("DEV")
  wisp.log_info("Env variables loaded")

  let #(eventsourcing_game, event_store_game) = eventsourcing_order_setup()

  let context =
    Context(
      static_directory: static_directory(),
      secret_key_base:,
      port: app_port |> int.parse() |> result.unwrap(42_069),
      host:,
      dev:,
      eventsourcing_game:,
      event_store_game:,
    )

  hot_reload(context)

  run_server(context)
}

fn hot_reload(context: Context) {
  case context.dev {
    True -> {
      let _ =
        radiate.new()
        |> radiate.add_dir(".")
        |> radiate.start()
      Nil
    }
    False -> Nil
  }
}

fn load_env_variables() -> Nil {
  wisp.log_info("Loading env variables...")
  dot.load_default()
}

fn static_directory() {
  let assert Ok(private_directory) = wisp.priv_directory("amongus")
  private_directory <> "/static"
}

fn run_server(context: context.Context) {
  wisp.log_info("Preparing to run the server...")
  let assert Ok(_) =
    router.handle_request(_, context)
    |> wisp.mist_handler(context.secret_key_base)
    |> mist.new
    |> mist.port(context.port)
    |> mist.start_http

  process.sleep_forever()
  Ok(Nil)
}

fn eventsourcing_order_setup() {
  let event_store_order =
    memory_store.new(game.default, game.handle, game.apply)
  #(eventsourcing.new(event_store_order, []), event_store_order)
}
