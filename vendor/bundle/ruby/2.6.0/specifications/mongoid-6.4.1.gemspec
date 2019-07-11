# -*- encoding: utf-8 -*-
# stub: mongoid 6.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "mongoid".freeze
  s.version = "6.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Durran Jordan".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDfDCCAmSgAwIBAgIBATANBgkqhkiG9w0BAQUFADBCMRQwEgYDVQQDDAtkcml2\nZXItcnVieTEVMBMGCgmSJomT8ixkARkWBTEwZ2VuMRMwEQYKCZImiZPyLGQBGRYD\nY29tMB4XDTE4MDEyNDEyMTA0NFoXDTE5MDEyNDEyMTA0NFowQjEUMBIGA1UEAwwL\nZHJpdmVyLXJ1YnkxFTATBgoJkiaJk/IsZAEZFgUxMGdlbjETMBEGCgmSJomT8ixk\nARkWA2NvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANFdSAa8fRm1\nbAM9za6Z0fAH4g02bqM1NGnw8zJQrE/PFrFfY6IFCT2AsLfOwr1maVm7iU1+kdVI\nIQ+iI/9+E+ArJ+rbGV3dDPQ+SLl3mLT+vXjfjcxMqI2IW6UuVtt2U3Rxd4QU0kdT\nJxmcPYs5fDN6BgYc6XXgUjy3m+Kwha2pGctdciUOwEfOZ4RmNRlEZKCMLRHdFP8j\n4WTnJSGfXDiuoXICJb5yOPOZPuaapPSNXp93QkUdsqdKC32I+KMpKKYGBQ6yisfA\n5MyVPPCzLR1lP5qXVGJPnOqUAkvEUfCahg7EP9tI20qxiXrR6TSEraYhIFXL0EGY\nu8KAcPHm5KkCAwEAAaN9MHswCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0O\nBBYEFFt3WbF+9JpUjAoj62cQBgNb8HzXMCAGA1UdEQQZMBeBFWRyaXZlci1ydWJ5\nQDEwZ2VuLmNvbTAgBgNVHRIEGTAXgRVkcml2ZXItcnVieUAxMGdlbi5jb20wDQYJ\nKoZIhvcNAQEFBQADggEBAGe+fX9Mff6QXWee/byuCSwPDPLYE36ejrypK5nsM2nM\ncjVNzOU8Yd9lc2D5Yq2AUJbYU0P7a6IEow7Bbt6fzBTcOGd7kVhikLRIntCW3awu\nXGVS3HiEEdF4UiWHmbejzVwYPpU7KKB5b6UzhNC6QVDp4QEGAO3eUMsPT7yXW3dU\n/OQ/YL/+tJ3zOoMkApUpmiBW57UKAqn/CotLkk52vvdOLL4OhAzzVZx9io3eHNkk\nfxN/GvhskJEgmdQToxEBRLOu5/udtPpVe/hb3gk5hzsxcWuKN/VTi4SbtFQdz9cq\nfqd6ctFDOqcJmOYdlSRgb9g8zm4BiNgFWPBSk8NsP7c=\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2018-05-03"
  s.description = "Mongoid is an ODM (Object Document Mapper) Framework for MongoDB, written in Ruby.".freeze
  s.email = ["mongodb-dev@googlegroups.com".freeze]
  s.homepage = "http://mongoid.org".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Elegant Persistence in Ruby for MongoDB.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activemodel>.freeze, [">= 5.1", "< 6.0.0"])
      s.add_runtime_dependency(%q<mongo>.freeze, [">= 2.5.1", "< 3.0.0"])
    else
      s.add_dependency(%q<activemodel>.freeze, [">= 5.1", "< 6.0.0"])
      s.add_dependency(%q<mongo>.freeze, [">= 2.5.1", "< 3.0.0"])
    end
  else
    s.add_dependency(%q<activemodel>.freeze, [">= 5.1", "< 6.0.0"])
    s.add_dependency(%q<mongo>.freeze, [">= 2.5.1", "< 3.0.0"])
  end
end
