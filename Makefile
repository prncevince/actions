# add new action directories to `GHA_DIRS` & new template files to `GHA_WORKFLOWS_FILES` as necessary
# templates test out the actions & are great files to add to your repo
.PHONY: all setup_gha setup_rmd build_rmd preview_rmd

GHA_DIRS = setup-renv setup-pkgdown
GHA_WORKFLOWS_FILES = renv.yaml pkgdown.yaml
# GitHub Actions
GHAS = $(addsuffix /action.yaml,$(GHA_DIRS))
# Template Workflows
GH_DIR = .github
GHA_WORKFLOWS_DIR = $(addprefix $(GH_DIR)/,workflows)
GHA_WORKFLOWS = $(addprefix $(GHA_WORKFLOWS_DIR)/,$(GHA_WORKFLOWS_FILES))

RMD_GHPAGES_DIR = docs

all: setup_gha setup_rmd

setup_gha: | $(GHA_WORKFLOWS) $(GHAS)
	echo 'setup GHA'

setup_rmd: | $(RMD_GHPAGES_DIR)/libs $(RMD_GHPAGES_DIR)/.nojekyll
	echo 'setup RMD'

$(GHAS): | $(GHA_DIRS)
	touch $@

$(GHA_DIRS):
	mkdir -p $@

$(GHA_WORKFLOWS): | $(GHA_WORKFLOWS_DIR)
	touch $@
	
$(GHA_WORKFLOWS_DIR):
	mkdir -p $@

$(RMD_GHPAGES_DIR)/libs:
	mkdir -p $@
	
$(RMD_GHPAGES_DIR)/.nojekyll:
	touch $@

build_rmd:
	Rscript build/build.R
	
preview_rmd:
	Rscript utils/preview.R