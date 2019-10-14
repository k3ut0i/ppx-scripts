OPAM_BIN_DIR = /home/keutoi/.opam/default/bin
OCC = $(OPAM_BIN_DIR)/ocamlc
OCB = $(OPAM_BIN_DIR)/ocamlbuild

ppx_getenv.native : ppx_getenv.ml
	$(OCB) -package compiler-libs.common $@ $<

.PHONY : clean test_foo test_dump_source_foo
clean :
	rm -rf *.native *.cmi *.cmo a.out _build

test_dump_source_foo : foo.ml ppx_getenv.native
	$(OCC) -dsource -ppx ./ppx_getenv.native foo.ml

foo.native : foo.ml ppx_getenv.native
	$(OCC) -ppx ./ppx_getenv.native $< -o $@

test_foo : foo.native
	./foo.native
