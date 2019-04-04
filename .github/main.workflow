workflow "Check migrations" {
  on = "push"
  resolves = ["Run test inside docker"]
}

action "Build docker image" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t saleor:$GITHUB_SHA ."
  secrets = ["STATIC_URL"]
}

action "Run test inside docker" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "docker run --rm ecommerce-backend:latest pytest"
  needs = ["Build docker image"]
}
