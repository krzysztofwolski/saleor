workflow "Check migrations" {
  on = "push"
  resolves = ["Run test inside docker"]
}

action "Build docker image" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t saleor:$GITHUB_SHA ."
  secrets = ["STATIC_URL"]
}

action "Check if there is missing migration" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "run --rm saleor:$GITHUB_SHA ./manage.py makemigrations --check --dry-run"
  needs = ["Build docker image"]
}
