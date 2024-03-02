RESOURCEDIR = resources
TARGETDIR = build

# theme stuff
THEMEDIR = theme

SOURCES := $(wildcard source/**/*.md)
HTMLs := $(patsubst source/%.md,build/%.html,$(SOURCES))

all: setupdirs copy_resources $(HTMLs)

setupdirs:
	mkdir -p $(TARGETDIR)

copy_resources:
	cp -r -u $(RESOURCEDIR) $(TARGETDIR)
	cp -r -u $(THEMEDIR)/$(RESOURCEDIR) $(TARGETDIR)

build/%.html: source/%.md 
	mkdir -p $(@D)
	pandoc -t html5 --standalone --template $(THEMEDIR)/base.html --metadata-file settings.yaml $^ -o $@

serve:
	python3 -m http.server 8080 -d $(TARGETDIR)

clean: 
	rm -rf $(TARGETDIR)