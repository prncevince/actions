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

# RMD html_document output
GHPAGES_DIR = docs
RMD_FILES = .nojekyll
RMD_GHPAGES_DIR = $(addprefix $(GHPAGES_DIR)/,rmd)
RMD_DIRS = libs

RMD_GHPAGES_FILES = $(addprefix $(GHPAGES_DIR)/,$(RMD_FILES))
RMD_GHPAGES_DIRS = $(addprefix $(RMD_GHPAGES_DIR)/,$(RMD_DIRS))


all: setup_gha setup_rmd

setup_gha: | $(GHA_WORKFLOWS) $(GHAS)
	echo 'setup GHA'

setup_rmd: | $(RMD_GHPAGES_FILES)
	echo 'setup RMD'

$(GHAS): | $(GHA_DIRS)
	touch $@

$(GHA_DIRS):
	mkdir -p $@

$(GHA_WORKFLOWS): | $(GHA_WORKFLOWS_DIR)
	touch $@
	
$(GHA_WORKFLOWS_DIR):
	mkdir -p $@

$(RMD_GHPAGES_FILES): | $(RMD_GHPAGES_DIRS)
	touch $@

$(RMD_GHPAGES_DIRS):
	mkdir -p $@

build_rmd:
	Rscript build/build_rmd.R
	
preview_rmd:
	Rscript utils/preview.R