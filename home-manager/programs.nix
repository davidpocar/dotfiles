{ pkgs, ... }:

{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        # LSP support
        nvim-lspconfig

        # Auto-completion
        nvim-cmp
        cmp-nvim-lsp
        luasnip
        cmp_luasnip

        # Code formatting
        conform-nvim

        # Diagnostics UI
        telescope-nvim
        trouble-nvim

        # File explorer
        nerdtree

        # Git integration
        gitsigns-nvim
      ];
      extraPackages = with pkgs; [
        nixd # Use nixd as the Nix LSP
        nixfmt-rfc-style # Use nixfmt-rfc-style instead of nixfmt
        git # Ensure git is installed
      ];
      extraConfig = ''
        lua << EOF
        -- Setup LSP (nixd)
        require("lspconfig").nixd.setup {}

        -- Setup auto-completion
        local cmp = require("cmp")
        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" }
          })
        })

        -- Setup code formatting
        require("conform").setup({
          formatters = {
            nixfmt_rfc = {
              command = "nixfmt-rfc-style",
              stdin = true,
            },
          },
          formatters_by_ft = {
            nix = { "nixfmt_rfc" }
          }
        })

        -- Setup diagnostics UI
        require("telescope").setup {
          defaults = {
            file_ignore_patterns = { "node_modules", ".git" },
            path_display = { "truncate" },
            layout_strategy = "horizontal",
          },
          pickers = {
            find_files = {
              cwd = vim.fn.expand('%:p:h') -- Open in the current file's directory
            },
            live_grep = {
              cwd = vim.fn.expand('%:p:h')
            }
          }
        }
        require("trouble").setup {}

        -- Setup Git integration
        require("gitsigns").setup {
          signs = {
            add          = { text = "│" },
            change       = { text = "│" },
            delete       = { text = "_" },
            topdelete    = { text = "‾" },
            changedelete = { text = "~" },
          },
          numhl = false,
          linehl = false,
          watch_gitdir = {
            interval = 1000,
            follow_files = true
          },
          attach_to_untracked = true,
        }

        -- Setup NERDTree to open in the current project directory
        vim.g.NERDTreeChDirMode = 2
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            if vim.fn.argc() == 0 then
              vim.cmd("NERDTree")
              vim.cmd("wincmd p")
            end
          end
        })

        -- Keybindings
        vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format() end, { desc = "Format file" })
        vim.keymap.set("n", "<leader>td", "<cmd>TroubleToggle<cr>", { desc = "Toggle diagnostics" })
        vim.keymap.set("n", "<leader>fs", "<cmd>Telescope find_files<cr>", { desc = "Search files in current folder" })
        vim.keymap.set("n", "<leader>nt", "<cmd>NERDTreeToggle<cr>", { desc = "Toggle NERDTree" })
        vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle Git blame" })
        vim.keymap.set("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next buffer" })
        vim.keymap.set("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous buffer" })
        vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close buffer" })
        EOF
      '';
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        editor = "nvim";
      };
    };

    git = {
      enable = true;
      userName = "David Pocar";
      userEmail = "david.pocar@kosik.cz";
      aliases = {
        l = "log --date=short --decorate --pretty=format:'%C(yellow)%h %C(green)%ad%C(magenta)%d %Creset%s%C(brightblue) [%cn]'";
        branches = "!git --no-pager branch --format '%(refname:short)' --sort=-committerdate | ${pkgs.fzf}/bin/fzf-tmux $1 --preview 'git log --color=always --decorate {}'";
        dog = "log --all --decorate --oneline --graph";
        to = "!git checkout $(git branches --no-multi)";
        drop = "!git branch -d $(git branches --multi)";
        st = "status";
        p = "pull";
        pp = "push";
        c = "commit";
        cm = "commit -m";
        can = "commit --amend --no-edit";
        co = "checkout";
        default = "!git remote show origin | grep 'HEAD branch' | cut -d ' ' -f5";
        back = "reset HEAD~1";
        backk = "reset HEAD~1 --hard";
        files = ''!git diff --name-only $(git merge-base HEAD "$REVIEW_BASE")'';
        stat = ''!git diff --stat $(git merge-base HEAD "$REVIEW_BASE")'';
        what = "!git config --get-regexp alias";
        fixup = "!git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup";
        sweep = "!git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -D";
      };
      delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          side-by-side = true;
          line-numbers = true;
          decorations = {
            minus-style = "syntax #741827";
            minus-emph-style = "syntax #a8113c";
            line-numbers-minus-style = "#F38BA8";
            line-numbers-plus-style = "#94E2D5";
            plus-style = "syntax #154e45";
            plus-emph-style = "syntax bold #146675";
          };
          features = "decorations";
        };
      };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        core = {
          editor = "nvim";
        };
        diff = {
          algorithm = "histogram";
        };
        status = {
          showUntrackedFiles = "all";
        };
        blame = {
          date = "relative";
        };
        rebase = {
          autosquash = true;
        };
        merge = {
          conflictStyle = "diff3";
        };
        pull = {
          ff = "only";
        };
        commit = {
          verbose = true;
        };
        push = {
          autoSetupRemote = true;
        };
        safe.directory = "/k3w";
      };
    };

    zsh = {
      enable = true;
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles";
        update = "sudo nix flake update ~/dotfiles";
        upgrade = "sudo nixos-rebuild switch --upgrade-all --flake ~/dotfiles";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      oh-my-zsh = {
        enable = true;
      };
      autosuggestion = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
      enableCompletion = true;
      initExtra = ''
        setopt NO_NOMATCH
        source ~/.p10k.zsh
        	  '';
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  home.file.".config/kitty/kitty.conf".text = ''
    # vim:ft=kitty

    #zshell
    shell zsh

    map f1 toggle_layout stack

    # window_border_width 0
    background_opacity 0.95
    # draw_minimal_borders yes

    # Remove close window confirm
    confirm_os_window_close 0

    # Font config
    font_family      Fira Code

    font_size 14.0

    # Window padding
    window_padding_width 10

    # The basic colors
    foreground              #CDD6F4
    background              #1E1E2E
    selection_foreground    #1E1E2E
    selection_background    #F5E0DC

    # Cursor colors
    cursor                  #F5E0DC
    cursor_text_color       #1E1E2E

    # URL underline color when hovering with mouse
    url_color               #F5E0DC

    # Kitty window border colors
    active_border_color     #B4BEFE
    inactive_border_color   #6C7086
    bell_border_color       #F9E2AF

    # OS Window titlebar colors
    wayland_titlebar_color system
    macos_titlebar_color system

    # Tab bar colors
    active_tab_foreground   #11111B
    active_tab_background   #CBA6F7
    inactive_tab_foreground #CDD6F4
    inactive_tab_background #181825
    tab_bar_background      #11111B

    # Colors for marks (marked text in the terminal)
    mark1_foreground #1E1E2E
    mark1_background #B4BEFE
    mark2_foreground #1E1E2E
    mark2_background #CBA6F7
    mark3_foreground #1E1E2E
    mark3_background #74C7EC

    # The 16 terminal colors

    # black
    color0 #45475A
    color8 #585B70

    # red
    color1 #F38BA8
    color9 #F38BA8

    # green
    color2  #A6E3A1
    color10 #A6E3A1

    # yellow
    color3  #F9E2AF
    color11 #F9E2AF

    # blue
    color4  #89B4FA
    color12 #89B4FA

    # magenta
    color5  #F5C2E7
    color13 #F5C2E7

    # cyan
    color6  #94E2D5
    color14 #94E2D5

    # white
    color7  #BAC2DE
    color15 #A6ADC8
  '';
}
