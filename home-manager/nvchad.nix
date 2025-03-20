{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nvchad4nix.homeManagerModule
  ];

  programs = {
    nvchad = {
      enable = true;
      extraPackages = with pkgs; [
        nixd
      ];
      extraConfig = ''
        -- Setup LSP (nixd)
        require("lspconfig").nixd.setup {}
      '';
    };
  };
}
