#lang scribble/manual
@(require "utils.rkt")

@title{Scribble: Racket 文档工具}

@author["Matthew Flatt" "Eli Barzilay"]

Scribble 是通过 HTML 或 PDF（通过 latex）的形式创建论文，书籍，库文档等这类文
档的一系列工具的集合。更一般地说，Scribble 帮助你书写富含文本内容的程序，不管
这些内容是需要被排版的散文还是以某种形式通过编码的方式生成的。

这份文档本身就是使用 Scribble 编写的。你可以在
@(let ([url "https://github.com/racket/scribble/tree/master/scribble-doc/scribblings/scribble"])
(link url url))
看它的源码，从 @filepath{scribble.scrbl} 文件开始看。

@table-of-contents[]

@; ------------------------------------------------------------------------
@include-section["how-to-paper.scrbl"]
@include-section["reader.scrbl"]
@include-section["generic.scrbl"]
@include-section["plt.scrbl"]
@include-section["lp.scrbl"]
@include-section["internals.scrbl"]
@include-section["running.scrbl"]

@index-section[]
