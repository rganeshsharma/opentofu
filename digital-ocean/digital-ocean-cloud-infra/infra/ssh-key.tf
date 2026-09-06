resource "digitalocean_ssh_key" "ai_lab" {
  name       = "${var.project_name}-ssh-key"
  public_key = file("/Users/ganeshsharma/.ssh/do-ai-lab.pub")
}