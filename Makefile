OPAM_BIN_DIR = /home/keutoi/.opam/default/bin
OCC = $(OPAM_BIN_DIR)/ocamlc
OCB = $(OPAM_BIN_DIR)/ocamlbuild

.PHONY : clean test_foo test_dump_source_foo
clean :
	rm -rf *.native *.cmi *.cmo a.out _build

ppx_getenv.native : ppx_getenv.ml
	$(OCB) -package compiler-libs.common $@ $<

ppx_addone.native : ppx_addone.ml
	$(OCB) -package compiler-libs.common $@ $<

test_dump_source_foo_addone : foo_addone.ml ppx_addone.native
	$(OCC) -dsource -ppx ./ppx_addone.native foo_addone.ml

test_dump_source_foo : foo.ml ppx_getenv.native
	$(OCC) -dsource -ppx ./ppx_getenv.native foo.ml

foo.native : foo.ml ppx_getenv.native
	$(OCC) -ppx ./ppx_getenv.native $< -o $@

test_foo : foo.native
	./foo.native
