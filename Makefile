# add new action directories to `GHA_DIRS` & new template files to `GHA_WORKFLOWS_FILES` as necessary
# templates test out the actions & are great files to add to your repo
.PHONY: all setup_gha setup_site setup_pkgdown setup_rmd build_index build_site build_pkgdown build_rmd build_r_pkg r_pkg_check preview

GHA_DIRS = setup-renv setup-pkgdown setup-index setup-knitr-cache
GHA_WORKFLOWS_FILES = renv-r-pkg.yaml renv-restore.yaml pkgdown.yaml index.yaml knitr-cache.yaml
# GitHub Actions
GHAS = $(addsuffix /action.yaml,$(GHA_DIRS))
# Template Workflows
GH_DIR = .github
GHA_WORKFLOWS_DIR = $(addprefix $(GH_DIR)/,workflows)
GHA_WORKFLOWS = $(addprefix $(GHA_WORKFLOWS_DIR)/,$(GHA_WORKFLOWS_FILES))

# GitHub Pages
GHPAGES_DIR = docs
GHPAGES_FILES = .nojekyll
GHPAGES_FILE_PATHS = $(addprefix $(GHPAGES_DIR)/,$(GHPAGES_FILES))

# Site Static Content
SITE_DIR = static
SITE_FILES = index.html .nojekyll
SITE_FILE_PATHS = $(addprefix $(SITE_DIR)/,$(SITE_FILES))

# pkgdown output
PKGDOWN_FILES = DESCRIPTION NAMESPACE .Rbuildignore _pkgdown.yml
PKGDOWN_DIRS = R
PKGDOWN_GHPAGES_DIR = $(addprefix $(GHPAGES_DIR)/,pkgdown)

# RMD html_document output
RMD_FILES = setup-knitr-cache/knitr-cache.Rmd
RMD_DIRS = libs
RMD_GHPAGES_DIR = $(addprefix $(GHPAGES_DIR)/,rmd)
RMD_GHPAGES_DIRS = $(addprefix $(RMD_GHPAGES_DIR)/,$(RMD_DIRS))

# all separate sites built by workflows that the index links to
GHPAGES_SITE_DIRS = $(PKGDOWN_GHPAGES_DIR) $(RMD_GHPAGES_DIR)

all: setup_gha setup_site

setup_gha: $(GHA_WORKFLOWS) $(GHAS)
	@echo 'setup GHA'

setup_site: $(GHPAGES_FILE_PATHS) $(SITE_FILE_PATHS) setup_rmd setup_pkgdown
	@echo 'setup site'

setup_pkgdown: $(PKGDOWN_FILES)
	@echo 'setup pkgdown'

setup_rmd: $(RMD_FILES) $(RMD_GHPAGES_DIRS)
	@echo 'setup RMD'

$(GHAS): | $(GHA_DIRS)
	touch $@

$(GHA_DIRS):
	mkdir -p $@

$(GHA_WORKFLOWS): | $(GHA_WORKFLOWS_DIR)
	touch $@
	
$(GHA_WORKFLOWS_DIR):
	mkdir -p $@

$(SITE_FILE_PATHS) &: | $(SITE_DIR) $(GHPAGES_SITE_DIRS)
	Rscript utils/build_site.R $(SITE_DIR)/index.html $(GHPAGES_DIR)
	cp -pr $(SITE_DIR)/. $(GHPAGES_DIR)

$(SITE_DIR):
	mkdir -p $@
	
$(GHPAGES_SITE_DIRS):
	mkdir -p $@

$(GHPAGES_FILE_PATHS): | $(GHPAGES_DIR)
	touch $@
	
$(GHPAGES_DIR):
	mkdir -p $@

$(RMD_GHPAGES_DIRS):
	mkdir -p $@

$(PKGDOWN_FILES): | $(PKGDOWN_DIRS)
	touch $@
# usethis::create_package(path = '.')
# usethis::use_pkgdown(destdir = "docs/pkgdown/")

$(RMD_FILES):
	touch $@

$(PKGDOWN_DIRS):
	mkdir -p $@

build_index:
	Rscript utils/build_index.R
	cp $(SITE_DIR)/index.html $(GHPAGES_DIR)

build_site:
	Rscript utils/build_site.R $(SITE_DIR)/index.html $(GHPAGES_DIR)
	cp -pr $(SITE_DIR)/. $(GHPAGES_DIR)

build_pkgdown:
	Rscript utils/build_pkgdown.R

build_rmd:
	Rscript utils/build_rmd.R
	
build_r_pkg:
	Rscript utils/build_r_pkg.R
	
r_pkg_check:
	Rscript utils/r_pkg_check.R
	
preview:
	Rscript utils/preview.R