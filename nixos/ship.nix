# Shipnix recommended settings
# IMPORTANT: These settings are here for ship-nix to function properly on your server
# Modify with care

{ config, pkgs, modulesPath, lib, ... }:
{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
    settings = {
      trusted-users = [ "root" "ship" "nix-ssh" ];
    };
  };

  programs.git.enable = true;
  programs.git.config = {
    advice.detachedHead = false;
  };

  services.openssh = {
    enable = true;
    # ship-nix uses SSH keys to gain access to the server
    # Manage permitted public keys in the `authorized_keys` file
    passwordAuthentication = false;
    #  permitRootLogin = "no";
  };


  users.users.ship = {
    isNormalUser = true;
    extraGroups = [ "wheel" "nginx" ];
    # If you don't want public keys to live in the repo, you can remove the line below
    # ~/.ssh will be used instead and will not be checked into version control. 
    # Note that this requires you to manage SSH keys manually via SSH,
    # and your will need to manage authorized keys for root and ship user separately
    openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWxl1WbRxGcEBAjyBZlFHJoteykXKmx8UGMd6/54n1mY2XU8IwwDA07g2KbFm1qAwVc0gIeT5ywDDqRh4WhT2UFzv1DyH6ZluqlF4nPAzpKEEq+zs2wx/sFRgr4kKDsXszD7S81amk0xMOrgNbqoaYRPszJPoJHAqBm6HIHi23WDuSKEVQ8MUgR2MTK3ci6BKMwhI3gPK9cPu/CyZIXNV2RvRVDmUCtRz8GIwG9LLf+oAW/7LNMDEafUVZVP5dIhbj+gB7d6nsSayF29PnuDYuAuKlxuTPVJ6DqeH8lG88BvmkvZCzl/Whkjl807U7+7JHK1mT2Vwm9BtkKL9BI+tgozAPaqy/8fEg8JqToXnqHUzDVVQB8ASx1ZwTj+H3mAZf3JtTRLIk0JxfeODWyZKOKYqkrkGUiinKYjImF7PdUrwhVEMBNbIO+6OoudN7NwS+7rZsh7tPLWN1899z/CLgpY+kTO8b+dJR0LJ/lV9peYpTMz+rkSgyplYwoSCgNBc= ship@tite-ship
"
    ];
  };

  # Can be removed if you want authorized keys to only live on server, not in repository
  # Se note above for users.users.ship.openssh.authorizedKeys.keyFiles
  users.users.root.openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWxl1WbRxGcEBAjyBZlFHJoteykXKmx8UGMd6/54n1mY2XU8IwwDA07g2KbFm1qAwVc0gIeT5ywDDqRh4WhT2UFzv1DyH6ZluqlF4nPAzpKEEq+zs2wx/sFRgr4kKDsXszD7S81amk0xMOrgNbqoaYRPszJPoJHAqBm6HIHi23WDuSKEVQ8MUgR2MTK3ci6BKMwhI3gPK9cPu/CyZIXNV2RvRVDmUCtRz8GIwG9LLf+oAW/7LNMDEafUVZVP5dIhbj+gB7d6nsSayF29PnuDYuAuKlxuTPVJ6DqeH8lG88BvmkvZCzl/Whkjl807U7+7JHK1mT2Vwm9BtkKL9BI+tgozAPaqy/8fEg8JqToXnqHUzDVVQB8ASx1ZwTj+H3mAZf3JtTRLIk0JxfeODWyZKOKYqkrkGUiinKYjImF7PdUrwhVEMBNbIO+6OoudN7NwS+7rZsh7tPLWN1899z/CLgpY+kTO8b+dJR0LJ/lV9peYpTMz+rkSgyplYwoSCgNBc= ship@tite-ship
"
  ];

  security.sudo.extraRules = [
    {
      users = [ "ship" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" "SETENV" ];
        }
      ];
    }
  ];
}
