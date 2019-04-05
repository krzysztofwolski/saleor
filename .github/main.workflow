workflow "Check migrations" {
  on = "push"
  resolves = ["Check if there is missing migration"]
}

action "Build docker image" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t saleor:$GITHUB_SHA ."
  secrets = ["STATIC_URL"]
}

action "Start db" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "run -d --name db -e POSTGRES_USER=saleor -e POSTGRES_PASSWORD=saleor postgres:9.4-alpine"
  secrets = ["STATIC_URL"]
}

action "Check if there is missing migration" {
  uses = "docker://saleor"
  args = "DATABASE_URL=$DATABASE_URL SECRET_KEY=$SECRET_KEY ./manage.py makemigrations --check --dry-run"
  secrets = ["STATIC_URL", "SECRET_KEY", "DATABASE_URL"]
  needs = ["Build docker image", "Start db"]
}

# action "Check if schema is updated" {
#   uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
#   args = "run -e SECRET_KEY=sekret --rm saleor:$GITHUB_SHA npm run build-schema"
#   needs = ["Build docker image"]
# }
