workflow "Build and Publish" {
  on = "push"
  resolves = ["Publish"]
}

action "Build" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  args = "install"
  runs = "npm"
}

action "Build" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  args = "build"
  runs = "npm"
}

action "Publish" {
  uses = "Azure/github-actions/cli@843845a95833e81c790d80c6e2fa714ccbd5e145"
  needs = ["Build"]
  runs = "azure"
  args = "publish"
}
