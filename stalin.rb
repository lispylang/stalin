class Stalin < Formula
  desc "Optimizing Scheme compiler with aggressive compile-time optimizations"
  homepage "https://github.com/celicoo/stalin"
  url "https://github.com/celicoo/stalin/archive/refs/heads/master.tar.gz"
  version "0.11-arm64"
  sha256 :no_check # Will be updated when proper release is created

  depends_on "gcc"
  depends_on "docker"

  def install
    # Build the Docker environment
    system "./docker-build.sh"

    # Install using the Makefile
    system "make", "install", "PREFIX=#{prefix}"

    # Install documentation
    (share/"doc/stalin").install "DEVELOPMENT.md", "README.md" if File.exist?("README.md")

    # Install examples
    (share/"stalin/examples").install "benchmarks/"
  end

  def caveats
    <<~EOS
      Stalin has been installed with Docker integration for ARM64/Apple Silicon.

      To compile Scheme programs:
        stalin yourfile.sc

      Example programs are available in:
        #{HOMEBREW_PREFIX}/share/stalin/examples/

      Documentation:
        #{HOMEBREW_PREFIX}/share/doc/stalin/

      Note: First compilation may take a few minutes to download Docker images.
    EOS
  end

  test do
    # Create a simple test program
    (testpath/"test.sc").write("(display \"Hello from Stalin!\")(newline)")

    # Test compilation
    system "#{bin}/stalin", "test.sc"
    assert_predicate testpath/"test", :exist?

    # Test execution
    output = shell_output("#{testpath}/test")
    assert_match "Hello from Stalin!", output
  end
end