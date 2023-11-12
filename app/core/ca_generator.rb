require 'openssl'

# CA generator
class CaGenerator
  class << self
    def generate_certificates
      ca_key, ca_cert = generate_certificate_authority
      File.write('ca_key.pem', ca_key.to_pem)
      File.write('ca_cert.pem', ca_cert.to_pem)

      server_key, server_cert = generate_server_certificate(ca_key, ca_cert)
      File.write('server_key.pem', server_key.to_pem)
      File.write('server_cert.pem', server_cert.to_pem)
    end

    private

    def generate_certificate_authority
      key = OpenSSL::PKey::RSA.new(2048)
      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.serial = 1
      cert.subject = cert.issuer = OpenSSL::X509::Name.parse('/C=US/ST=State/L=City/O=Organization/OU=CA/CN=CA')
      cert.public_key = key.public_key
      cert.not_before = Time.now
      cert.not_after = 1.week.from_now
      cert.sign(key, OpenSSL::Digest.new('SHA256'))

      [key, cert]
    end

    def generate_server_certificate(ca_key, ca_cert)
      key = OpenSSL::PKey::RSA.new(2048)
      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.serial = 2
      cert.subject = OpenSSL::X509::Name.parse('/C=US/ST=State/L=City/O=Organization/OU=Server/CN=localhost')
      cert.issuer = ca_cert.subject
      cert.public_key = key.public_key
      cert.not_before = Time.now
      cert.not_after = 1.week.from_now
      cert.sign(ca_key, OpenSSL::Digest.new('SHA256'))

      [key, cert]
    end
  end
end
