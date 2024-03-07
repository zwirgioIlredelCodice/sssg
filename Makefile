RESOURCEDIR = resources
TARGETDIR = build
SOURCEDIR = source
# theme stuff
THEMEDIR = theme

SOURCES := $(shell find $(SOURCEDIR) -name '*.md')
HTMLs := $(addprefix $(TARGETDIR)/,$(patsubst index/index.html,index.html,$(addsuffix /index.html,$(basename $(SOURCES:$(SOURCEDIR)/%.md=%.html)))))

all: setupdirs copy_resources $(HTMLs)

setupdirs:
	mkdir -p $(TARGETDIR)

copy_resources:
	cp -r -u $(RESOURCEDIR) $(TARGETDIR)
	cp -r -u $(THEMEDIR)/$(RESOURCEDIR) $(TARGETDIR)

$(HTMLs): $(SOURCES)
	mkdir -p $(@D)
	pandoc -t html5 --standalone --template $(THEMEDIR)/base.html --metadata-file settings.yaml $^ -o $@

db:
	$(info $(HTMLs))

serve:
	python3 -m http.server 80 -d $(TARGETDIR)

clean: 
	rm -rf $(TARGETDIR)