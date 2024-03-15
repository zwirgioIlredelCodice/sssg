RESOURCEDIR = resources
OUTDIR := build
RELEASEDIR = $(OUTDIR)/release
TESTINGDIR = $(OUTDIR)/testing
SOURCEDIR = source
# theme stuff
THEMEDIR = theme

TESTINGURL := http://0.0.0.0:8080

SOURCES := $(filter-out $(SOURCEDIR)/index.md,$(shell find $(SOURCEDIR) -name '*.md'))

HTMLS-RELEASE := $(addprefix $(RELEASEDIR)/,$(addsuffix /index.html,$(basename $(SOURCES:$(SOURCEDIR)/%.md=%.html))))
HTMLS-TESTING := $(addprefix $(TESTINGDIR)/,$(addsuffix /index.html,$(basename $(SOURCES:$(SOURCEDIR)/%.md=%.html))))
RESOURCES_THEME_IN := $(shell find $(THEMEDIR)/$(RESOURCEDIR) -not -type d)
RESOURCES_BASE_IN := $(shell find $(RESOURCEDIR) -not -type d)
RESOURCES_THEME_OUT_RELEASE := $(RESOURCES_THEME_IN:$(THEMEDIR)/%=$(RELEASEDIR)/%)
RESOURCES_THEME_OUT_TESTING := $(RESOURCES_THEME_IN:$(THEMEDIR)/%=$(TESTINGDIR)/%)
RESOURCES_BASE_OUT_RELEASE := $(RESOURCES_BASE_IN:%=$(RELEASEDIR)/%)
RESOURCES_BASE_OUT_TESTING := $(RESOURCES_BASE_IN:%=$(TESTINGDIR)/%)

PANDOC-BASE-ARGS := -t html5 --standalone --mathml --template $(THEMEDIR)/base.html --metadata-file settings.yaml
PANDOC-TESTING-ARGS := $(PANDOC-BASE-ARGS) --metadata=siteurl:"$(TESTINGURL)"

release: $(RESOURCES_THEME_OUT_RELEASE) $(RESOURCES_BASE_OUT_RELEASE) $(HTMLS-RELEASE) $(RELEASEDIR)/index.html

testing: $(RESOURCES_THEME_OUT_TESTING) $(RESOURCES_BASE_OUT_TESTING) $(HTMLS-TESTING) $(TESTINGDIR)/index.html

$(RESOURCES_THEME_OUT_RELEASE): $(RELEASEDIR)/%: $(THEMEDIR)/%
	mkdir -p $(@D)
	cp $< $@

$(RESOURCES_THEME_OUT_TESTING): $(TESTINGDIR)/%: $(THEMEDIR)/%
	mkdir -p $(@D)
	cp $< $@

$(RESOURCES_BASE_OUT_RELEASE): $(RELEASEDIR)/%: %
	mkdir -p $(@D)
	cp $< $@

$(RESOURCES_BASE_OUT_TESTING): $(TESTINGDIR)/%: %
	mkdir -p $(@D)
	cp $< $@

$(RELEASEDIR)/index.html: $(SOURCEDIR)/index.md $(THEMEDIR)/* 
	pandoc $(PANDOC-BASE-ARGS) $< -o $@

$(HTMLS-RELEASE): $(RELEASEDIR)/%/index.html: $(SOURCEDIR)/%.md $(THEMEDIR)/*
	mkdir -p $(@D)
	pandoc $(PANDOC-BASE-ARGS) $< -o $@

$(TESTINGDIR)/index.html: $(SOURCEDIR)/index.md $(THEMEDIR)/* 
	pandoc $(PANDOC-TESTING-ARGS) $< -o $@

$(HTMLS-TESTING): $(TESTINGDIR)/%/index.html: $(SOURCEDIR)/%.md $(THEMEDIR)/*
	mkdir -p $(@D)
	pandoc $(PANDOC-TESTING-ARGS) $< -o $@

serve:
	python3 -m http.server 8080 -d $(TESTINGDIR)

clean: 
	rm -rf $(OUTDIR)