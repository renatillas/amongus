import wisp

import infrastructure/context.{type Context, Context}
import infrastructure/middleware

pub fn handle_request(request: wisp.Request, context: Context) -> wisp.Response {
  use request <- middleware.middleware(request, context)
  case wisp.path_segments(request), request.method {
    _, _ -> todo
  }
}
