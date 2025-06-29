
auth-token:
	export GITHUB_TOKEN=$(cat ~/.config/gh/hosts.yml | yq '.[].oauth_token')

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply