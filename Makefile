date=$$(date '+%Y.%m.%d.%H.%M')
.EXPORT_ALL_VARIABLES:
.ONESHELL:
include .env


auth-token:
	export GITHUB_TOKEN=$(cat ~/.config/gh/hosts.yml | yq '.[].oauth_token')

init:
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply

tag:
	git tag v${date}
	git push origin tag v${date}
