RESOURCEDIR = "resources"
TARGETDIR = "build"

# theme stuff
THEMEDIR = "theme"

SOURCES := $(wildcard source/*.md)
HTMLs := $(patsubst source/%.md,build/%.html,$(SOURCES))

all: setupdirs copy_resources $(HTMLs)

setupdirs:
	mkdir -p $(TARGETDIR)

copy_resources:
	cp -r $(RESOURCEDIR) $(TARGETDIR)
	cp -r $(THEMEDIR)/$(RESOURCEDIR) $(TARGETDIR)

build/%.html: source/%.md
	pandoc -t html5 --standalone --template $(THEMEDIR)/base.html --metadata-file settings.yaml $^ -o $@

clean: 
	rm -rf $(TARGETDIR)