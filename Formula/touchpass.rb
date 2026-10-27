class Touchpass < Formula
  desc "Touch ID for CLI secrets: Secure Enclave pass store and command gates"
  homepage "https://github.com/saefty/touchpass"
  url "https://github.com/saefty/touchpass/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6b9846830bbc74fa3d069d3b09e3d36c480b91d388887aad1fbc0c485f718868"
  license "MIT"

  depends_on macos: :ventura

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "touchpass"
    bin.install ".build/release/touchpass"
    # the linker's ad-hoc signature has neither hardened runtime nor a stable identifier
    system "codesign", "--force", "--sign", "-", "--identifier", "touchpass", "--options", "runtime", bin/"touchpass"
  end

  def caveats
    <<~EOS
      touchpass needs a config before it does anything:
        https://github.com/saefty/touchpass#quick-start-granted
    EOS
  end

  test do
    assert_equal "touchpass #{version}", shell_output("#{bin}/touchpass --version").strip
  end
end
