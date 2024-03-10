RESOURCEDIR = resources
TARGETDIR = build
SOURCEDIR = source
# theme stuff
THEMEDIR = theme

SOURCES := $(filter-out $(SOURCEDIR)/index.md,$(shell find $(SOURCEDIR) -name '*.md'))
HTMLs := $(addprefix $(TARGETDIR)/,$(addsuffix /index.html,$(basename $(SOURCES:$(SOURCEDIR)/%.md=%.html))))

RESOURCES := $(shell find $(RESOURCEDIR) $(THEMEDIR)/$(RESOURCEDIR) -not -type d)

all: setupdirs copy_resources $(HTMLs) $(TARGETDIR)/index.html

setupdirs:
	mkdir -p $(TARGETDIR)

copy_resources: $(RESOURCES) # TODO: dependencies not working
	cp -r -u $(RESOURCEDIR) $(TARGETDIR)
	cp -r -u $(THEMEDIR)/$(RESOURCEDIR) $(TARGETDIR)

$(TARGETDIR)/index.html: $(SOURCEDIR)/index.md $(THEMEDIR)/* 
	pandoc -t html5 --standalone --template $(THEMEDIR)/base.html --metadata-file settings.yaml $< -o $@

$(HTMLs): $(TARGETDIR)/%/index.html: $(SOURCEDIR)/%.md $(THEMEDIR)/*
	mkdir -p $(@D)
	pandoc -t html5 --standalone --template $(THEMEDIR)/base.html --metadata-file settings.yaml $< -o $@


serve:
	python3 -m http.server 8080 -d $(TARGETDIR)

clean: 
	rm -rf $(TARGETDIR)