SRCS = main.asm user.asm pics.asm
ASMFLAGS = -mcg -z0 -iutil/include
TARGET = gbfade.gb

ASM = motorz80
LIB = xlib
LINK = xlink

DEPDIR := .d
$(shell mkdir -p $(DEPDIR) >/dev/null)
DEPFLAGS = -d$(DEPDIR)/$*.Td

ASSEMBLE = $(ASM) $(DEPFLAGS) $(ASMFLAGS)
POSTCOMPILE = @mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d && touch $@

$(TARGET) : $(SRCS:asm=obj) util/mos.lib
	$(LINK) -o$@ -tg $+

util/mos.lib:
	$(MAKE) -C util

%.obj : %.asm
%.obj : %.asm $(DEPDIR)/%.d
	$(ASSEMBLE) -o$@ $<
	$(POSTCOMPILE)

$(DEPDIR)/%.d: ;
.PRECIOUS: $(DEPDIR)/%.d

clean :
	rm -rf $(TARGET) $(SRCS:asm=obj) $(DEPDIR)
	$(MAKE) -C util clean

include $(wildcard $(patsubst %,$(DEPDIR)/%.d,$(basename $(SRCS))))
