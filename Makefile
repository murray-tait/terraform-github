date=$$(date '+%Y.%m.%d.%H.%M')

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

start-deploy: tag
	gh workflow run tag-based-deployment.yml -f tag=v${date} -f target=

