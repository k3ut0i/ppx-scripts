OPAM_BIN_DIR = $(HOME)/.opam/default/bin
OPAM_PPX_DIR = $(HOME)/.opam/default/lib/ppx_tools
OCC = $(OPAM_BIN_DIR)/ocamlc
OCB = $(OPAM_BIN_DIR)/ocamlbuild
REW = $(OPAM_PPX_DIR)/rewriter
.PHONY : clean test_foo test_dump_source_foo all-ppx

all-ppx : ppx_addone.native ppx_getenv.native \
	  ppx_equiv.native ppx_arith.native

clean :
	rm -rf *.native *.cmi *.cmo a.out _build

ppx_%.native : ppx_%.ml
	$(OCB) -package compiler-libs.common $@ $<

#This is very hackky. is there no way to use prerequisites individually?
test_dump_source_foo_% : ppx_%.native foo_%.ml
	$(REW) $(PWD)/$^

foo.native : foo.ml ppx_getenv.native
	$(OCC) -ppx ./ppx_getenv.native $< -o $@

test_foo : foo.native
	./foo.native
