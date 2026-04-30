class Clew < Formula
  desc "A lightweight, local, git-native project tracker for humans and agents."
  homepage "https://github.com/npatten/Clew"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/npatten/Clew/releases/download/v0.1.0/clew-aarch64-apple-darwin.tar.xz"
      sha256 "b5d65fd854f150c0c33f5937475b6154cb1e5e1cbd463450ae88a70faca94c1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/npatten/Clew/releases/download/v0.1.0/clew-x86_64-apple-darwin.tar.xz"
      sha256 "650ef2c89e1ffd594ea44610c664e35d69fcd22738a7544e46f17dd608a4e4b7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/npatten/Clew/releases/download/v0.1.0/clew-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3fcc25f039dfc8ac99cfe0197097eea84fbd19712aad23f2b13e82a0aedc2b73"
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
