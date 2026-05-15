class Clew < Formula
  desc "A lightweight, local, git-native project tracker for humans and agents."
  homepage "https://github.com/npatten/Clew"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/npatten/Clew/releases/download/v0.1.3/clew-aarch64-apple-darwin.tar.xz"
      sha256 "b1b008985294d9f70262d4a2245aa264a2baf37b772f7acaa543e2d7e924b74b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/npatten/Clew/releases/download/v0.1.3/clew-x86_64-apple-darwin.tar.xz"
      sha256 "31feb98a1475cb8f2c643d6c8b2226077df20e39793b6aaf87fa0a5efdaac23d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/npatten/Clew/releases/download/v0.1.3/clew-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "6b946c29cec77967e12c913af6b9a447a733978e00f93662fe22b7222f761dc6"
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
