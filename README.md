# Infrastructure

Declarative provisioning of a single Oracle Cloud Infrastructure (OCI) Arm
server using OpenTofu. Everything here fits inside the OCI Always Free tier.

## What this provisions

- A `VM.Standard.A1.Flex` instance using **2 OCPUs and 12 GB of memory**
- A **200 GB boot volume** with an Ubuntu 24.04 Arm image selected at plan time
- A compartment named `OpenTofu` (pass `compartment` to place the instance in an
  existing one instead; the created compartment still exists)
- A public IP on the supplied subnet

It does not create networking (VCN, subnet, security lists). Pass the OCID of an
existing public subnet, or add those resources here.

## Free tier limits that matter

Oracle halved the Always Free Ampere A1 allowance in 2026 and began enforcing it
on 18 August 2026. Instances above the limit were terminated on free accounts.

| Resource | Always Free allowance |
| --- | --- |
| Ampere A1 compute | 1,500 OCPU-hours and 9,000 GB-hours per month, equivalent to **2 OCPUs / 12 GB always on** |
| AMD micro | 2x `VM.Standard.E2.1.Micro` (1/8 OCPU, 1 GB each) |
| Block storage | **200 GB total, boot volumes included** |
| Egress | 10 TB per month |

Consequences encoded in this configuration:

- `ocpus` and `memory_in_gbs` are capped at 2 and 12 by variable validation.
  Those caps are the Always Free limits; edit the validations if you move to
  Pay As You Go.
- The boot volume (`boot_volume_gb`, default 200) uses the block storage
  allowance. There is no separate boot-volume quota: boot volumes, data
  volumes, and anything else left behind share the same 200 GB. 200 is the cap,
  not a target; leave headroom if you want a data volume.
- Always Free compute must be in the tenancy's home region (`ap-sydney-1` here).

Avoid the idle reclamation policy: Oracle may reclaim an A1 instance when, over
7 days, the 95th percentile CPU, network and memory utilisation all stay below
20%. A server that actually does something is fine; a box that only idles may
not be.

## Auditing storage

The allowance is per tenancy, not per instance. Sum boot volumes and data
volumes separately and keep the total at or under 200 GB:

```bash
oci bv boot-volume list --compartment-id "$COMPARTMENT" \
  --query 'sum(data[]."size-in-gbs")' --raw-output
oci bv volume list --compartment-id "$COMPARTMENT" \
  --query 'sum(data[]."size-in-gbs")' --raw-output
```

Delete the old 200 GB launch data volume if it is still attached; this
configuration no longer creates one.

## Prerequisites

- [OpenTofu](https://opentofu.org/) 1.6 or newer
- An OCI API key, with its private key at `~/.oci/rsa.pem` by default
- The OCIDs of your tenancy, user, API key fingerprint, and a public subnet
- An SSH key pair for the instance

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars   # then fill it in
tofu init
tofu plan
tofu apply
```

The image's default user is `ubuntu`:

```bash
ssh ubuntu@$(tofu output -raw public_ip)
```

## State

State is local and git-ignored. That means:

- Keep `terraform.tfstate` somewhere safe. It is the only record of what exists.
- A fresh clone cannot `apply` safely; it would try to create a second
  compartment and instance.

For anything long-lived, move state to OCI Object Storage (S3-compatible API) or
another remote backend before using this from more than one machine.

## Resizing an existing 4 OCPU / 24 GB instance

`shape_config` is updatable, so changing the variables resizes in place and OCI
reboots the instance; it does not replace it. Before applying:

1. Read `tofu plan`. Expect an in-place update of `shape_config` and nothing
   else. Anything else needs to be understood before it is applied.
2. Make sure nothing on the host needs a graceful shutdown first.
3. If the instance still has the old 200 GB data volume created by
   `launch_volume_attachments`, detach and delete it first: it plus the boot
   volume exceed the 200 GB allowance.

`availability_domain`, the boot image, and the SSH key are fixed on an existing
instance, so changes to them are ignored rather than planned. Set
`availability_domain` if you need a specific AD when creating a new instance.

If the plan does show a replacement, `preserve_boot_volume = true` keeps the
boot volume, but reattaching it is manual. Read the plan before applying.

## Destroying

`preserve_boot_volume` and `preserve_data_volumes_created_at_launch` are both
true, so `tofu destroy` leaves the boot volume (and any launch data volume)
behind. Delete them in the console when you are finished with them, otherwise
the next apply creates a second boot volume and both count against the 200 GB
allowance.

## NixOS

The Terraform layer only cares about shape and image, so the OS is replaceable.
For a one-off host, the pragmatic path is to keep the stock Ubuntu image here and
convert it once with `nixos-anywhere`:

```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake /path/to/nixos-config#oci-arm \
  --kexec-url https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-kexec-installer-aarch64-linux.tar.gz \
  root@$(tofu output -raw public_ip)
```

Put the host configuration in your existing NixOS flake (with `disko` for the
boot volume), not in this repository. After the conversion, `tofu apply`
continues to manage the VM, and rebuilds go over SSH with `deploy-rs`,
`colmena`, or `nixos-rebuild --target-host`.

The fully declarative alternative is to build an OCI image with nixpkgs'
`virtualisation/oci-image.nix`, upload it to Object Storage, import it as a
custom image, and register `VM.Standard.A1.Flex` shape compatibility plus an
image capability schema (firmware `UEFI_64`, paravirtualized launch and storage).
That makes `tofu apply` able to rebuild the OS too, at the cost of an image
pipeline and several more resources. Worth it only if you expect to recreate the
instance often.
