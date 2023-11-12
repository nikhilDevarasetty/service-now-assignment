require 'openssl'

# ca controller
class CaController < ApplicationController
  def expiration
    server_cert = OpenSSL::X509::Certificate.new(File.read('server_cert.pem'))

    render json: { expiration_date: server_cert.not_after.to_s }
  end
end
