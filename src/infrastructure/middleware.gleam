import infrastructure/context.{type Context}

import gleam/http
import gleam/int

import glotel/span
import glotel/span_kind
import wisp

pub fn middleware(
  request: wisp.Request,
  context: Context,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let method = http.method_to_string(request.method)
  let path = request.path
  span.extract_values(request.headers)
  use span_ctx <- span.new_of_kind(span_kind.Server, method <> " " <> path, [
    #("http.method", method),
    #("http.route", path),
  ])
  use <- wisp.serve_static(
    request,
    under: "/static",
    from: context.static_directory,
  )

  use <- wisp.log_request(request)
  use <- wisp.rescue_crashes
  use request <- wisp.handle_head(request)

  let response = handle_request(request)

  span.set_attribute(
    span_ctx,
    "http.status_code",
    int.to_string(response.status),
  )

  case response.status >= 500 {
    True -> span.set_error(span_ctx)
    _ -> Nil
  }

  response
}
