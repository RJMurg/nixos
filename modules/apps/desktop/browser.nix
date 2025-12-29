{...}: {
  programs.firefox = {
    enable = true;
    languagePacks = ["en-US" "en-GB" "de"];

    preferences = {
      "browser.startup.homepage" = "https://start.rjm.ie";
      "privacy.resistFingerprinting" = true;
    };

    policies = {
      DisableTelemetry = true;
    };

    # NTRJM - Add the extensions
  };
}
