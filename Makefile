SRC_REPO := https://github.com/kubernetes/git-sync
SRC_DIR := git-sync

clone:
	git clone $(SRC_REPO) $(SRC_DIR)

build-amd64:
	docker buildx build --platform linux/amd64 --tag git-sync .

build-arm64:
	docker buildx build --platform linux/arm64 --tag git-sync .

clean:
	rm -rf git-sync/
