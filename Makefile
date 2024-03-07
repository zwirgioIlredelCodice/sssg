RESOURCEDIR = resources
TARGETDIR = build
SOURCEDIR = source
# theme stuff
THEMEDIR = theme

SOURCES := $(shell find $(SOURCEDIR) -name '*.md')
HTMLs := $(addprefix $(TARGETDIR)/,$(SOURCES:%.md=%.html))

all: setupdirs copy_resources $(HTMLs)

setupdirs:
	mkdir -p $(TARGETDIR)

copy_resources:
	cp -r -u $(RESOURCEDIR) $(TARGETDIR)
	cp -r -u $(THEMEDIR)/$(RESOURCEDIR) $(TARGETDIR)

$(TARGETDIR)/%.html: %.md
	mkdir -p $(@D)
	pandoc -t html5 --standalone --template $(THEMEDIR)/base.html --metadata-file settings.yaml $^ -o $@

serve:
	python3 -m http.server 8080 -d $(TARGETDIR)

clean: 
	rm -rf $(TARGETDIR)