
auth-token:
	export GITHUB_TOKEN=$(cat ~/.config/gh/hosts.yml | yq '.[].oauth_token')

init:
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply