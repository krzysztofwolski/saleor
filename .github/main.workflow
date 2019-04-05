workflow "Check migrations" {
  on = "push"
  resolves = ["Check if there is missing migration", "Check if schema is updated"]
}

action "Build docker image" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t saleor:$GITHUB_SHA ."
  secrets = ["STATIC_URL"]
}

action "Check if there is missing migration" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "run -e SECRET_KEY=sekret --rm saleor:$GITHUB_SHA ./manage.py makemigrations --check --dry-run"
  needs = ["Build docker image"]
}


action "Check if schema is updated" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "run -e SECRET_KEY=sekret --rm saleor:$GITHUB_SHA npm run build-schema"
  needs = ["Build docker image"]
}
