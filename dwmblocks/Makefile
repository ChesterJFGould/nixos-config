.POSIX:

PREFIX = /usr/local
CFLAGS = -Ofast $(INCLUDE_FLAGS)
LDLIBS = -lX11 $(LOAD_FLAGS)
CC     = gcc

BIN = dwmblocks

$(BIN): main.o
	$(CC) $^ -o $@ $(LDLIBS)

clean:
	$(RM) *.o $(BIN)

install: $(BIN)
	install -D -m 755 $(BIN) $(DESTDIR)$(PREFIX)/bin/$(BIN)

uninstall:
	$(RM) $(DESTDIR)$(PREFIX)/bin/$(BIN)

.PHONY: clean install uninstall
