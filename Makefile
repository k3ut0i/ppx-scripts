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

ppx_getenv.native : ppx_getenv.ml
	$(OCB) -package compiler-libs.common $@ $<

ppx_addone.native : ppx_addone.ml
	$(OCB) -package compiler-libs.common $@ $<

ppx_equiv.native : ppx_equiv.ml
	$(OCB) -package compiler-libs.common $@ $<
ppx_arith.native : ppx_arith.ml
	$(OCB) -package compiler-libs.common $@ $<

test_dump_source_foo_arith : foo_arith.ml ppx_arith.native
	$(REW) ./ppx_arith.native foo_arith.ml

test_dump_source_foo_addone : foo_addone.ml ppx_addone.native
	$(OCC) -dsource -ppx ./ppx_addone.native foo_addone.ml

test_dump_source_foo : foo.ml ppx_getenv.native
	$(OCC) -dsource -ppx ./ppx_getenv.native foo.ml

test_dump_source_foo_equiv : foo_equiv.ml ppx_equiv.native
	$(OCC) -dsource -ppx ./ppx_equiv.native foo_equiv.ml

foo.native : foo.ml ppx_getenv.native
	$(OCC) -ppx ./ppx_getenv.native $< -o $@

test_foo : foo.native
	./foo.native
