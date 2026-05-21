_: {
  config.perSystem =
    { pkgs, ... }:
    {
      config.terranix.terranixConfigurations.github-tf = {
        workdir = ".terraform/github";
        terraformWrapper.package = pkgs.opentofu.withPlugins (p: [ p.integrations_github ]);
        modules = [
          {
            terraform.required_providers.github = {
              source = "integrations/github";
              version = "~> 6.0";
            };

            provider.github = {
              owner = "jtrrll";
              token = "\${var.github_token}";
            };

            variable = {
              github_token = {
                type = "string";
                sensitive = true;
                description = "GitHub personal access token with repo admin permissions";
              };
              pr_bot_token = {
                type = "string";
                sensitive = true;
                description = "GitHub PAT for the PR bot to create/merge PRs";
              };
            };

            resource = {
              github_repository.dotfiles = {
                name = "dotfiles";
                description = "jtrrll's declarative dotfiles";
                visibility = "public";

                has_issues = true;
                has_projects = false;
                has_wiki = false;
                has_discussions = false;

                allow_merge_commit = false;
                allow_squash_merge = true;
                allow_rebase_merge = false;
                allow_auto_merge = true;
                allow_update_branch = true;
                delete_branch_on_merge = true;
                vulnerability_alerts = true;

                topics = [
                  "dotfiles"
                  "nix"
                  "nixos"
                  "home-manager"
                ];
              };

              github_branch_default.main = {
                repository = "\${github_repository.dotfiles.name}";
                branch = "main";
              };

              github_repository_ruleset.main = {
                name = "main";
                repository = "\${github_repository.dotfiles.name}";
                target = "branch";
                enforcement = "active";

                conditions = {
                  ref_name = {
                    include = [ "~DEFAULT_BRANCH" ];
                    exclude = [ ];
                  };
                };

                rules = {
                  deletion = true;
                  non_fast_forward = true;
                  required_linear_history = true;
                };
              };

              github_repository_ruleset.pull_requests = {
                name = "pull-requests";
                repository = "\${github_repository.dotfiles.name}";
                target = "branch";
                enforcement = "active";

                conditions = {
                  ref_name = {
                    include = [ "~DEFAULT_BRANCH" ];
                    exclude = [ ];
                  };
                };

                rules = {
                  pull_request = {
                    dismiss_stale_reviews_on_push = false;
                    required_approving_review_count = 0;
                    require_last_push_approval = false;
                  };

                  required_status_checks = {
                    required_check = [
                      {
                        context = "Build Home Manager configuration (jtrrll, ubuntu-latest)";
                      }
                      {
                        context = "Build Home Manager configuration (jtrrll, macos-latest)";
                      }
                      {
                        context = "Build NixOS configuration (ares, ubuntu-latest)";
                      }
                      {
                        context = "Build NixOS configuration (athena, ubuntu-latest)";
                      }
                      {
                        context = "Check";
                      }
                    ];
                    strict_required_status_checks_policy = true;
                  };
                };
              };

              github_actions_secret.pr_bot_token = {
                repository = "\${github_repository.dotfiles.name}";
                secret_name = "PR_BOT_PERSONAL_ACCESS_TOKEN";
                plaintext_value = "\${var.pr_bot_token}";
              };
            };

            output.url = {
              value = "\${github_repository.dotfiles.html_url}";
            };
          }
        ];
      };
    };
}
