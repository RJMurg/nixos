# RJM's NixOS Configs

This repo contains the NixOS configs for all my machines

## Repository Structure

```
.
├── common             # Universal settings & packages
├── modules
│   ├── apps           # Specific applications with mkOptions
│   │   ├── desktop
│   │   └── server
│   ├── fonts          # Custom fonts
│   └── infra          # Different infrastructure types
│       ├── hetzner
│       └── standalone
├── secrets            # Encrypted secrets
├── systems            # Individual Systems
│   ├── artemy
│   ├── block
│   ├── daniil
│   └── sticky
└── flake.nix
```

# Current Systems
**Last Updated:** 29/12/25

| System    | Type   | Description                                  |
|-----------|--------|----------------------------------------------|
| `Artemy`  | Server | Primary production server for most workloads |
| `Block `  | Server | Home server for backups and management       |
| `Daniil`  | PC     | Main Personal Computer                       |
| `Sticky`  | Server | Cloud testing server, networked with Artemy  |