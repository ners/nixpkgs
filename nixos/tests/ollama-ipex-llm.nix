{ lib, ... }:
{
  name = "ollama-ipex-llm";
  meta.maintainers = with lib.maintainers; [ ners ];

  nodes.ollama =
    { ... }:
    {
      services.ollama.enable = true;
      services.ollama.acceleration = "ipex-llm";
    };

  testScript = ''
    ollama.wait_for_unit("multi-user.target")
    ollama.wait_for_open_port(11434)
  '';
}
