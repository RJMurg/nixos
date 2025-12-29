{...}: {
  programs.ssh = {
    extraConfig = "
      Host theta
        HostName 5.75.190.142
        user rjm
        IdentityFile ~/.ssh/rjm_key

      Host sticky
        HostName 167.235.18.38
        User rjm
        IdentityFile ~/.ssh/rjm_key

      Host block
        HostName 192.168.5.251
        User rjm
        IdentityFile ~/.ssh/rjm_key
    ";
  };
}
