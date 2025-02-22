class Kong < Formula
  desc "Open source Microservices and API Gateway"
  homepage "https://docs.konghq.com"

  stable do
    url "https://bintray.com/kong/kong-src/download_file?file_path=kong-1.2.1.tar.gz"
    sha256 "bbbb8d91e4eab767171a803d88363d254b59b211ea64d7dd4ef13cff2a89b68a"
  end

  head do
    url "https://github.com/Kong/kong.git", :branch => "next"
  end

  depends_on "dorongold/kong/luarocks"
  depends_on "dorongold/kong/openresty"
  depends_on "libyaml"
  depends_on "openssl@1.1"

  patch :DATA

  def install
    luarocks_prefix = Formula["dorongold/kong/luarocks"].prefix
    openresty_prefix = Formula["dorongold/kong/openresty"].prefix
    openssl_prefix = Formula["openssl@1.1"].prefix

    system "#{luarocks_prefix}/bin/luarocks",
           "--tree=#{prefix}",
           "--lua-dir=#{openresty_prefix}/luajit",
           "make",
           "CRYPTO_DIR=#{openssl_prefix}",
           "OPENSSL_DIR=#{openssl_prefix}"

    bin.install "bin/kong"
  end
end

# patch Kong default `prefix` to `/usr/local/opt/kong` as `/usr/local/`
# not writable by non root user on OSX
__END__
diff --git a/kong/templates/kong_defaults.lua b/kong/templates/kong_defaults.lua
index e38b475..7a74a2f 100644
--- a/kong/templates/kong_defaults.lua
+++ b/kong/templates/kong_defaults.lua
@@ -1,5 +1,5 @@
 return [[
-prefix = /usr/local/kong/
+prefix = /usr/local/opt/kong/
 log_level = notice
 proxy_access_log = logs/access.log
 proxy_error_log = logs/error.log
