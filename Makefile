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
RESOURCES := $(shell find $(RESOURCEDIR) $(THEMEDIR)/$(RESOURCEDIR) -not -type d)

PANDOC-BASE-ARGS := -t html5 --standalone --mathml --template $(THEMEDIR)/base.html --metadata-file settings.yaml
PANDOC-TESTING-ARGS := $(PANDOC-BASE-ARGS) --metadata=siteurl:"$(TESTINGURL)"

release: setupdirs copy_resources $(HTMLS-RELEASE) $(RELEASEDIR)/index.html

testing: setupdirs copy_resources $(HTMLS-TESTING) $(TESTINGDIR)/index.html

setupdirs:
	mkdir -p $(OUTDIR)
	mkdir -p $(RELEASEDIR)
	mkdir -p $(TESTINGDIR)

copy_resources: $(RESOURCES) # TODO: dependencies not working
	cp -r -u $(RESOURCEDIR) $(RELEASEDIR)
	cp -r -u $(THEMEDIR)/$(RESOURCEDIR) $(RELEASEDIR)
	
	cp -r -u $(RESOURCEDIR) $(TESTINGDIR)
	cp -r -u $(THEMEDIR)/$(RESOURCEDIR) $(TESTINGDIR)

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