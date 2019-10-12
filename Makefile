OPAM_BIN_DIR = /home/keutoi/.opam/default/bin
OCC = $(OPAM_BIN_DIR)/ocamlc
OCB = $(OPAM_BIN_DIR)/ocamlbuild

ppx_getenv.native : ppx_getenv.ml
	$(OCB) -package compiler-libs.common $@ $<
.PHONY : clean test
clean :
	rm -f *.native *.cmi *.cmo
test_foo : foo.ml ppx_getenv.native
	$(OCC) -dsource -ppx ./ppx_getenv.native foo.ml
