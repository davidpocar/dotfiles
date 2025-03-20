{ pkgs, ... }:
{
  programs = {
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

  };
}
