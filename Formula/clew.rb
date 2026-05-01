class Clew < Formula
  desc "A lightweight, local, git-native project tracker for humans and agents."
  homepage "https://github.com/npatten/Clew"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/npatten/Clew/releases/download/v0.1.1/clew-aarch64-apple-darwin.tar.xz"
      sha256 "52790274b96aeb217662d931413b980589cac8f6845240cc1c89eb4d43629c6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/npatten/Clew/releases/download/v0.1.1/clew-x86_64-apple-darwin.tar.xz"
      sha256 "22caa3158d5ab2421a0e85ece37e32c698d8cdab605f68eb0ae04507f7c0c007"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/npatten/Clew/releases/download/v0.1.1/clew-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "17299d3c558e0806c48686d56c9638620355117d974b4c7646eb4721a9edf9a3"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "clew" if OS.mac? && Hardware::CPU.arm?
    bin.install "clew" if OS.mac? && Hardware::CPU.intel?
    bin.install "clew" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
