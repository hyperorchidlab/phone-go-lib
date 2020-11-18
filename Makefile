BINDIR=bin

#.PHONY: pbs

all: m a i test
#
#pbs:
#	cd pbs/ && $(MAKE)
#
test:
	go build  -ldflags '-w -s' -o $(BINDIR)/ctest mac/*.go
m:
	CGO_CFLAGS=-mmacosx-version-min=10.11 \
	CGO_LDFLAGS=-mmacosx-version-min=10.11 \
	GOARCH=amd64 GOOS=darwin go build  --buildmode=c-archive -o $(BINDIR)/phone.a mac/*.go
	cp mac/callback.h $(BINDIR)/
a:
	gomobile bind -v -o $(BINDIR)/phone.aar -target=android github.com/hyperorchidlab/phone-go-lib/android
i:
	gomobile bind -v -o $(BINDIR)/phone.framework -target=ios github.com/hyperorchidlab/phone-go-lib/ios
	cp -rf bin/phone.framework $(tp)
	rm -rf bin/phone.framework

clean:
	gomobile clean
	rm $(BINDIR)/*