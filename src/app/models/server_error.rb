# 独自の例外の定義
# code: エラーコード
# status: レスポンスのHTTPステータスコード
class ServerError < ServerErrorBase
  define_error :InternalServerError, code: 100, status: 500
  define_error :NotFound, code: 101, status: 404
  define_error :BadRequest, code: 102, status: 400
  define_error :MissingParameters, code: 103, status: 400
  define_error :ValidationError, code: 104, status: 400
  define_error :ExistRelatedData, code: 105, status: 400
  define_error :Forbidden, code: 106, status: 403
  define_error :Unauthorized, code: 107, status: 401
  define_error :OnlyOwnerRole, code: 108, status: 403
  define_error :RoleError, code: 109, status: 403
  define_error :ExpiredError, code: 110, status: 400
end
