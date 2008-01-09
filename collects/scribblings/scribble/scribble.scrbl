#lang scribble/doc
@(require scribble/manual
          scribble/bnf
          "utils.ss")

@title{@bold{Scribble}: PLT Documentation Tool}

Scribble is a collection of tools for creating prose documents,
especially those that document libraries, and especially for HTML and
PDF (via LaTeX) output.

This document itself is written using Scribble. At the time that it
was written, its source was available at
@(let ([url "http://svn.plt-scheme.org/plt/trunk/collects/scribblings/scribble/"])
   (link url url))
starting with the @filepath{scribble.scrbl} file.

@table-of-contents[]

@; ------------------------------------------------------------------------
@include-section["how-to.scrbl"]
@include-section["layers.scrbl"]
@include-section["reader.scrbl"]
@include-section["struct.scrbl"]
@include-section["renderer.scrbl"]
@include-section["decode.scrbl"]
@include-section["doclang.scrbl"]
@include-section["docreader.scrbl"]
@include-section["basic.scrbl"]
@include-section["scheme.scrbl"]
@include-section["manual.scrbl"]
@include-section["eval.scrbl"]
@include-section["bnf.scrbl"]
@include-section["xref.scrbl"]

@index-section[]
