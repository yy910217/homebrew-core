class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag      => "v19.03.2",
      :revision => "6a30dfca03664a0b6bf0646a7d389ee7d0318e6e"

  bottle :unneeded

  conflicts_with "docker",
    :because => "docker already includes these completion scripts"

  def install
    bash_completion.install "components/cli/contrib/completion/bash/docker"
    fish_completion.install "components/cli/contrib/completion/fish/docker.fish"
    zsh_completion.install "components/cli/contrib/completion/zsh/_docker"
  end

  test do
    assert_match "-F _docker",
      shell_output("bash -c 'source #{bash_completion}/docker && complete -p docker'")
  end
end
