# angsd
Small source-built container for `angsd`.

## Quick Usage

```bash
# Pull the image
docker pull docker.io/picotainers/angsd:latest

# Run the tool
docker run --rm docker.io/picotainers/angsd:latest --help
```

## Usage with input files

```bash
docker run --rm -v "$(pwd):/data" docker.io/picotainers/angsd:latest --help
```
