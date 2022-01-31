current:
	echo make pd_linux, pd_linux32, pd_nt, pd_darwin

clean: ; rm -f *.pd_linux *.o

# ----------------------- Windows-----------------------
# note; you will certainly have to edit the definition of VC to agree with
# whatever you've got installed on your machine:

VC="C:\Program FIles (x86)\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.16.27023"

pd_nt: thingbob.dll

.SUFFIXES: .obj .dll

PDNTCFLAGS = /W3 /DNT /DPD /nologo

PDNTINCLUDE = /I. /I\tcl\include /I..\..\src /I$(VC)\include

PDNTLDIR = $(VC)\lib\x64
PDNTLIB = $(PDNTLDIR)\libcmt.lib \
	$(PDNTLDIR)\oldnames.lib \
	..\..\bin\pd.lib 

.c.dll:
	cl $(PDNTCFLAGS) $(PDNTINCLUDE) /c $*.c
	link /dll /export:$*_setup $*.obj $(PDNTLIB)

# override explicitly for tilde objects like this:
dspobj~.dll: dspobj~.c; 
	cl $(PDNTCFLAGS) $(PDNTINCLUDE) /c $*.c
	link /dll /export:dspobj_tilde_setup $*.obj $(PDNTLIB)

# ----------------------- LINUX i386 -----------------------

pd_linux: obj1.l_ia64 obj2.l_ia64 obj3.l_ia64 obj4.l_ia64 \
    obj5.l_ia64 dspobj~.l_ia64

pd_linux32: obj1.l_i386 obj2.l_i386 obj3.l_i386 obj4.l_i386 \
    obj5.l_i386 dspobj~.l_i386

.SUFFIXES: .l_i386 .l_ia64

LINUXCFLAGS = -DPD -O2 -funroll-loops -fomit-frame-pointer \
    -Wall -W -Wshadow -Wstrict-prototypes -Werror \
    -Wno-unused -Wno-parentheses -Wno-switch

LINUXINCLUDE =  -I../../src

.c.l_i386:
	cc $(LINUXCFLAGS) $(LINUXINCLUDE) -o $*.o -c $*.c
	ld -shared -o $*.l_i386 $*.o -lc -lm
	strip --strip-unneeded $*.l_i386
	rm $*.o

.c.l_ia64:
	cc $(LINUXCFLAGS) $(LINUXINCLUDE) -fPIC -o $*.o -c $*.c
	ld -shared -o $*.l_ia64 $*.o -lc -lm
	strip --strip-unneeded $*.l_ia64
	rm $*.o

# ----------------------- macOS -----------------------

pd_darwin: obj1.pd_darwin obj2.pd_darwin \
     obj3.pd_darwin obj4.pd_darwin obj5.pd_darwin dspobj~.pd_darwin

.SUFFIXES: .pd_darwin

DARWINCFLAGS = -DPD -O2 -Wall -W -Wshadow -Wstrict-prototypes \
    -Wno-unused -Wno-parentheses -Wno-switch -arch i386 -arch x86_64

.c.pd_darwin:
	cc $(DARWINCFLAGS) $(LINUXINCLUDE) -o $*.o -c $*.c
	cc -bundle -undefined suppress -arch i386 -arch x86_64 \
            -flat_namespace -o $*.pd_darwin $*.o 
	rm -f $*.o

