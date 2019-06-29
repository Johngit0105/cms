# Be sure to restart your server when you modify this file.

Rails.application.config.public_file_server.enabled = true

Rails.application.config.public_file_server.headers = {
  'Access-Control-Allow-Methods' => 'get',
  'Access-Control-Allow-Origin' => '*',
  'Access-Control-Max-Age' => '600',
  'Cache-Control' => "public, max-age=#{Integer(1.year)}"
}
